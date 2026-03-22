#!/usr/bin/env bash

set -euo pipefail

wallpaper="${1:-$HOME/.config/awesome/wallpaper/Dark_Nature.png}"
persist="${2:-}"
state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/hypr"
state_file="$state_dir/current_wallpaper"

if [[ ! -f "$wallpaper" ]]; then
  notify-send "Wallpaper" "File not found: $wallpaper"
  exit 1
fi

mkdir -p "$state_dir"

if ! pgrep -x hyprpaper >/dev/null 2>&1; then
  hyprpaper >/dev/null 2>&1 &
fi

for _ in {1..30}; do
  if pgrep -x hyprpaper >/dev/null 2>&1; then
    break
  fi
  sleep 0.1
done

sleep 0.2

~/.config/hypr/scripts/hyprctl.sh hyprpaper preload "$wallpaper" >/dev/null 2>&1 || true

mapfile -t monitors < <(~/.config/hypr/scripts/hyprctl.sh monitors -j | jq -r '.[].name')

if [[ ${#monitors[@]} -eq 0 ]]; then
  notify-send "Wallpaper" "No Hyprland monitors found"
  exit 1
fi

for monitor in "${monitors[@]}"; do
  ~/.config/hypr/scripts/hyprctl.sh hyprpaper wallpaper "$monitor,$wallpaper"
done

if [[ "$persist" != "--no-persist" ]]; then
  printf '%s\n' "$wallpaper" > "$state_file"
fi
