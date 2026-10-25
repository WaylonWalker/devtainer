#!/usr/bin/env bash
set -euo pipefail

state_dir="${HERDR_PLUGIN_STATE_DIR:?}"
mkdir -p "$state_dir"

exec 9>"$state_dir/lock"
flock 9

previous=""
if [ -f "$state_dir/previous" ]; then
  IFS= read -r previous <"$state_dir/previous" || true
fi

[ -n "$previous" ] || exit 0

current="${HERDR_WORKSPACE_ID:-}"
[ "$previous" != "$current" ] || exit 0

"${HERDR_BIN_PATH:?herdr binary is not set}" workspace focus "$previous"
