#!/bin/bash

# Функция для получения текущей раскладки и отправки уведомления
show_layout_notification() {
    # Получаем короткое имя (us, ru, ua) и переводим в верхний регистр
    LAYOUT=$(xkb-switch -p | tr '[:lower:]' '[:upper:]')
    
    # Отправляем в Dunst с тегом, чтобы уведомления заменяли друг друга, а не плодились
    dunstify -h string:x-dunst-stack-tag:layout \
             -a "System" \
             -i input-keyboard \
             "Раскладка: $LAYOUT"
}

# Следим за событиями изменения раскладки
# Эта команда xkb-switch -w заставляет скрипт ждать события смены
xkb-switch -w | while read -r line; do
    show_layout_notification
done
