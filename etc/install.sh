#!/bin/sh

\cp -f ~/workspace/dotfiles/.zshrc ~/.zprezto/runcoms/zshrc
ln -sf ~/.zprezto/runcoms/zshrc ~/.zshrc
ln -sf ~/workspace/dotfiles/.vimrc ~
ln -sf ~/workspace/dotfiles/.gitignore_global ~
