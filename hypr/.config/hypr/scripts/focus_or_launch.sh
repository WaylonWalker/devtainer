#!/usr/bin/env bash

set -euo pipefail

# Args
class="${1:-}"
shift
start_command="$*"

if [[ -z "$class" || -z "$start_command" ]]; then
	echo "Usage: $0 <class> <start-command...>"
	exit 1
fi

# Current active window
current_addr=$(hyprctl activewindow -j | jq -r '.address')

# All windows with matching class
matching_windows=($(hyprctl clients -j | jq -r --arg class "$class" '.[] | select(.class == $class) | .address'))

num_windows=${#matching_windows[@]}

if ((num_windows == 0)); then
	# None running — start it
	eval "$start_command" &
	exit
fi

# See if currently focused window is in matching list
current_index=-1
for i in "${!matching_windows[@]}"; do
	if [[ "${matching_windows[$i]}" == "$current_addr" ]]; then
		current_index=$i
		break
	fi
done

# Cycle to next window if already in one
if ((current_index != -1)); then
	next_index=$(((current_index + 1) % num_windows))
	hyprctl dispatch focuswindow address:${matching_windows[$next_index]}
else
	# Not in one — focus first
	hyprctl dispatch focuswindow address:${matching_windows[0]}
fi
