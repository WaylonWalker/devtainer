#!/usr/bin/env bash

# Usage: webapp.sh <url>
url="$1"

# Extract domain (e.g., youtube.com from https://youtube.com)
domain=$(echo "$url" | awk -F/ '{print $3}')

# Construct Brave app window class (matches what hyprctl shows)
class="brave-${domain//./.}__-Default"

# Find an open window with this class
addr=$(hyprctl clients -j | jq -r \
	--arg class "$class" \
	'.[] | select(.class == $class) | .address' | head -n1)

if [ -n "$addr" ]; then
	# Focus the window if found
	hyprctl dispatch focuswindow address:$addr
	# echo "focuswindow address:$addr"
else
	# Otherwise, launch the webapp
	brave --app="$url" --password-store=basic &
	# echo "launchurl $url"
fi
