#!/usr/bin/env bash

# ─────────────────────────────────────────────
# Arch Linux installer для i3wm + ROCm
# Ryzen 5 PRO 3500U / Vega 8
# ─────────────────────────────────────────────

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

if [ "$EUID" -eq 0 ]; then
    echo "Запустите скрипт как обычный пользователь."
    exit 1
fi

# ─────────────────────────────────────────────
echo "► Обновление системы..."
# ─────────────────────────────────────────────
sudo pacman -Syu --noconfirm

# ─────────────────────────────────────────────
echo "► Микрокод AMD и базовая графика..."
# ─────────────────────────────────────────────
sudo pacman -S --noconfirm \
    amd-ucode \
    xorg xorg-xinit xbindkeys \
    xf86-video-amdgpu \
    xf86-input-libinput \
    mesa vulkan-radeon libva-mesa-driver \
    mesa-vdpau

# Настройка тачпада
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
echo "► Системные утилиты..."
# ─────────────────────────────────────────────
sudo pacman -S --noconfirm \
    base-devel wget curl \
    avahi acpi acpid \
    gvfs xfce4-power-manager lm_sensors \
    polkit thunar ranger file-roller \
    zip unzip rxvt-unicode \
    tlp tlp-rdw networkmanager network-manager-applet \
    xdg-user-dirs xdg-utils \
    light

sudo systemctl enable avahi-daemon acpid NetworkManager tlp
xdg-user-dirs-update

# ─────────────────────────────────────────────
echo "► PipeWire..."
# ─────────────────────────────────────────────
sudo pacman -S --noconfirm \
    pipewire pipewire-pulse pipewire-alsa pipewire-jack \
    wireplumber \
    alsa-utils pavucontrol pamixer

systemctl --user enable pipewire pipewire-pulse wireplumber
systemctl --user start pipewire pipewire-pulse wireplumber

# ─────────────────────────────────────────────
echo "► Bluetooth..."
# ─────────────────────────────────────────────
sudo pacman -S --noconfirm \
    bluez bluez-utils blueman

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
echo "► Шрифты и темы..."
# ─────────────────────────────────────────────
sudo pacman -S --noconfirm \
    lxappearance feh \
    ttf-font-awesome \
    terminus-font \
    font-manager \
    xss-lock

# ─────────────────────────────────────────────
echo "► Принтеры и сканеры..."
# ─────────────────────────────────────────────
sudo pacman -S --noconfirm \
    cups system-config-printer \
    simple-scan sane

sudo systemctl enable cups

# ─────────────────────────────────────────────
echo "► EasyEffects..."
# ─────────────────────────────────────────────
sudo pacman -S --noconfirm easyeffects

# ─────────────────────────────────────────────
echo "► i3wm и компоненты..."
# ─────────────────────────────────────────────
sudo pacman -S --noconfirm \
    i3-wm i3lock \
    picom polybar \
    rofi dunst libnotify \
    wmctrl geany \
    python python-pip python-pipx

# ─────────────────────────────────────────────
echo "► Прикладные программы..."
# ─────────────────────────────────────────────
sudo pacman -S --noconfirm \
    fastfetch htop \
    mpv gimp \
    transmission-gtk \
    shotcut \
    flameshot \
    gthumb \
    moc \
    calcurse catfish \
    zathura zathura-pdf-mupdf \
    webp-pixbuf-loader

# ─────────────────────────────────────────────
echo "► Библиотеки для компиляции..."
# ─────────────────────────────────────────────
sudo pacman -S --noconfirm \
    autoconf gcc make pkgconf \
    pam cairo fontconfig \
    libxcb xcb-util xcb-util-image \
    xcb-util-keysyms xcb-util-renderutil \
    xcb-util-wm xcb-util-xrm \
    libxkbcommon libxkbcommon-x11 \
    libjpeg-turbo libev

# ─────────────────────────────────────────────
echo "► Установка yay (AUR helper)..."
# ─────────────────────────────────────────────
if ! command -v yay &> /dev/null; then
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd "$REPO_DIR"
fi

