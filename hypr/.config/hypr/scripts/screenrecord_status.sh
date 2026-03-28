#!/usr/bin/env bash
set -euo pipefail

state_dir="${XDG_RUNTIME_DIR:-/tmp}/waylon-hypr"
pid_file="${state_dir}/screenrecord.pid"

if [[ -f "${pid_file}" ]] && kill -0 "$(cat "${pid_file}")" >/dev/null 2>&1; then
    printf '{"text":"REC","class":"active","tooltip":"Screen recording in progress"}\n'
else
    printf '{"text":"","class":"hidden","tooltip":"Start screen recording"}\n'
fi
