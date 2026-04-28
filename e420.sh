#!/usr/bin/env bash

# Определяем директорию репозитория
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

if [ "$EUID" -eq 0 ]; then
  echo "Пожалуйста, запустите скрипт как обычный пользователь."
  exit 1
fi

echo "Обновление системы..."
sudo apt update
sudo apt upgrade -y

echo "Установка базовой графики и микрокода Intel..."
# Заменили микрокод на Intel, а видеодрайверы на intel + старый radeon
sudo apt install -y xorg xserver-xorg xbindkeys light xinput
sudo apt install -y intel-microcode firmware-amd-graphics libgl1-mesa-dri libglx-mesa0 mesa-vulkan-drivers xserver-xorg-video-intel xserver-xorg-video-radeon
sudo apt install -y firmware-iwlwifi firmware-realtek firmware-misc-nonfree

echo "Установка системных утилит и демонов..."
sudo apt install -y build-essential wget dialog mtools dosfstools avahi-daemon acpi acpid gvfs-backends xfce4-power-manager lm-sensors
sudo apt install -y policykit-1-gnome pcmanfm ranger file-roller zip unzip rxvt-unicode
# Вернули tp-smapi-dkms для управления батареей старых ThinkPad
sudo apt install -y tlp tlp-rdw tp-smapi-dkms acpi-call-dkms network-manager network-manager-gnome network-manager-openvpn-gnome xdg-user-dirs

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
sudo apt install -y fastfetch htop cava mpv gimp obs-studio transmission shotcut darktable flameshot telegram-desktop viewnior moc webp-pixbuf-loader calcurse catfish zathura

echo "Установка библиотек для компиляции..."
sudo apt install -y autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util0-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev

xdg-user-dirs-update

# Включаем NetworkManager и другие сервисы
sudo systemctl enable NetworkManager avahi-daemon acpid cups bluetooth

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
    cd "$REPO_DIR"
fi

echo "Установка betterlockscreen..."
wget https://raw.githubusercontent.com/betterlockscreen/betterlockscreen/main/install.sh -O - -q | sudo bash -s system
systemctl --user enable betterlockscreen@$USER

echo "Запуск скрипта установки Lemurs..."
if [ -f "$REPO_DIR/ly.sh" ]; then
    bash "$REPO_DIR/ly.sh"
fi

echo "Установка локального .deb (tlpui)..."
if [ -f "$REPO_DIR/tlpui.deb" ]; then
    sudo apt install -y "$REPO_DIR/tlpui.deb"
fi

echo "Копирование кастомных скриптов..."
sudo cp "$REPO_DIR/autotiling" /usr/local/bin/
sudo chmod +x /usr/local/bin/autotiling

sudo cp "$REPO_DIR/rofi-power-menu" /usr/local/bin/
sudo chmod +x /usr/local/bin/rofi-power-menu

echo "Копирование конфигурационных файлов..."
mkdir -p ~/.config ~/.local ~/.moc

cp -r ~/debian-i3wm/.config ~/
cp -r ~/debian-i3wm/.moc ~/
cp -r ~/debian-i3wm/.local ~/
cp ~/debian-i3wm/.bashrc ~/
cp ~/debian-i3wm/.Xresources ~/

sudo chmod +x ~/.config/polybar/*.sh
sudo chmod +x ~/.config/rofi/*.sh

sudo apt autoremove -y

echo "Установка завершена!"
