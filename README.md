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

The genre controllers (e.g. [godot-fps-controller](https://github.com/duckenclaw/godot-fps-controller))
live in their own repos too and depend on the four shared kits; each per-genre
template repo pulls the shared kits + its own controller.

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
- [x] **Phase 2 (local)** — extract shared kits into standalone repos (root layout, history via `git subtree split`), scaffold this hub with submodules + smoke test.
- [ ] **Phase 2 (publish)** — run `scripts/publish.sh`, submit kits to the Asset Library.
- [ ] **Phase 3** — convert the FPS template repo to consume the kits as submodules; make it a GitHub template repo.
- [ ] **Phase 4** — new per-genre templates (third-person, 2D sidescroller, top-down), each with its own controller + the shared kits.

## License

MIT — see [LICENSE](LICENSE). Each kit repo carries its own MIT license.
