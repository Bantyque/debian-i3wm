#!/usr/bin/env bash


REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"


if [ "$EUID" -eq 0 ]; then
  echo "Пожалуйста, запустите скрипт как обычный пользователь (не через sudo su)."
  exit 1
fi

echo "Обновление системы..."
sudo apt update
sudo apt upgrade -y

echo "Установка базовой графики и Xorg..."
sudo apt install -y xorg xserver-xorg xbindkeys light xinput
sudo apt install -y firmware-amd-graphics libgl1-mesa-dri libglx-mesa0 mesa-vulkan-drivers xserver-xorg-video-amdgpu

echo "Установка системных утилит и демонов..."
sudo apt install -y build-essential wget dialog mtools dosfstools avahi-daemon acpi acpid gvfs-backends xfce4-power-manager
sudo apt install -y policykit-1-gnome pcmanfm ranger file-roller zip unzip rxvt-unicode
sudo apt install -y tlp tlp-rdw acpi-call-dkms tp-smapi-dkms connman connman-gtk connman-vpn xdg-user-dirs

echo "Установка звука и Bluetooth..."
sudo apt install -y pulseaudio alsa-utils pavucontrol pamixer
sudo apt install -y bluetooth bluez bluez-tools pulseaudio-module-bluetooth blueman

echo "Установка шрифтов и тем..."
sudo apt install -y lxappearance feh fonts-recommended fonts-ubuntu fonts-font-awesome fonts-terminus font-manager
sudo apt install -y grub-customizer plymouth plymouth-themes xss-lock

echo "Установка принтеров и сканеров..."
sudo apt install -y cups system-config-printer simple-scan printer-driver-splix sane

echo "Установка i3wm и компонентов..."
sudo apt install -y picom rofi dunst libnotify-bin i3 wmctrl curl geany
sudo apt install -y python3 python3-i3ipc pipx

echo "Установка прикладных программ..."
sudo apt install -y neofetch htop cava mpv gimp obs-studio transmission shotcut darktable flameshot telegram-desktop viewnior moc webp-pixbuf-loader calcurse catfish zathura

echo "Установка библиотек для компиляции i3lock-color и Ly..."
sudo apt install -y autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util0-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev

# Обновляем директории пользователя
xdg-user-dirs-update


sudo systemctl enable avahi-daemon acpid cups bluetooth

echo "Установка Google Chrome..."
if ! command -v google-chrome-stable &> /dev/null; then
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb
    sudo dpkg -i /tmp/chrome.deb
    sudo apt --fix-broken install -y
fi

echo "Установка pywal и wpgtk..."
pipx install pywal
pipx install wpgtk
pipx ensurepath

~/.local/bin/wpg-install.sh -g -i

echo "Настройка plymouth..."
sudo plymouth-set-default-theme -R spinner

echo "Установка i3lock-color..."
if [ ! -d "$HOME/i3lock-color" ]; then
    git clone https://github.com/Raymo111/i3lock-color.git "$HOME/i3lock-color"
    cd "$HOME/i3lock-color"
    ./install-i3lock-color.sh
    cd "$REPO_DIR" # Возвращаемся обратно
fi

echo "Установка betterlockscreen..."
wget https://raw.githubusercontent.com/betterlockscreen/betterlockscreen/main/install.sh -O - -q | sudo bash -s system

systemctl --user enable betterlockscreen@$USER

echo "Запуск скрипта установки Ly..."
if [ -f "$REPO_DIR/ly.sh" ]; then
    bash "$REPO_DIR/ly.sh"
else
    echo "ПРЕДУПРЕЖДЕНИЕ: Файл ly.sh не найден в $REPO_DIR!"
fi

echo "Установка локального .deb (tlpui)..."
if [ -f "$REPO_DIR/tlpui.deb" ]; then
    sudo apt install -y "$REPO_DIR/tlpui.deb"
fi

echo "Копирование кастомных скриптов (autotiling, rofi-power-menu)..."

sudo cp "$REPO_DIR/autotiling" /usr/local/bin/
sudo chmod +x /usr/local/bin/autotiling

sudo cp "$REPO_DIR/rofi-power-menu" /usr/local/bin/
sudo chmod +x /usr/local/bin/rofi-power-menu

echo "Копирование конфигурационных файлов..."

mkdir -p ~/.config ~/.local ~/.moc

cp -a "$REPO_DIR/.config/"* ~/.config/ 2>/dev/null || true
cp -a "$REPO_DIR/.moc/"* ~/.moc/ 2>/dev/null || true
cp -a "$REPO_DIR/.local/"* ~/.local/ 2>/dev/null || true

cp "$REPO_DIR/.bashrc" ~/
cp "$REPO_DIR/.Xresources" ~/

chmod +x ~/.config/polybar/*.sh 2>/dev/null || true
chmod +x ~/.config/rofi/*.sh 2>/dev/null || true

sudo apt autoremove -y

echo "Установка завершена!"
