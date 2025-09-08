#!/usr/bin/env bash

# addr=$(hyprctl clients -j | jq -r \
# 	'.[] | select(.class == "brave-browser") | .address' | head -n1)
#
# if [ -n "$addr" ]; then
# 	# Focus the existing browser window
# 	hyprctl dispatch focuswindow address:$addr
# else
# 	# Launch a new browser window
# 	brave --password-store=basic &
# fi
#

# Get current window address
current_addr=$(hyprctl activewindow -j | jq -r '.address')

# Get all Brave window addresses
brave_windows=($(hyprctl clients -j | jq -r '.[] | select(.class == "brave-browser") | .address'))

num_windows=${#brave_windows[@]}

if ((num_windows == 0)); then
	# No Brave windows, launch it
	brave --password-store=basic &
	exit
fi

# Find the index of the current window in brave_windows
current_index=-1
for i in "${!brave_windows[@]}"; do
	if [[ "${brave_windows[$i]}" == "$current_addr" ]]; then
		current_index=$i
		break
	fi
done

# If we're already in a Brave window, switch to the next one (wrap around)
if ((current_index != -1)); then
	next_index=$(((current_index + 1) % num_windows))
	hyprctl dispatch focuswindow address:${brave_windows[$next_index]}
else
	# Not currently in a Brave window — focus the first one
	hyprctl dispatch focuswindow address:${brave_windows[0]}
fi
