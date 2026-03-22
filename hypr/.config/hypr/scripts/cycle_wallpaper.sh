#!/usr/bin/env bash

set -euo pipefail

direction="${1:-next}"
wallpaper_dir="${2:-$HOME/.config/awesome/wallpaper}"
state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/hypr"
state_file="$state_dir/current_wallpaper"

if [[ "$direction" != "next" && "$direction" != "prev" ]]; then
  notify-send "Wallpaper" "Usage: cycle_wallpaper.sh [next|prev] [dir]"
  exit 1
fi

if [[ ! -d "$wallpaper_dir" ]]; then
  notify-send "Wallpaper" "Directory not found: $wallpaper_dir"
  exit 1
fi

mkdir -p "$state_dir"

shopt -s nullglob nocaseglob
wallpapers=(
  "$wallpaper_dir"/*.png
  "$wallpaper_dir"/*.jpg
  "$wallpaper_dir"/*.jpeg
  "$wallpaper_dir"/*.webp
)

if [[ ${#wallpapers[@]} -eq 0 ]]; then
  notify-send "Wallpaper" "No images found in $wallpaper_dir"
  exit 1
fi

IFS=$'\n' wallpapers=($(printf '%s\n' "${wallpapers[@]}" | sort))
unset IFS

current=""
if [[ -f "$state_file" ]]; then
  current="$(<"$state_file")"
fi

next_index=0
for i in "${!wallpapers[@]}"; do
  if [[ "${wallpapers[$i]}" == "$current" ]]; then
    if [[ "$direction" == "prev" ]]; then
      next_index=$(((i - 1 + ${#wallpapers[@]}) % ${#wallpapers[@]}))
    else
      next_index=$(((i + 1) % ${#wallpapers[@]}))
    fi
    break
  fi
done

next_wallpaper="${wallpapers[$next_index]}"

~/.config/hypr/scripts/set_wallpaper.sh "$next_wallpaper"
printf '%s\n' "$next_wallpaper" > "$state_file"
