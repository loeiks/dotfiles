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

REPO="$HOME/dotfiles"

if [[ ! -d "$REPO/.git" ]]; then
  echo "==> Cloning dotfiles to $REPO"
  git clone https://github.com/loeiks/dotfiles "$REPO"
fi
cd "$REPO"

echo "==> Installing Nix"
bash scripts/prep/install-nix.sh

# Make `nix` usable in this same run (the installer only patches login shells).
NIX_SH=/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
if [[ -e "$NIX_SH" ]]; then
  # shellcheck disable=SC1090
  . "$NIX_SH"
fi

echo "==> Setting hostname"
bash scripts/prep/set-hostname.sh

echo "==> Applying Home Manager configuration"
bash scripts/prep/switch.sh

# Home Manager just populated ~/.nix-profile; put it on PATH so `zsh` resolves below.
export PATH="$HOME/.nix-profile/bin:$PATH"

echo "==> Setting zsh as the default shell"
bash scripts/prep/default-zsh.sh

echo "==> Pointing origin at the SSH remote"
bash scripts/prep/origin-ssh.sh

echo
echo "==> Done."
if [[ -t 0 ]]; then
  exec zsh -l
else
  echo
  echo "Open a new shell: exec zsh -l"
fi
