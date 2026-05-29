#!/bin/bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
    echo "Usage: $0 <repo_path> [extensions_path]"
    echo
    echo "Arguments:"
    echo "  repo_path         Path to the repository for the agent to work on"
    echo "  extensions_path   Optional path to custom extensions folder"
    exit 0
}

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    usage
fi

repo_path="${1:?Usage: $0 <repo_path> [extensions_path]}"
repo_path="$(cd "$repo_path" && pwd)"
extensions_path="${2:-}"

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

docker run "${docker_args[@]}" pi-agent:latest
