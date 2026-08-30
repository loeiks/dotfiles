#!/usr/bin/env bash
set -euo pipefail

# Apply the repo's Home Manager flake. Uses `nix run` so the home-manager CLI
# never has to be installed (installing it collides with the flake's
# programs.home-manager.enable).

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

case "$(uname -s)" in
  Darwin) profile="loeiks-m" ;;
  *)      profile="loeiks" ;;
esac

exec nix run home-manager -- switch --flake "$REPO#$profile"
