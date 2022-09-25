#!/bin/bash

echo "welcome to the post_install.sh script created by Mathias"

# make user
useradd -m -G wheel mathias

passwd mathias # password of user mathias

# installation paru
sudo pacman -Syu paru

paru -Syu rofi river zip xorg-xev wpaperd wlr-randr wget vscodium virt-manager unzip ttf-twemoji texlive-latexextra texlab teams-for-linux swaylock slurp rust-analyzer rtorrent textlive-core pacmixer nvm nmap network-manager-applet nerd-fonts-anonymous-pro neofetch libreoffice-still kotlin-language-server kotlin joshuto imv httpie grim firefox-developer-edition docker discord android-studio alacritty

