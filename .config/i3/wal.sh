#!/bin/bash
# ~/.config/i3/scripts/wallpaper.sh
WALLPAPER_DIR=~/Изображения/Обои

while true; do
    WALL=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" \) | shuf -n1)
    
    wpg -s "$WALL"
    
    sleep 1  # ждём пока wpg применит тему
    
    pkill dunst && dunst &
    
    pkill polybar
    sleep 0.5
    ~/.config/polybar/launch.sh &
    
    # Обновляем betterlockscreen с новым обоем
    betterlockscreen -u "$WALL" &
    
    dunstify "🎨 Тема обновлена" "$(basename $WALL)"
    
    sleep 900
done
