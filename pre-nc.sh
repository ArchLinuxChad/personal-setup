#!/usr/bin/env bash

# update the system
sudo pacman -Syu

# install apps
sudo pacman -S firefox awesome sddm kitty

# enable sddm
sudo systemctl enable sddm.service --now
