#!/usr/bin/env bash
set -euo pipefail

case "${1:-git}" in
  git|work) root_name="${1:-git}" ;;
  *) printf 'Usage: %s [git|work]\n' "${0##*/}" >&2; exit 2 ;;
esac

project_root="${HOME}/${root_name}"
herdr_bin="${HERDR_BIN_PATH:-herdr}"

project_name=$(
  find "$project_root" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' |
    sort |
    fzf --reverse --header="Select ${root_name} project from ~/${root_name}"
) || exit 0

[ -n "$project_name" ] || exit 0
project="${project_root}/${project_name}"

workspace_id=$(
  "$herdr_bin" api snapshot |
    jq -r --arg cwd "$project" \
      '[.result.snapshot.panes[] | select(.cwd == $cwd) | .workspace_id] | first // empty'
)

if [ -n "$workspace_id" ]; then
  "$herdr_bin" workspace focus "$workspace_id"
else
  "$herdr_bin" workspace create \
    --cwd "$project" \
    --label "$(basename "$project")" \
    --focus
fi
