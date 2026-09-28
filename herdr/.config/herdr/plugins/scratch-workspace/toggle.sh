#!/usr/bin/env bash
set -euo pipefail

herdr="${HERDR_BIN_PATH:?herdr binary is not set}"
current="${HERDR_WORKSPACE_ID:-${HERDR_ACTIVE_WORKSPACE_ID:-}}"
state_dir="${HERDR_PLUGIN_STATE_DIR:?}"
mkdir -p "$state_dir"

exec 9>"$state_dir/lock"
flock 9

workspaces=$("$herdr" workspace list 2>/dev/null) || exit 1
scratch_id=$(jq -r '
  first(.result.workspaces[] | select(.label == "scratch") | .workspace_id)
  // empty
' <<<"$workspaces")

if [ -z "$scratch_id" ]; then
  [ -n "$current" ] && printf '%s\n' "$current" >"$state_dir/origin"
  "$herdr" workspace create --cwd "$HOME" --label scratch --focus
elif [ "$current" = "$scratch_id" ]; then
  origin=""
  if [ -f "$state_dir/origin" ]; then
    IFS= read -r origin <"$state_dir/origin" || true
  fi
  [ -n "$origin" ] || exit 0
  "$herdr" workspace focus "$origin"
  rm -f "$state_dir/origin"
else
  [ -n "$current" ] && printf '%s\n' "$current" >"$state_dir/origin"
  "$herdr" workspace focus "$scratch_id"
fi
