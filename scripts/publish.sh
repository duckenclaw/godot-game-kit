#!/usr/bin/env bash
#
# Publish the shared kits and this hub to GitHub.
#
#   scripts/publish.sh [owner] [public|private]
#
# Defaults: owner=duckenclaw, visibility=public.
#
# For each kit repo it creates the GitHub repo, pushes main, and tags v1.0.0.
# Then it re-points this hub's submodule URLs from local paths to the GitHub
# URLs, and publishes the hub. Requires an authenticated `gh` CLI.
#
# Safe to re-run: existing repos are skipped for creation and just pushed.
# Written for bash 3.2 (macOS default) — no associative arrays.
set -euo pipefail

OWNER="${1:-duckenclaw}"
VIS="${2:-public}"
VERSION="v1.0.0"

HUB="$(cd "$(dirname "$0")/.." && pwd)"
WS="$(dirname "$HUB")"

KITS="godot-core godot-settings-kit godot-inventory-kit godot-components-kit godot-fps-controller"
# The four shared kits that this hub wires as submodules under addons/.
SHARED="godot-core godot-settings-kit godot-inventory-kit godot-components-kit"

# Map a kit repo name to its addon (plugin) directory name.
plugin_for() {
  case "$1" in
    godot-core)           echo core ;;
    godot-settings-kit)   echo settings_kit ;;
    godot-inventory-kit)  echo inventory_kit ;;
    godot-components-kit) echo components_kit ;;
    godot-fps-controller) echo fps_controller ;;
    *) echo "unknown" ;;
  esac
}

echo "About to publish to github.com/$OWNER as $VIS repos:"
for r in $KITS godot-game-kit; do echo "  - $r"; done
read -r -p "Proceed? [y/N] " ans
[ "$ans" = "y" ] || { echo "aborted"; exit 1; }

create_and_push() {
  dir="$1"; name="$2"
  ( cd "$dir"
    git tag -f "$VERSION" >/dev/null
    if gh repo view "$OWNER/$name" >/dev/null 2>&1; then
      echo "[$name] repo exists — pushing"
      git remote get-url origin >/dev/null 2>&1 || git remote add origin "https://github.com/$OWNER/$name.git"
      git push -u origin main
    else
      echo "[$name] creating + pushing"
      gh repo create "$OWNER/$name" --"$VIS" --source=. --remote=origin --push
    fi
    git push origin "$VERSION"
  )
}

for repo in $KITS; do
  create_and_push "$WS/$repo" "$repo"
done

echo "Re-pointing hub submodules at GitHub URLs..."
cd "$HUB"
for repo in $SHARED; do
  name="$(plugin_for "$repo")"
  git config -f .gitmodules "submodule.addons/$name.url" "https://github.com/$OWNER/$repo.git"
done
git submodule sync
git add .gitmodules
git commit -m "Point submodules at GitHub remotes" || true
create_and_push "$HUB" "godot-game-kit"

echo "Done. Verify a clean consumer clone with:"
echo "  git clone --recurse-submodules https://github.com/$OWNER/godot-game-kit /tmp/ggk-check"
