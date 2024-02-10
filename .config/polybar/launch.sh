#!/bin/bash

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use
# polybar-msg cmd quit

# Launch nakedbar
echo "---" | tee -a /tmp/bantybarbar.log
polybar banty >>/tmp/bantybar.log 2>&1 & disown

echo "Bars launched..."
