#!/usr/bin/env bash
set -euo pipefail

if ! command -v zsh &>/dev/null; then
  echo "zsh is not installed; skipping. Install it via \`nix develop\` or modules/packages.nix."
  exit 0
fi

ZSH_PATH="$(command -v zsh)"

if ! grep -qxF "$ZSH_PATH" /etc/shells; then
  echo "Adding $ZSH_PATH to /etc/shells..."
  echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
fi

if [ "$SHELL" != "$ZSH_PATH" ]; then
  echo "Setting default shell to $ZSH_PATH..."
  chsh -s "$ZSH_PATH"
else
  echo "zsh is already the default shell."
fi