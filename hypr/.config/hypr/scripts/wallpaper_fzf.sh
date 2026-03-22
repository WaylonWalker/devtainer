#!/usr/bin/env bash

set -euo pipefail

WALLPAPER_DIR="${1:-$HOME/.config/awesome/wallpaper}"

if [[ ! -d "$WALLPAPER_DIR" ]]; then
  notify-send "Wallpaper picker" "Directory not found: $WALLPAPER_DIR"
  exit 1
fi

if [[ -z "${KITTY_WINDOW_ID:-}" ]]; then
  exec kitty --class=WallpaperPicker --title "Wallpaper Picker" "$0" "$WALLPAPER_DIR"
fi

if ! command -v fzf >/dev/null 2>&1; then
  notify-send "Wallpaper picker" "fzf is not installed"
  exit 1
fi

shopt -s nullglob nocaseglob
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

set +e
selection="$({
  printf '%s\n' "${wallpapers[@]}"
} | fzf \
  --prompt="Wallpaper > " \
  --height=100% \
  --layout=reverse \
  --border \
  --cycle \
  --bind='focus:execute-silent(~/.config/hypr/scripts/set_wallpaper.sh {} --no-persist >/dev/null 2>&1)')"
status=$?
set -e

if [[ $status -ne 0 || -z "$selection" ]]; then
  exit 0
fi

~/.config/hypr/scripts/set_wallpaper.sh "$selection" >/dev/null 2>&1 || true
