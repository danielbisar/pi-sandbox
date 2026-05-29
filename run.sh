#!/bin/bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_path="${1:?Usage: $0 <repo_path>}"
repo_path="$(cd "$repo_path" && pwd)"

pi_settings="$script_dir/pi"

mkdir -p "$pi_settings"

docker run -it --rm \
    -v "$pi_settings:/home/pi/.pi" \
    -v "$repo_path:/home/pi/src" \
    pi-agent:latest
