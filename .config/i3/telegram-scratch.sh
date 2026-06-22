#!/bin/bash

# Ищем окно Telegram в дереве i3
SCRATCH=$(i3-msg -t get_tree | python3 -c "
import json, sys
tree = json.load(sys.stdin)

def find(node):
    if 'telegram' in (node.get('name') or '').lower() or \
       'telegram' in (node.get('window_properties', {}).get('class') or '').lower():
        return True
    for child in node.get('nodes', []) + node.get('floating_nodes', []):
        if find(child):
            return True
    return False

print('found' if find(tree) else '')
")

if [ -z "$SCRATCH" ]; then
    telegram-desktop &
    for i in $(seq 1 30); do
        sleep 0.2
        WIN=$(xdotool search --class "telegram" 2>/dev/null)
        if [ -n "$WIN" ]; then
            break
        fi
    done
    sleep 0.3
    i3-msg '[class="TelegramDesktop"] floating enable, move position center, move scratchpad'
fi

i3-msg '[class="TelegramDesktop"] scratchpad show'
