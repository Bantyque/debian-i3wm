#!/usr/bin/env bash

# Остановка при критической ошибке
set -e

echo "--- 1. Защита от установки лишнего в будущем ---"
# Это самое важное: теперь apt не будет тянуть 'рекомендуемые' пакеты
sudo tee /etc/apt/apt.conf.d/99no-recommends <<EOF
APT::Install-Recommends "false";
APT::Install-Suggests "false";
EOF

echo "--- 2. Удаление мета-пакетов ---"
# Удаляем общие пакеты, которые заставляют систему думать, что 'все это' нужно
sudo apt remove -y task-gnome-desktop gnome gnome-games

echo "--- 3. Удаление конкретного мусора (Bloatware) ---"
# Магазин приложений, почта, карты, погода, контакты и прочее
sudo apt purge -y \
    gnome-software \
    gnome-maps \
    gnome-weather \
    gnome-contacts \
    gnome-music \
    gnome-photos \
    gnome-clocks \
    gnome-recipes \
    gnome-calendar \
    gnome-todo \
    gnome-logs \
    evolution \
    cheese \
    shotwell \
    simple-scan \
    gnome-font-viewer \
    gnome-characters \
    gnome-dictionary

echo "--- 4. Удаление лишних офисных и системных утилит ---"
# Удаляем LibreOffice (если нужен, потом поставишь только Writer) и лишние терминалы
sudo apt purge -y transmission-common reportbug debian-faq

echo "--- 5. Глубокая очистка системы ---"
# Удаляем все зависимости, которые остались после удаления приложений
sudo apt autoremove --purge -y
sudo apt clean

echo "--- Готово! Система очищена. ---"
