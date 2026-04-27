#!/usr/bin/env bash

# Останавливаем скрипт при любой критической ошибке
set -e

echo "=== Шаг 1: Обновление списков пакетов ==="
# Это обязательно, чтобы apt не выдавал "пакет не найден"
sudo apt update

echo "=== Шаг 2: Установка зависимостей ==="
# Добавил libxkbcommon-x11-dev как страховку для Debian 13
sudo apt install -y build-essential git libpam0g-dev libxcb-xkb-dev libxkbcommon-x11-dev

echo "=== Шаг 3: Очистка старых временных файлов ==="
rm -rf /tmp/ly-build

echo "=== Шаг 4: Клонирование репозитория ==="
# Флаг --recurse-submodules критически важен, без него сборка упадет!
git clone --recurse-submodules https://github.com/fairyglade/ly /tmp/ly-build

echo "=== Шаг 5: Компиляция Ly ==="
cd /tmp/ly-build
make

echo "=== Шаг 6: Установка и интеграция с systemd ==="
sudo make install installsystemd

echo "=== Шаг 7: Активация Ly ==="
sudo systemctl enable ly.service

echo "=== Шаг 8: Отключение конфликтующих сервисов ==="
# Отключаем текстовый логин на втором терминале, чтобы он не перекрывал Ly
sudo systemctl disable getty@tty2.service

# Безопасно отключаем другие графические экраны входа, если они случайно установлены
sudo systemctl disable lightdm gdm3 sddm 2>/dev/null || true

echo "=== Готово! Очистка мусора... ==="
cd ~
rm -rf /tmp/ly-build

echo "Установка дисплейного менеджера Ly успешно завершена! При следующей загрузке системы он появится автоматически."
