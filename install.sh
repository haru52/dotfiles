#!/bin/bash

cd "$(dirname "$0")" || exit 1

repo_root_path=$(pwd)

# dotfiles
dotfiles_path=${repo_root_path}/dotfiles

os=$("${repo_root_path}"/get-os.sh)

if [[ ! -d "${dotfiles_path}" ]]; then
  echo "Error: ${dotfiles_path} is not a directory" >&2
  exit 1
fi

# Symlink every regular file in dotfiles/ (dotfiles included) into ~.
# dotglob: match names starting with '.'; nullglob: an empty directory yields no iterations.
shopt -s dotglob nullglob
for file_path in "${dotfiles_path}"/*; do
  if [[ -f "${file_path}" ]]; then
    ln -sfv "${file_path}" ~
  fi
done
shopt -u dotglob nullglob

# Zsh
cp -fv "${dotfiles_path}"/zprezto/runcoms/* ~/.zprezto/runcoms
cp -fv "${dotfiles_path}"/zprezto/modules/git/* ~/.zprezto/modules/git

# OS specific installation

# WSL2 Linux
wsl_dotfiles_path=${dotfiles_path}/wsl

# WSL specific config
# TODO: Add some conditions to determine that the environment is WSL2
if [[ "${os}" = linux ]]; then
  sudo ln -sfv "${wsl_dotfiles_path}"/wsl.conf /etc/wsl.conf
  sudo ln -sfv "${wsl_dotfiles_path}"/resolv_template.conf /etc/resolv_template.conf
fi

# Custom commands
mkdir -p ~/bin

# Install scripts from bin directory (excluding linux subdirectory)
bin_path=${repo_root_path}/bin
if [[ -d "${bin_path}" ]]; then
  for script in "${bin_path}"/*.sh; do
    if [[ -f "${script}" ]]; then
      script_name=$(basename "${script}" .sh)
      ln -sfv "${script}" ~/bin/"${script_name}"
    fi
  done
fi

# Install scripts from private_bin directory
private_bin_path=${repo_root_path}/private_bin
if [[ -d "${private_bin_path}" ]]; then
  for script in "${private_bin_path}"/*.sh; do
    if [[ -f "${script}" ]]; then
      script_name=$(basename "${script}" .sh)
      ln -sfv "${script}" ~/bin/"${script_name}"
    fi
  done
fi

if [[ "${os}" = linux ]]; then
  ln -sfv "${bin_path}"/linux/apt-update.sh ~/bin/apt-update
fi
