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

1. `cd ~/ && git clone https://github.com/loeiks/dotfiles`
2. Prepare environment: `./prep.sh`, will intall Nix etc. finally does switch.
3. Next `bun run manager`. Install bun based tools.
4. Now switch into zsh for the first time, `exec zsh`. So plugins gets installed. 
5. Finally set repo's remot via SSH, and ready!

Any config change should be made within this repo via `Nix`.