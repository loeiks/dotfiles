# loeiks's dotfiles

This repo contains all my Nix profiles which contains three profiles:

1. loeiks, my primary profile for up to date changes.
2. fresh, a fresh starting with all required tools, configs etc.
3. server, my general server dedicated profile.

I aim to fix few issues with this dotfiles repo via Nix and scripting;

- automate environment syncing and new instance setup
- sync configs and almost everything across various machines or instances
- get more experienced about shell scripting and nix home manager
- relax my brain and stop over-thinking about all above

More detailed things are inside `docs/` folder.

---

For a new instance setup;

`bash <(curl -fsSL https://raw.githubusercontent.com/loeiks/dotfiles/refs/heads/main/prep.sh)`

Handles the whole first-run setup: clones this repo to `~/dotfiles`, installs Nix, sets the hostname, applies the Home Manager flake, makes zsh the default shell, installs bun deps + globals and Docker, then drops you into zsh. *Needs `git` and `curl` present*; safe to re-run.

> Optionally you can also clone repo and run `prep.sh` script locally.

Then you can use `bun run manager` to run selected actions manually.

---

Any config change should be made within this repo via `Nix`. Re-apply later with `nix run home-manager -- switch --flake .#loeiks` (`.#loeiks-m` on macOS).