#!/usr/bin/env bash

set -e

echo "--- 1. Запрещаем установку мусора (Recommends) ---"
sudo tee /etc/apt/apt.conf.d/99no-recommends <<EOF
APT::Install-Recommends "false";
APT::Install-Suggests "false";
EOF

echo "--- 2. Обновление и подключение репозиториев ---"
# Убедись, что в /etc/apt/sources.list есть non-free-firmware
sudo apt update && sudo apt upgrade -y

echo "--- 3. Установка GNOME Core (Без магазина и карт) ---"
# Ставим только основу: рабочий стол, настройки, терминал и файловый менеджер
sudo apt install -y gnome-core gdm3 nautilus gnome-terminal gnome-control-center

echo "--- 4. Звук Pipewire (Чистая установка) ---"
sudo apt install -y pipewire-audio-client-libraries wireplumber pavucontrol

echo "--- 5. Драйверы для T495 (AMD Ryzen / Vega) ---"
sudo apt install -y firmware-amd-graphics libgl1-mesa-dri mesa-vulkan-drivers

echo "--- 6. Специфичный софт для ThinkPad (Батарея и кнопки) ---"
# TLP для энергосбережения + acpi_call для порогов зарядки
sudo apt install -y tlp tlp-rdw acpi-call-dkms
sudo systemctl enable tlp

echo "--- 7. Системный минимум (Bluetooth, Сеть, Пароли) ---"
sudo apt install -y network-manager-gnome bluez blueman policykit-1-gnome xdg-user-dirs

echo "--- 8. Шрифты (Чтобы всё было красиво) ---"
# Inter — отличный шрифт для интерфейса, JetBrains — для кода
sudo apt install -y fonts-inter fonts-jetbrains-mono

echo "--- 9. Твои инструменты ---"
# Ставим только то, что просил: браузер и редактор
sudo apt install -y firefox-esr micro

echo "--- 10. Финальная чистка ---"
sudo apt autoremove --purge -y

echo "Готово! Магазин приложений (gnome-software) НЕ установлен."
echo "Используй 'sudo apt install имя_пакета' для новых программ."
