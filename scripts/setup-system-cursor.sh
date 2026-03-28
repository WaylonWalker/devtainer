#!/usr/bin/env bash
set -euxo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname -- "${SCRIPT_DIR}")"

package_hint='Install `breeze` on Arch or `breeze-cursor-theme` on Ubuntu/Debian.'

if [[ "${EUID}" -ne 0 ]]; then
    printf 'Run this script with sudo.\n' >&2
    exit 1
fi

if [[ ! -d /usr/share/icons/breeze_cursors && ! -d /usr/share/icons/Breeze_Light ]]; then
    printf 'Breeze cursor theme is not installed.\n' >&2
    printf '%s\n' "${package_hint}" >&2
    exit 1
fi

if ! command -v sddm >/dev/null 2>&1; then
    printf 'SDDM is not installed. Skipping /etc/sddm.conf.d/cursor.conf.\n'
else
    install -Dm644 \
        "${REPO_DIR}/sddm/etc/sddm.conf.d/cursor.conf" \
        /etc/sddm.conf.d/cursor.conf
fi

install -Dm644 \
    "${REPO_DIR}/system-icons/usr/share/icons/default/index.theme" \
    /usr/share/icons/default/index.theme
