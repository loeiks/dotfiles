#!/usr/bin/env bash
set -euo pipefail

install_linux() {
  if [[ "$(id -u)" -eq 0 ]]; then
    echo "Error: do not run this script as root or with sudo." >&2
    echo "Run it as your normal user: ./install-docker.sh (it calls sudo internally)." >&2
    exit 1
  fi

  sudo apt remove -y $(dpkg-query -W -f='${Package}\n' docker.io docker-compose docker-compose-v2 docker-doc docker-buildx podman-docker containerd runc 2>/dev/null) || true

  sudo apt update
  sudo apt install ca-certificates curl -y

  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  # Add the repository to Apt sources:
  sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

  sudo apt update
  sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

  sudo systemctl enable --now docker

  sudo groupadd -f docker
  sudo usermod -aG docker "$USER"

  echo "Docker installed. Run 'rrl' (or open a new shell) then 'docker run hello-world' to verify."
}

install_darwin() {
  echo "Docker isn't scripted on macOS. Install Docker Desktop instead: https://www.docker.com/products/docker-desktop"
}

case "$(uname -s)" in
Linux) install_linux ;;
Darwin) install_darwin ;;
*)
  echo "Error: unsupported OS $(uname -s)." >&2
  exit 1
  ;;
esac
