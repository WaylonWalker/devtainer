#!/usr/bin/env bash
set -euo pipefail

state_dir="${XDG_RUNTIME_DIR:-/tmp}/waylon-hypr"
pid_file="${state_dir}/screenrecord.pid"
log_file="${state_dir}/screenrecord.log"
mkdir -p "${state_dir}"

notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "$@"
    fi
}

signal_waybar() {
    pkill -RTMIN+8 waybar >/dev/null 2>&1 || true
}

cleanup_stale_pid() {
    if [[ -f "${pid_file}" ]]; then
        local pid
        pid="$(cat "${pid_file}")"
        if ! kill -0 "${pid}" >/dev/null 2>&1; then
            rm -f "${pid_file}"
        fi
    fi
}

stop_recording() {
    cleanup_stale_pid
    if [[ -f "${pid_file}" ]]; then
        kill "$(cat "${pid_file}")"
        rm -f "${pid_file}"
        signal_waybar
        notify 'Screen recording stopped'
        exit 0
    fi

    pkill -x wl-screenrec >/dev/null 2>&1 || true
    pkill -x wf-recorder >/dev/null 2>&1 || true
    signal_waybar
}

has_nvidia() {
    command -v nvidia-smi >/dev/null 2>&1 && nvidia-smi -L >/dev/null 2>&1
}

start_command() {
    : > "${log_file}"
    "$@" >>"${log_file}" 2>&1 &
    printf '%s\n' "$!" > "${pid_file}"
    sleep 1

    if kill -0 "$(cat "${pid_file}")" >/dev/null 2>&1; then
        signal_waybar
        return 0
    fi

    rm -f "${pid_file}"
    return 1
}

start_region_recording() {
    local geometry timestamp output
    geometry="$(slurp)"
    timestamp="$(date +%Y-%m-%d_%H-%M-%S)"
    output="${HOME}/Videos/screenrecord-${timestamp}.mp4"
    mkdir -p "${HOME}/Videos"

    if has_nvidia; then
        if start_command wf-recorder --audio --no-dmabuf --geometry "${geometry}" --file "${output}"; then
            notify 'Screen recording started' "${output}"
            return 0
        fi
    fi

    if start_command wl-screenrec --audio --geometry "${geometry}" --filename "${output}"; then
        notify 'Screen recording started' "${output}"
        return 0
    fi

    if start_command wf-recorder --audio --no-dmabuf --geometry "${geometry}" --file "${output}"; then
        notify 'Screen recording started (fallback)' "${output}"
        return 0
    fi

    notify 'Screen recording failed' "See ${log_file}"
    exit 1
}

case "${1:-region}" in
    toggle)
        cleanup_stale_pid
        if [[ -f "${pid_file}" ]]; then
            stop_recording
        else
            start_region_recording
        fi
        ;;
    stop)
        stop_recording
        ;;
    region)
        cleanup_stale_pid
        if [[ -f "${pid_file}" ]]; then
            stop_recording
        else
            start_region_recording
        fi
        ;;
    *)
        printf 'usage: %s [region|toggle|stop]\n' "$0" >&2
        exit 1
        ;;
esac
