#!/usr/bin/env bash
set -euo pipefail

# One-shot setup for a new machine (WSL/Linux or macOS). Safe to run again.
# bash <(curl -fsSL https://raw.githubusercontent.com/loeiks/dotfiles/refs/heads/main/prep.sh)

if [[ "$(id -u)" -eq 0 ]]; then
  echo "Error: run prep.sh as your normal user, not root (sudo prompts come from within)." >&2
  exit 1
fi

for t in git curl; do
  if ! command -v "$t" >/dev/null 2>&1; then
    echo "Error: '$t' is required. Install it first." >&2
    exit 1
  fi
done

# Refresh system packages first (Linux only). apt upgrades don't need a shell
# reload for anything prep does next, so we just continue.
if [[ "$(uname -s)" == "Linux" ]]; then
  echo "==> Updating system packages (apt)"
  sudo apt update
  sudo apt upgrade -y
fi

REPO="$HOME/dotfiles"

if [[ ! -d "$REPO/.git" ]]; then
  echo "==> Cloning dotfiles to $REPO"
  git clone https://github.com/loeiks/dotfiles "$REPO"
fi
cd "$REPO"

echo "==> Installing Nix"
bash scripts/install-nix.sh

# Make `nix` usable in this same run (the installer only patches login shells).
NIX_SH=/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
if [[ -e "$NIX_SH" ]]; then
  # shellcheck disable=SC1090
  . "$NIX_SH"
fi

# On macOS the fresh Nix install usually isn't active until a reboot. Stop here
# with a clean exit; re-running prep.sh after the reboot picks up from this point.
if ! command -v nix >/dev/null 2>&1; then
  echo
  if [[ "$(uname -s)" == "Darwin" ]]; then
    echo "==> Nix is installed but not active yet. Reboot, then run prep.sh again."
  else
    echo "==> Nix is installed but not on PATH yet. Open a new shell, then run prep.sh again."
  fi
  exit 0
fi

echo "==> Setting hostname"
bash scripts/set-hostname.sh

echo "==> Applying Home Manager configuration"
bash scripts/switch.sh

# Home Manager just populated ~/.nix-profile; put it on PATH so `zsh` resolves below.
export PATH="$HOME/.nix-profile/bin:$PATH"

echo "==> Setting zsh as the default shell"
bash scripts/default-zsh.sh

echo "==> Installing project dependencies (bun)"
bun install

echo "==> Installing global bun packages"
bash scripts/install-bun-globals.sh

echo "==> Installing Docker"
bash scripts/install-docker.sh

echo "==> Pointing origin at the SSH remote"
bash scripts/origin-ssh.sh

echo
echo "==> Done. Generate an SSH key and add it to GitHub when you need push access:"
echo "    bun run manager   (then https://github.com/settings/ssh/new)"
if [[ -t 0 ]]; then
  echo
  echo "Starting zsh..."
  exec zsh -l
else
  echo
  echo "Open a new shell: exec zsh -l"
fi
