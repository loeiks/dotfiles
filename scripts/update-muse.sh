#!/usr/bin/env bash
set -euo pipefail

# Refresh pkgs/muse.nix from Meta's public Muse channel manifest.
# Run `bun run update:muse` (or `scripts/update-muse.sh`) after Meta ships a
# new release, then commit the resulting change.

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

exec python3 - "$REPO/pkgs/muse.nix" <<'PY'
import base64
import json
import re
import sys
import urllib.parse
import urllib.request

CHANNEL_URL = "https://api.meta.ai/muse-code/channels/muse-stable"
PLATFORMS = {
    "x86_64-linux": ("x86_linux", "muse-x86-linux"),
    "aarch64-linux": ("aarch64_linux", "muse-aarch64-linux"),
    "x86_64-darwin": ("x86_macos", "muse-x86-macos"),
    "aarch64-darwin": ("aarch64_macos", "muse-aarch64-macos"),
}


def fetch_json(url):
    request = urllib.request.Request(url, headers={"Accept": "application/json"})
    with urllib.request.urlopen(request, timeout=60) as response:
        return json.load(response)


def sri(checksum):
    return "sha256-" + base64.b64encode(bytes.fromhex(checksum)).decode()


path = sys.argv[1]
channel = fetch_json(CHANNEL_URL)
if channel.get("state") not in (None, "public"):
    sys.exit(f"muse: channel is not public (state={channel['state']!r})")

version = channel["version"]
release = fetch_json(channel["manifest_url"])
if release.get("version") != version:
    sys.exit("muse: channel and release manifests disagree on the version")
if release.get("checksum_algorithm") != "sha256":
    sys.exit("muse: unsupported checksum algorithm")

artifacts = release["artifacts"]
with open(path, encoding="utf-8") as handle:
    text = handle.read()

text = re.sub(
    r'(version = ")[^"]+(";)',
    lambda match: match.group(1) + version + match.group(2),
    text,
    count=1,
)

for system, (key, file_name) in PLATFORMS.items():
    artifact = artifacts.get(key)
    if artifact is None:
        sys.exit(f"muse: release has no artifact for {system} ({key})")

    # Trust the URL's file name when present, so a rename upstream is not
    # silently pinned to a stale label.
    query = urllib.parse.parse_qs(urllib.parse.urlparse(artifact["url"]).query)
    published_file = query.get("file", [file_name])[0]

    pattern = re.compile(
        r'(' + re.escape(system) + r' = \{\n)'
        r'(\s*file = ")[^"]+(";\n)'
        r'(\s*hash = ")[^"]+(";\n)'
    )
    replacement = (
        r'\1\2' + published_file + r'\3\4' + sri(artifact["checksum"]) + r'\5'
    )
    text, count = pattern.subn(replacement, text, count=1)
    if count != 1:
        sys.exit(f"muse: could not update the {system} source block in {path}")

with open(path, "w", encoding="utf-8") as handle:
    handle.write(text)

print(f"muse: updated {path} to {version}")
PY
