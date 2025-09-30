# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository that manages Unix/Linux configuration files (including macOS and WSL). The repository uses symlinks to install dotfiles from the `dotfiles/` directory to the home directory, and provides custom shell scripts in the `bin/` directory.

## Architecture

### Installation System

- `Makefile`: Primary entry point for common operations
- `install.sh`: Symlinks dotfiles to home directory and installs custom commands to `~/bin`
- `get-os.sh`: Detects OS (macOS or Linux) for platform-specific installation
- OS-specific configs in `dotfiles/wsl/` for WSL2 Linux environments

### Directory Structure

- `dotfiles/`: Contains configuration files to be symlinked to home directory
  - `dotfiles/zprezto/`: Zsh Prezto framework configuration
  - `dotfiles/etc/`: Additional Zsh modules (e.g., Git aliases)
  - `dotfiles/wsl/`: WSL-specific configuration files
- `bin/`: Custom shell scripts installed to `~/bin`
  - `bin/linux/`: Linux-specific scripts (e.g., apt-update.sh)

### Linting Architecture

Multi-layered linting system enforced via husky pre-commit hooks:

- **npm linting**: Markdown, Prettier, secretlint (credentials check)
- **Text linting**: Vale for prose (README, CONTRIBUTING, SECURITY, .github docs)
- **YAML linting**: yamllint with strict mode
- **Shell linting**: shellcheck for all .sh files and husky hooks
- **GitHub Actions linting**: actionlint for workflow files

## Commands

### Installation

```sh
make                    # Run install.sh to symlink dotfiles and custom commands
make dev-install        # Install npm dependencies and sync Vale styles
```

### Linting

```sh
make lint               # Run all linters (npm, text, yaml, shell, actions)
make lint-npm           # npm run lint (MD, Prettier, secretlint)
make lint-text          # Vale prose linter
make lint-yaml          # yamllint --strict
make lint-sh            # shellcheck on all shell scripts
make lint-action        # actionlint for GitHub Actions

npm run lint            # Run all npm-based linters
npm run lint:md         # markdownlint
npm run lint:prettier   # prettier --check
npm run lint:credentials # secretlint (skipped in CI)
```

### Formatting

```sh
npm run format          # Auto-fix all formatters
npm run format:md       # markdownlint --fix
npm run format:prettier # prettier --write
```

### Commits

```sh
npm run commit          # Interactive commit with commitizen (conventional commits)
npm run cm              # Alias for npm run commit
```

### Gitignore Management

```sh
make update-gi          # Update .gitignore using gibo
make update-gi-global   # Update dotfiles/.gitignore_global using gibo
```

## Development Workflow

1. **Making changes**: Edit files in `dotfiles/` or `bin/` directories
2. **Testing changes**: Run `make` to reinstall symlinks (for dotfiles changes)
3. **Linting**: Pre-commit hooks automatically run lint-staged checks. Run `make lint` manually to check all files
4. **Committing**: Use `npm run commit` for conventional commit format (enforced by commitlint)

## Custom Commands

After installation, these commands are available in `~/bin`:

- `all-update`: Update all package managers and tools
- `clean-branch`: Clean up Git branches
- `rm-merged-worktrees`: Remove merged Git worktrees
- `apt-update`: (Linux only) Update apt packages

## Technical Details

- Node.js version: ^22.20.0 (defined in package.json and .node-version)
- npm version: ^11.6.1
- Commit format: Conventional Commits (via commitlint + commitizen)
- Pre-commit: lint-staged runs appropriate linters based on file types
- Commit message: validated by commitlint using conventional config
