#!/usr/bin/env bash
set -euo pipefail

RUNTIME="${CONTAINER_RUNTIME:-podman}"
IMAGE="${1:-}"

if [[ -z "${IMAGE}" ]]; then
    printf 'Usage: %s IMAGE\n' "${0##*/}" >&2
    exit 1
fi

run_script() {
    local description="$1"

    printf '==> %s (%s)\n' "${description}" "${IMAGE}"

    "${RUNTIME}" run --rm -i --entrypoint /bin/sh "${IMAGE}" -s
}

run_script "verify baked-in dotfiles" <<'EOF'
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
EOF

run_script "verify apps use default home dotfiles" <<'EOF'
set -eu

hook_bypass_dir="$(mktemp -d)"
printf '#!/bin/sh\nexit 0\n' > "${hook_bypass_dir}/distrobox-host-exec"
chmod +x "${hook_bypass_dir}/distrobox-host-exec"

zsh_output="$(PATH="${hook_bypass_dir}:${PATH}" zsh -ic 'printf "%s|%s|%s\n" "${NVIM_CONFIG_PATH:-}" "${EDITOR:-}" "$(alias gs >/dev/null 2>&1 && printf yes || printf no)"' 2>&1)"
zsh_output="$(printf '%s\n' "${zsh_output}" | tail -n 1)"
[ "${zsh_output}" = 'nvim/.config/nvim|nvim|yes' ]

tmux_bin="$(PATH="/usr/local/bin:/usr/bin:/bin" command -v tmux || true)"
if [ -n "${tmux_bin}" ]; then
    tmux_status="$("${tmux_bin}" -L smoke-default start-server \; show -gv status \; kill-server)"
    [ "${tmux_status}" = 'off' ]
fi

nvim_bin="$(PATH="/usr/local/bin:/usr/bin:/bin" command -v nvim || true)"
if [ -n "${nvim_bin}" ]; then
    nvim_config_dir="$("${nvim_bin}" --headless --clean '+lua io.write(vim.fn.stdpath("config"))' +qa)"
    [ "${nvim_config_dir}" = '/home/devtainer/.config/nvim' ]
    [ -f "${nvim_config_dir}/init.lua" ]
fi
EOF

run_script "verify bootstrap on remapped home" <<'EOF'
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

zsh_output="$(HOME="${tmp_home}" USER=devtainer XDG_CONFIG_HOME="${tmp_home}/.config" XDG_CACHE_HOME="${tmp_home}/.cache" XDG_STATE_HOME="${tmp_home}/.local/state" PATH="${hook_bypass_dir}:${PATH}" zsh -ic 'printf "%s|%s|%s\n" "${NVIM_CONFIG_PATH:-}" "${EDITOR:-}" "$(alias gs >/dev/null 2>&1 && printf yes || printf no)"' 2>&1)"
zsh_output="$(printf '%s\n' "${zsh_output}" | tail -n 1)"
[ "${zsh_output}" = 'nvim/.config/nvim|nvim|yes' ]

tmux_bin="$(PATH="/usr/local/bin:/usr/bin:/bin" command -v tmux || true)"
if [ -n "${tmux_bin}" ]; then
    tmux_status="$(HOME="${tmp_home}" USER=devtainer XDG_CONFIG_HOME="${tmp_home}/.config" XDG_CACHE_HOME="${tmp_home}/.cache" XDG_STATE_HOME="${tmp_home}/.local/state" "${tmux_bin}" -L smoke-bootstrap start-server \; show -gv status \; kill-server)"
    [ "${tmux_status}" = 'off' ]
fi

nvim_bin="$(PATH="/usr/local/bin:/usr/bin:/bin" command -v nvim || true)"
if [ -n "${nvim_bin}" ]; then
    nvim_config_dir="$(HOME="${tmp_home}" USER=devtainer XDG_CONFIG_HOME="${tmp_home}/.config" XDG_CACHE_HOME="${tmp_home}/.cache" XDG_STATE_HOME="${tmp_home}/.local/state" "${nvim_bin}" --headless --clean '+lua io.write(vim.fn.stdpath("config"))' +qa)"
    [ "${nvim_config_dir}" = "${tmp_home}/.config/nvim" ]
    [ -f "${nvim_config_dir}/init.lua" ]
fi
EOF

printf 'Smoke tests passed for %s\n' "${IMAGE}"
