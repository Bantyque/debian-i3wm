#!/usr/bin/env bash

TITLE="rtorrent-scratch"

# Ищем окно rTorrent по заголовку в дереве i3
SCRATCH=$(i3-msg -t get_tree | python3 -c "
import json, sys

tree = json.load(sys.stdin)
title = '$TITLE'

def find(node):
    if node.get('name') == title:
        return True
    for child in node.get('nodes', []) + node.get('floating_nodes', []):
        if find(child):
            return True
    return False

print('found' if find(tree) else '')
")

if [ -z "$SCRATCH" ]; then
    alacritty --title "$TITLE" --class rtorrent-scratch,rtorrent-scratch -e rtorrent &

    for i in $(seq 1 30); do
        sleep 0.1
        WIN=$(xdotool search --name "$TITLE" 2>/dev/null | head -n 1)
        if [ -n "$WIN" ]; then
            break
        fi
    done

    sleep 0.2

    i3-msg '[title="rtorrent-scratch"] floating enable'
    i3-msg '[title="rtorrent-scratch"] resize set 1100 700'
    i3-msg '[title="rtorrent-scratch"] move position center'
    i3-msg '[title="rtorrent-scratch"] move scratchpad'
fi

i3-msg '[title="rtorrent-scratch"] scratchpad show'
