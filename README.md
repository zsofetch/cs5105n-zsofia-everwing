dont mind this section thank you

lacking features/checklist:
- [x] choose character in the video game loading screen
- [ ] improve the overall UI (personalized home screen and cuter fonts)
- [x] dapat mo game over if ma hit ang character sa one of the mobs
- [x] video game loading screen
- [ ] final boss assets (change to something more dcism themed)
- [ ] final bosses shoot stuff at the character (it tracks where the character is currently located and the player should dodge those bullets)
- [ ] sound effects and bgm (FIND A BETTER SFX FOR SHOOTING SABA KAAU ANG CURRENT) -- placeholders are wired in via AudioManager, just swap in the final files
- [ ] powerups for more fun
- [x] organize file structure
- [x] level 1 is too fast we need to fix that 
- [ ] i feel like need ichange ang pacing 
- [ ] transition to a more dcism themed game (including name)
- [ ] change the background for the game (should have different backgrounds every level)
- [ ] animate the characters to be more mobile ?? (ex. monsters gently float/bounce)
- [ ] add a final boss incoming warning before the boss shows up

	
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

### Current Features

- Main menu with **character select** (Boy / Girl), Start and Quit
- Auto-firing player with drag / keyboard movement, banking tilt, and `idle` / `move` animations
- Lane-based enemy waves with HP bars, hit flash, explosion particles, and coin drops (1s and 0s)
- **Two levels** with a difficulty curve, each ending in a boss fight and a level transition
- Touching a mob or the boss ends the run; **game over screen** with Retry / Main Menu
- **HUD** (CanvasLayer): score, level name, and a boss-arrival progress bar
- **Audio** routed through separate `SFX` and `Music` buses (placeholder sounds for now)
- **Accessibility:** colorblind-safe health-bar palette, toggled from the main menu and saved between sessions

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
   - Click "Import" / "Open Project"
   - Select the project folder (the one containing `project.godot`)
   - The main scene is `ui/main_menu/main_menu.tscn`

### Running the Game

- Press **F5** (or the Play button) to run the project from the main menu
- Press **F6** to run the scene that is currently open (e.g. `levels/game.tscn` to skip the menu)

### Controls

- **Move:** drag with the mouse / touch, or use the `move_left` / `move_right` keyboard actions
- **Shoot:** automatic

---

## Project Structure

```
cs5105n-zsofia-everwing/
├── assets/
│   ├── art/                  # Sprites and backgrounds (characters, mobs, boss, 1/0 coins, ammo, corridor)
│   ├── audio/
│   │   ├── sfx/              # shoot, hit, explosion, coin, player_death, boss_appear, click
│   │   └── music/            # bgm
│   └── fonts/
├── autoload/                 # Global singletons
│   ├── score.gd              # Score: points + score_changed signal
│   ├── game_state.gd         # GameState: selected character, colorblind setting
│   └── audio_manager.gd      # AudioManager: SFX voice pool + looping music
├── entities/
│   ├── player/               # player.tscn / player.gd
│   ├── enemies/              # enemy.tscn / enemy.gd
│   ├── boss/                 # boss.tscn / boss.gd
│   ├── bullets/              # bullet.tscn / bullet.gd
│   ├── pickups/              # coin.tscn / coin.gd (1s/0s point pickup)
│   └── effects/              # explosion.tscn / explosion.gd (particles)
├── levels/
│   ├── game.tscn / game.gd   # Level + wave manager
│   └── parallax_scroller.gd  # Scrolling background
├── ui/
│   ├── ui_kit.gd             # Shared label/button helpers (UIKit)
│   ├── main_menu/            # Main menu + character select
│   ├── hud/                  # In-game HUD (CanvasLayer)
│   └── game_over/            # Game over screen
├── screenshots/              # Development progress documentation
├── default_bus_layout.tres   # Audio buses (Music, SFX)
├── .gitignore                # Git ignore rules
├── .gitattributes            # Git LFS tracking rules
└── README.md                 # This file
```

---

## Weekly Development Log

