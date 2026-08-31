#!/usr/bin/env bash
set -euo pipefail

state_dir="${HERDR_PLUGIN_STATE_DIR:?}"
mkdir -p "$state_dir"

event_json="${HERDR_PLUGIN_EVENT_JSON:-}"
workspace_id=$(jq -r '.workspace_id // .data.workspace_id // .workspace.workspace_id // .workspace.id // empty' <<<"$event_json")
workspace_id="${workspace_id:-${HERDR_WORKSPACE_ID:-}}"
[ -n "$workspace_id" ] || exit 0

workspace_label=$(jq -r '.workspace.label // .label // empty' <<<"$event_json")
if [ -z "$workspace_label" ]; then
  workspace_label=$("${HERDR_BIN_PATH:?herdr binary is not set}" workspace list 2>/dev/null | \
    jq -r --arg workspace_id "$workspace_id" '
      first(.result.workspaces[] | select(.workspace_id == $workspace_id) | .label)
      // empty
    ') || workspace_label=""
fi

# The scratch workspace is an overlay for another workspace, not a session in
# its own right. Do not let focusing it change the normal last-workspace pair.
[ "$workspace_label" = "scratch" ] && exit 0

exec 9>"$state_dir/lock"
flock 9

current=""
if [ -f "$state_dir/current" ]; then
  IFS= read -r current <"$state_dir/current" || true
fi

[ "$current" = "$workspace_id" ] && exit 0

if [ -n "$current" ]; then
  printf '%s\n' "$current" >"$state_dir/previous.tmp"
  mv -f "$state_dir/previous.tmp" "$state_dir/previous"
else
  rm -f "$state_dir/previous"
fi

printf '%s\n' "$workspace_id" >"$state_dir/current.tmp"
mv -f "$state_dir/current.tmp" "$state_dir/current"
