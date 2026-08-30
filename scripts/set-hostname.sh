#!/usr/bin/env bash
set -euo pipefail

case "$(uname -s)" in
  Linux)
    sudo hostnamectl set-hostname ubuntu
    # Only add the wsl.conf entry if it isn't already there, so re-runs don't stack it.
    if ! grep -qs '^generateHosts\s*=\s*false' /etc/wsl.conf; then
      echo -e "[network]\ngenerateHosts = false" | sudo tee -a /etc/wsl.conf
    fi
    ;;
  *)
    echo "Skipping hostname: only set on Linux/WSL (current OS is $(uname -s))."
    ;;
esac