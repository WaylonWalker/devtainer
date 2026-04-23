#!/usr/bin/env bash
set -euo pipefail

RUNTIME="${CONTAINER_RUNTIME:-podman}"
OUT_DIR="${TEST_OUTPUT_DIR:-.test-results}"
IMAGE="${1:-}"

if [[ -z "${IMAGE}" ]]; then
    printf 'Usage: %s IMAGE\n' "${0##*/}" >&2
    exit 1
fi

RUN_ID="${RUN_ID:-$(date +%Y%m%d%H%M%S)}"
IMAGE_NAME="${IMAGE##*/}"
IMAGE_NAME="${IMAGE_NAME//[:\/]/-}"
RESULT_DIR="${OUT_DIR}/${RUN_ID}/${IMAGE_NAME}"
CHECKS_DIR="${RESULT_DIR}/checks"
mkdir -p "${CHECKS_DIR}"

json_escape() {
    sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e 's/$/\\n/'
}

run_container_check() {
    local name="$1"
    local description="$2"
    local log_file="${CHECKS_DIR}/${name}.log"
    local json_file="${CHECKS_DIR}/${name}.json"

    printf '==> %s (%s)\n' "${name}" "${IMAGE}"
    if "${RUNTIME}" run --rm -i --entrypoint /bin/sh "${IMAGE}" -s >"${log_file}" 2>&1; then
        {
            printf '{'
            printf '"name":"%s","description":"%s","status":"pass","log":"%s"' "${name}" "${description}" "${log_file}"
            printf '}'
        } >"${json_file}"
        return 0
    fi

    {
        printf '{'
        printf '"name":"%s","description":"%s","status":"fail","log":"%s"' "${name}" "${description}" "${log_file}"
        printf '}'
    } >"${json_file}"
    return 1
}

run_nvim_check() {
    local name="$1"
    local description="$2"
    local lua_expr="$3"
    local log_file="${CHECKS_DIR}/${name}.log"
    local json_file="${CHECKS_DIR}/${name}.json"
    local nvim_bin

    nvim_bin="$(PATH="/usr/local/bin:/usr/bin:/bin" command -v nvim || true)"
    if [[ -z "${nvim_bin}" ]]; then
        printf '{"name":"%s","description":"%s","status":"fail","log":"%s","error":"nvim not found"}\n' "${name}" "${description}" "${log_file}" >"${json_file}"
        return 1
    fi

    if HOME=/home/devtainer USER=devtainer XDG_CONFIG_HOME=/home/devtainer/.config XDG_DATA_HOME=/home/devtainer/.local/share XDG_CACHE_HOME=/home/devtainer/.cache XDG_STATE_HOME=/home/devtainer/.local/state "${nvim_bin}" --headless "+set runtimepath^=/home/devtainer/.config/nvim" "+lua dofile('/home/devtainer/.config/nvim/init.lua')" "+lua assert(${lua_expr})" +qa >"${log_file}" 2>&1; then
        printf '{"name":"%s","description":"%s","status":"pass","log":"%s"}\n' "${name}" "${description}" "${log_file}" >"${json_file}"
        return 0
    fi

    printf '{"name":"%s","description":"%s","status":"fail","log":"%s"}\n' "${name}" "${description}" "${log_file}" >"${json_file}"
    return 1
}

read_log() {
    local file="$1"
    if [[ -f "${file}" ]]; then
        sed 's/\\/\\\\/g; s/"/\\"/g' "${file}"
    fi
}

