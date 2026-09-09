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
│   └── main.tscn       # Main gameplay scene
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
- [Week 2: Player Movement & Input Handling](#week-2-player-movement--input-handling)
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

## Development Notes

- **Engine:** This project uses **Godot 4.x** with GDScript for scripting
- **Asset Management:** All binary assets (images, audio) are tracked via Git LFS to keep the repository lightweight
- **Scenes:** Each major game component is organized as a separate scene for modularity and reusability

---

## Known Issues & Roadmap

- [x] Week 1: Engine setup and hello world
- [ ] Week 2–7: Gameplay features in progress
- [ ] Week 8: Final polish and submission

---

## Contributing

This is a course project. Contributions and feedback are welcome. Please ensure:
1. All binary assets use Git LFS
2. Code follows Godot/GDScript conventions
3. Scenes are properly organized in the `scenes/` directory

---

## License

This project is developed as part of CS-5105N coursework.

---

**Last Updated:** Week 1 (Initial Setup)  
**Developer:** Zsofia Everwing
