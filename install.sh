#!/bin/bash

cd "$(dirname "$0")" || exit 1

repo_root_path=$(pwd)

# dotfiles
dotfiles_path=$repo_root_path/dotfiles

os=$("$repo_root_path"/get-os.sh)

# https://www.shellcheck.net/wiki/SC2207
ls_dotfiles=()
while IFS='' read -r line; do ls_dotfiles+=("${line}"); done < <(ls -A "${dotfiles_path}")

for file_name in "${ls_dotfiles[@]}"; do
  file_path=${dotfiles_path}/${file_name}
  if [ -f "$file_path" ]; then
    ln -sfv "$file_path" ~
  fi
done

# Zsh
cp -fv "$dotfiles_path"/zprezto/* ~/.zprezto/runcoms

# OS specific installation

# WSL2 Linux
linux_dotfiles_path=$dotfiles_path/linux

if [ "$os" = linux ]; then
  sudo ln -sfv "$linux_dotfiles_path"/wsl.conf /etc/wsl.conf
  sudo ln -sfv "$linux_dotfiles_path"/resolv_template.conf /etc/resolv_template.conf
fi

# Custom commands
bin_path=$repo_root_path/bin
mkdir -p ~/bin

ln -sfv "$bin_path"/common/brew-update.sh ~/bin/brew-update

if [ "$os" = linux ]; then
  ln -sfv "$bin_path"/linux/all-update.sh ~/bin/all-update
  ln -sfv "$bin_path"/linux/apt-update.sh ~/bin/apt-update
fi
