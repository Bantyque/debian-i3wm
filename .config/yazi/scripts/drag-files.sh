#!/usr/bin/env bash
set -euo pipefail

if ! command -v dragon >/dev/null 2>&1; then
  notify-send "Yazi" "dragon не установлен"
  exit 1
fi

if [ "$#" -eq 0 ]; then
  notify-send "Yazi" "Нет выбранных файлов"
  exit 1
fi

# -a / --all          тащить все файлы одним drag-and-drop
# -A / --all-compact  то же самое, но показывать компактно только количество
# -T / --on-top       держать окно поверх
# -f / --name-only    показывать только имена файлов
dragon --all --on-top "$@"
