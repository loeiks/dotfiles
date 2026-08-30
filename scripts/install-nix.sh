#!/usr/bin/env bash
set -euo pipefail

if command -v nix >/dev/null 2>&1; then
    echo "Nix is already installed ($(nix --version)), skipping install."
else
    curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh -s -- --daemon
fi

# The multi-user installer reads /etc/nix/nix.conf via the daemon, so flakes
# must be enabled there (a ~/.config/nix/nix.conf entry is ignored).
enable_flakes() {
  local conf="/etc/nix/nix.conf"
  local line="experimental-features = nix-command flakes"

  if grep -qF "$line" "$conf" 2>/dev/null; then
    echo "Flakes already enabled in $conf."
    return
  fi

  echo "$line" | sudo tee -a "$conf" >/dev/null

  case "$(uname -s)" in
    Linux)  sudo systemctl restart nix-daemon 2>/dev/null || true ;;
    Darwin) sudo launchctl kickstart -k system/org.nixos.nix-daemon 2>/dev/null || true ;;
  esac
}

enable_flakes