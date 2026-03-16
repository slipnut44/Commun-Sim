# Commun‑Sim

A community simulator game that explores the impact of community‑focused funding, care‑based safety strategies, and different crisis‑response models. The simulation demonstrates how policing, social services, crisis response, and community support shape neighborhood stability and well‑being.

## About the Project

Commun‑Sim is an educational simulation where players build community infrastructure and observe how different responders handle crises. Homes generate events, agents respond based on their role, and the resulting patterns reveal how different systems influence community outcomes.

### Core Features

- **Dynamic Simulation Loop** — Homes emit events based on stability and unmet needs
- **Multiple Building Types** — Homes, Police Stations, Social Services, Community Centers
- **Agent System** — Police, Social Workers, Community Workers, Crisis Responders
- **Event System** — Conflicts, crises, unmet needs, and community events
- **Resource Management** — Build infrastructure to influence stability
- **Interactive UI** — Build mode, stats panels, event logs, budget display

## Repository Structure

```
Commun-Sim/
├── Docs/
│   ├── core-features-list.md
│   └── basic_proj_structure.txt
├── README.md
└── src_/
    ├── project.godot
    ├── addons/
    ├── Scenes/
    ├── scripts/
    ├── assets/
    ├── launcher.sh
    ├── launcher.bat
    ├── export_presets.cfg
    ├── sample/
    │   ├── CommunSim-Windows.console.exe
    │   ├── CommunSim-Windows.exe
    │   ├── Commun-Sim.x86_64
    │   ├── Commun-Sim.sh
    │   ├── Commun-Sim.pck
    │   ├── CommunSim-Windows.pck
    │   ├── launcher.sh
    │   ├── launcher.bat
    │   └── success_rates.txt
    └── ...
```

- **`src_/`** contains the Godot project.
- **`src_/sample/`** contains prebuilt executables for Windows and Linux.
- **`Docs/`** contains design and feature documentation.

## Running Commun‑Sim (Executable Version)

Prebuilt executables are included in the repository under `src_/sample/`.

### Windows

1. Navigate to `src_/sample/`
2. Run `CommunSim-Windows.console.exe`

This launches:

- The simulator window
- A terminal window showing real‑time agent events

Keep all files in the folder together — the `.exe` and `.pck` must remain side‑by‑side.

### Linux

1. Navigate to `src_/sample/`
2. Make the launcher executable (first time only):

```
chmod +x Commun-Sim.sh
```

1. Then run:

```
./Commun-Sim.sh
```

This launches the simulator and a terminal window for event output.

## Running From Source (Godot Editor)

If you want to modify or extend the game:

1. Install **Godot Engine 4.6+**
2. Open Godot → **Open Project**
3. Select the folder:

```
Commun-Sim/src_/
```

1. Press **F5** to run the game in the editor.

## Building Your Own Executable

If you want to export new builds:

1. Open the project in Godot (`src_/`)
2. Go to **File → Export Project**
3. Choose a preset (Windows or Linux)
4. If no preset exists:
    - Click **Add…**
    - Select your platform
    - Ensure the `.pck` is included
5. Click **Export Project**
6. Godot will generate:
    - A platform‑specific executable
    - A matching `.pck` file

Place both files together in the same directory before running.

## Interaction & Controls

### Build Mode

- **Ctrl + B** — Toggle Build Mode
- All building shortcuts require Build Mode to be active

### Building Types

- **H** — Home
- **S** — Social Services
- **C** — Community Center
- **P** — Police Station

### Placement Workflow

1. Press **Ctrl + B**
2. Press a building key
3. A ghost preview appears
4. Click on valid terrain (grass)
5. Agents spawn automatically

## Generated Files

### `report.txt` — Simulation Report

Created automatically when the game closes.

Located in the same directory as the executable.

Includes:

- Responded events
- Successes / failures
- Success rates
- Home agent average content

### `success_rates.txt` — Optional Effectiveness Overrides

Located in `src_/sample/success_rates.txt`

Format of the `success_rates.txt` file is as follows:

```
home, social_services, community_center, police
```

Example:

```
0.2, 0.6, 0.56, 0.4
```

Values represent probability of successful crisis resolution (0.0–1.0).

If missing or invalid, defaults are used.

## Development Notes

Key managers:

- **Sim_Manager** — Simulation loop
- **BuildingManager** — Building placement & logic
- **AgentManager** — Agent spawning & behavior
- **EventManager** — Crisis generation & routing

<aside>
<img src="https://www.notion.so/icons/code_orange.svg" alt="https://www.notion.so/icons/code_orange.svg" width="40px" />

***Author***: Shamar Pennant (slipnut44)

</aside>
