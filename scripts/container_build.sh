#!/usr/bin/env bash
set -euo pipefail

usage() {
    printf 'Usage: %s RUNTIME BUILD_ARGS...\n' "${0##*/}" >&2
}

declare -i proxy_args_added=0

redacted_build_arg() {
    local arg="$1"
    local name="${arg%%=*}"

    case "${name}" in
        HTTP_PROXY|HTTPS_PROXY|NO_PROXY|ALL_PROXY|http_proxy|https_proxy|no_proxy|all_proxy|UV_INDEX_URL|UV_EXTRA_INDEX_URL|UV_DEFAULT_INDEX|PIP_INDEX_URL|PIP_EXTRA_INDEX_URL)
            printf '%s=<redacted>' "${name}"
            ;;
        *)
            printf '%q' "${arg}"
            ;;
    esac
}

print_command() {
    local redact_next=0

    printf '+'
    for arg in "${CMD[@]}"; do
        printf ' '
        if (( redact_next )); then
            redacted_build_arg "${arg}"
            redact_next=0
            continue
        fi

        printf '%q' "${arg}"
        if [[ "${arg}" == "--build-arg" ]]; then
            redact_next=1
        fi
    done
    printf '\n'
}

runtime_uses_distrobox_host_exec() {
    [[ "${runtime_cmd[0]}" == "distrobox-host-exec" ]]
}

runtime_uses_docker() {
    local last_idx=$(( ${#runtime_cmd[@]} - 1 ))
    [[ "${runtime_cmd[$last_idx]}" == "docker" ]]
}

host_env_value() {
    local name="$1"

    if ! runtime_uses_distrobox_host_exec; then
        return 0
    fi

    distrobox-host-exec printenv "${name}" 2>/dev/null || true
}

append_proxy_build_args() {
    local upper="$1"
    local lower="$2"
    local upper_value="${!upper:-}"
    local lower_value="${!lower:-}"

    if [[ -z "${upper_value}" ]]; then
        upper_value="$(host_env_value "${upper}")"
    fi
    if [[ -z "${lower_value}" ]]; then
        lower_value="$(host_env_value "${lower}")"
    fi

    if [[ -n "${upper_value}" ]]; then
        CMD+=(--build-arg "${upper}=${upper_value}")
        proxy_args_added=1
    fi
    if [[ -n "${lower_value}" ]]; then
        CMD+=(--build-arg "${lower}=${lower_value}")
        proxy_args_added=1
    fi

    if [[ -n "${upper_value}" && -z "${lower_value}" ]]; then
        CMD+=(--build-arg "${lower}=${upper_value}")
        proxy_args_added=1
    fi
    if [[ -z "${upper_value}" && -n "${lower_value}" ]]; then
        CMD+=(--build-arg "${upper}=${lower_value}")
        proxy_args_added=1
    fi
}

append_build_arg_from_env() {
    local name="$1"
    local value="${!name:-}"

    if [[ -z "${value}" ]]; then
        value="$(host_env_value "${name}")"
    fi

    if [[ -n "${value}" ]]; then
        CMD+=(--build-arg "${name}=${value}")
    fi
}

if [[ $# -lt 2 ]]; then
    usage
    exit 1
fi

runtime_string="$1"
shift

declare -a runtime_cmd=()
read -r -a runtime_cmd <<< "${runtime_string}"
if [[ ${#runtime_cmd[@]} -eq 0 ]]; then
    printf 'container_build: runtime command is empty\n' >&2
    exit 1
fi

subcommand="build"
if [[ "$1" == "build" || "$1" == "pull" || "$1" == "push" ]]; then
    subcommand="$1"
    shift
fi

declare -a CMD=("${runtime_cmd[@]}" "${subcommand}")

if [[ "${subcommand}" != "build" ]]; then
    CMD+=("$@")

    print_command

    "${CMD[@]}"
    exit $?
fi

# Mirror the common proxy env names into the build when they are present so the
# same just recipes work on direct and proxy-managed networks.
append_proxy_build_args HTTP_PROXY http_proxy
append_proxy_build_args HTTPS_PROXY https_proxy
append_proxy_build_args NO_PROXY no_proxy
append_proxy_build_args ALL_PROXY all_proxy
append_build_arg_from_env UV_INDEX_URL
append_build_arg_from_env UV_EXTRA_INDEX_URL
append_build_arg_from_env UV_DEFAULT_INDEX
append_build_arg_from_env PIP_INDEX_URL
append_build_arg_from_env PIP_EXTRA_INDEX_URL

if (( proxy_args_added )) && runtime_uses_docker; then
    CMD+=(--network host)
fi

CMD+=("$@")

print_command

"${CMD[@]}"
