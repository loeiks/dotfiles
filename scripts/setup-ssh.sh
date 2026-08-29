#!/usr/bin/env bash
set -euo pipefail

KEY_PATH="${HOME}/.ssh/id_ed25519"
EMAIL="$(git config --get user.email 2>/dev/null || echo "90484193+loeiks@users.noreply.github.com")"

if [[ -f "$KEY_PATH" ]]; then
  echo "SSH key already exists at $KEY_PATH, skipping generation."
else
  mkdir -p "${HOME}/.ssh"
  chmod 700 "${HOME}/.ssh"
  ssh-keygen -t ed25519 -a 100 -C "$EMAIL" -N "" -f "$KEY_PATH"
fi

if ! pgrep -x ssh-agent >/dev/null 2>&1 && [[ -z "${SSH_AGENT_PID:-}" ]]; then
  eval "$(ssh-agent -s)"
else
  echo "ssh-agent is already running."
fi

ssh-add "$KEY_PATH" 2>/dev/null || ssh-add -A 2>/dev/null || true

echo ""
echo "Add the following public key to GitHub:"
echo ""
cat "${KEY_PATH}.pub"
echo ""
echo "https://github.com/settings/ssh/new"