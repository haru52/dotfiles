# Code Style & Conventions

## Shell scripts (from CONTRIBUTING.md)
- File names: `kebab-case.sh`.
- Variable names: `snake_case`.
- Comments and identifiers: English only.
- Max line length: 100 half-width chars.
- Indentation: 2 spaces.
- Must pass `shellcheck --enable=all --severity=style` with no errors or warnings
  (e.g., SC2312: capture `$(cmd)` into a variable before `eval "${var}"`).
- Default shebang: `#!/bin/sh`. Use `#!/usr/bin/env bash` only when bash features are actually
  required (`install.sh` is a legitimate bash example; `get-os.sh` uses `/bin/sh`).
- OS detection: `get-os.sh` from repo-local code; inline the identical
  `case $(uname) in Darwin) os=mac ;; Linux) os=linux ;; esac` in `bin/*.sh` and zsh runcoms,
  which run outside the repo and can't locate `get-os.sh`.

## Zsh runcoms
- See the `zsh_config` memory (upstream Prezto structure, zprofile vs zshrc split).
- Not ShellCheck-linted (zsh); syntax-check with `zsh -n`.

## Markdown / YAML / misc
- `markdownlint` + `prettier --check` enforce formatting (see `.markdownlint.yml`, `.prettierignore`).
  Prettier ignores `*.md` and `*.yml` (markdownlint / yamllint own those); `.serena/` and
  `.claude/` are excluded from both.
- `yamllint --strict` for YAML.
- `vale` for top-level prose Markdown (`README.md`, `CONTRIBUTING.md`, `SECURITY.md`, `.github/`).
  `AGENTS.md` is not Vale-linted.
- `secretlint` scans everything for credential leaks (skipped in CI via `$CI=true`).

## Git
- **Commits**: Conventional Commits v1.0.0, enforced by commitlint via husky `commit-msg` hook.
- **Branching**: GitHub flow.
- **Versioning**: Semantic Versioning 2.0.0.
- **PR titles**: same rule as commit messages.

## Pre-commit (lint-staged)
From `.lintstagedrc.yml`:
- `*`: `secretlint`, `prettier --check`.
- `*.{md,markdown}`: `markdownlint`, `make lint-text`.
- `*.{yml,yaml}`: `make lint-yaml`.
- `{*.sh,.husky/*}`: `shellcheck` (default flags, NOT `--enable=all --severity=style`).

## Generated files — do not hand-edit
- `.gitignore`, `dotfiles/.gitignore_global`, `dotfiles/.gitignore_global_personal`.
- Their hand-written prefixes live in the matching `*_custom` files at the repo root.
- Regenerate via `make update-gi` / `make update-gi-global`.
