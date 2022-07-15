#!/bin/sh

brew doctor
brew update &&
brew upgrade &&
brew cleanup
