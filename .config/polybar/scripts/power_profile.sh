!/usr/bin/env bash

# Путь к файлу, где хранится текущий статус
STATUS_FILE="/tmp/current_power_profile"

# Если файла нет (например, после перезагрузки), создаем его со статусом "Баланс"
if [ ! -f "$STATUS_FILE" ]; then
    echo "⚖️ Bal" > "$STATUS_FILE"
fi

# Если скрипт запущен с параметром --get, он просто выводит текущий статус для Polybar
if [ "$1" == "--get" ]; then
    cat "$STATUS_FILE"
    exit 0
fi

# Варианты для меню Rofi
options="🤫 Сбережение (10W)\n⚖️ Баланс (15W)\n🚀 Максимум (22W)"

# Запуск Rofi
chosen=$(printf "🤫 Сбережение (10W)\n⚖️ Баланс (15W)\n🚀 Максимум (22W)" | rofi -dmenu -i -p "Профиль мощности:" -theme-str 'window {width: 300px;}')

# Обработка выбора
case "$chosen" in
    *Сбережение*)
        sudo /usr/local/bin/ryzenadj --stapm-limit=10000 --fast-limit=12000 --slow-limit=10000 --tctl-temp=60
        echo "🤫 Eco" > "$STATUS_FILE"
        notify-send "Power Profile" "Включен режим энергосбережения (10W)" -i battery
        ;;
    *Баланс*)
        sudo /usr/local/bin/ryzenadj --stapm-limit=15000 --fast-limit=18000 --slow-limit=15000 --tctl-temp=65
        echo "⚖️ Bal" > "$STATUS_FILE"
        notify-send "Power Profile" "Включен сбалансированный режим (15W)" -i utilities-system-monitor
        ;;
    *Максимум*)
        sudo /usr/local/bin/ryzenadj --stapm-limit=22000 --fast-limit=25000 --slow-limit=22000 --tctl-temp=80
        echo "🚀 Max" > "$STATUS_FILE"
        notify-send "Power Profile" "Включен максимальный режим (22W)" -i preferences-system-performance
        ;;
esac

# Заставляем Polybar мгновенно обновить модуль (посылаем сигнал IPC)
polybar-msg action "#power_profile.hook.0" &>/dev/null
