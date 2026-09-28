#!/usr/bin/env bash
set -euo pipefail

state_dir="${HERDR_PLUGIN_STATE_DIR:?}"
mkdir -p "$state_dir"

snapshot=$("${HERDR_BIN_PATH:?herdr binary is not set}" api snapshot 2>/dev/null) || exit 0
current=$(jq -r '.result.snapshot.focused_workspace_id // empty' <<<"$snapshot")
[ -n "$current" ] || exit 0

printf '%s\n' "$current" >"$state_dir/current"
rm -f "$state_dir/previous"
