#!/usr/bin/env bash
set -euo pipefail

curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh -s -- --daemon

nix flake --help