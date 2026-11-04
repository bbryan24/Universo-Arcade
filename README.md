# Universo Arcade

**INSERT COIN. PLAY FOREVER.**

Universo Arcade is a retro-inspired arcade experience built on Roblox. Players can explore a colorful arcade, interact with physical arcade machines and compete in a collection of classic-inspired minigames.

The project focuses on modular architecture, independent game sessions, fair competition and persistent personal records.

> **Project status:** In development — Version 0.1

## Vision

Create a social arcade where players can enjoy different minigames, compete for high scores and gradually discover new experiences.

The initial goal is to deliver one fully playable arcade machine and establish the technical foundations for future minigames.

## Planned features

- Interactive arcade machines.
- Independent minigame sessions.
- Persistent personal high scores.
- Retro-inspired visual design.
- Modular minigame architecture.
- Future leaderboards and progression systems.

## Initial minigames

| Minigame | Inspiration | Status |
|---|---|---|
| Block puzzle | Tetris-style gameplay | Planned |
| Bubble shooter | Pang-style gameplay | Planned |
| Space shooter | Space Invaders-style gameplay | Planned |
| Brick breaker | Breakout-style gameplay | Planned |

All minigames will use original implementations and assets.

## Technology stack

| Technology | Purpose |
|---|---|
| Roblox Studio | Game development and testing |
| Luau | Gameplay programming |
| Visual Studio Code | Code editor |
| Rojo | Synchronization with Roblox Studio |
| Rokit | Development toolchain management |
| Git | Version control |
| GitHub | Repository hosting |

## Project structure

```text
src/
├── client/
│   ├── Controllers/
│   └── UI/
├── server/
│   ├── Data/
│   ├── Services/
│   └── Systems/
└── shared/
    ├── Config/
    ├── Modules/
    └── Types/

assets/
docs/
tests/
```

## Development setup

### Requirements

- Roblox Studio
- Visual Studio Code
- Git
- Rokit
- Rojo

### Build the project

From the project root, run:

```bash
rojo build default.project.json --output build-test.rbxlx
```

### Synchronize with Roblox Studio

1. Open Roblox Studio.
2. Open a development experience.
3. Start the Rojo plugin.
4. Start the Rojo server from the project terminal:

```bash
rojo serve
```

5. Connect the Studio plugin to the local Rojo server.

## Documentation

- [Game Design Document](docs/GDD.md)
- [Development Roadmap](docs/ROADMAP.md)
- [Technical Architecture](docs/ARCHITECTURE.md)

## Development principles

- Server-authoritative gameplay and scoring.
- Modular and reusable systems.
- Independent minigame sessions.
- Clear separation between client, server and shared code.
- Version-controlled development.
- Incremental testing and documentation.

## Project status

Universo Arcade is currently in its initial setup and architecture phase.

The first milestone is **Version 0.1: one playable arcade machine, one minigame, scoring and persistent personal records**.

---

*Universo Arcade — A small arcade with endless possibilities.*