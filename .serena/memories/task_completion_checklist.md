# Task Completion Checklist

When a code-editing task is done, run these before committing / handing off:

1. **Lint everything**: `make lint`
   - Equivalent to running `make lint-npm lint-text lint-yaml lint-sh`.
   - If iterating, target the relevant subset:
     - Shell changes → `make lint-sh` (note the exact flags: `shellcheck --enable=all --severity=style`).
     - Markdown changes → `make lint-text` + `npm run lint:md`.
     - YAML changes → `make lint-yaml`.
     - Any file → `prettier --check .` (part of `make lint-npm`).
2. **Auto-fix what's safe**: `npm run format` (markdownlint --fix + prettier --write).
3. **Secret scan**: part of `npm run lint` via `secretlint` (skipped only when `CI=true`).
4. **Do not edit generated gitignores**: if `.gitignore` or `dotfiles/.gitignore_global*`
   need changes, edit the matching `*_custom` prefix file and run `make update-gi` or
   `make update-gi-global` — never hand-edit the generated file.
5. **Commit**: use `npm run commit` (Commitizen) or a plain `git commit` that satisfies
   Conventional Commits — the husky `commit-msg` hook will enforce it.
   Pre-commit hook runs `lint-staged`, so staged files are re-linted automatically.
6. **No test suite**: `npm test` intentionally exits 1 — do not treat that as a failure.
