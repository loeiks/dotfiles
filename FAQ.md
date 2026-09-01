# FAQ, QAs to Remember

Q: **How do we sync Claude Code and OpenCode settings such as MCPs, Plugins etc.?**
A: Both shares a json file but works differently, OpenCode directly works over a `opencode.jsonc` file and handles most of the things via this single file, for Claude its similar it has `settings.json` file at `~/.claude/settings.json` but doesn't work only via this file, its kind of a list for Claude to know and more details are stored in different folders for Claude which cannot be symlinked easily. Plugin and MCP installs for (globally, we don't care about project level stuff) OpenCode done by editing file, for Claude its via commands which updates its file.

> Written by: loeiks

---

## Commit Signing

Q: **How does commit signing work here?**
A: Commits are signed with an SSH key whose private half never touches disk — it lives only in KeePassXC and is served through the SSH agent, from the same database on WSL (Windows OpenSSH agent → `wsl2-ssh-agent` bridge) and macOS (launchd `ssh-agent`). Nix wires it up: `modules/files.nix` symlinks `files/general/id_ed25519.pub` → `~/.ssh/id_ed25519.pub`, `modules/packages.nix` installs `wsl2-ssh-agent` + `socat` (Linux), `files/zsh/extra.zsh` runs `eval "$(wsl2-ssh-agent)"` on WSL, and `profiles/loeiks.nix` sets `gpg.format = ssh` + `commit.gpgSign`/`tag.gpgSign`/`user.signingKey`. One-time setup: KeePassXC SSH Agent integration (OpenSSH mode) with the private key attached to the entry and *Add key when DB unlocked / Remove when locked*; on WSL enable + start the Windows `ssh-agent` service; on GitHub add the public key as both an Authentication and a Signing key and enable Vigilant mode. Verify after unlocking the DB with `ssh-add -l`, `ssh -T git@github.com`, then a test commit and `git cat-file -p HEAD | grep SIGNATURE`. Gotchas: locking the DB drops the key so commits/pushes fail until unlock; `git log --show-signature` warns about `gpg.ssh.allowedSignersFile` locally (harmless); when rotating keys add the new key before removing the old and keep old keys in the signing slot.

> Written by: AI (summarized from `docs/Commit-Signing.md`, which was "AI Generated, I fixed")
