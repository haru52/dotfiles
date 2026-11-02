# AGENTS.md

This file provides guidance to AI coding agents when working with code in this repository.

## English writing style

- When writing in English (e.g., code comments, Git commit messages, PR titles and bodies), use natural, concise, and plain wording wherever possible
- Write `e.g.,` and `i.e.,` (with a trailing comma), not bare `e.g.` or `i.e.`

## Roles of code, tests, commits, and comments

- As a rule, code describes how, test code describes what, commit messages describe why, and code comments describe why not

## Repository purpose

haru's personal dotfiles. Targets macOS (Apple silicon — Homebrew paths are hardcoded to `/opt/homebrew`) and Linux (including WSL2). Installation is driven by `make` / `install.sh`, which symlinks config files from `dotfiles/` into `~`, copies the Prezto runcoms into `~/.zprezto`, and symlinks scripts from `bin/` (and `private_bin/`, if present) into `~/bin`.

## Common commands

|                        Task                         |                                Command                                 |
| --------------------------------------------------- | ---------------------------------------------------------------------- |
| Install dotfiles onto the system                    | `make` (alias for `make install` → `./install.sh`)                     |
| Set up dev tooling (npm + Vale styles)              | `make dev-install`                                                     |
| Run all linters                                     | `make lint`                                                            |
| Lint one category                                   | `make lint-npm` / `make lint-text` / `make lint-yaml` / `make lint-sh` |
| Auto-fix Markdown and Prettier issues               | `npm run format`                                                       |
| Regenerate `.gitignore` from gibo                   | `make update-gi`                                                       |
| Regenerate global gitignores shipped in `dotfiles/` | `make update-gi-global`                                                |
| Conventional-commit helper                          | `npm run commit` (or `npm run cm`)                                     |

`make lint-npm` runs `npm run lint`, which fans out via `run-s --continue-on-error` to `secretlint` (skipped when `CI=true`), `markdownlint`, and `prettier --check`. `make lint-text` runs Vale on `README.md`, `CONTRIBUTING.md`, `SECURITY.md`, and `.github/` only (not on `AGENTS.md`). `make lint-sh` runs ShellCheck with `--enable=all --severity=style` — match those flags if invoking ShellCheck manually.

Linter coverage gaps to cover by hand:

- **`make lint-sh` does not check the top-level `bin/*.sh` scripts.** Make runs the recipe with `/bin/sh`, where `bin/**/*.sh` behaves like `bin/*/*.sh` and matches only `bin/linux/apt-update.sh`. After editing anything in `bin/`, also run `shellcheck --enable=all --severity=style bin/*.sh`. The lint-staged pre-commit `shellcheck` uses default flags, so it is not a substitute.
- The zsh files under `dotfiles/zprezto/` (`runcoms/*`, `modules/git/alias.zsh`) are not covered by any linter; syntax-check them with `zsh -n <file>`.

There is no test suite; `npm test` intentionally exits 1.

## Architecture

The repo is a two-layer install system:

1. **`dotfiles/`** — files that get symlinked into `$HOME`. `install.sh` exits 1 if `dotfiles/` is missing, then globs `dotfiles/*` (with `dotglob`/`nullglob`) and `ln -sfv` each regular file into `~`. Subdirectories under `dotfiles/` are *not* symlinked; they are handled by special cases:
   - `dotfiles/zprezto/` mirrors the layout of `~/.zprezto`. `dotfiles/zprezto/runcoms/{zpreztorc,zprofile,zshrc}` are **copied** (not symlinked) into `~/.zprezto/runcoms`, where Prezto's own `~/.zshrc`, `~/.zprofile`, etc. symlinks point. Edits take effect only after `make install` and a new shell.
   - `dotfiles/zprezto/modules/git/alias.zsh` is copied over `~/.zprezto/modules/git/alias.zsh`. It is a fork of the upstream Prezto git module's aliases.
   - Both copies overwrite tracked files in the Prezto git checkout, so `~/.zprezto` always shows them as modified, and upstream Prezto changes to those files have to be merged into this repo by hand.
   - `dotfiles/wsl/{wsl.conf,resolv_template.conf}` is symlinked into `/etc/` only when `get-os.sh` reports `linux` (this branch currently has no WSL-vs-native-Linux guard — see the TODO in `install.sh`).
   - `.gitconfig` uses `includeIf "gitdir:~/workspace/haru52/"` to load `.gitconfig_personal`, which switches the global excludes file to `~/.gitignore_global_personal`.

