#!/usr/bin/env bash
set -euo pipefail

if ! command -v checkupdates >/dev/null 2>&1; then
    printf '{"text":"","tooltip":"checkupdates not installed"}\n'
    exit 0
fi

updates="$(checkupdates 2>/dev/null || true)"

if [[ -z "${updates}" ]]; then
    count=0
else
    count="$(printf '%s\n' "${updates}" | wc -l)"
fi

if [[ "${count}" -eq 0 ]]; then
    printf '{"text":"","tooltip":"System is up to date"}\n'
else
    printf '{"text":" %s","tooltip":"%s package updates available"}\n' "${count}" "${count}"
fi
