#!/usr/bin/env bash
#
# Build an `assetlib` branch for each kit in the Asset-Library layout.
#
#   scripts/make-assetlib-branch.sh [owner]
#
# The kit repos are root-layout (plugin.cfg at the repo root) which is ideal for
# git submodules but NOT what the Godot Asset Library expects — the AssetLib
# installer copies an `addons/<name>/` folder out of the archive. This script
# creates/refreshes an orphan `assetlib` branch in each kit where the same files
# live under `addons/<name>/`, and tags it `assetlib-v1.0.0`. Point the Asset
# Library submission at that branch/tag.
#
# Run AFTER publish.sh (needs the repos to exist to push). Requires `gh`.
# Written for bash 3.2 (macOS default) — no associative arrays.
set -euo pipefail

OWNER="${1:-duckenclaw}"
VERSION="assetlib-v1.0.0"
HUB="$(cd "$(dirname "$0")/.." && pwd)"
WS="$(dirname "$HUB")"

KITS="godot-core godot-settings-kit godot-inventory-kit godot-components-kit godot-fps-controller"

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

for repo in $KITS; do
  name="$(plugin_for "$repo")"
  dir="$WS/$repo"
  echo "[$repo] building assetlib layout addons/$name/"
  ( cd "$dir"
    work="$(mktemp -d)"
    mkdir -p "$work/addons/$name"
    # copy tracked files (main branch) into addons/<name>/
    git archive main | tar -x -C "$work/addons/$name"
    git checkout --orphan assetlib >/dev/null 2>&1 || git checkout assetlib
    git rm -rqf . >/dev/null 2>&1 || true
    cp -R "$work/addons" ./addons
    git add addons
    git -c user.name="DuckenClaw" -c user.email="sen@duckenclaw.xyz" commit -qm "Asset Library layout ($VERSION)" || true
    git tag -f "$VERSION" >/dev/null
    git checkout - >/dev/null 2>&1 || git checkout main
    rm -rf "$work"
    echo "  built. Push with: (cd $dir && git push origin assetlib && git push origin $VERSION)"
  )
done
echo "Then in Godot: AssetLib submission points at the 'assetlib' branch / $VERSION tag of each repo."
