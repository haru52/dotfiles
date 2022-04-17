#!/bin/sh

cd $(dirname $0)/../dotfiles || exit 1

dotfiles_path=$(pwd)

ls_dotfiles=$(ls -a $dotfiles_path)

for file_name in ${ls_dotfiles[@]}; do
  file_path=$dotfiles_path/$file_name
  if [ -f $file_path ]; then
    ln -sfv $file_path ~
  fi
done

cp -fv $dotfiles_path/zprezto/* ~/.zprezto/runcoms