- [Week 1: Engine Setup, Version Control, & Hello World Scene](#week-1-engine-setup-version-control--hello-world-scene)
- [Week 2: Gameplay Mechanics & Game Feel](#week-2-gameplay-mechanics--game-feel)
- [Week 3: Level Design](#week-3-level-design)
- [Week 4: Art, Animation & Particles](#week-4-art-animation--particles)
- [Week 5: UI/UX & Audio](#week-5-uiux--audio)
- Week 6: AI & Enemies *(upcoming)*
- Week 7: Juice, Save/Load & Optimization *(upcoming)*
- Week 8: Final Project Showcase *(upcoming)*

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

## Week 3: Level Design

### Objectives & Overview

- Spawn enemies on a fixed 5-lane grid so waves read as clean, Everwing-style rows, and always leave at least one lane free so every wave can be dodged.
- Implement a wave-gating system so a new row only spawns once the previous row has cleared enough vertical space, instead of relying on a flat timer.
- Give each mob (`enemy.gd`) its own HP pool, hit-flash feedback, and a custom-drawn health bar (`_draw()`), with damage delivered via `take_damage()` on `Area2D` collision with bullets.
- Introduce a `boss.gd` enemy type: descends to a fixed stop position, holds there, and has a larger custom health bar.
- Make touching any mob or the boss a hazard: the run ends immediately.
- Build **two levels** with a difficulty curve: Level 1 teaches the mechanic gently, Level 2 tests it. Defeating the boss is each level's goal and triggers the transition.
- Add visual variety by giving mobs a `textures` array so each spawned enemy randomly picks one of several sprite skins, auto-scaled to a consistent `target_size` regardless of the source asset's native resolution.
- Reorganize the project into feature folders (`entities/`, `levels/`, `ui/`, `autoload/`, `assets/`).

### Implementation Details

- **Level Table:** `game.gd` holds a `LEVELS` constant with one entry per level, so every difficulty value lives in one place (see the table below). `game.gd` is the central level/wave manager: it loads the current level's settings, tracks elapsed time toward the boss, and spawns the boss only once the screen is clear of mobs.
- **Lane System:** `_setup_lanes()` computes 5 evenly spaced X positions across the viewport width. Each wave shuffles the lanes and fills only `mobs_per_wave` of them (never all 5), so there is always a free lane to dodge into.
- **Wave Gating:** `_check_spawn_wave()` checks the minimum Y position among currently alive mobs and only releases the next wave once that value passes `wave_gap` (a fraction of screen height), preventing overlapping wave stacking.
- **Difficulty Curve:** Level 1 uses slower mobs with low HP and only 2 per wave, giving the player room to learn moving and shooting. Level 2 uses faster, tougher mobs, 3 per wave, tighter spacing, a longer run-up, and a bigger boss. Within each level mob speed also ramps from 100% to 125% before the boss, so every level builds toward its boss.
- **Hazards & Game Over:** `enemy.gd` and `boss.gd` connect `body_entered`; when the body is in the `"player"` group they call `player.die()`. The player emits a `died` signal that the level manager listens for, which freezes play and opens the game over screen (see Week 5).
- **Level Transition:** When the boss dies, `game.gd` shows a "LEVEL 1 COMPLETE" banner and loads the next level's settings. Finishing the last level shows "YOU WIN!" and returns to the main menu.
- **Boss Timing:** After `boss_delay` seconds the manager flags `boss_incoming` and waits for the active wave to clear before spawning `boss.tscn`.
- **Health Bars:** Both `enemy.gd` and `boss.gd` implement `_draw()` to render a background + fill bar above the sprite, refreshed via `queue_redraw()` on spawn and on damage. Enemy bar colors come from `GameState.hp_color()` (see Week 5 accessibility).
- **Mob Variety:** `_apply_random_skin()` and `_fit_sprite_to_target_size()` pick a random texture from an exported array and normalize its scale, so mixed-resolution assets all render at a consistent in-game size.

| | Level 1 | Level 2 |
|---|---|---|
| Mob speed | 90 | 130 |
| Mob HP | 2 | 3 |
| Mobs per wave | 2 | 3 |
| Wave gap (fraction of screen) | 0.40 | 0.33 |
| Boss arrives after | 30 s | 40 s |
| Boss HP | 30 | 50 |

### Still To Do For This Week

- The Week 3 sheet asks for TileMap-built levels. The levels currently use a scrolling `Parallax2D` background, so a TileMap level visual (and a different background per level) is still pending.

### Playable Build Evidence

![Week 3 Enemy Waves & Boss](screenshots/week3-enemy-waves.png)
![Week 3 Levels](screenshots/week3-levels.png)

---

## Week 4: Art, Animation & Particles

### Objectives & Overview

- Animate the player with an `AnimationPlayer` (`idle` and `move`), triggered from the movement script.
- Add a particle effect tied to an action (enemy explosion on kill).
- Generate one asset with an AI image tool (the final boss sprite), edit it, import it, and document the process.
- Carry over the scoring system built earlier: coins dropped by mobs, a global score, and a row-clear bonus.

### Implementation Details

- **Player Animations:** An `AnimationPlayer` child of the Player has two animations. `idle` is a gentle looping hover (a position track on the `Sprite2D`). `move` is a short looping squash-and-stretch (a scale track). `player.gd` picks the animation every physics frame from horizontal speed (`absf(velocity.x) > 100` plays `move`, otherwise `idle`). The animations only touch position and scale, so they don't fight the code-driven banking tilt on rotation. They animate the sprite node rather than its texture, so they work for any selected character.
- **Particles:** `entities/effects/explosion.tscn` is a one-shot `CPUParticles2D` burst of 18 small square particles that fade from yellow to transparent red. It is configured in `explosion.gd`, spawned by `enemy.gd` when a mob dies, and frees itself when finished.
- **Death Handling Fix:** Mob death is now deferred (`call_deferred`) with an `is_dying` guard. This avoids Godot's "can't change state while flushing queries" error from spawning a coin inside a collision callback, and stops two simultaneous bullets from dropping two coins or two explosions.

### Scoring & Coin System (built earlier, carried over)

- **Global Score State:** `score.gd` is registered as an Autoload singleton (`Score`), exposing `add_points()`, `reset()`, and a `score_changed` signal so any node can update or read the score without direct references. The score resets at the start of every run.
- **Coin Pickups:** Mobs drop a coin styled as a binary `1` / `0` sprite on death. `coin.gd` (`Area2D`) detects the player via `body_entered` (checked against the `"player"` group, added in `player.gd`'s `_ready()`), awards `Score.add_points(value)`, and `queue_free()`s itself on pickup.
- **Coin Physics:** Coins fall under gravitational acceleration, capped at `max_fall_speed`, so they start slow and speed up and the player has to react quickly to catch them.
- **Real Kills Only:** `enemy.gd` distinguishes a real kill (lethal damage, which emits `died` and drops a coin) from an off-screen escape (no signal, no coin).
- **Row-Clear Bonus:** `game.gd` tracks each spawned wave's mobs and listens for each mob's `died` signal; once every mob in the wave is killed, `Score.add_points(5)` fires.
- **Score Display:** The score was originally a standalone `CanvasLayer` + `Label`; it is now part of the HUD (see Week 5).

### Playable Build Evidence

![Week 4 Scoring & UI](screenshots/week4-scoring-ui.png)
![Week 4 Boss](screenshots/week4-boss.png)
![Week 4 Animation Particles](screenshots/week4-animation-particles.png)

---

## Week 5: UI/UX & Audio

### Objectives & Overview

- Build a HUD on a `CanvasLayer` that updates during play.
- Create a main menu (Start / Quit), a character select, and a way to restart or return to the menu.
- Route sound effects and music through separate audio buses and balance them.
- Add one accessibility feature.
- Run a 5-minute peer playtest and act on the feedback.

### Implementation Details

- **Shared UI Helpers:** `ui/ui_kit.gd` (`UIKit`) builds labels and buttons in one place so the UI is consistent. Labels get a dark outline to stay readable on any background, and every button plays the click sound.
- **HUD:** `ui/hud/hud.tscn` is a `CanvasLayer` that stays on screen. It shows the score (updated from `Score.score_changed`), the current level name, and a boss-arrival progress bar that serves as the timer (it reads BOSS IN, then BOSS INCOMING, then BOSS FIGHT!). `game.gd` feeds it the level name and progress.
- **Main Menu:** `ui/main_menu/main_menu.tscn` is the project's main scene. It has a darkened corridor backdrop, the title, character select, Start, the accessibility toggle, and Quit.
- **Character Select:** The `GameState` autoload stores the selected character (`GameState.CHARACTERS`: Boy, Girl). The arrows in the menu change the selection and `player.gd` applies the chosen texture in `_ready()`. Adding a character only needs a new entry in the list.
- **Game Over / Restart:** `ui/game_over/game_over.tscn` is a `CanvasLayer` that pauses the game (it keeps running because its `process_mode` is Always), shows the final score, and offers **Retry** (reload the level) and **Main Menu**.
- **Audio Buses:** `default_bus_layout.tres` defines two buses, `SFX` and `Music`, both sent to `Master`, mixed at roughly −4 dB and −10 dB so effects sit above the music. The `AudioManager` autoload owns a pool of 8 players on the `SFX` bus (so sounds can overlap) and one looping player on the `Music` bus.
- **Sound Lookup:** `AudioManager.play_sfx("shoot")` and `play_music("bgm")` find files by name in `assets/audio/` (checking `.ogg`, `.mp3`, then `.wav`), so a sound can be replaced by dropping in a file with the same base name. A missing file is skipped silently instead of crashing. The shoot sound is quieter and pitch-varied (±8%) because it plays about 8 times a second.
- **Sounds Wired In:** shoot, enemy hit, enemy explosion, coin pickup, player death, boss appears, button click, and one looping background track. The music keeps playing without restarting when going from the menu into the game, and stops when the player dies.
- **Boss Death Fix:** `boss.gd` now has an `is_dying` guard so two near-simultaneous hits can't emit `boss_defeated` twice (which would skip a level).

### Accessibility Feature: Colorblind-Safe Palette

- Enemy health bars used green → yellow → red, a combination that is hard to tell apart for red-green colorblind players. A **COLORBLIND** toggle on the main menu switches them to the Okabe–Ito palette (blue → yellow → vermilion).
- `GameState.hp_color(pct)` is the single source of truth for health-bar colors. The menu shows three swatches that update live when the toggle changes.
- The choice is saved to `user://settings.cfg` with `ConfigFile`, so it persists between sessions.
- Color is never the only signal: the bar's length also shows remaining health.

**Accessibility checklist (AI-assisted, tailored to this game):**

- [x] Color is not the only signal (bar length also shows HP)
- [x] A colorblind-safe palette option exists
- [x] Text has an outline and a readable size
- [x] Controls work with mouse, touch, and keyboard
- [x] Sounds are backed up by visuals (hit flash, explosion particles)
- [ ] Remappable controls (not yet)

### Playable Build Evidence

![Week 5 Audio and Music](screenshots/week5-audio.png)
![Week 5 Game Over](screenshots/week5-game-over.png)
![Week 5 UI Accessibility](screenshots/week5-ui-accessibility.png)

---

## Development Notes

- **Engine:** This project uses **Godot 4.x** with GDScript for scripting
- **Asset Management:** All binary assets (images, audio) are tracked via Git LFS to keep the repository lightweight
- **Scenes:** Each major game component is organized as a separate scene for modularity and reusability
- **Autoloads:** `Score`, `GameState`, and `AudioManager` are registered under Project Settings → Globals → Autoload
- **UI:** The menus, HUD, and game over screen are built in code on top of root nodes, with shared styling in `UIKit`
- **Settings:** Player settings are stored in `user://settings.cfg`

---

## Known Issues & Roadmap

- [x] Week 1: Engine setup and hello world
- [x] Week 2: Player movement, shooting, and game feel
- [x] Week 3: Two levels with a difficulty curve, game over on collision, level transition
- [ ] Week 3 (remaining): TileMap level visuals and the inclusive-content reflection line
- [x] Week 4: Player animations, explosion particles, AI-generated boss asset
- [ ] Week 4 (remaining): document the AI asset (tool, prompt, edits)
- [x] Week 5: HUD, main menu with character select, game over screen, audio buses, colorblind-safe palette
- [ ] Week 5 (remaining): final sound effects and music (placeholders for now) and the playtest write-up
- [ ] Week 6: AI enemy (boss state machine that fires aimed, dodgeable bullets)
- [ ] Week 7: Powerups, juice, save/load, and optimization
- [ ] Week 8: Final polish and submission

---

## License

This project is developed as part of CS-5105N coursework.

---

**Last Updated:** Week 5 (UI/UX & Audio)  
**Developer:** Zsofia Everwing
