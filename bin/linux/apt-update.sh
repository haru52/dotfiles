#!/bin/sh

sudo apt update --yes &&
sudo apt upgrade --yes &&
sudo apt full-upgrade --yes &&
sudo apt autoremove &&
sudo apt autoclean
