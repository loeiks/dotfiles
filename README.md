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

   Clones this repo to `~/dotfiles`, installs Nix, sets the hostname (Linux only),
   applies the Home Manager flake (`.#loeiks`, or `.#loeiks-m` on macOS), makes zsh
   the default shell, points `origin` at the SSH remote, then drops you into zsh.
   Needs `git` and `curl` present; safe to re-run.
2. In the new zsh: `cd ~/dotfiles && bun run manager` — Docker, bun globals, SSH key.
3. Add the printed SSH public key to GitHub: <https://github.com/settings/ssh/new>

Any config change should be made within this repo via `Nix`.
Re-apply later with `nix run home-manager -- switch --flake .#loeiks` (`.#loeiks-m` on macOS).