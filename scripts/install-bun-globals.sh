#!/usr/bin/env bash
set -euo pipefail

LIST_FILE="$(dirname "$0")/bun-globals.txt"

if ! command -v bun >/dev/null 2>&1; then
  echo "Error: 'bun' is not on PATH. Install it first (e.g. via Nix home-manager)." >&2
  exit 1
fi

if [[ ! -f "$LIST_FILE" ]]; then
  echo "Error: $LIST_FILE not found." >&2
  exit 1
fi

packages=()
while IFS= read -r pkg; do
  packages+=("$pkg")
done < <(grep -vE '^\s*(#|$)' "$LIST_FILE")

if [[ ${#packages[@]} -eq 0 ]]; then
  echo "No packages found in $LIST_FILE."
  exit 0
fi

echo "Installing global bun packages: ${packages[*]}"
bun add -g "${packages[@]}"
