#!/usr/bin/env bash
set -euxo pipefail

config="${MISE_CONFIG_FILE:-${XDG_CONFIG_HOME:-${HOME}/.config}/mise/config.toml}"

if (( $# > 0 )); then
    tools=("$@")
else
    mapfile -t tools < <(
        awk '
            /^\[tools\]$/ { in_tools = 1; next }
            /^\[/ { if (in_tools) exit }
            in_tools && /^[[:space:]]*[^#[:space:]].*=/ {
                line = $0
                sub(/[[:space:]]#.*/, "", line)
                split(line, parts, "=")
                key = parts[1]
                gsub(/^[[:space:]]+|[[:space:]]+$/, "", key)
                gsub(/^"|"$/, "", key)
                print key
            }
        ' "${config}"
    )
fi

required_tools=()
optional_tools=()

for tool in "${tools[@]}"; do
    if [[ "${tool}" == pipx:* ]]; then
        optional_tools+=("${tool}")
    else
        required_tools+=("${tool}")
    fi
done

if (( ${#required_tools[@]} > 0 )); then
    mise install --locked "${required_tools[@]}"
fi

for tool in "${optional_tools[@]}"; do
    if ! mise install --locked "${tool}"; then
        printf 'warning: optional mise tool failed to install: %s\n' "${tool}" >&2
    fi
done

mise reshim
