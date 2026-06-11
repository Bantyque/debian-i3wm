#!/usr/bin/env bash


REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

if [ "$EUID" -eq 0 ]; then
    echo "Пожалуйста, запустите скрипт как обычный пользователь."
    exit 1
fi


export XDG_RUNTIME_DIR="/run/user/$(id -u)"

# ─────────────────────────────────────────────
echo "Обновление системы"
# ─────────────────────────────────────────────
sudo apt update
sudo apt upgrade -y

# ─────────────────────────────────────────────
echo "Установка драйверов"
# ─────────────────────────────────────────────
sudo apt install -y xorg xserver-xorg xbindkeys light xinput xserver-xorg-input-libinput
sudo apt install -y amd64-microcode firmware-amd-graphics libgl1-mesa-dri libglx-mesa0 mesa-vulkan-drivers xserver-xorg-video-amdgpu
sudo apt install -y firmware-iwlwifi firmware-realtek firmware-misc-nonfree
xdg-user-dirs-update

# ─────────────────────────────────────────────
echo "Настройка тачпада"
# ─────────────────────────────────────────────
sudo mkdir -p /etc/X11/xorg.conf.d/
sudo tee /etc/X11/xorg.conf.d/30-touchpad.conf > /dev/null << 'EOF'
Section "InputClass"
    Identifier "touchpad"
    MatchIsTouchpad "on"
    Driver "libinput"
    Option "Tapping" "on"
    Option "TappingButtonMap" "lrm"
    Option "NaturalScrolling" "true"
    Option "AccelSpeed" "0.5"
    Option "DisableWhileTyping" "on"
EndSection
EOF

# ─────────────────────────────────────────────
echo "Системные утилиты"
# ─────────────────────────────────────────────
sudo apt install -y build-essential bc wget curl dialog mtools dosfstools avahi-daemon acpi acpid gvfs-backends xfce4-power-manager lm-sensors
sudo apt install -y lxpolkit thunar ranger file-roller unzip alacritty
sudo apt install -y tlp tlp-rdw acpi-call-dkms network-manager network-manager-gnome network-manager-openvpn-gnome xdg-user-dirs
sudo apt install -y build-essential cmake gettext libtool libtool-bin autoconf automake g++ pkg-config unzip curl doxygen

git clone https://github.com/neovim/neovim
cd neovim
make CMAKE_BUILD_TYPE=Release
sudo make install
cd
rm neovim

# ─────────────────────────────────────────────
echo "PipeWire"
# ─────────────────────────────────────────────
sudo apt remove -y pulseaudio pulseaudio-module-bluetooth pulseaudio-utils 2>/dev/null || true
sudo apt install -y pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber
sudo apt install -y alsa-utils pavucontrol pamixer
systemctl --user enable pipewire pipewire-pulse wireplumber
systemctl --user start pipewire pipewire-pulse wireplumber

# ─────────────────────────────────────────────
echo "Bluetooth"
# ─────────────────────────────────────────────
sudo apt install -y bluetooth bluez bluez-tools libspa-0.2-bluetooth blueman
sudo systemctl enable bluetooth

mkdir -p ~/.config/wireplumber/wireplumber.conf.d/
cat > ~/.config/wireplumber/wireplumber.conf.d/51-bluetooth-auto.conf << 'EOF'
monitor.bluez.properties = {
  bluez5.auto-connect = [ a2dp_sink hsp_hs hfp_hf ]
  bluez5.headset-roles = [ hsp_hs hfp_hf ]
}
EOF

cat > ~/.config/wireplumber/wireplumber.conf.d/52-default-sink.conf << 'EOF'
wireplumber.settings = {
  default-policy.move-streams-to-newly-connected-device = true
}
EOF

# ─────────────────────────────────────────────
echo "Шрифты"
# ─────────────────────────────────────────────
sudo apt install -y lxappearance feh fonts-recommended fonts-ubuntu fonts-font-awesome fonts-terminus font-manager
sudo apt install -y plymouth plymouth-themes xss-lock

# ─────────────────────────────────────────────
echo "Принтеры и сканеры"
# ─────────────────────────────────────────────
sudo apt install -y cups system-config-printer simple-scan printer-driver-splix sane

# ─────────────────────────────────────────────
echo "EasyEffects"
# ─────────────────────────────────────────────
sudo apt install -y easyeffects

# ─────────────────────────────────────────────
echo "i3wm"
# ─────────────────────────────────────────────
sudo apt install -y picom polybar feh rofi dunst libnotify-bin i3-wm i3lock wmctrl geany
sudo apt install -y python3 python3-pip python3-full pipx

# ─────────────────────────────────────────────
echo "Софт"
# ─────────────────────────────────────────────
sudo apt install -y fastfetch btop cava mpv gimp obs-studio transmission shotcut flameshot gthumb moc webp-pixbuf-loader calcurse catfish zathura

# ─────────────────────────────────────────────
echo "Компиляция"
# ─────────────────────────────────────────────
sudo apt install -y autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util0-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev

# ─────────────────────────────────────────────
echo "Системные сервисы"
# ─────────────────────────────────────────────
sudo systemctl enable NetworkManager avahi-daemon acpid cups bluetooth tlp

# ─────────────────────────────────────────────
echo "Google Chrome"
# ─────────────────────────────────────────────
if ! command -v google-chrome-stable &> /dev/null; then
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb
    sudo dpkg -i /tmp/chrome.deb
    sudo apt --fix-broken install -y
fi

