# Commit Signing (SSH via KeePassXC)

Git commits are signed with an **SSH key whose private half never touches disk** it lives only in KeePassXC and is served through the SSH agent. Works on WSL and macOS with the same KeePassXC database.

## How it fits together

```
KeePassXC (holds private key)
  ├─ macOS  → adds key to the launchd ssh-agent  → git signs directly
  └─ WSL    → adds key to the Windows OpenSSH agent
                 └─ wsl2-ssh-agent bridges it into WSL → git signs
```

The public key is committed at `files/general/id_ed25519.pub` and symlinked to `~/.ssh/id_ed25519.pub` by `modules/files.nix`. `git`'s `user.signingKey` points at that path; the private half comes from the agent.

## What Nix manages

| File                           | Purpose                                                                |
| ------------------------------ | ---------------------------------------------------------------------- |
| `files/general/id_ed25519.pub` | the public key (source of truth)                                       |
| `modules/files.nix`            | symlinks it to `~/.ssh/id_ed25519.pub`                                 |
| `modules/packages.nix`         | installs `wsl2-ssh-agent` + `socat` (Linux only)                       |
| `files/zsh/extra.zsh`          | on WSL, runs `eval "$(wsl2-ssh-agent)"` to bridge the agent            |
| `profiles/loeiks.nix`          | `gpg.format = ssh`, `commit.gpgSign`, `tag.gpgSign`, `user.signingKey` |

## One-time setup

### KeePassXC
1. Settings → **SSH Agent** → enable integration, mode **Use OpenSSH**.
2. On the entry holding the key: **Advanced** → attach the private key file.
3. Same entry → **SSH Agent** tab → select the attachment, tick
   *Add key when database is unlocked* and *Remove when locked*.

### Windows (WSL only)
```powershell
Get-Service ssh-agent | Set-Service -StartupType Automatic
Start-Service ssh-agent
```

### GitHub
- Add the public key twice: once as an **Authentication key**, once as a **Signing key**.
- Settings → SSH and GPG keys → tick **Flag unsigned commits as unverified**
  (Vigilant mode).

## Verify

Unlock the KeePassXC database, then:

```sh
ssh-add -l                                  # KeePassXC key is listed
ssh -T git@github.com                        # "Hi loeiks!"
git commit --allow-empty -m "sig test"
git cat-file -p HEAD | grep SIGNATURE        # BEGIN SSH SIGNATURE
git reset --soft HEAD~1
```

`ssh-add -l` can be run in PowerShell (Windows agent), WSL zsh (bridged), or the
macOS terminal (launchd agent) — all should show the same key.

## Notes

- Lock the database → no key in the agent → commits and pushes fail until you unlock.
  This is expected.
- `git log --show-signature` prints *"gpg.ssh.allowedSignersFile needs to be
  configured"* locally — signing and GitHub verification are unaffected; only local
  verification is disabled.
- Rotating keys: add the new public key on GitHub **before** removing the old one, and
  keep old public keys in the signing slot so historical commits stay verified.

---

> AI Generated, I fixed.