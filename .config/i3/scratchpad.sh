#!/bin/bash

# Ищем окно по заголовку в дереве i3
SCRATCH=$(i3-msg -t get_tree | python3 -c "
import json, sys
tree = json.load(sys.stdin)

def find(node):
    if node.get('name') == 'scratch-term':
        return True
    for child in node.get('nodes', []) + node.get('floating_nodes', []):
        if find(child):
            return True
    return False

print('found' if find(tree) else '')
")

if [ -z "$SCRATCH" ]; then
    alacritty --title scratch-term &
    for i in $(seq 1 20); do
        sleep 0.1
        WIN=$(xdotool search --name "scratch-term" 2>/dev/null)
        if [ -n "$WIN" ]; then
            break
        fi
    done
    sleep 0.2
    i3-msg '[title="scratch-term"] floating enable, resize set 700 600, move position center, move scratchpad'
fi

i3-msg '[title="scratch-term"] scratchpad show'
