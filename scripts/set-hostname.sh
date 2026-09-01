#!/usr/bin/env bash
set -euo pipefail

HOSTNAME="ubuntu"

case "$(uname -s)" in
  Linux)
    sudo hostnamectl set-hostname "$HOSTNAME"

    # On native Linux hostnamectl persists on its own. WSL instead resets the
    # hostname from Windows on every start, so persist it via /etc/wsl.conf.
    if ! grep -qiE 'microsoft|wsl' /proc/version; then
      exit 0
    fi

    WSL_CONF=/etc/wsl.conf
    grep -qs '^\[network\]' "$WSL_CONF" || printf '\n[network]\n' | sudo tee -a "$WSL_CONF" >/dev/null

    set_conf() {
      local key="$1" value="$2"
      if grep -qs "^${key}[[:space:]]*=" "$WSL_CONF"; then
        sudo sed -i "s|^${key}[[:space:]]*=.*|${key} = ${value}|" "$WSL_CONF"
      else
        sudo sed -i "/^\[network\]/a ${key} = ${value}" "$WSL_CONF"
      fi
    }
    set_conf hostname "$HOSTNAME"
    set_conf generateHosts false
    echo "Note: run 'wsl --shutdown' from Windows to apply /etc/wsl.conf."
    ;;
  *)
    echo "Skipping hostname: only set on Linux/WSL (current OS is $(uname -s))."
    ;;
esac