# ─────────────────────────────────────────────
echo "► ROCm для Vega 8 (gfx902)..."
# ─────────────────────────────────────────────
sudo pacman -S --noconfirm \
    rocm-opencl-runtime \
    rocminfo \
    rocm-smi-lib

# Добавляем пользователя в группы render и video
sudo usermod -aG render,video "$USER"

# Переменные для gfx902
echo 'export HSA_OVERRIDE_GFX_VERSION=9.0.2' >> ~/.bashrc
echo 'export PYTORCH_ROCM_ARCH=gfx902' >> ~/.bashrc

# ─────────────────────────────────────────────
echo "► PyTorch ROCm через AUR..."
# ─────────────────────────────────────────────
yay -S --noconfirm python-pytorch-rocm

# ─────────────────────────────────────────────
echo "► Telegram Desktop..."
# ─────────────────────────────────────────────
sudo pacman -S --noconfirm telegram-desktop

# ─────────────────────────────────────────────
echo "► Google Chrome..."
# ─────────────────────────────────────────────
if ! command -v google-chrome-stable &> /dev/null; then
    yay -S --noconfirm google-chrome
fi

# ─────────────────────────────────────────────
echo "► pywal и wpgtk..."
# ─────────────────────────────────────────────
pipx install pywal
pipx install wpgtk
pipx ensurepath
export PATH="/usr/local/bin:$HOME/.local/bin:$PATH"

if command -v wpg &> /dev/null; then
    if [ ! -d "$HOME/.config/wpg" ]; then
        WPGINSTALL=$(find ~/.local/bin -name "wpg-install.sh" 2>/dev/null | head -1)
        if [ -n "$WPGINSTALL" ]; then
            bash "$WPGINSTALL" -g -i -r -p
        else
            mkdir -p ~/.config/wpg/templates
            wpg -n "default" 2>/dev/null || true
        fi
    fi
fi

# ─────────────────────────────────────────────
echo "► Сканер отпечатков пальцев..."
# ─────────────────────────────────────────────
sudo pacman -S --noconfirm fprintd
sudo systemctl enable fprintd

# Добавляем fprintd в PAM
sudo tee /etc/pam.d/system-local-login > /dev/null << 'EOF'
auth      sufficient  pam_fprintd.so
auth      include     system-login
account   include     system-login
password  include     system-login
session   include     system-login
EOF

# ─────────────────────────────────────────────
echo "► i3lock-color..."
# ─────────────────────────────────────────────
yay -S --noconfirm i3lock-color

# ─────────────────────────────────────────────
echo "► betterlockscreen..."
# ─────────────────────────────────────────────
yay -S --noconfirm betterlockscreen

# Включение сервиса
systemctl --user daemon-reload
if systemctl --user list-unit-files 2>/dev/null | grep -q "betterlockscreen"; then
    systemctl --user enable "betterlockscreen@$USER"
else
    mkdir -p ~/.config/systemd/user/
    cat > ~/.config/systemd/user/betterlockscreen@.service << 'EOF'
[Unit]
Description=betterlockscreen
Before=sleep.target

[Service]
Type=oneshot
ExecStart=/usr/bin/betterlockscreen -l

[Install]
WantedBy=sleep.target
EOF
    systemctl --user daemon-reload
    systemctl --user enable "betterlockscreen@$USER"
fi

# PAM для i3lock — только пароль без отпечатка
sudo tee /etc/pam.d/i3lock > /dev/null << 'EOF'
auth    sufficient    pam_unix.so try_first_pass
auth    requisite     pam_nologin.so
EOF

# ─────────────────────────────────────────────
echo "► Howdy (распознавание лица)..."
# ─────────────────────────────────────────────
yay -S --noconfirm howdy
# Настройка IR камеры
sudo sed -i 's|device_path = none|device_path = /dev/video2|' /lib/security/howdy/config.ini 2>/dev/null || true

# Добавляем Howdy в PAM для входа
sudo tee /etc/pam.d/login > /dev/null << 'EOF'
auth      sufficient  pam_howdy.so
auth      include     system-local-login
account   include     system-local-login
session   include     system-local-login
EOF

