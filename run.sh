#!/bin/bash
set -euo pipefail


pi_settings="$(pwd)/pi"

mkdir -p "$pi_settings"

docker run -it --rm \
    -v "$pi_settings:/home/pi/.pi" \
    -v "$repo_path:/home/pi/src" \
    pi-agent:latest
