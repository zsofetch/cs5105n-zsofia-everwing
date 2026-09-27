#dont mind this section

lacking features:
	
	- choose character in the video game loading screen
	- dapat mo game over if ma hit ang character sa one of the mobs
	- video game loading screen
	- final boss assets
	- final bosses shoot stuff at the character (it tracks where the character is currently located and the player should dodge those bullets)
	- sound effects and bgm
	- powerups?
	
# Everwing (Godot 2D)

**Course:** CS-5105N — Game Development  
**Engine:** Godot Engine 4.x (Standard Build)  
**Version Control:** Git + Git LFS  
**Language:** GDScript

---

## Project Overview

**Genre:** 2D Vertical Shooter / Endless Runner

**Concept:** A vertical scrolling shooter where the player navigates through oncoming waves of enemies and obstacles.

**Target Platforms:** Desktop (Windows / macOS / Linux) and Mobile

---

## Getting Started

### Prerequisites
- **Godot Engine 4.x** (Standard Build) — [Download here](https://godotengine.org/download)
- **Git** with Git LFS support — [Install Git LFS](https://git-lfs.github.com/)

### Installation & Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/zsofetch/cs5105n-zsofia-everwing.git
   cd cs5105n-zsofia-everwing
   ```

2. **Initialize Git LFS:**
   ```bash
   git lfs pull
   ```

3. **Open in Godot:**
   - Launch Godot 4.x
   - Click "Open Project"
   - Select the project folder
   - Open `main.tscn` to run the demo scene

### Running the Game

- Press **F5** (or the Play button) in the Godot editor to run the active scene
- Press **F8** to run the main scene (`main.tscn`)

---

## Project Structure

```
cs5105n-zsofia-everwing/
├── scenes/              # Godot scene files (.tscn)
│   ├── main.tscn        # Main gameplay scene
│   ├── game.tscn        # Level/wave manager scene
│   ├── player.tscn      # Player scene
│   ├── bullet.tscn      # Player projectile scene
│   ├── enemy.tscn       # Mob scene (multiple sprite variants)
│   ├── boss.tscn        # Boss scene
│   └── coin.tscn        # 1s/0s point pickup scene
├── scripts/             # GDScript source files
├── assets/              # Art, sprites, audio
│   ├── sprites/
│   ├── audio/
│   └── fonts/
├── screenshots/         # Development progress documentation
├── .gitignore          # Git ignore rules
├── .gitattributes      # Git LFS tracking rules
└── README.md           # This file
```

---

## Weekly Development Log

- [Week 1: Engine Setup, Version Control, & Hello World Scene](#week-1-engine-setup-version-control--hello-world-scene)
- [Week 2: Gameplay Mechanics & Game Feel](#week-2-gameplay-mechanics--game-feel)
- [Week 3: Enemy Waves & Collision Detection](#week-3-enemy-waves--collision-detection)
- [Week 4: Scoring & UI Systems](#week-4-scoring--ui-systems)
- [Week 5: Audio & Visual Effects](#week-5-audio--visual-effects)
- [Week 6: Polish & Optimization](#week-6-polish--optimization)
- [Week 7: Mobile Support & Testing](#week-7-mobile-support--testing)
- [Week 8: Final Project Showcase](#week-8-final-project-showcase)

---

## Week 1: Engine Setup, Version Control, & Hello World Scene

### Objectives & Overview

- Establish local game development toolchain using Godot 4
- Initialize project version control with a clean `.gitignore` structure
- Configure Git Large File Storage (Git LFS) for binary asset management (`.png`, `.wav`)
- Construct and execute a base 2D running scene (`main.tscn`) containing node hierarchies and placeholder visual assets

### Implementation Details

- **Node Hierarchy:** Structured `main.tscn` using a root `Node2D` with an instantiated `Sprite2D` rendering the placeholder sprite
- **Asset Tracking:** Tracked binary media assets using Git LFS via `.gitattributes` to prevent repository bloat over the 8-week cycle
- **Ignored Artifacts:** Structured `.gitignore` to omit local editor caches (`.godot/`) and build target outputs (`/export/`)

### Scene Execution Evidence

![Week 1 Running Scene](screenshots/week1-running-scene.png)

### Stretch Goals Completed

- Implemented scene switching logic using Godot signals connecting a menu trigger to an active game scene

---

## Week 2: Gameplay Mechanics & Game Feel

### Objectives & Overview
- Map custom player input actions (`move_left`, `move_right`, and `shoot`) via Godot's Input Map.
- Construct a player controller using `CharacterBody2D` utilizing kinematic physics movement (`move_and_slide()`).
- Implement the core vertical shoot-'em-up mechanic with dynamic projectile instancing (`bullet.tscn`) and viewport horizontal boundary clamping.
- Integrate aesthetic "game feel" / juice via procedural banking tilt on the sprite during directional changes.

### Implementation Details

- **Core Mechanic:** Responsive horizontal dodging along the X-axis coupled with rapid vertical projectile firing.
- **Physics & Bounds:** Movement utilizes `CharacterBody2D.velocity` bounded within viewport dimensions via `clamp()`.
- **Game Feel (Juice):** Implemented angular interpolation (`lerp_angle`) tied to the movement direction vector (`direction * tilt_angle`), producing responsive aerodynamic banking as the fairy moves across the screen.

### Playable Build Evidence

![Week 2 Core Mechanic & Juice](screenshots/week2-core-mechanic.png)

---

## Week 3: Enemy Waves & Collision Detection

### Objectives & Overview

- Replace random mob placement with a fixed 5-lane formation so enemies spawn in clean, Everwing-style rows.
- Implement a wave-gating system so a new row only spawns once the previous row has cleared enough vertical space, instead of relying on a flat timer.
- Give each mob (`enemy.gd`) its own HP pool, hit-flash feedback, and a custom-drawn health bar (`_draw()`), with damage delivered via `take_damage()` on `Area2D` collision with bullets.
- Introduce a `boss.gd` enemy type: descends to a fixed stop position, holds there, and has a larger custom health bar.
- Build out `game.gd` as the central level/wave manager: tracks elapsed time toward the boss encounter, spawns boss only once the current wave is fully cleared, and scales mob HP/speed and boss HP per level using a compounding growth curve on `current_level`.
- Add visual variety by giving mobs a `textures` array so each spawned enemy randomly picks one of several sprite skins, auto-scaled to a consistent `target_size` regardless of the source asset's native resolution.

### Implementation Details

- **Lane System:** `_setup_lanes()` computes 5 evenly spaced X positions across the viewport width; every wave fills all 5 lanes.
- **Wave Gating:** `_check_spawn_wave()` checks the minimum Y position among currently alive mobs and only releases the next wave once that value passes a screen-height threshold, preventing overlapping wave stacking.
- **Boss Timing:** A `level_timer` accumulates while no boss is active/incoming; at `boss_spawn_delay` (currently 30s) the manager flags `boss_incoming` and waits for the active wave to clear before spawning `boss.tscn`.
- **Difficulty Curve:** `_mob_hp_for_level()`, `_mob_speed_for_level()`, and `_boss_hp_for_level()` scale exponentially (`pow()`) off `current_level`, so each level cycle after a boss defeat is noticeably harder, not just incrementally so.
- **Health Bars:** Both `enemy.gd` and `boss.gd` implement `_draw()` to render a background + fill bar above the sprite, color-shifting from green → yellow → red as HP drops, refreshed via `queue_redraw()` on spawn and on damage.
- **Mob Variety:** `_apply_random_skin()` and `_fit_sprite_to_target_size()` pick a random texture from an exported array and normalize its scale, so mixed-resolution assets all render at a consistent in-game size.

### Playable Build Evidence

![Week 3 Enemy Waves & Boss](screenshots/week3-enemy-waves.png)

---

## Week 4: Scoring & UI Systems

### Objectives & Overview

- Add a point-collection system: mobs drop a coin (styled as binary `1`/`0` sprites) on death, worth 1 point when caught by the player.
- Award a bonus of +5 points when an entire 5-mob row is fully defeated (not merely despawned off-screen).
- Add a persistent, global score tracker accessible from any script, plus an on-screen counter.
- Give coins a natural gravitational drop so catching them requires quick, active positioning rather than a passive straight-line intercept.

### Implementation Details

- **Global Score State:** `score.gd` registered as an Autoload singleton (`Score`), exposing `add_points()`, `reset()`, and a `score_changed` signal so any node can update or read the score without direct references.
- **Coin Pickups:** `coin.gd` (`Area2D`) detects the player via `body_entered` (checked against the `"player"` group, added to `player.gd`'s `_ready()`), awards `Score.add_points(value)`, and `queue_free()`s itself on pickup for the "obtained" feel.
- **Coin Physics:** Coins fall under true gravitational acceleration (`fall_velocity` increasing by `gravity * delta` each frame, capped at `max_fall_speed`) instead of a constant fall speed, so they start slow and speed up — requiring the player to react quickly to catch them before they escape.
- **Mob Coin Drops:** `enemy.gd` distinguishes a real kill (took lethal damage → `died.emit()` + `_drop_coin()`) from an off-screen escape (mob leaves the viewport with no signal, no coin), so only genuine kills reward the player.
- **Row-Clear Bonus:** `game.gd` tracks each spawned wave's mob list and listens for each mob's `died` signal; once every mob in that wave has been confirmed killed, `Score.add_points(5)` fires automatically.
- **Score UI:** A `CanvasLayer` + `Label` (`score_label.gd`) anchored top-right, subscribed to `Score.score_changed`, displaying `"Score: <n>"` live as points are earned.

### Playable Build Evidence

![Week 4 Scoring & UI](screenshots/week4-scoring-ui.png)

---

## Development Notes

- **Engine:** This project uses **Godot 4.x** with GDScript for scripting
- **Asset Management:** All binary assets (images, audio) are tracked via Git LFS to keep the repository lightweight
- **Scenes:** Each major game component is organized as a separate scene for modularity and reusability

---

## Known Issues & Roadmap

- [x] Week 1: Engine setup and hello world
- [x] Week 2: Player movement, shooting, and game feel
- [x] Week 3: Enemy waves, lanes, collision detection, boss, difficulty scaling
- [x] Week 4: Coin drops, scoring, row-clear bonus, score UI
- [ ] Week 5–7: Audio, visual effects, polish, mobile support in progress
- [ ] Week 8: Final polish and submission

---

## License

This project is developed as part of CS-5105N coursework.

---

<<<<<<< HEAD
**Last Updated:** Week 4 (Scoring & UI Systems)  
=======
**Last Updated:** Week 2 (Gameplay Mechanics)  
>>>>>>> 26d9148941d14fbdfe1534faba27aa434ceeadd0
**Developer:** Zsofia Everwing
