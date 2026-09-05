#!/usr/bin/env bash
set -euo pipefail

out=/tmp/omarchy-greetd-theme.json
bg="$(omarchy theme color background 2>/dev/null || true)"
fg="$(omarchy theme color foreground 2>/dev/null || true)"
accent="$(omarchy theme color accent 2>/dev/null || omarchy theme color blue 2>/dev/null || true)"
dim="$(omarchy theme color dark_foreground 2>/dev/null || omarchy theme color selection 2>/dev/null || true)"
wallpaper="$(readlink -f "$HOME/.local/state/omarchy/current/background" 2>/dev/null || true)"

[[ "$bg" =~ ^#[0-9A-Fa-f]{6}$ ]] || bg="#1a1b26"
[[ "$fg" =~ ^#[0-9A-Fa-f]{6}$ ]] || fg="#c0caf5"
[[ "$accent" =~ ^#[0-9A-Fa-f]{6}$ ]] || accent="#7aa2f7"
[[ "$dim" =~ ^#[0-9A-Fa-f]{6}$ ]] || dim="#565f89"
if [[ -f "$wallpaper" ]]; then
  wallpaper_copy="/tmp/omarchy-greetd-wallpaper.${wallpaper##*.}"
  cp -f "$wallpaper" "$wallpaper_copy"
  chmod 644 "$wallpaper_copy"
  wallpaper="$wallpaper_copy"
else
  wallpaper=""
fi

tmp="${out}.tmp.$$"
printf '{"background":"%s","foreground":"%s","accent":"%s","dim":"%s","wallpaper":"%s"}\n' \
  "$bg" "$fg" "$accent" "$dim" "$wallpaper" > "$tmp"
mv -f "$tmp" "$out"
