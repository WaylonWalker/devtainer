#!/usr/bin/env bash

set -euo pipefail

state_file="${XDG_STATE_HOME:-$HOME/.local/state}/hypr/current_wallpaper"
default_wallpaper="$HOME/.config/awesome/wallpaper/Dark_Nature.png"

wallpaper="$default_wallpaper"
if [[ -f "$state_file" ]]; then
  saved_wallpaper="$(<"$state_file")"
  if [[ -f "$saved_wallpaper" ]]; then
    wallpaper="$saved_wallpaper"
  fi
fi

~/.config/hypr/scripts/set_wallpaper.sh "$wallpaper"
