# godot-game-kit

A modular ecosystem of reusable **Godot 4** addons, shared across game templates
of different genres (FPS, third-person, 2D sidescroller, top-down). This repo is
the **hub**: it aggregates the shared kits as git submodules and validates that
they integrate, and is the index for the whole system.

## The shared kits

Each kit is its own repository (root-layout, so it drops straight into a project's
`addons/` as a submodule) and its own Godot Asset Library entry.

| Kit | Repo | Provides |
|-----|------|----------|
| **Game Core** | [godot-core](https://github.com/duckenclaw/godot-core) | EventBus, SceneManager, AudioManager, SaveManager, Localization, Debug autoloads |
| **Settings Kit** | [godot-settings-kit](https://github.com/duckenclaw/godot-settings-kit) | `SettingsManager` (settings persistence + key/gamepad rebinding) + rebind-row UI |
| **Inventory Kit** | [godot-inventory-kit](https://github.com/duckenclaw/godot-inventory-kit) | `ItemResource`, `ItemDB`, grid `Inventory`, `InventorySlot` |
| **Components Kit** | [godot-components-kit](https://github.com/duckenclaw/godot-components-kit) | `Health`, `StateMachine` + `State` base |

## Genre controllers & templates

Each genre has a controller addon (its own repo, depends on the shared kits) and a
ready-to-use **GitHub template** that pulls the shared kits + its controller as
submodules. Click *Use this template* to start a game.

| Genre | Controller addon | Template (Use this template) |
|-------|------------------|------------------------------|
| **FPS** | [godot-fps-controller](https://github.com/duckenclaw/godot-fps-controller) — movement states, camera, hands/viewmodel, grab, projectile; modular mechanics | [fps-godot-template](https://github.com/duckenclaw/fps-godot-template) |
| **2D sidescroller** | [godot-platformer-controller-2d](https://github.com/duckenclaw/godot-platformer-controller-2d) — state machine + comprehensive animation controller (idle/run/jump/fall/roll/attack-combo/block/wall-slide/hurt/death); modular mechanics | [sidescroller-godot-template](https://github.com/duckenclaw/sidescroller-godot-template) |
| **Third-person** | *planned* | *planned* |
| **Top-down** | *planned* | *planned* |

Both controllers share the same modular-mechanics design: toggle abilities via
config flags, or delete a state node from the `StateMachine` to remove a mechanic.

## Use the kits in your game

```bash
# add a kit as a submodule straight into your project's addons/
git submodule add https://github.com/duckenclaw/godot-core addons/core
git submodule add https://github.com/duckenclaw/godot-inventory-kit addons/inventory_kit
git submodule update --init
```

Then enable the addons in *Project → Project Settings → Plugins*. For Asset
Library installation, see **Asset Library** below.

## This repo (hub)

```bash
git clone --recurse-submodules https://github.com/duckenclaw/godot-game-kit
# validate the integration headlessly:
godot --headless --path . --import
godot --headless --path . --script tests/smoke.gd   # expects "RESULT: 0 failures"
```

`tests/smoke.gd` loads each kit from its submodule and exercises its core API, so
CI catches a kit change that breaks integration.

## Publishing (maintainer)

The kits and this hub are developed locally first. When ready to publish:

```bash
scripts/publish.sh <owner> <public|private>      # creates GitHub repos, pushes, tags
scripts/make-assetlib-branch.sh <owner>          # builds addons/<name>/ branches for the Asset Library
```

See [`scripts/`](scripts/) and the roadmap below.

## Roadmap

- [x] **Phase 1** — split the FPS template into five addons in place.
- [x] **Phase 2** — extract shared kits into standalone repos (root layout, history via `git subtree split`); publish them (main + `v*` tags + `assetlib` branches).
- [x] **Phase 3** — FPS template consumes the kits as submodules; published as a GitHub template.
- [~] **Phase 4** — per-genre templates. **Done:** FPS, 2D sidescroller. **Planned:** third-person, top-down.
- [ ] Submit the shared kits + genre controllers to the Godot Asset Library (branches/SHAs ready; see `docs/asset-library.md`).

## License

MIT — see [LICENSE](LICENSE). Each kit repo carries its own MIT license.
