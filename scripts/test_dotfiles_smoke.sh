#!/usr/bin/env bash
set -euo pipefail

declare -a RUNTIME=()
read -r -a RUNTIME <<< "${CONTAINER_RUNTIME:-podman}"
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
PASS_COUNT=0
FAIL_COUNT=0
SKIP_COUNT=0

image_dir_name() {
    local image_ref="$1"
    local image_name="${image_ref##*/}"
    printf '%s\n' "${image_name//[:\/]/-}"
}

json_get_string() {
    local key="$1"
    local file="$2"
    grep -o "\"${key}\":\"[^\"]*\"" "${file}" | head -n1 | cut -d'"' -f4 || true
}

json_get_number() {
    local key="$1"
    local file="$2"
    grep -o "\"${key}\":[0-9]*" "${file}" | head -n1 | cut -d':' -f2 || true
}

feature_title() {
    case "$1" in
        verify-baked-dotfiles) printf 'Baked dotfiles' ;;
        verify-default-home) printf 'Default home' ;;
        verify-nvim-install) printf 'Neovim install' ;;
        verify-nvim-config) printf 'Neovim config' ;;
        verify-nvim-plugins) printf 'Plugins cached' ;;
        verify-nvim-checkhealth) printf 'Headless health' ;;
        verify-remapped-home) printf 'Bootstrap remap' ;;
        *) printf '%s' "$1" ;;
    esac
}

feature_status() {
    local image_dir="$1"
    local check_name="$2"
    local json_file="${image_dir}/checks/${check_name}.json"
    local status

    if [[ ! -f "${json_file}" ]]; then
        printf 'na\n'
        return
    fi

    status="$(json_get_string status "${json_file}")"
    case "${status}" in
        pass|fail) printf '%s\n' "${status}" ;;
        *) printf 'na\n' ;;
    esac
}

status_label() {
    case "$1" in
        pass) printf 'Pass' ;;
        fail) printf 'Fail' ;;
        *) printf 'N/A' ;;
    esac
}

