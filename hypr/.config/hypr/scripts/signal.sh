#!/usr/bin/env bash
addr=$(~/.config/hypr/scripts/hyprctl.sh clients -j | jq -r \
	'.[] | select(.class == "Signal") | .address' | head -n1)

if [ -n "$addr" ]; then
	# Focus the existing browser window
	~/.config/hypr/scripts/hyprctl.sh dispatch focuswindow address:$addr
else
	# Launch a new browser window
	signal-desktop &
fi
