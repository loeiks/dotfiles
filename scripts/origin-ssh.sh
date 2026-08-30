#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

git -C "$REPO" remote set-url origin git@github.com:loeiks/dotfiles.git
echo "origin -> $(git -C "$REPO" remote get-url origin)"
