# Suggested Commands

## Install / setup
- `make` — alias for `make install` → runs `./install.sh` to symlink dotfiles.
- `make dev-install` — `npm ci` + `vale sync`; run once before linting.

## Lint (run before commit / task completion)
- `make lint` — runs all lint categories.
- `make lint-npm` — `npm run lint` → fans out via `run-s --continue-on-error` to:
  `secretlint` (skipped when `CI=true`), `markdownlint`, `prettier --check`.
- `make lint-text` — Vale on `README.md CONTRIBUTING.md SECURITY.md .github/*.md .github/ISSUE_TEMPLATE`.
- `make lint-yaml` — `yamllint --strict .`.
- `make lint-sh` — `shellcheck --enable=all --severity=style *.sh bin/**/*.sh .husky/commit-msg .husky/pre-commit`.
  Match those flags if running shellcheck manually.

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
- Default shell: zsh. Standard BSD userland (`ls`, `find`, `sed`, `grep` are BSD variants, not GNU).
  Watch for BSD flag differences; use `gsed` / `ggrep` from coreutils/gnu-sed if GNU behavior is required.
- Git, gh CLI, standard `ls`/`cd`/`grep`/`find` all behave normally.
