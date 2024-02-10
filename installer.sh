#!/usr/bin/env bash

sudo apt install -y xorg xserver-xorg xbindkeys light xinput

sudo apt install -y build-essential wget

xdg-user-dirs-update

sudo apt install -y dialog mtools dosfstools avahi-daemon acpi acpid gvfs-backends xfce4-power-manager

sudo systemctl enable avahi-daemon
sudo systemctl enable acpid

sudo apt install -y policykit-1-gnome 

sudo apt install -y pcmanfm ranger file-roller

sudo apt install -y rxvt-unicode

sudo apt install -y pulseaudio alsa-utils pavucontrol pamixer

sudo apt install -y neofetch

sudo apt install -y lxappearance 

sudo apt install -y feh
 
sudo apt install -y fonts-recommended fonts-ubuntu fonts-font-awesome fonts-terminus font-manager

sudo apt install -y cups system-config-printer simple-scan printer-driver-splix sane
sudo apt install -y bluez blueman

sudo systemctl enable cups
sudo systemctl enable bluetooth

sudo apt install -y picom rofi dunst libnotify-bin i3 unzip wmctrl

sudo apt install -y geany

sudo apt install -y mpv scrot gimp obs-studio transmission inkscape telegram-desktop viewnior moc webp-pixbuf-loader calcurse catfish

sudo apt install -y zathura

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

sudo apt install python3-i3ipc

sudo apt install pipx

pipx install pywal

pipx install wpgtk

wpg-install.sh -g -i

sudo apt install grub-customizer plymouth plymouth-themes

sudo plymouth-set-default-theme -R spinner

sudo apt install xss-lock

sudo apt install autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util0-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev

git clone https://github.com/Raymo111/i3lock-color.git
cd i3lock-color
./install-i3lock-color.sh

cd

wget https://raw.githubusercontent.com/betterlockscreen/betterlockscreen/main/install.sh -O - -q | sudo bash -s system
systemctl enable betterlockscreen@$USER

bash ~/debian-i3wm/ly.sh

sudo apt install tlp tlp-rdw acpi-call-dkms tp-smapi-dkms
sudo apt install ~/debian-i3wm/tlpui.deb

sudo apt install connman connman-gtk connman-vpn

sudo chmod +x ~/debian-i3wm/autotiling
sudo cp ~/debian-i3wm/autotiling /bin/

sudo chmod +x ~/debian-i3wm/rofi-power-menu
sudo cp ~/debian-i3wm/rofi-power-menu /bin/

\cp -r ~/debian-i3wm/.config ~
\cp -r ~/debian-i3wm/.moc ~
\cp -r ~/debian-i3wm/.local ~
\cp ~/debian-i3wm/.bashrc ~
\cp ~/debian-i3wm/.Xresources ~

sudo chmod +x ~/.config/polybar/launch.sh



sudo apt autoremove