2. **`bin/`** — shell scripts symlinked into `~/bin` *without the `.sh` suffix* (e.g., `bin/clean-branch.sh` → `~/bin/clean-branch`). New top-level `bin/*.sh` scripts are picked up automatically. `bin/linux/` is *not* globbed: only `bin/linux/apt-update.sh` is linked, by a hardcoded Linux-only line in `install.sh`, so a new Linux-only script needs its own line there. If the optional, gitignored `private_bin` symlink exists (points to a user-private directory), its `*.sh` scripts are installed the same way as `bin/*.sh`.

3. **Gitignore generation** — `.gitignore` and the two `dotfiles/.gitignore_global*` files are generated by `gibo`. The `*_custom` files at the repo root hold the hand-written prefix that each generated file starts with; never edit the generated files directly — edit the `*_custom` prefix and re-run `make update-gi` / `make update-gi-global`. The two global files differ in that `.gitignore_global` ignores `.serena/` while `.gitignore_global_personal` (active under `~/workspace/haru52/`) does not, which is why this repo can track `.serena/`.

4. **OS detection** — `./get-os.sh` prints `mac` or `linux` (and exits 1 on anything else); it is the canonical check for code that runs from the repo (`install.sh`). Code that runs from outside the repo — `bin/*.sh` (invoked through `~/bin` symlinks) and the zsh runcoms (copied into `~/.zprezto`) — cannot locate `get-os.sh`, so it inlines the same switch (`Darwin) os=mac`, `Linux) os=linux`). Keep that mapping identical everywhere and don't introduce other `uname` variants.

## Zsh configuration (Prezto)

- The runcoms keep the upstream Prezto template structure (Sorin Ionescu header). Personal additions go below the `# Custom` marker in `zprofile` and the `# Customize to your needs...` marker in `zshrc`.
- `zprofile` holds environment variables and `PATH`. Prezto's `zshenv` also sources it for non-login, non-interactive shells, so it must not reference positional parameters such as `$1`. `typeset -gU ... path PATH` dedupes entries. Later prepends win: `brew shellenv` runs before the asdf shims are prepended, so asdf keeps precedence.
- `zshrc` holds interactive-only setup: Prezto init, aliases, shell functions, completion and hook `eval`s (fzf, direnv, uv), `GPG_TTY`, and the Claude Code / MCP helper aliases.
- Prezto modules are enabled in `zpreztorc` (`zstyle ':prezto:load' pmodule`). ssh-agent is managed solely by the Prezto `ssh` module, which loads `id_ed25519`; don't add keychain or another agent launcher.

## Conventions

Pulled from `CONTRIBUTING.md` — apply to any new shell code:

- File names: `kebab-case.sh`; variables: `snake_case`.
- Comments/identifiers in English.
- Max line length: 100 half-width chars; 2-space indent.
- Must pass `shellcheck --enable=all --severity=style` cleanly.
- Default shebang is `#!/bin/sh`; use `#!/usr/bin/env bash` only when bash features are actually required (`install.sh` is a legitimate bash example).

Commits follow **Conventional Commits** (enforced by commitlint via the husky `commit-msg` hook). Pre-commit runs `lint-staged`, which applies `secretlint` + `prettier --check` to everything, `markdownlint` + `make lint-text` to Markdown, `make lint-yaml` to YAML, and `shellcheck` to shell files. Branching follows GitHub flow; PR titles follow the same rule as commits.

## Serena

`.serena/project.yml` (bash language server) and `.serena/memories/*.md` are tracked; `.serena/cache/` and `.serena/project.local.yml` are gitignored. The memories mirror this file — when you change the architecture, commands, or conventions described here, update the matching memory as well. `.serena/` and `.claude/` are excluded from markdownlint and Prettier.
