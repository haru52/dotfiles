#!/bin/sh

dotfiles_path=$(cd $(dirname $0)/../dotfiles/ && pwd)

cp -f $dotfiles_path/.zshrc ~/.zprezto/runcoms/zshrc

ln -sf $dotfiles_path/.gitignore_global ~
ln -sf $dotfiles_path/.vimrc ~
