#!/usr/bin/env bash
set -euo pipefail

case "$(uname -s)" in
  Linux)
    sudo hostnamectl set-hostname ubuntu
    echo -e "[network]\ngenerateHosts = false" | sudo tee -a /etc/wsl.conf
    ;;
  *)
    echo "Skipping hostname: only set on Linux/WSL (current OS is $(uname -s))."
    ;;
esac