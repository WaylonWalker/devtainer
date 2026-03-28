#!/usr/bin/env bash
set -euxo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname -- "${SCRIPT_DIR}")"

if ! command -v stow >/dev/null 2>&1; then
    printf 'stow is required. Install it first.\n' >&2
    exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
    printf 'python3 is required. Install it first.\n' >&2
    exit 1
fi

if [[ ! -d /usr/share/icons/breeze_cursors && ! -d /usr/share/icons/Breeze_Light ]]; then
    printf 'Breeze cursor theme is not installed.\n' >&2
    printf 'Install `breeze` on Arch or `breeze-cursor-theme` on Ubuntu/Debian.\n' >&2
    exit 1
fi

cd "${REPO_DIR}"

icons_target="${HOME}/.icons/default/index.theme"
icons_source="${REPO_DIR}/icons/.icons/default/index.theme"

if [[ -e "${icons_target}" && ! -L "${icons_target}" ]]; then
    if cmp -s "${icons_source}" "${icons_target}"; then
        rm "${icons_target}"
    else
        mv "${icons_target}" "${icons_target}.bak.$(date +%Y%m%d%H%M%S)"
    fi
fi

stow hypr icons

mkdir -p "${HOME}/.config/gtk-3.0" "${HOME}/.icons/default"

python3 - <<'PY'
from __future__ import annotations

from pathlib import Path


def update_settings_ini(path: Path) -> None:
    desired = {
        "gtk-cursor-theme-name": "breeze_cursors",
        "gtk-cursor-theme-size": "24",
    }

    lines = path.read_text().splitlines() if path.exists() else ["[Settings]"]
    if not lines:
        lines = ["[Settings]"]
    if lines[0].strip() != "[Settings]":
        lines.insert(0, "[Settings]")

    seen: set[str] = set()
    out: list[str] = []
    for line in lines:
        if "=" in line:
            key, _ = line.split("=", 1)
            key = key.strip()
            if key in desired:
                out.append(f"{key}={desired[key]}")
                seen.add(key)
                continue
        out.append(line)

    for key, value in desired.items():
        if key not in seen:
            out.append(f"{key}={value}")

    path.write_text("\n".join(out) + "\n")


def update_gtkrc(path: Path) -> None:
    desired = {
        "gtk-cursor-theme-name": '"breeze_cursors"',
        "gtk-cursor-theme-size": "24",
    }

    lines = path.read_text().splitlines() if path.exists() else []
    seen: set[str] = set()
    out: list[str] = []
    for line in lines:
        stripped = line.strip()
        if "=" in stripped and not stripped.startswith("#"):
            key, _ = stripped.split("=", 1)
            key = key.strip()
            if key in desired:
                out.append(f"{key}={desired[key]}")
                seen.add(key)
                continue
        out.append(line)

    for key, value in desired.items():
        if key not in seen:
            out.append(f"{key}={value}")

    path.write_text("\n".join(out) + "\n")


update_settings_ini(Path.home() / ".config/gtk-3.0/settings.ini")
update_gtkrc(Path.home() / ".gtkrc-2.0")
PY
