#!/usr/bin/env bash
addr=$(hyprctl clients -j | jq -r \
	'.[] | select(.class == "kitty") | .address' | head -n1)

if [ -n "$addr" ]; then
	# Focus the existing browser window
	hyprctl dispatch focuswindow address:$addr
else
	# Launch a new browser window
	kitty &
fi
