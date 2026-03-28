#!/usr/bin/env bash
set -euo pipefail

if pgrep -x hyprlock >/dev/null 2>&1; then
    exit 0
fi

exec hyprlock
