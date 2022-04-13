#!/bin/sh

dotfiles_path=$(cd $(dirname $0)/../dotfiles/ && pwd)

cp -f $dotfiles_path/.zpreztorc ~/.zprezto/runcoms/zpreztorc
cp -f $dotfiles_path/.zshrc ~/.zprezto/runcoms/zshrc

ln -sfv $dotfiles_path/.gitignore_global ~
ln -sfv $dotfiles_path/.vimrc ~