print_report_styles() {
    cat <<'EOF'
<style>
:root {
    color-scheme: dark;
    --bg: #07111f;
    --panel: rgba(15, 23, 42, 0.88);
    --panel-strong: rgba(15, 23, 42, 0.96);
    --line: rgba(148, 163, 184, 0.2);
    --text: #e2e8f0;
    --muted: #94a3b8;
    --pass: #22c55e;
    --fail: #ef4444;
    --na: #f59e0b;
    --accent: #60a5fa;
    --accent-2: #a78bfa;
}
* { box-sizing: border-box; }
body {
    margin: 0;
    min-height: 100vh;
    font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    line-height: 1.5;
    color: var(--text);
    background:
        radial-gradient(circle at top left, rgba(96, 165, 250, 0.18), transparent 26%),
        radial-gradient(circle at top right, rgba(167, 139, 250, 0.14), transparent 22%),
        linear-gradient(180deg, #020617, var(--bg));
}
a { color: #bfdbfe; }
code {
    font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", monospace;
    background: rgba(15, 23, 42, 0.92);
    border: 1px solid rgba(148, 163, 184, 0.18);
    border-radius: 0.5rem;
    padding: 0.15rem 0.4rem;
}
pre {
    margin: 0;
    overflow-x: auto;
    white-space: pre-wrap;
    background: #020617;
    border: 1px solid rgba(148, 163, 184, 0.12);
    border-radius: 0.9rem;
    padding: 1rem;
}
.page {
    width: min(1400px, calc(100vw - 2rem));
    margin: 0 auto;
    padding: 2rem 0 4rem;
}
.hero {
    background: linear-gradient(135deg, rgba(15, 23, 42, 0.96), rgba(17, 24, 39, 0.82));
    border: 1px solid rgba(148, 163, 184, 0.18);
    border-radius: 1.5rem;
    padding: 1.5rem;
    box-shadow: 0 20px 45px rgba(2, 6, 23, 0.32);
    margin-bottom: 1.5rem;
}
.hero h1 {
    margin: 0 0 0.5rem;
    font-size: clamp(1.8rem, 4vw, 3rem);
    line-height: 1.05;
}
.hero p {
    margin: 0.3rem 0;
    color: var(--muted);
}
.hero-grid,
.stats-grid,
.checks-grid {
    display: grid;
    gap: 1rem;
}
.hero-grid,
.stats-grid {
    grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
    margin-top: 1rem;
}
.stat-card,
.check-card,
.panel {
    background: var(--panel);
    border: 1px solid var(--line);
    border-radius: 1.1rem;
    padding: 1rem;
    box-shadow: 0 10px 30px rgba(2, 6, 23, 0.2);
}
.stat-label {
    display: block;
    color: var(--muted);
    font-size: 0.82rem;
    text-transform: uppercase;
    letter-spacing: 0.08em;
    margin-bottom: 0.4rem;
}
.stat-value {
    font-size: 1.6rem;
    font-weight: 700;
}
.pill {
    display: inline-flex;
    align-items: center;
    gap: 0.45rem;
    font-weight: 700;
    border-radius: 999px;
    padding: 0.35rem 0.75rem;
    border: 1px solid currentColor;
    background: rgba(15, 23, 42, 0.7);
}
.pass { color: var(--pass); }
.fail { color: var(--fail); }
.na { color: var(--na); }
.table-wrap {
    overflow-x: auto;
    background: var(--panel-strong);
    border: 1px solid var(--line);
    border-radius: 1.2rem;
    box-shadow: 0 14px 32px rgba(2, 6, 23, 0.22);
}
table {
    width: 100%;
    border-collapse: collapse;
}
th, td {
    padding: 0.9rem 1rem;
    border-bottom: 1px solid rgba(148, 163, 184, 0.12);
    text-align: left;
    vertical-align: top;
}
th {
    font-size: 0.82rem;
    text-transform: uppercase;
    letter-spacing: 0.08em;
    color: #cbd5e1;
    background: rgba(15, 23, 42, 0.9);
    position: sticky;
    top: 0;
}
tbody tr:hover { background: rgba(30, 41, 59, 0.32); }
.matrix td,
.matrix th { text-align: center; }
.matrix td:first-child,
.matrix th:first-child,
.matrix td:nth-child(2),
.matrix th:nth-child(2) { text-align: left; }
.section-title {
    margin: 2rem 0 0.75rem;
    font-size: 1.1rem;
    color: #f8fafc;
}
.muted { color: var(--muted); }
details summary {
    cursor: pointer;
    color: #bfdbfe;
    user-select: none;
}
.checks-grid {
    grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
}
.check-card h2 {
    margin: 0 0 0.6rem;
    font-size: 1rem;
}
.check-card p {
    margin: 0.35rem 0 0.75rem;
    color: var(--muted);
}
</style>
EOF
}

json_string() {
    local value="$1"
    value="${value//\\/\\\\}"
    value="${value//\"/\\\"}"
    value="${value//$'\n'/\\n}"
    printf '%s' "${value}"
}

run_runtime() {
    "${RUNTIME[@]}" "$@"
}

nvim_log_has_errors() {
    local file="$1"
    grep -Eq '^Error detected while processing|^Failed to run `config`|^E[0-9]{4}:' "${file}"
}

html_escape_file() {
    local file="$1"
    if [[ -f "${file}" ]]; then
        sed -e 's/\&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g' "${file}"
    fi
}

write_check_json() {
    local name="$1"
    local description="$2"
    local status="$3"
    local log_file="$4"
    local message="${5:-}"
    local json_file="${CHECKS_DIR}/${name}.json"

    case "${status}" in
        pass) PASS_COUNT=$((PASS_COUNT + 1)) ;;
        fail) FAIL_COUNT=$((FAIL_COUNT + 1)) ;;
        skip) SKIP_COUNT=$((SKIP_COUNT + 1)) ;;
    esac

    {
        printf '{'
        printf '"name":"%s",' "$(json_string "${name}")"
        printf '"description":"%s",' "$(json_string "${description}")"
        printf '"status":"%s",' "$(json_string "${status}")"
        printf '"log":"%s"' "$(json_string "${log_file}")"
        if [[ -n "${message}" ]]; then
            printf ',"message":"%s"' "$(json_string "${message}")"
        fi
        printf '}\n'
    } >"${json_file}"
}

