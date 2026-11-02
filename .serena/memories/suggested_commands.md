# Suggested Commands

## Install / setup
- `make` — alias for `make install` → runs `./install.sh` (symlinks dotfiles and `bin/`, copies
  the Prezto runcoms and `alias.zsh`). Re-run after editing anything under `dotfiles/zprezto/`.
- `make dev-install` — `npm ci` + `vale sync`; run once before linting.

## Lint (run before commit / task completion)
- `make lint` — runs all lint categories.
- `make lint-npm` — `npm run lint` → fans out via `run-s --continue-on-error` to:
  `secretlint` (skipped when `CI=true`), `markdownlint`, `prettier --check`.
- `make lint-text` — Vale on `README.md CONTRIBUTING.md SECURITY.md .github/*.md .github/ISSUE_TEMPLATE`.
- `make lint-yaml` — `yamllint --strict .`.
- `make lint-sh` — `shellcheck --enable=all --severity=style *.sh bin/**/*.sh .husky/commit-msg .husky/pre-commit`.
  Match those flags if running shellcheck manually.
  - GOTCHA: Make runs this with `/bin/sh` (no globstar), so `bin/**/*.sh` == `bin/*/*.sh` and
    only matches `bin/linux/apt-update.sh`. Top-level `bin/*.sh` are NOT checked. Run
    `shellcheck --enable=all --severity=style bin/*.sh` manually after editing `bin/`.
- Zsh files (no linter): `zsh -n dotfiles/zprezto/runcoms/zprofile` (likewise `zshrc`,
  `zpreztorc`, `dotfiles/zprezto/modules/git/alias.zsh`).

## Format
- `npm run format` — runs `format:md` (markdownlint --fix) and `format:prettier` (prettier --write).

## Generated gitignores (never hand-edit the generated files)
- `make update-gi` — regenerate repo `.gitignore` from `.gitignore_custom` + `gibo dump ...`.
- `make update-gi-global` — regenerate `dotfiles/.gitignore_global{,_personal}` from their `*_custom` prefixes.

## Commits
- `npm run commit` (or alias `npm run cm`) — Commitizen with commitlint adapter (Conventional Commits).
- `git commit` — also fine; husky `commit-msg` hook enforces commitlint.
  Pre-commit hook runs `lint-staged`.

## Tests
- None. `npm test` intentionally exits 1.

## System (Darwin / macOS-specific notes)
- Default shell: zsh with Prezto. Standard BSD userland (`ls`, `find`, `sed`, `grep` are BSD
  variants, not GNU). Watch for BSD flag differences (e.g., `sed -i ''`); use `gsed` / `ggrep`
  if GNU behavior is required.
- Prezto enables `noclobber`: in interactive zsh, overwrite an existing file with `>|`, not `>`.
- Git, gh CLI, standard `ls`/`cd`/`grep`/`find` all behave normally.
