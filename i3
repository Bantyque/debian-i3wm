#!/usr/bin/env bash

set -e

echo "--- 1. Обновление системы ---"
sudo apt update && sudo apt upgrade -y

echo "--- 2. Базовая графика и Драйверы AMD (T495) ---"
# X-сервер и драйверы для Ryzen/Vega, чтобы не было разрывов кадров (tearing)
sudo apt install -y xserver-xorg-core xinit x11-xserver-utils
sudo apt install -y firmware-amd-graphics libgl1-mesa-dri mesa-vulkan-drivers xserver-xorg-video-amdgpu

echo "--- 3. Оконный менеджер и Экран входа ---"
sudo apt install -y i3-wm i3lock lightdm lightdm-gtk-greeter

echo "--- 4. Аудио, Bluetooth и Сеть ---"
# В Debian 13 Pipewire — новый стандарт. Он идеально работает с Bluetooth-наушниками из коробки.
sudo apt install -y pulseaudio pulseaudio-module-bluetooth pulseaudio-utils pavucontrol
# Сеть и Bluetooth (плюс апплеты для системного трея)
sudo apt install -y network-manager-gnome bluez blueman
sudo systemctl enable bluetooth

echo "--- 5. Управление питанием и Кнопки ноутбука ---"
# Служба XFCE Power Manager для сна, гашения экрана и иконки батареи
sudo apt install -y xfce4-power-manager brightnessctl tlp tlp-rdw acpi
sudo systemctl enable tlp

echo "--- 6. Печать и Сканирование ---"
sudo apt install -y cups cups-pdf system-config-printer simple-scan
sudo systemctl enable cups
sudo usermod -aG lpadmin $USER

echo "--- 7. Мультимедиа, Кодеки и WebM ---"
# Полный набор кодеков для видео, аудио и работы в браузере
sudo apt install -y ffmpeg gstreamer1.0-libav gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly
# Универсальный плеер и просмотрщик картинок
sudo apt install -y mpv feh

echo "--- 8. Окружение i3 (Внешний вид и Удобство) ---"
# Агент авторизации, уведомления, лаунчер, прозрачность и статус-бар
sudo apt install -y lxpolkit dunst rofi picom polybar

echo "--- 9. Повседневный софт и Файловый менеджер ---"
# Thunar отлично работает с дисками, флешками и архивами из коробки
sudo apt install -y thunar thunar-archive-plugin thunar-volman file-roller
sudo apt install -y alacritty firefox-esr geany unzip zip tar curl wget

echo "--- 10. Шрифты ---"
sudo apt install -y fonts-font-awesome fonts-inter fonts-noto-color-emoji

echo "--- Очистка ---"
sudo apt autoremove -y && sudo apt clean

echo "Готово! Установка завершена."
