# Zsh configuration (Prezto runcoms)

Files: `dotfiles/zprezto/runcoms/{zpreztorc,zprofile,zshrc}` and
`dotfiles/zprezto/modules/git/alias.zsh` (the directory mirrors `~/.zprezto`).
They are copied into `~/.zprezto` by `install.sh` (see `install_flow`), so changes need
`make install` + a new shell to take effect. No linter covers them; use `zsh -n <file>`.

## Structure
- Keep the upstream Prezto template structure (Sorin Ionescu header). Personal additions go
  below the `# Custom` marker in `zprofile` and `# Customize to your needs...` in `zshrc`.
- `alias.zsh` is a fork of upstream Prezto `modules/git/alias.zsh`; sync it with upstream
  manually (e.g., commit `54d42a6`).

## zprofile vs zshrc
- `zprofile`: environment variables and `PATH` (Homebrew, PostgreSQL, OpenJDK, curl, asdf shims,
  WSL-only VS Code path, Docker, `THOR_MERGE`, ...).
  - Prezto's `zshenv` also sources it for non-login, non-interactive shells (SHLVL=1), so never
    reference positional parameters like `$1` / `$2` there.
  - It defines `$os` via an inline `uname` switch, since the copied runcom cannot call `get-os.sh`.
  - `typeset -gU cdpath fpath mailpath path PATH` dedupes; `PATH` is listed because `-U` on
    `path` doesn't dedupe `export PATH=...` string assignments.
  - Order matters: later prepends win. `brew shellenv` runs before the asdf shims are
    prepended so asdf keeps precedence.
- `zshrc`: interactive-only setup — Prezto init, aliases (aliases aren't inherited by child
  processes), shell functions, completion/hook `eval`s (fzf, direnv, uv), `GPG_TTY`, and the
  Claude Code / MCP helpers (`claudes`, `claude-serena*`, `claude-rm-serena`, `serena-update`,
  `claude-github*`, `claude-clickup`, `claude-notion`).

## zpreztorc
- Modules enabled via `zstyle ':prezto:load' pmodule`: environment, terminal, editor, history,
  directory, spectrum, utility, ssh, git, completion, syntax-highlighting,
  history-substring-search, autosuggestions, prompt.
- ssh-agent is managed solely by the Prezto `ssh` module (loads `id_ed25519`). Don't add
  keychain or another agent launcher — it caused duplicate agents and double passphrase prompts.
