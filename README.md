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

1. `cd ~/ && git clone https://github.com/loeiks/dotfiles && cd ~/dotfiles`
2. Prepare environment: `./prep.sh`. Installs Nix and sets the hostname (bootstrap only, no switch).
3. Apply dotfiles: `home-manager switch --flake .#loeiks` (installs packages, zsh, configs, plus `bun`).
4. Install bun-based tools: `bun run manager`.
5. Switch into zsh for the first time: `exec zsh` (installs plugins via zinit).
6. Point the repo at the SSH remote: `git remote set-url origin git@github.com:loeiks/dotfiles.git`

Any config change should be made within this repo via `Nix`.