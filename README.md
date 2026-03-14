# Commun-Sim

A community simulator game that explores the positive effects of community-focused funding and methods of providing safety. This interactive experience simulates how different community interventions impact neighborhood stability and quality of life.

## About the Project

Commun-Sim is an educational simulation game where players manage community resources and respond to neighborhood events. The game features a dynamic simulation loop with various building types, agents, and households that interact to create emergent gameplay around community safety and stability.

### Core Features

- **Dynamic Simulation**: Real-time simulation loop with time-steps where homes emit events based on stability
- **Multiple Building Types**: Police Stations, Crisis Response Hubs, Social Services Offices, and Community Centers
- **Agent System**: Specialized agents (Police, Crisis Responders, Social Workers, Community Workers) respond to neighborhood needs
- **Event System**: Conflicts, mental health crises, unmet needs, and community events occur dynamically
- **Resource Management**: Build and manage community infrastructure to improve neighborhood stability
- **Interactive UI**: Build menus, statistics panels, event logs, and budget displays

## Requirements

### Build & Runtime Dependencies

- **Godot Engine 4.6+** - The game engine required to run and build the project
- **Operating System**: Windows, macOS, or Linux
- **RAM**: Minimum 4GB recommended
- **Disk Space**: 500MB for Godot and project files

## Installation & Setup

### Prerequisites

1. Download and install [Godot Engine 4.6](https://godotengine.org/download/)
2. Clone or download this repository

### Opening the Project

1. Open Godot Engine
2. Click "Open Project"
3. Navigate to the `Commun-Sim` directory
4. Select the `src_` folder and click "Open"
5. Wait for Godot to import the project assets

## Building & Running

### Running in the Editor

1. Open the project in Godot Engine
2. Click the **Play** button (or press F5) to run the game
3. The main scene will launch automatically

### Building an Executable

1. In Godot, go to **File → Export Project**
2. Select your target platform (Windows, macOS, or Linux)
3. If the export preset doesn't exist, create a new one:
   - Click "Add..." to create a new export preset
   - Configure the export settings (output path, resources to include, etc.)
4. Click "Export Project" and select an output directory
5. Godot will compile and package the game

#### Export Presets Available

- **Windows (EXE)**: Exports as a standalone Windows executable
- **macOS (DMG)**: Exports as a macOS application bundle
- **Linux (Binary)**: Exports as a Linux executable

### Running the Built Game

After exporting, run the generated executable for your platform:

```bash
# Windows
./CommUnSim.exe

# macOS
open CommUnSim.app

# Linux
./CommUnSim
```

## Project Structure

```
Commun-Sim/
├── src_/
│   ├── project.godot          # Godot project configuration
│   ├── addons/                # Godot plugins and assets
│   ├── scenes/                # Game scenes (.tscn files)
│   ├── scripts/               # GDScript source files
│   └── assets/                # Images, audio, and other resources
├── Docs/
│   ├── core-features-list.md  # Detailed feature documentation
│   └── basic_proj_structure.txt # Scene and node hierarchy
└── README.md
```

## Development

### Adding New Features

1. Open the project in Godot
2. Create new scenes in the `scenes/` directory
3. Attach GDScript files to nodes for functionality
4. Test using the Play button in the editor

### Key Scripts & Managers

- **Sim_Manager**: Autoload singleton that manages the simulation loop
- **BuildingManager**: Handles building placement and operations
- **AgentManager**: Controls agent behavior and spawning
- **EventManager**: Manages event generation and distribution

## License

This project includes Kenney's Tiny Battle Assets addon which is freely available.

## Contributing

For contributions, feature requests, or bug reports, please open an issue or pull request on GitHub.

## Author

**Shamar Pennant** (slipnut44)

---

For more information about the game mechanics and design, see the documentation in the `Docs/` folder.
