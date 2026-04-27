#!/usr/bin/env bash

# Останавливаем при ошибках
set -e

echo "=== Шаг 1: Подготовка системы ==="
sudo apt update
sudo apt install -y wget tar

# Создаем временную папку
mkdir -p /tmp/lemurs_install
cd /tmp/lemurs_install

echo "=== Шаг 2: Скачивание готового бинарного файла ==="
# Берем последнюю версию с GitHub (v0.3.2 на данный момент)
wget https://github.com/coastalwhite/lemurs/releases/latest/download/lemurs-x86_64-unknown-linux-gnu.tar.gz

echo "=== Шаг 3: Распаковка и установка ==="
tar -xvf lemurs-x86_64-unknown-linux-gnu.tar.gz
# Копируем сам файл программы
sudo cp lemurs /usr/local/bin/
sudo chmod +x /usr/local/bin/lemurs

echo "=== Шаг 4: Настройка конфигурации ==="
# Создаем папку для конфигов, если её нет
sudo mkdir -p /etc/lemurs

# Генерируем стандартный конфиг (если программа это умеет) или создаем базовый
sudo sh -c '/usr/local/bin/lemurs --generate-config > /etc/lemurs/config.toml' || true

echo "=== Шаг 5: Установка systemd сервиса ==="
# Создаем файл сервиса вручную, чтобы точно работало
sudo tee /etc/systemd/system/lemurs.service <<EOF
[Unit]
Description=Lemurs Display Manager
After=systemd-user-sessions.service plymouth-quit-active.service
Conflicts=getty@tty1.service
Before=getty@tty1.service

[Service]
ExecStart=/usr/local/bin/lemurs
StandardInput=tty
StandardOutput=tty
TTYPath=/dev/tty1
TTYReset=yes
TTYVHangup=yes

[Install]
WantedBy=graphical.target
EOF

echo "=== Шаг 6: Активация ==="
# Отключаем другие менеджеры, если они есть
sudo systemctl disable lightdm gdm sddm ly 2>/dev/null || true
# Отключаем стандартный логин на 1-й консоли, чтобы не мешал
sudo systemctl mask getty@tty1.service

# Включаем Lemurs
sudo systemctl daemon-reload
sudo systemctl enable lemurs.service

echo "=== Готово! ==="
echo "Очистка временных файлов..."
rm -rf /tmp/lemurs_install

echo "Lemurs установлен. Теперь при перезагрузке ты увидишь текстовое меню входа."
