# Universo Arcade

**INSERT COIN. PLAY FOREVER.**

Universo Arcade is a retro-inspired arcade experience built on Roblox. Players can explore a colorful arcade, interact with physical arcade machines and enjoy a collection of classic-inspired minigames.

The project focuses on modular architecture, independent game sessions, fair competition and persistent personal records.

> **Project status:** In development — Version 0.1

## Vision

Create a social arcade where players can enjoy different minigames, compete for high scores and gradually discover new experiences.

The initial goal is to deliver a complete and stable playable arcade machine while establishing the technical foundations for future minigames and shared systems.

## Current progress

The project already includes:

- A main arcade environment with four themed rooms.
- 28 physical arcade machines arranged throughout the arcade.
- A central area and connecting corridors.
- Custom architecture, flooring and decorative elements.
- Ambient and architectural lighting.
- An initial Rojo-based development workflow.
- An advanced implementation of BrickBreaker, including gameplay mechanics, controls, power-ups, level transitions and game interfaces.

The arcade environment's main architecture and lighting have been approved.

The general machine interaction, reservation and session systems are still pending. Persistent personal high scores have also not yet been implemented.

## Minigames

| Minigame | Inspiration | Status |
|---|---|---|
| BrickBreaker | Breakout-style gameplay | Advanced development |
| Block Puzzle | Classic block-placement puzzle games | Planned |
| Bubble Shooter | Puzzle Bobble-style gameplay | Planned |
| Space Shooter | Space Invaders-style gameplay | Planned |

All minigames will feature original implementations and assets while taking inspiration from classic arcade gameplay.

## BrickBreaker

BrickBreaker is currently the most advanced minigame in the project.

Implemented features include:

- Paddle and ball gameplay.
- Destructible blocks.
- Lives and scoring systems.
- Progressive levels.
- Temporary power-ups and effects.
- Keyboard and mouse controls.
- PRESS START initial screen.
- Pause menu with resume and exit options.
- Exit confirmation.
- Automatic level transitions.
- Full-screen GAME OVER screen.
- Final score display.
- Restarting with Space or mouse click.

Persistent high-score storage and integration with the general arcade machine and session systems are still pending.

## Planned features

- Interactive arcade machines.
- Independent minigame sessions.
- Persistent personal high scores.
- Retro-inspired visual design.
- Modular minigame architecture.
- Multiple simultaneous arcade sessions.
- Future leaderboards and progression systems.
- Unlockable rooms and additional minigames.
- Optional cosmetic customization and monetization.

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
│   ├── UI/
│   └── Minigames/
│       └── BrickBreaker/
├── server/
└── shared/

assets/
docs/
tests/
```

The project structure is organized to separate client-side, server-side and shared functionality. Individual minigames maintain their own modules and logic.

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
2. Open the Universo Arcade development experience.
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
- Fair competition without pay-to-win mechanics.
- Persistent player progression.

## Project status

Universo Arcade is in active development.

The main arcade environment has been built, and BrickBreaker has reached an advanced stage of implementation.

The current priorities are:

1. Consolidate the project structure and documentation.
2. Complete and stabilize BrickBreaker.
3. Implement persistent personal high scores.
4. Develop the shared arcade machine and session systems.
5. Integrate BrickBreaker into the general arcade experience.
6. Expand the project with the remaining minigames.

The first playable milestone aims to deliver one fully integrated arcade machine, one complete minigame, scoring and persistent personal records.

---

*Universo Arcade — A small arcade with endless possibilities.*