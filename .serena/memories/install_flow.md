# Install flow (install.sh)

Two-layer install system:

## 1. `dotfiles/` → `$HOME`
- `install.sh` exits 1 if `dotfiles/` is missing, then globs `dotfiles/*` (with `dotglob`/`nullglob`) and `ln -sfv` each regular file into `~`.
- Subdirectories under `dotfiles/` are NOT symlinked; they are handled by special cases:
  - `dotfiles/zprezto/` mirrors the layout of `~/.zprezto`. `dotfiles/zprezto/runcoms/*`
    (`zpreztorc`, `zprofile`, `zshrc`) → COPIED (not symlinked) into `~/.zprezto/runcoms`.
    Prezto's own `~/.zshrc`, `~/.zprofile`, etc. symlinks point into that dir. Edits take effect
    only after re-running `make install` and starting a new shell.
  - `dotfiles/zprezto/modules/git/alias.zsh` → copied over `~/.zprezto/modules/git/alias.zsh`
    (a fork of the upstream Prezto git module aliases).
  - Both copies overwrite tracked files of the Prezto git checkout, so `~/.zprezto` always shows
    them as modified; upstream Prezto changes to those files must be merged into this repo by hand.
  - `dotfiles/wsl/{wsl.conf,resolv_template.conf}` → `sudo` symlinked into `/etc/` when
    `get-os.sh` reports `linux`. **Known TODO**: no WSL-vs-native-Linux guard yet.

## 2. `bin/` → `~/bin`
- `bin/*.sh` are symlinked into `~/bin` WITHOUT the `.sh` suffix
  (e.g., `bin/clean-branch.sh` → `~/bin/clean-branch`). New top-level scripts are picked up
  automatically.
- `bin/linux/` is NOT globbed: only `bin/linux/apt-update.sh` is linked, via a hardcoded line
  guarded by `os = linux`. A new Linux-only script needs its own line in `install.sh`.
- If a `private_bin` symlink exists (pointing to a user-private dir; gitignored), its `*.sh`
  scripts are installed the same way.

## OS detection
- `install.sh` calls `./get-os.sh`. Returns `mac` or `linux`; exits 1 on anything else.
- Scripts run from `~/bin` and the copied zsh runcoms can't locate `get-os.sh`, so they inline
  `case $(uname) in Darwin) os=mac ;; Linux) os=linux ;; esac` (e.g., `bin/all-update.sh`,
  `zprofile`). Keep that mapping identical everywhere; don't add other `uname` variants.

## Current `bin/` contents
- `all-update.sh` — updates apt (Linux), Homebrew, TeX Live (macOS), asdf plugins, pip,
  RubyGems, gibo, and Prezto in one go.
- `clean-branch.sh` — deletes local branches merged (incl. squash-merged) into the default branch;
  skips `main`/`master`/`develop` and `sandbox*`.
- `get-npm-latest.sh` — prints the latest stable version of an npm package, optionally limited
  to a major version.
- `rm-merged-worktrees.sh` — removes git worktrees whose branches are merged into a base branch
  (default `develop`).
- `linux/apt-update.sh` — apt update / upgrade / full-upgrade / autoremove / autoclean.

## Current `dotfiles/` subdirs
- `wsl/`, `zprezto/` (both special-cased, see above). `zprezto/` holds `runcoms/` and
  `modules/git/`, mirroring `~/.zprezto`.
