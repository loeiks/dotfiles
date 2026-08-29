#!/usr/bin/env bash
set -euo pipefail

if [[ "$(id -u)" -eq 0 ]]; then
  echo "Error: do not run prep.sh as root or with sudo." >&2
  echo "Run it as your normal user (sudo prompts come from within)." >&2
  exit 1
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Installing Nix"
"$ROOT/scripts/install-nix.sh"

echo "==> Setting hostname"
"$ROOT/scripts/set-hostname.sh"

echo
echo "==> Done. Apply your dotfiles by running:"
echo "    home-manager switch --flake .#loeiks"