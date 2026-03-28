#!/usr/bin/env bash

set -euo pipefail

WALLPAPER_DIR="${1:-$HOME/.config/awesome/wallpaper}"

if [[ ! -d "$WALLPAPER_DIR" ]]; then
  notify-send "Wallpaper picker" "Directory not found: $WALLPAPER_DIR"
  exit 1
fi

shopt -s nullglob
wallpapers=(
  "$WALLPAPER_DIR"/*.png
  "$WALLPAPER_DIR"/*.jpg
  "$WALLPAPER_DIR"/*.jpeg
  "$WALLPAPER_DIR"/*.webp
)

if [[ ${#wallpapers[@]} -eq 0 ]]; then
  notify-send "Wallpaper picker" "No images found in $WALLPAPER_DIR"
  exit 1
fi

if ! pgrep -x hyprpaper >/dev/null 2>&1; then
  hyprpaper >/dev/null 2>&1 &
  sleep 0.3
fi

for wp in "${wallpapers[@]}"; do
  ~/.config/hypr/scripts/hyprctl.sh hyprpaper preload "$wp" >/dev/null 2>&1 || true
done

declare -A label_to_path=()
options=()
declare -A label_count=()
for wp in "${wallpapers[@]}"; do
  label="$(basename "$wp")"
  if [[ -n "${label_to_path[$label]:-}" ]]; then
    count=$(( ${label_count[$label]:-1} + 1 ))
    label_count["$label"]="$count"
    label="$label ($count)"
  else
    label_count["$label"]=1
  fi
  options+=("$label")
  label_to_path["$label"]="$wp"
done

selected=""
while true; do
  preselect=()
  if [[ -n "$selected" ]]; then
    index=1
    selected_index=""
    for opt in "${options[@]}"; do
      if [[ "$opt" == "$selected" ]]; then
        selected_index="$index"
        break
      fi
      index=$((index + 1))
    done

    if [[ -n "$selected_index" ]]; then
      preselect=(-a "$selected_index")
    fi
  fi

  choice="$(printf '%s\n' "${options[@]}" | walker --dmenu --theme dmenu_250 -p "Wallpaper" "${preselect[@]}")"

  if [[ -z "$choice" || "$choice" == "CNCLD" ]]; then
    break
  fi

  target="${label_to_path[$choice]:-}"
  if [[ -n "$target" ]]; then
    ~/.config/hypr/scripts/hyprctl.sh hyprpaper wallpaper ",$target" >/dev/null
    selected="$choice"
  fi
done
