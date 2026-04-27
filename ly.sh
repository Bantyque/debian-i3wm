#!/usr/bin/env bash

echo "Установка зависимостей для сборки Ly..."
sudo apt update
sudo apt install -y build-essential libpam0g-dev libxcb-xkb-dev git

echo "Удаление старых временных файлов..."
rm -rf /tmp/ly-build

echo "Клонирование актуального репозитория Ly..."
git clone --recurse-submodules https://github.com/fairyglade/ly /tmp/ly-build

echo "Переход в директорию сборки..."
cd /tmp/ly-build

echo "Запуск компиляции..."
make

echo "Установка Ly и интеграция с systemd..."
sudo make install installsystemd

echo "Активация сервиса Ly..."
sudo systemctl enable ly.service

echo "Отключение getty на tty2 (предотвращает наложение консоли на экран логина)..."
sudo systemctl disable getty@tty2.service

echo "Отключение других дисплейных менеджеров (чтобы избежать конфликтов)..."
sudo systemctl disable gdm gdm3 lightdm sddm 2>/dev/null || true

echo "Очистка временных файлов сборки..."
rm -rf /tmp/ly-build

echo "Установка Ly успешно завершена! При следующей загрузке системы он должен запуститься автоматически."
