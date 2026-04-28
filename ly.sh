#!/usr/bin/env bash
sudo apt update

sudo apt install build-essential zig libpam0g-dev libxcb-xkb-dev xauth xserver-xorg brightnessctl

git clone https://codeberg.org/fairyglade/ly.git
cd ly
zig build

zig build installexe -Dinit_system=systemd

sudo systemctl enable ly@tty2.service