# ─────────────────────────────────────────────
echo "pywal и wpgtk"
# ─────────────────────────────────────────────
export PIPX_BIN_DIR=/usr/local/bin
pipx install pywal
pipx install wpgtk
pipx ensurepath
export PATH="/usr/local/bin:$HOME/.local/bin:$PATH"

# Инициализация wpgtk
if command -v wpg &> /dev/null; then
    if [ ! -d "$HOME/.config/wpg" ]; then
        WPGINSTALL=$(find /usr/local/bin ~/.local/bin -name "wpg-install.sh" 2>/dev/null | head -1)
        if [ -n "$WPGINSTALL" ]; then
            bash "$WPGINSTALL" -g -i -r -p
        else
            echo "⚠ wpg-install.sh не найден, инициализируем вручную..."
            mkdir -p ~/.config/wpg/templates
            wpg -n "default" 2>/dev/null || true
        fi
    fi
else
    echo "⚠ wpg не найден — после перезагрузки выполни: wpg-install.sh -g -i -r -p"
fi

# ─────────────────────────────────────────────
echo "Cканер отпечатков пальцев"
# ─────────────────────────────────────────────
sudo apt install -y fprintd libpam-fprintd
sudo pam-auth-update --enable fprintd

# ─────────────────────────────────────────────
echo "i3lock-color"
# ─────────────────────────────────────────────

sudo apt install -y autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util0-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev libgif-dev

if ! command -v i3lock &> /dev/null || ! i3lock --version 2>&1 | grep -q "color"; then
    git clone https://github.com/Raymo111/i3lock-color.git /tmp/i3lock-color
    cd /tmp/i3lock-color
    ./install-i3lock-color.sh
    cd "$REPO_DIR"
fi

# ─────────────────────────────────────────────
echo "betterlockscreen"
# ─────────────────────────────────────────────
if ! command -v betterlockscreen &> /dev/null; then
    wget https://raw.githubusercontent.com/betterlockscreen/betterlockscreen/main/install.sh -O /tmp/bls-install.sh
    sudo bash /tmp/bls-install.sh system
fi

# Включение betterlockscreen
systemctl --user daemon-reload
if systemctl --user list-unit-files 2>/dev/null | grep -q "betterlockscreen"; then
    systemctl --user enable "betterlockscreen@$USER"
    echo "✓ betterlockscreen сервис включён"
else
    mkdir -p ~/.config/systemd/user/
    cat > ~/.config/systemd/user/betterlockscreen@.service << 'EOF'
[Unit]
Description=betterlockscreen
Before=sleep.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/betterlockscreen -l

[Install]
WantedBy=sleep.target
EOF
    systemctl --user daemon-reload
    systemctl --user enable "betterlockscreen@$USER"
    echo "✓ betterlockscreen unit создан и включён"
fi

# Настройка PAM для экрана блокировки (только пароль, без отпечатка)
sudo tee /etc/pam.d/i3lock > /dev/null << 'EOF'
auth    sufficient    pam_unix.so try_first_pass
auth    requisite     pam_nologin.so
EOF

# ─────────────────────────────────────────────
echo "emptty"
# ─────────────────────────────────────────────
sudo apt install -y emptty
sudo systemctl enable emptty
sudo systemctl start emptty

# ─────────────────────────────────────────────
echo "GRUB"
# ─────────────────────────────────────────────
sudo sed -i 's|GRUB_TIMEOUT=.*|GRUB_TIMEOUT=1|' /etc/default/grub
sudo sed -i 's|GRUB_CMDLINE_LINUX_DEFAULT=.*|GRUB_CMDLINE_LINUX_DEFAULT="quiet splash loglevel=3 rd.systemd.show_status=false rd.udev.log_level=3"|' /etc/default/grub

grep -q "GRUB_TIMEOUT_STYLE" /etc/default/grub \
    && sudo sed -i 's|GRUB_TIMEOUT_STYLE=.*|GRUB_TIMEOUT_STYLE=hidden|' /etc/default/grub \
    || echo 'GRUB_TIMEOUT_STYLE=hidden' | sudo tee -a /etc/default/grub > /dev/null

sudo update-grub

# ─────────────────────────────────────────────
echo "Копируем скрипты"
# ─────────────────────────────────────────────
sudo cp "$REPO_DIR/autotiling" /usr/local/bin/
sudo chmod +x /usr/local/bin/autotiling
sudo cp "$REPO_DIR/rofi-power-menu" /usr/local/bin/
sudo chmod +x /usr/local/bin/rofi-power-menu

# ─────────────────────────────────────────────
echo "Копируем конфиги"
# ─────────────────────────────────────────────
mkdir -p ~/.config ~/.local ~/.moc
cp -r "$REPO_DIR/.config/." ~/.config/
cp -r "$REPO_DIR/.moc/." ~/.moc/
cp -r "$REPO_DIR/.local/." ~/.local/
cp "$REPO_DIR/.bashrc" ~/
cp "$REPO_DIR/.Xresources" ~/

chmod +x ~/.config/polybar/*.sh 2>/dev/null || true
chmod +x ~/.config/rofi/*.sh 2>/dev/null || true
chmod +x ~/.config/i3/scripts/* 2>/dev/null || true

# Шрифты
fc-cache -fv

# ─────────────────────────────────────────────
sudo apt autoremove -y

echo "Установка завершена!"
echo "  1. Перезагрузка:        sudo reboot"
echo "  2. Отпечаток пальца:    fprintd-enroll"
echo "  3. betterlockscreen:    betterlockscreen -u ~/Изображения/Обои/"
echo "  4. Темв через wpg:      wpg -s <файл>"