# ─────────────────────────────────────────────
echo "► Display Manager (ly)..."
# ─────────────────────────────────────────────
yay -S --noconfirm ly
sudo systemctl enable ly

# ─────────────────────────────────────────────
echo "► Timeshift..."
# ─────────────────────────────────────────────
yay -S --noconfirm timeshift
sudo systemctl enable cronie

# ─────────────────────────────────────────────
echo "► Настройка GRUB..."
# ─────────────────────────────────────────────
sudo sed -i 's|GRUB_TIMEOUT=.*|GRUB_TIMEOUT=1|' /etc/default/grub
sudo sed -i 's|GRUB_CMDLINE_LINUX_DEFAULT=.*|GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=3 rd.systemd.show_status=false rd.udev.log_level=3 amdgpu.ppfeaturemask=0xffffffff"|' /etc/default/grub

grep -q "GRUB_TIMEOUT_STYLE" /etc/default/grub \
    && sudo sed -i 's|GRUB_TIMEOUT_STYLE=.*|GRUB_TIMEOUT_STYLE=hidden|' /etc/default/grub \
    || echo 'GRUB_TIMEOUT_STYLE=hidden' | sudo tee -a /etc/default/grub > /dev/null

sudo grub-mkconfig -o /boot/grub/grub.cfg

# ─────────────────────────────────────────────
echo "► Копирование кастомных скриптов..."
# ─────────────────────────────────────────────
sudo cp "$REPO_DIR/autotiling" /usr/local/bin/ 2>/dev/null || true
sudo chmod +x /usr/local/bin/autotiling 2>/dev/null || true
sudo cp "$REPO_DIR/rofi-power-menu" /usr/local/bin/ 2>/dev/null || true
sudo chmod +x /usr/local/bin/rofi-power-menu 2>/dev/null || true

# ─────────────────────────────────────────────
echo "► Копирование конфигурационных файлов..."
# ─────────────────────────────────────────────
mkdir -p ~/.config ~/.local ~/.moc
cp -r "$REPO_DIR/.config/." ~/.config/ 2>/dev/null || true
cp -r "$REPO_DIR/.moc/." ~/.moc/ 2>/dev/null || true
cp -r "$REPO_DIR/.local/." ~/.local/ 2>/dev/null || true
cp "$REPO_DIR/.bashrc" ~/ 2>/dev/null || true
cp "$REPO_DIR/.Xresources" ~/ 2>/dev/null || true

chmod +x ~/.config/polybar/*.sh 2>/dev/null || true
chmod +x ~/.config/rofi/*.sh 2>/dev/null || true
chmod +x ~/.config/i3/scripts/* 2>/dev/null || true

# ComfyUI .desktop файл
mkdir -p ~/.local/share/applications/
cat > ~/.local/share/applications/comfyui.desktop << 'EOF'
[Desktop Entry]
Name=ComfyUI
Comment=ComfyUI Stable Diffusion
Exec=rxvt -e bash -c 'cd ~/ComfyUI && source venv/bin/activate && HSA_OVERRIDE_GFX_VERSION=9.0.2 python3 main.py --cpu-vae; read'
Icon=utilities-terminal
Terminal=false
Type=Application
Categories=Graphics;
EOF

# Обновляем кэш шрифтов
fc-cache -fv

# ─────────────────────────────────────────────
sudo pacman -Rns --noconfirm $(pacman -Qdtq) 2>/dev/null || true

echo ""
echo "✓ Установка завершена!"
echo ""
echo "Следующие шаги после перезагрузки:"
echo "  1. Перезагрузи систему:                sudo reboot"
echo "  2. Зарегистрируй отпечаток пальца:     fprintd-enroll"
echo "  3. Добавь лицо в Howdy:                sudo howdy add"
echo "  4. Сгенерируй кэш betterlockscreen:    betterlockscreen -u ~/Изображения/Обои/"
echo "  5. Выбери обои через wpg:              wpg -s <файл>"
echo "  6. Настрой Timeshift:                  sudo timeshift-gtk"
