#!/bin/bash

cd "$(dirname "$0")" || exit 1

repo_root_path=$(pwd)
dotfiles_path=$repo_root_path/dotfiles

os=$("$repo_root_path"/get-os.sh)

ls_dotfiles=$(ls -a "$dotfiles_path")

# shellcheck disable=SC2068
for file_name in ${ls_dotfiles[@]}; do
  file_path=${dotfiles_path}/${file_name}
  if [ -f "$file_path" ]; then
    ln -sfv "$file_path" ~
  fi
done

cp -fv "$dotfiles_path"/zprezto/* ~/.zprezto/runcoms

bin_path=$repo_root_path/bin
mkdir -p ~/bin

ln -sfv "$bin_path"/common/brew-update.sh ~/bin/brew-update

if [ "$os" = linux ]; then
  ln -sfv "$bin_path"/linux/all-update.sh ~/bin/all-update
  ln -sfv "$bin_path"/linux/apt-update.sh ~/bin/apt-update
fi