run_container_check() {
    local name="$1"
    local description="$2"
    local log_file="${CHECKS_DIR}/${name}.log"
    local shell_path

    printf '==> %s (%s)\n' "${name}" "${IMAGE}"
    shell_path="$(resolve_container_shell "${log_file}")"
    if [[ -z "${shell_path}" ]]; then
        write_check_json "${name}" "${description}" fail "${log_file}" "no shell found"
        return 1
    fi

    if run_runtime run --rm -i --entrypoint "${shell_path}" "${IMAGE}" -s >"${log_file}" 2>&1; then
        write_check_json "${name}" "${description}" pass "${log_file}"
        return 0
    fi

    write_check_json "${name}" "${description}" fail "${log_file}"
    return 1
}

resolve_container_shell() {
    local log_file="$1"
    local candidate

    : >"${log_file}"

    for candidate in /bin/sh /usr/bin/sh /bin/bash /usr/bin/bash; do
        if run_runtime run --rm --entrypoint "${candidate}" "${IMAGE}" -c 'exit 0' >>"${log_file}" 2>&1; then
            printf '%s\n' "${candidate}"
            return 0
        fi
    done

    printf 'Unable to find a working shell in %s\n' "${IMAGE}" >>"${log_file}"
    return 1
}

run_nvim_container_check() {
    local name="$1"
    local description="$2"
    local lua_expr="$3"
    local log_file="${CHECKS_DIR}/${name}.log"
    local shell_path
    local shell_lua_expr

    shell_lua_expr=${lua_expr//\'/\'\\\'\'}

    printf '==> %s (%s)\n' "${name}" "${IMAGE}"
    shell_path="$(resolve_container_shell "${log_file}")"
    if [[ -z "${shell_path}" ]]; then
        write_check_json "${name}" "${description}" fail "${log_file}" "no shell found"
        return 1
    fi

    if run_runtime run --rm -i --entrypoint "${shell_path}" "${IMAGE}" -s >"${log_file}" 2>&1 <<EOF
set -eu
nvim_bin="\$(command -v nvim || true)"
if [ -z "\${nvim_bin}" ]; then
    printf 'nvim not found\n' >&2
    exit 1
fi
export NVIM_LUA_ASSERT='${shell_lua_expr}'
tmp_log="\$(mktemp)"
cleanup() {
    rm -f "\${tmp_log}"
}
trap cleanup EXIT
rc=0
HOME=/home/devtainer \
USER=devtainer \
XDG_CONFIG_HOME=/home/devtainer/.config \
XDG_DATA_HOME=/home/devtainer/.local/share \
XDG_CACHE_HOME=/home/devtainer/.cache \
XDG_STATE_HOME=/home/devtainer/.local/state \
"\${nvim_bin}" --headless \
    "+set runtimepath^=/home/devtainer/.config/nvim" \
    "+lua dofile('/home/devtainer/.config/nvim/init.lua')" \
    "+lua assert(assert(load('return ' .. vim.env.NVIM_LUA_ASSERT))())" \
    +qa >"\${tmp_log}" 2>&1 || rc="\$?"
cat "\${tmp_log}"
if [ "\${rc}" -ne 0 ]; then
    exit "\${rc}"
fi
if grep -Eq '^Error detected while processing|^Failed to run .*config.*|^E[0-9]{4}:' "\${tmp_log}"; then
    exit 1
fi
EOF
    then
        write_check_json "${name}" "${description}" pass "${log_file}"
        return 0
    fi

    write_check_json "${name}" "${description}" fail "${log_file}"
    return 1
}

run_nvim_checkhealth() {
    local name="$1"
    local description="$2"
    local log_file="${CHECKS_DIR}/${name}.log"
    local shell_path

    printf '==> %s (%s)\n' "${name}" "${IMAGE}"
    shell_path="$(resolve_container_shell "${log_file}")"
    if [[ -z "${shell_path}" ]]; then
        write_check_json "${name}" "${description}" fail "${log_file}" "no shell found"
        return 1
    fi

    if run_runtime run --rm -i --entrypoint "${shell_path}" "${IMAGE}" -s >"${log_file}" 2>&1 <<'EOF'
set -eu
nvim_bin="$(command -v nvim || true)"
if [ -z "${nvim_bin}" ]; then
    printf 'nvim not found\n' >&2
    exit 1
fi
tmp_log="$(mktemp)"
cleanup() {
    rm -f "${tmp_log}"
}
trap cleanup EXIT
rc=0
HOME=/home/devtainer \
USER=devtainer \
XDG_CONFIG_HOME=/home/devtainer/.config \
XDG_DATA_HOME=/home/devtainer/.local/share \
XDG_CACHE_HOME=/home/devtainer/.cache \
XDG_STATE_HOME=/home/devtainer/.local/state \
"${nvim_bin}" --headless \
    "+checkhealth" \
    "+lua local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false); print(table.concat(lines, '\n'))" \
    +qa >"${tmp_log}" 2>&1 || rc="$?"
cat "${tmp_log}"
if [ "${rc}" -ne 0 ]; then
    exit "${rc}"
fi
if grep -Eq '^Error detected while processing|^Failed to run `config`|^E[0-9]{4}:' "${tmp_log}"; then
    exit 1
fi
EOF
    then
        write_check_json "${name}" "${description}" pass "${log_file}"
        return 0
    fi

    write_check_json "${name}" "${description}" fail "${log_file}"
    return 1
}

write_summary() {
    local status="$1"
    local summary_file="${RESULT_DIR}/summary.json"
    local html_file="${RESULT_DIR}/index.html"
    local run_root="$(dirname "${RESULT_DIR}")"
    local run_name="$(basename "${run_root}")"
    local name description check_status log_path log_content message

    printf '{"image":"%s","status":"%s","checks_dir":"%s","pass":%s,"fail":%s,"skip":%s}\n' "$(json_string "${IMAGE}")" "${status}" "$(json_string "${CHECKS_DIR}")" "${PASS_COUNT}" "${FAIL_COUNT}" "${SKIP_COUNT}" >"${summary_file}"

    {
        printf '<!doctype html>\n<html lang="en">\n<head>\n<meta charset="utf-8">\n'
        printf '<meta name="viewport" content="width=device-width, initial-scale=1">\n'
        printf '<title>Devtainer smoke: %s</title>\n' "${IMAGE}"
        print_report_styles
        printf '</head>\n<body>\n'
        printf '<main class="page">\n'
        printf '<section class="hero">\n'
        printf '<p><a href="../index.html">Back to run dashboard</a></p>\n'
        printf '<h1>%s</h1>\n' "${IMAGE}"
        printf '<p>Smoke test details for one image variant.</p>\n'
        printf '<div class="hero-grid">\n'
        printf '<div class="stat-card"><span class="stat-label">Run ID</span><span class="stat-value"><code>%s</code></span></div>\n' "${run_name}"
        printf '<div class="stat-card"><span class="stat-label">Summary</span><span class="stat-value"><span class="pill %s">%s</span></span></div>\n' "${status}" "$(status_label "${status}")"
        printf '<div class="stat-card"><span class="stat-label">Pass</span><span class="stat-value pass">%s</span></div>\n' "${PASS_COUNT}"
        printf '<div class="stat-card"><span class="stat-label">Fail</span><span class="stat-value fail">%s</span></div>\n' "${FAIL_COUNT}"
        printf '<div class="stat-card"><span class="stat-label">N/A</span><span class="stat-value na">%s</span></div>\n' "${SKIP_COUNT}"
        printf '</div>\n'
        printf '</section>\n'
        printf '<h2 class="section-title">Feature Checks</h2>\n'
        printf '<section class="checks-grid">\n'
        for json_file in "${CHECKS_DIR}"/*.json; do
            [[ -e "${json_file}" ]] || continue
            name="$(json_get_string name "${json_file}")"
            description="$(json_get_string description "${json_file}")"
            check_status="$(json_get_string status "${json_file}")"
            log_path="$(json_get_string log "${json_file}")"
            message="$(json_get_string message "${json_file}")"
            log_content="$(html_escape_file "${log_path}")"
            printf '<article class="check-card">\n'
            printf '<div><span class="pill %s">%s</span></div>\n' "${check_status}" "$(status_label "${check_status}")"
            printf '<h2>%s</h2>\n' "$(feature_title "${name}")"
            printf '<p>%s</p>\n' "${description}"
            printf '<p class="muted">Check: <code>%s</code></p>\n' "${name}"
            if [[ -n "${message}" ]]; then
                printf '<p class="muted">Message: %s</p>\n' "${message}"
            fi
            printf '<details><summary>Show log</summary><pre>%s</pre></details>\n' "${log_content}"
            printf '</article>\n'
        done
        printf '</section>\n'
        printf '</main>\n</body>\n</html>\n'
    } >"${html_file}"
}

render_dashboard() {
    local dashboard_file="${OUT_DIR}/${RUN_ID}/index.html"
    local manifest_file="${OUT_DIR}/${RUN_ID}/manifest.json"
    local image_tag image_dir summary_file image report_status pass fail skip overall_status total_images passing_images failing_images na_images
    local -a image_tags=(latest slim alpine alpine-slim arch arch-slim)
    local -a features=(
        verify-baked-dotfiles
        verify-default-home
        verify-nvim-install
        verify-nvim-config
        verify-nvim-plugins
        verify-nvim-checkhealth
        verify-remapped-home
    )
    local feature_name feature_state

    mkdir -p "${OUT_DIR}/${RUN_ID}"
    printf '{"run_id":"%s","images":["latest","slim","alpine","alpine-slim","arch","arch-slim"]}\n' "${RUN_ID}" >"${manifest_file}"

    total_images=0
    passing_images=0
    failing_images=0
    na_images=0
    for image_tag in "${image_tags[@]}"; do
        total_images=$((total_images + 1))
        summary_file="${OUT_DIR}/${RUN_ID}/$(image_dir_name "ghcr.io/waylonwalker/devtainer:${image_tag}")/summary.json"
        if [[ ! -f "${summary_file}" ]]; then
            na_images=$((na_images + 1))
            continue
        fi
        overall_status="$(json_get_string status "${summary_file}")"
        case "${overall_status}" in
            pass) passing_images=$((passing_images + 1)) ;;
            fail) failing_images=$((failing_images + 1)) ;;
            *) na_images=$((na_images + 1)) ;;
        esac
    done

    {
        printf '<!doctype html>\n<html lang="en">\n<head>\n<meta charset="utf-8">\n'
        printf '<meta name="viewport" content="width=device-width, initial-scale=1">\n'
        printf '<title>Devtainer smoke report</title>\n'
        print_report_styles
        printf '</head>\n<body>\n'
        printf '<main class="page">\n'
        printf '<section class="hero">\n'
        printf '<h1>Devtainer Smoke Report</h1>\n'
        printf '<p>Run ID: <code>%s</code></p>\n' "${RUN_ID}"
        printf '<p>Manifest: <code>manifest.json</code></p>\n'
        printf '<p>Build once, compare every image variant, and inspect feature-level health from one page.</p>\n'
        printf '<div class="stats-grid">\n'
        printf '<div class="stat-card"><span class="stat-label">Images</span><span class="stat-value">%s</span></div>\n' "${total_images}"
        printf '<div class="stat-card"><span class="stat-label">Passing</span><span class="stat-value pass">%s</span></div>\n' "${passing_images}"
        printf '<div class="stat-card"><span class="stat-label">Failing</span><span class="stat-value fail">%s</span></div>\n' "${failing_images}"
        printf '<div class="stat-card"><span class="stat-label">N/A or Missing</span><span class="stat-value na">%s</span></div>\n' "${na_images}"
        printf '</div>\n'
        printf '</section>\n'
        printf '<h2 class="section-title">Image Summary</h2>\n'
        printf '<div class="table-wrap"><table>\n<thead><tr><th>Image</th><th>Status</th><th>Pass</th><th>Fail</th><th>N/A</th><th>Report</th></tr></thead>\n<tbody>\n'
        for image_tag in "${image_tags[@]}"; do
            image="ghcr.io/waylonwalker/devtainer:${image_tag}"
            image_dir="$(image_dir_name "${image}")"
            summary_file="${OUT_DIR}/${RUN_ID}/${image_dir}/summary.json"
            if [[ -f "${summary_file}" ]]; then
                report_status="$(json_get_string status "${summary_file}")"
                pass="$(json_get_number pass "${summary_file}")"
                fail="$(json_get_number fail "${summary_file}")"
                skip="$(json_get_number skip "${summary_file}")"
                printf '<tr><td><code>%s</code></td><td><span class="pill %s">%s</span></td><td>%s</td><td>%s</td><td>%s</td><td><a href="%s/index.html">details</a></td></tr>\n' "${image}" "${report_status}" "$(status_label "${report_status}")" "${pass:-0}" "${fail:-0}" "${skip:-0}" "${image_dir}"
            else
                printf '<tr><td><code>%s</code></td><td><span class="pill na">N/A</span></td><td>-</td><td>-</td><td>-</td><td class="muted">not generated</td></tr>\n' "${image}"
            fi
        done
        printf '</tbody>\n</table></div>\n'
        printf '<h2 class="section-title">Feature Matrix</h2>\n'
        printf '<div class="table-wrap"><table class="matrix">\n<thead><tr><th>Image</th><th>Overall</th>'
        for feature_name in "${features[@]}"; do
            printf '<th>%s</th>' "$(feature_title "${feature_name}")"
        done
        printf '</tr></thead>\n<tbody>\n'
        for image_tag in "${image_tags[@]}"; do
            image="ghcr.io/waylonwalker/devtainer:${image_tag}"
            image_dir="${OUT_DIR}/${RUN_ID}/$(image_dir_name "${image}")"
            summary_file="${image_dir}/summary.json"
            if [[ -f "${summary_file}" ]]; then
                report_status="$(json_get_string status "${summary_file}")"
            else
                report_status="na"
            fi
            printf '<tr><td><code>%s</code></td><td><span class="pill %s">%s</span></td>' "${image}" "${report_status}" "$(status_label "${report_status}")"
            for feature_name in "${features[@]}"; do
                feature_state="$(feature_status "${image_dir}" "${feature_name}")"
                printf '<td><span class="pill %s">%s</span></td>' "${feature_state}" "$(status_label "${feature_state}")"
            done
            printf '</tr>\n'
        done
        printf '</tbody>\n</table></div>\n'
        printf '</main>\n</body>\n</html>\n'
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

    if ! run_nvim_container_check "verify-nvim-install" "verify neovim is installed" '(function() local v = vim.version(); return v.major > 0 or v.minor >= 11 end)()'; then
        status=1
    fi
    if ! run_nvim_container_check "verify-nvim-config" "verify neovim config is present" 'vim.fn.filereadable(vim.fn.stdpath("config") .. "/init.lua") == 1'; then
        status=1
    fi
    if ! run_nvim_container_check "verify-nvim-plugins" "verify lazy plugins are downloaded" 'vim.fn.isdirectory(vim.fn.stdpath("data") .. "/lazy") == 1'; then
        status=1
    fi
    if ! run_nvim_checkhealth "verify-nvim-checkhealth" "verify neovim checkhealth runs headlessly"; then
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

status=0
main "$@" || status=$?
render_dashboard
exit "${status}"
