#!/usr/bin/env bash
set -euo pipefail

git_root="${HOME}/git"
herdr_bin="${HERDR_BIN_PATH:-herdr}"

project_name=$(
  find "$git_root" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' 2>/dev/null |
    sort |
    fzf --reverse --header="Select git project from ~/git"
) || exit 0

[ -n "$project_name" ] || exit 0
project="${git_root}/${project_name}"

workspace_id=$(
  "$herdr_bin" workspace list 2>/dev/null |
    jq -r --arg cwd "$project" \
      '[.. | objects | select(.workspace_id? and .cwd? == $cwd) | .workspace_id] | first // empty'
) || workspace_id=""

if [ -n "$workspace_id" ]; then
  "$herdr_bin" workspace focus "$workspace_id"
else
  "$herdr_bin" workspace create \
    --cwd "$project" \
    --label "$(basename "$project")" \
    --focus
fi
