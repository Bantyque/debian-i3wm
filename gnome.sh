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
sudo apt install -y wget tar xz-utils curl

echo "--- 3. GNOME Core (База) ---"
sudo apt install -y gnome-core gdm3 nautilus gnome-terminal 

echo "--- 4. Кастомизация (Твики и Расширения) ---"
sudo apt install -y gnome-tweaks gnome-shell-extension-manager

echo "--- 5. Драйверы AMD (Для T495) ---"
sudo apt install -y firmware-amd-graphics libgl1-mesa-dri mesa-vulkan-drivers firmware-realtek

echo "--- 6. Звук и Bluetooth (с поддержкой гарнитур) ---"
sudo apt install -y pipewire-audio-client-libraries wireplumber pavucontrol bluez gnome-bluetooth libspa-0.2-bluetooth

echo "--- 7. МУЛЬТИМЕДИА (Камера, Музыка, Видео и Кодеки) ---"
# Сами приложения
sudo apt install -y cheese totem rhythmbox
# Кодеки для воспроизведения MP3, MP4, MKV, H.264 и т.д.
sudo apt install -y gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav

echo "--- 8. Интеграция дисков и смартфонов (Важно для Nautilus) ---"
sudo apt install -y gvfs-backends gvfs-fuse udisks2

echo "--- 9. Приложения ---"
sudo apt install -y gimp obs-studio transmission shotcut darktable webp-pixbuf-loader

echo "--- 10. ПЕЧАТЬ (Принтеры и PDF) ---"
sudo apt install -y cups cups-client system-config-printer evince printer-driver-gutenprint
sudo systemctl enable cups

echo "--- 11. АРХИВЫ (Встраиваем в файловый менеджер) ---"
# file-roller — это GUI для архивов, остальное — сами форматы
sudo apt install -y file-roller zip unzip p7zip-full unrar

echo "--- 12. Установка Google Chrome ---"
if ! command -v google-chrome-stable &> /dev/null; then
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb
    sudo dpkg -i /tmp/chrome.deb
    sudo apt --fix-broken install -y
fi

echo "--- 13. Повседневные мелочи ---"
sudo apt install -y network-manager-gnome xdg-user-dirs fonts-inter loupe gnome-calculator firefox-esr micro

echo "--- 14. Установка Telegram (Официальный бинарник) ---"
# Скачиваем последнюю версию напрямую с серверов Telegram во временную папку
wget -O /tmp/telegram.tar.xz https://telegram.org/dl/desktop/linux
# Распаковываем в системную директорию /opt/
sudo tar -xJvf /tmp/telegram.tar.xz -C /opt/
# Создаем символическую ссылку, чтобы можно было запускать через терминал
sudo ln -sf /opt/Telegram/Telegram /usr/local/bin/telegram-desktop
# Создаем ярлык для меню приложений GNOME
sudo tee /usr/share/applications/telegramdesktop.desktop > /dev/null <<EOF
[Desktop Entry]
Version=1.0
Name=Telegram Desktop
Comment=Официальное приложение Telegram
Exec=/opt/Telegram/Telegram -- %u
Icon=telegram
Terminal=false
Type=Application
Categories=Chat;Network;InstantMessaging;
MimeType=x-scheme-handler/tg;
EOF
# Удаляем скачанный архив
rm /tmp/telegram.tar.xz

echo "--- 15. Очистка ---"
sudo apt autoremove --purge -y

echo "--- Установка завершена! ---"
