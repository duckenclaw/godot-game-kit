# Godot Asset Library submission guide

The kits are root-layout for git submodules, which the Asset Library does **not**
consume directly. Before submitting, run `scripts/make-assetlib-branch.sh` to build
an `assetlib` branch per kit where the files live under `addons/<name>/`, push that
branch and its `assetlib-v1.0.0` tag, then submit from the Asset Library web form
(or the editor's *AssetLib → Submit*) pointing at that branch/tag.

Submit each kit as its own asset. Common fields:

- **Version control**: Git
- **Repository / Issues URL**: `https://github.com/duckenclaw/<repo>`
- **Download commit/branch**: the `assetlib` branch (tag `assetlib-v1.0.0`)
- **License**: MIT
- **Godot version**: 4.x (match the version you support)
- **Icon**: a 128×128 PNG (add one per kit before submitting; placeholder for now)

Per-kit metadata:

| Repo | Title | Category | Short description |
|------|-------|----------|-------------------|
| godot-core | Game Core | Tools | Service-layer autoloads: EventBus, SceneManager, AudioManager, SaveManager, Localization, Debug. |
| godot-settings-kit | Settings Kit | Tools | Settings persistence + key/gamepad rebinding with a reusable rebind-row UI. |
| godot-inventory-kit | Inventory Kit | Scripts | ItemResource, ItemDB, grid Inventory with stacking/quick-slots, InventorySlot. |
| godot-components-kit | Components Kit | Scripts | Saveable Health component and a genre-agnostic StateMachine + State base. |
| godot-fps-controller | FPS Controller | 3D Tools | First-person controller: movement states, camera, hands, grab, projectile, props, UI. |

After the first submission, each new tagged release is published by editing the
asset and updating the download commit — keep the Asset Library version in step
with the git tag (`v1.x.y` on `main`, mirrored to the `assetlib` branch).

Note: the Asset Library requires a public repository and a maintainer review pass,
so there is a short delay before an asset appears.
