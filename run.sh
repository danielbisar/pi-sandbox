#!/bin/bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$script_dir/shared.sh"

usage() {
    echo "Usage: $0 [--extensions <extensions_path>] [--skills <skill_path>]... [--session <session_id>] [--shell] <repo_path>"
    echo
    echo "Options:"
    echo "  --extensions <path>    Optional path to custom extensions folder"
    echo "  --skills <path>        Optional path to a custom skill folder; may be repeated"
    echo "  --skill <path>         Alias for --skills"
    echo "  --session <id>         Optional pi session ID to resume"
    echo "  --shell                Run /bin/bash instead of pi"
    echo "  -h, --help             Show this help message"
    echo
    echo "Arguments:"
    echo "  repo_path              Path to the repository for the agent to work on"
    exit 0
}

repo_path=""
extensions_path=""
skills_paths=()
session_id=""
run_shell=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            usage
            ;;
        --extensions)
            [[ $# -ge 2 ]] || { echo "Error: --extensions requires a path" >&2; exit 1; }
            extensions_path="$2"
            shift 2
            ;;
        --skills|--skill)
            [[ $# -ge 2 ]] || { echo "Error: $1 requires a path" >&2; exit 1; }
            skills_paths+=("$2")
            shift 2
            ;;
        --session)
            [[ $# -ge 2 ]] || { echo "Error: --session requires a session ID" >&2; exit 1; }
            session_id="$2"
            shift 2
            ;;
        --shell)
            run_shell=true
            shift
            ;;
        --*)
            echo "Error: Unknown option: $1" >&2
            usage
            ;;
        *)
            if [[ -z "$repo_path" ]]; then
                repo_path="$1"
                shift
            else
                echo "Error: Unexpected argument: $1" >&2
                usage
            fi
            ;;
    esac
done

[[ -n "$repo_path" ]] || { echo "Error: repo_path is required" >&2; usage; }
repo_path="$(cd "$repo_path" && pwd)"

pi_settings="$script_dir/pi"

mkdir -p "$pi_settings"

docker_args=(
    -it --rm
    -v "$pi_settings:/home/pi/.pi"
    -v "$repo_path:/home/pi/src"
)

if [[ -n "$extensions_path" ]]; then
    extensions_path="$(cd "$extensions_path" && pwd)"
    docker_args+=(-v "$extensions_path:/home/pi/.pi/agent/extensions")
fi

if [[ ${#skills_paths[@]} -gt 0 ]]; then
    declare -A used_skill_mounts=()

    for skill_path in "${skills_paths[@]}"; do
        skill_path="$(cd "$skill_path" && pwd)"
        skill_name="$(basename "$skill_path")"
        mount_name="$skill_name"
        suffix=2

        while [[ -n "${used_skill_mounts[$mount_name]:-}" ]]; do
            mount_name="${skill_name}-${suffix}"
            ((suffix++))
        done

        used_skill_mounts["$mount_name"]=1
        docker_args+=(-v "$skill_path:/home/pi/.pi/agent/skills/$mount_name")
    done
fi

if [[ "$run_shell" == true ]]; then
    $container_cli run "${docker_args[@]}" pi-agent:latest /bin/bash
else
    pi_args=()

    if [[ -n "$session_id" ]]; then
        pi_args+=(--session "$session_id")
    fi

    $container_cli run "${docker_args[@]}" pi-agent:latest /usr/local/bin/pi "${pi_args[@]}"
fi
