# Install flow (install.sh)

Two-layer install system:

## 1. `dotfiles/` → `$HOME`
- `install.sh` iterates `ls -A dotfiles/` and `ln -sfv` each regular file into `~`.
- Subdirectories under `dotfiles/` are NOT symlinked; they are handled by special cases:
  - `dotfiles/zprezto/*` → copied (not symlinked) into `~/.zprezto/runcoms`.
  - `dotfiles/etc/alias.zsh` → copied into `~/.zprezto/modules/git`.
  - `dotfiles/wsl/{wsl.conf,resolv_template.conf}` → symlinked into `/etc/` when
    `get-os.sh` reports `linux`. **Known TODO**: no WSL-vs-native-Linux guard yet.

## 2. `bin/` → `~/bin`
- Scripts symlinked into `~/bin` WITHOUT the `.sh` suffix
  (e.g. `bin/clean-branch.sh` → `~/bin/clean-branch`).
- `bin/linux/apt-update.sh` is only linked on Linux.
- If a `private_bin` symlink exists (pointing to a user-private dir), its `*.sh`
  scripts are installed the same way.

## OS detection
- Always call `./get-os.sh`. Returns `mac` or `linux`; exits 1 on anything else.
- Don't duplicate `uname` switches elsewhere in the codebase.

## Current `bin/` contents
- `all-update.sh`, `clean-branch.sh`, `rm-merged-worktrees.sh`, plus `linux/apt-update.sh`.

## Current `dotfiles/` subdirs
- `etc/`, `wsl/`, `zprezto/` (all special-cased, see above).
