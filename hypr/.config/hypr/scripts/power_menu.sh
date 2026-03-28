#!/usr/bin/env bash
set -euo pipefail

choice="$({
    printf 'lock\n'
    printf 'suspend\n'
    printf 'logout\n'
    printf 'reboot\n'
    printf 'shutdown\n'
} | rofi -dmenu -i -p 'power')"

case "${choice}" in
    lock)
        exec ~/.config/hypr/scripts/lock.sh
        ;;
    suspend)
        loginctl suspend
        ;;
    logout)
        ~/.config/hypr/scripts/hyprctl.sh dispatch exit
        ;;
    reboot)
        systemctl reboot
        ;;
    shutdown)
        systemctl poweroff
        ;;
    *)
        exit 0
        ;;
esac
