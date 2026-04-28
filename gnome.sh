#!/usr/bin/env bash
set -e

echo "--- 1. Блокируем мусор (Recommends) ---"
sudo tee /etc/apt/apt.conf.d/99no-recommends <<EOF
APT::Install-Recommends "false";
APT::Install-Suggests "false";
EOF

echo "--- 2. Обновление системы ---"
# Убедись, что при установке были выбраны репозитории non-free и non-free-firmware
sudo apt update && sudo apt upgrade -y

echo "--- 3. GNOME Core (База) ---"
sudo apt install -y gnome-core gdm3 nautilus gnome-terminal 

echo "--- 4. Кастомизация (Твики и Расширения) ---"
sudo apt install -y gnome-tweaks gnome-shell-extension-manager

echo "--- 5. Драйверы AMD (Для T495) ---"
sudo apt install -y firmware-amd-graphics libgl1-mesa-dri mesa-vulkan-drivers firmware-realtek

echo "--- 6. Звук и Bluetooth (с поддержкой гарнитур) ---"
sudo apt install -y pipewire-audio-client-libraries wireplumber pavucontrol bluez gnome-bluetooth libspa-0.2-bluetooth

echo "--- 7. Приложения ---"
sudo apt install -y gimp obs-studio transmission shotcut darktable telegram-desktop webp-pixbuf-loader

echo "--- 8. ПЕЧАТЬ (Принтеры и PDF) ---"
sudo apt install -y cups cups-client system-config-printer evince printer-driver-gutenprint
sudo systemctl enable cups

echo "--- 9. АРХИВЫ (Встраиваем в файловый менеджер) ---"
# file-roller — это GUI для архивов, остальное — сами форматы
sudo apt install -y file-roller zip unzip p7zip-full unrar

echo "--- 10. Установка Google Chrome ---"
if ! command -v google-chrome-stable &> /dev/null; then
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb
    sudo dpkg -i /tmp/chrome.deb
    sudo apt --fix-broken install -y
fi

echo "--- 10. Повседневные мелочи ---"
sudo apt install -y network-manager-gnome xdg-user-dirs fonts-inter loupe gnome-calculator firefox-esr micro

echo "--- 11. Очистка ---"
sudo apt autoremove --purge -y

echo "--- Установка завершена! ---"
