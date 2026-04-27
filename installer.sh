#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Repository directory: $REPO_DIR"

sudo apt update


sudo apt install -y xorg xserver-xorg xbindkeys light xinput firmware-amd-graphics libgl1-mesa-dri libglx-mesa0 mesa-vulkan-drivers xserver-xorg-video-amdgpu build-essential gcc make autoconf pkg-config wget curl git unzip zip dialog mtools dosfstools
    avahi-daemon acpi acpid gvfs-backends gvfs-fuse gvfs-mtp xfce4-power-manager policykit-1-gnome lxpolkit lxsession pcmanfm ranger file-roller rxvt-unicode pulseaudio alsa-utils pavucontrol pamixer pulseaudio-module-bluetooth bluez bluez-tools blueman
    cups system-config-printer simple-scan printer-driver-splix sane picom rofi dunst libnotify-bin i3 i3lock xss-lock wmctrl xdotool feh arandr lxappearance xclip xsel wl-clipboard connman connman-gtk connman-vpn python3 python3-pip python3-i3ipc pipx fastfetch btop htop cava 
    jq tree bat eza fd-find ripgrep fzf dos2unix psmisc lsb-release ca-certificates software-properties-common xdg-utils xdg-user-dirs xdg-desktop-portal xdg-desktop-portal-gtk brightnessctl playerctl numlockx redshift papirus-icon-theme arc-theme materia-gtk-theme fonts-recommended fonts-ubuntu 
    fonts-font-awesome fonts-terminus font-manager geany zathura mpv gimp obs-studio transmission shotcut darktable flameshot telegram-desktop viewnior moc webp-pixbuf-loader calcurse catfish ffmpeg imagemagick p7zip-full unrar ntfs-3g exfatprogs zenity yad tlp tlp-rdw acpi-call-dkms 
    grub-customizer plymouth plymouth-themes xss-lock libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util0-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev
xdg-user-dirs-update


sudo systemctl enable avahi-daemon
sudo systemctl enable acpid
sudo systemctl enable cups
sudo systemctl enable bluetooth
sudo systemctl enable connman
sudo systemctl enable tlp


pipx ensurepath

pipx install pywal || true
pipx install wpgtk || true

if command -v wpg-install.sh >/dev/null 2>&1; then
    wpg-install.sh -g -i
fi


cd /tmp
wget -O google-chrome.deb \
    https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

sudo apt install -y ./google-chrome.deb
rm -f google-chrome.deb


sudo plymouth-set-default-theme -R spinner


cd /tmp
rm -rf i3lock-color

git clone https://github.com/Raymo111/i3lock-color.git
cd i3lock-color

./install-i3lock-color.sh


wget -qO- \
    https://raw.githubusercontent.com/betterlockscreen/betterlockscreen/main/install.sh \
    | sudo bash -s system

sudo systemctl enable "betterlockscreen@${USER}"



chmod +x "$REPO_DIR/ly.sh"
bash "$REPO_DIR/ly.sh"


if [[ -f "$REPO_DIR/tlpui.deb" ]]; then
    sudo apt install -y "$REPO_DIR/tlpui.deb"
fi


install -Dm755 "$REPO_DIR/autotiling" \
    /usr/local/bin/autotiling

install -Dm755 "$REPO_DIR/rofi-power-menu" \
    /usr/local/bin/rofi-power-menu


cp -rf "$REPO_DIR/.config" "$HOME/"
cp -rf "$REPO_DIR/.moc" "$HOME/"
cp -rf "$REPO_DIR/.local" "$HOME/"

install -m644 "$REPO_DIR/.bashrc" "$HOME/.bashrc"
install -m644 "$REPO_DIR/.Xresources" "$HOME/.Xresources"


find "$HOME/.config/polybar" \
    -type f -name "*.sh" \
    -exec chmod +x {} \; 2>/dev/null || true

find "$HOME/.config/rofi" \
    -type f -name "*.sh" \
    -exec chmod +x {} \; 2>/dev/null || true


sudo apt autoremove -y
sudo apt autoclean -y

echo
echo "Батя грит маладца!"
