#!/bin/bash
if pgrep waybar > /dev/null; then
    # pkill waybar
    echo "killed waybar"
else
    # waybar &
    echo "started waybar"
fi