write_summary() {
    local status="$1"
    local summary_file="${RESULT_DIR}/summary.json"
    local html_file="${RESULT_DIR}/index.html"

    printf '{"image":"%s","status":"%s","checks_dir":"%s"}\n' "${IMAGE}" "${status}" "${CHECKS_DIR}" >"${summary_file}"

    {
        printf '<!doctype html>\n<html lang="en">\n<head>\n<meta charset="utf-8">\n'
        printf '<meta name="viewport" content="width=device-width, initial-scale=1">\n'
        printf '<title>Devtainer smoke: %s</title>\n' "${IMAGE}"
        printf '<style>body{font-family:sans-serif;margin:2rem;line-height:1.5;background:#111;color:#e5e7eb}a{color:#93c5fd}table{border-collapse:collapse;width:100%%}th,td{border:1px solid #374151;padding:.5rem;vertical-align:top}th{background:#1f2937;text-align:left}code,pre{background:#0b1220;color:#e5e7eb;padding:.2rem .4rem}pre{margin:0;white-space:pre-wrap}.pass{color:#4ade80}.fail{color:#f87171}</style>\n'
        printf '</head>\n<body>\n'
        printf '<h1>Devtainer smoke</h1>\n'
        printf '<p>Image: <code>%s</code></p>\n' "${IMAGE}"
        printf '<p>Status: <strong class="%s">%s</strong></p>\n' "${status}" "${status}"
        printf '<p>Summary: <code>summary.json</code></p>\n'
        printf '<table>\n<thead><tr><th>Check</th><th>Description</th><th>Status</th><th>Log</th></tr></thead>\n<tbody>\n'
        for json_file in "${CHECKS_DIR}"/*.json; do
            [[ -e "${json_file}" ]] || continue
            name="$(grep -o '"name":"[^"]*"' "${json_file}" | head -n1 | cut -d'"' -f4)"
            description="$(grep -o '"description":"[^"]*"' "${json_file}" | head -n1 | cut -d'"' -f4)"
            check_status="$(grep -o '"status":"[^"]*"' "${json_file}" | head -n1 | cut -d'"' -f4)"
            log_path="$(grep -o '"log":"[^"]*"' "${json_file}" | head -n1 | cut -d'"' -f4)"
            log_content="$(read_log "${log_path}")"
            printf '<tr><td><code>%s</code></td><td>%s</td><td class="%s">%s</td><td><pre>%s</pre></td></tr>\n' "${name}" "${description}" "${check_status}" "${check_status}" "${log_content}"
        done
        printf '</tbody>\n</table>\n</body>\n</html>\n'
    } >"${html_file}"
}

render_dashboard() {
    local dashboard_file="${OUT_DIR}/${RUN_ID}/index.html"
    local manifest_file="${OUT_DIR}/${RUN_ID}/manifest.json"

    mkdir -p "${OUT_DIR}/${RUN_ID}"
    printf '{"run_id":"%s","images":["latest","slim","alpine","alpine-slim","arch","arch-slim"]}\n' "${RUN_ID}" >"${manifest_file}"

    {
        printf '<!doctype html>\n<html lang="en">\n<head>\n<meta charset="utf-8">\n'
        printf '<meta name="viewport" content="width=device-width, initial-scale=1">\n'
        printf '<title>Devtainer smoke report</title>\n'
        printf '<style>body{font-family:sans-serif;margin:2rem;line-height:1.5;background:#111;color:#e5e7eb}a{color:#93c5fd}table{border-collapse:collapse;width:100%%}th,td{border:1px solid #374151;padding:.5rem;vertical-align:top}th{background:#1f2937;text-align:left}code,pre{background:#0b1220;color:#e5e7eb;padding:.2rem .4rem}.pass{color:#4ade80}.fail{color:#f87171}</style>\n'
        printf '</head>\n<body>\n'
        printf '<h1>Devtainer smoke report</h1>\n'
        printf '<p>Run ID: <code>%s</code></p>\n' "${RUN_ID}"
        printf '<p>Manifest: <code>manifest.json</code></p>\n'
        printf '<table>\n<thead><tr><th>Image</th><th>Status</th><th>Report</th></tr></thead>\n<tbody>\n'
        for summary_file in "${OUT_DIR}/${RUN_ID}"/devtainer-*/summary.json; do
            [[ -e "${summary_file}" ]] || continue
            image="$(grep -o '"image":"[^"]*"' "${summary_file}" | head -n1 | cut -d'"' -f4)"
            status="$(grep -o '"status":"[^"]*"' "${summary_file}" | head -n1 | cut -d'"' -f4)"
            image_dir="$(dirname "${summary_file}")"
            printf '<tr><td><code>%s</code></td><td class="%s">%s</td><td><a href="%s/index.html">details</a></td></tr>\n' "${image}" "${status}" "${status}" "$(basename "${image_dir}")"
        done
        printf '</tbody>\n</table>\n</body>\n</html>\n'
    } >"${dashboard_file}"
}

main() {
    local status=0

    if ! run_container_check "verify-baked-dotfiles" "verify baked dotfiles are present" <<'EOF'
set -eu
[ -x /usr/local/bin/devtainer-bootstrap-home ]
[ -d /opt/devtainer-home/zsh ]
[ -f /opt/devtainer-home/zsh/.zshrc ]
[ -d /opt/devtainer-home/tmux ]
[ -f /opt/devtainer-home/tmux/.tmux.conf ]
[ -d /opt/devtainer-home/nvim/.config/nvim ]
[ -f /opt/devtainer-home/nvim/.config/nvim/init.lua ]
[ -d /opt/devtainer-home/mise/.config/mise ]
[ -f /opt/devtainer-home/mise/.config/mise/config.toml ]
[ -d /opt/devtainer-home/one-shot-apps ]
[ -r /home/devtainer/.zshrc ]
[ -r /home/devtainer/.tmux.conf ]
[ -f /home/devtainer/.config/nvim/init.lua ]
[ -f /home/devtainer/.config/mise/config.toml ]
[ -d /home/devtainer/.local/share/mise/shims ]
[ -d /home/devtainer/.local/share/nvim/lazy ]
EOF
    then
        status=1
    fi

    if ! run_container_check "verify-default-home" "verify default shell startup config" <<'EOF'
set -eu
hook_bypass_dir="$(mktemp -d)"
printf '#!/bin/sh\nexit 0\n' > "${hook_bypass_dir}/distrobox-host-exec"
chmod +x "${hook_bypass_dir}/distrobox-host-exec"
zsh_output="$(PATH="${hook_bypass_dir}:${PATH}" zsh -ic 'printf "%s|%s|%s\n" "${NVIM_CONFIG_PATH:-}" "${EDITOR:-}" "$(alias gs >/dev/null 2>&1 && printf yes || printf no)"' 2>&1)"
if printf '%s\n' "${zsh_output}" | grep -qE 'command not found: (atuin|wfetch)'; then
    printf '%s\n' "${zsh_output}" >&2
    exit 1
fi
zsh_output="$(printf '%s\n' "${zsh_output}" | tail -n 1)"
[ "${zsh_output}" = 'nvim/.config/nvim|nvim|yes' ]
tmux_bin="$(PATH="/usr/local/bin:/usr/bin:/bin" command -v tmux || true)"
if [ -n "${tmux_bin}" ]; then
    tmux_status="$(${tmux_bin} -L smoke-default start-server \; show -gv status \; kill-server)"
    [ "${tmux_status}" = 'off' ]
fi
EOF
    then
        status=1
    fi

    if ! run_nvim_check "verify-nvim-install" "verify neovim is installed" 'vim.fn.has("nvim-0.9") == 1 or vim.fn.has("nvim-0.10") == 1 or vim.fn.has("nvim-0.11") == 1'; then
        status=1
    fi
    if ! run_nvim_check "verify-nvim-config" "verify neovim config is present" 'vim.fn.filereadable(vim.fn.stdpath("config") .. "/init.lua") == 1'; then
        status=1
    fi
    if ! run_nvim_check "verify-nvim-plugins" "verify lazy plugins are downloaded" 'vim.fn.isdirectory(vim.fn.stdpath("data") .. "/lazy") == 1'; then
        status=1
    fi

    if ! run_container_check "verify-remapped-home" "verify bootstrap works on remapped home" <<'EOF'
set -eu
tmp_home="$(mktemp -d)"
hook_bypass_dir="$(mktemp -d)"
mkdir -p "${tmp_home}"
printf '#!/bin/sh\nexit 0\n' > "${hook_bypass_dir}/distrobox-host-exec"
chmod +x "${hook_bypass_dir}/distrobox-host-exec"
HOME="${tmp_home}" USER=devtainer devtainer-bootstrap-home
[ -L "${tmp_home}/.zshrc" ]
[ -L "${tmp_home}/.tmux.conf" ]
[ -L "${tmp_home}/.config/nvim" ]
[ -L "${tmp_home}/.config/mise" ]
[ -L "${tmp_home}/.local/share/mise" ]
EOF
    then
        status=1
    fi

    write_summary "$( [[ ${status} -eq 0 ]] && printf pass || printf fail )"
    return "${status}"
}

main "$@"
render_dashboard
