#!/bin/bash
set -euo pipefail

image="pi-agent"
base_image="node:24-slim"

# Get the latest available version from npm
latest_version="$(npm view @earendil-works/pi-coding-agent version)"

# Get the current image version (if it exists)
current_version="$(docker inspect --format '{{index .Config.Labels "pi.version"}}' "$image:latest" 2>/dev/null || echo "")"

if [[ "$current_version" == "$latest_version" ]]; then
    echo "pi version $latest_version unchanged, building with cache."
    cache_flag=""
else
    echo "New pi version $latest_version (current: ${current_version:-none}), building without cache."
    cache_flag="--no-cache"
fi

docker build $cache_flag \
    --build-arg "BASE_IMAGE=$base_image" \
    --label "pi.version=$latest_version" \
    -t "$image:latest" \
    -t "$image:$latest_version" \
    .
