\# Everwing (Godot 2D)



\*\*Course:\*\* CS-5105N — Game Development  

\*\*Engine:\*\* Godot Engine 4.x (Standard Build)  

\*\*Version Control:\*\* Git + Git LFS  



\---



\## Project Overview

\*\*Genre:\*\* 2D Vertical Shooter / Endless Runner

\*\*Concept:\*\* A vertical scrolling shooter where the player navigates through oncoming waves of enemies and obstacles.

\*\*Target Platforms:\*\* Desktop (Windows / macOS / Linux) and Mobile



\---



\## Weekly Development Log



\- \[Week 1: Engine Setup, Version Control, \& Hello World Scene](#week-1-engine-setup-version-control--hello-world-scene)

\- \[Week 2: To be announced](#week-2)

\- \[Week 3: To be announced](#week-3)

\- \[Week 4: To be announced](#week-4)

\- \[Week 5: To be announced](#week-5)

\- \[Week 6: To be announced](#week-6)

\- \[Week 7: To be announced](#week-7)

\- \[Week 8: Final Project Showcase](#week-8)



\---



\## Week 1: Engine Setup, Version Control, \& Hello World Scene



\### 1. Objectives \& Overview

\* Establish local game development toolchain using Godot 4.

\* Initialize project version control with a clean `.gitignore` structure.

\* Configure Git Large File Storage (Git LFS) for binary asset management (`.png`, `.wav`).

\* Construct and execute a base 2D running scene (`main.tscn`) containing node hierarchies and placeholder visual assets.



\### 2. Implementation Details

\* \*\*Node Hierarchy:\*\* Structured `main.tscn` using a root `Node2D` with an instantiated `Sprite2D` rendering the placeholder sprite.

\* \*\*Asset Tracking:\*\* Tracked binary media assets using Git LFS via `.gitattributes` to prevent repository bloat over the 8-week cycle.

\* \*\*Ignored Artifacts:\*\* Structured `.gitignore` to omit local editor caches (`.godot/`) and build target outputs (`/export/`).



\### 3. Scene Execution Evidence

!\[Week 1 Running Scene](screenshots/week1-running-scene.png)



\### 4. Stretch Goals Completed

\* Implemented scene switching logic using Godot signals connecting a menu trigger to an active game scene.

