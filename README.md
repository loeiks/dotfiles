# loeiks's dotfiles

This repo contains all my Nix profiles which contains three profiles:

1. loeiks, my primary profile for up to date changes.
2. fresh, a fresh starting with all required tools, configs etc.
3. server, my general server dedicated profile.

> for now I only added "loeiks" later on I will add fresh and server as well.

I aim to fix few issues with this dotfiles repo via Nix and scripting;

- automate environment syncing and new instance setup
- sync configs and almost everything across various machines or instances
- get more experienced about shell scripting and nix home manager
- relax my brain and stop thinking about all above
- remember why I made different decisions and centralize configs/settings etc.

More detailed things are inside `docs/` folder.

---

Start with following;

1. `bash <(curl -fsSL https://raw.githubusercontent.com/loeiks/dotfiles/refs/heads/main/prep.sh)`

   Does the whole first-run setup: clones this repo to `~/dotfiles`, installs Nix,
   sets the hostname (Linux only), applies the Home Manager flake (`.#loeiks`, or
   `.#loeiks-m` on macOS), makes zsh the default shell, installs bun deps + globals
   and Docker, points `origin` at the SSH remote, then drops you into zsh.
   Needs `git` and `curl` present; safe to re-run.
2. When you need push access: `bun run manager` → "Generate SSH key", then add it to
   GitHub: <https://github.com/settings/ssh/new>

`bun run manager` also re-runs the bun globals install.

Any config change should be made within this repo via `Nix`.
Re-apply later with `nix run home-manager -- switch --flake .#loeiks` (`.#loeiks-m` on macOS).