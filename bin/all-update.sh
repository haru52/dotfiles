#!/bin/sh

case $(uname) in
  Darwin) os=mac ;;
  Linux) os=linux ;;
  *) exit 1 ;;
esac

if [ "${os}" = linux ]; then
  apt-update
fi

# Homebrew
if [ "${os}" = mac ]; then
  alias brew="PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin brew"
fi
brew doctor; brew update && brew upgrade && brew cleanup

# asdf
asdf plugin update --all

# Python pip
pip install -U pip

# RubyGems
gem update --system

# gibo
gibo update

# Zsh Prezto
zprezto-update
