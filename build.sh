#!/bin/bash
set -euo pipefail

image="pi-agent"
base_image="node:24-slim"

docker build --no-cache --build-arg "BASE_IMAGE=$base_image" -t "$image:latest" .
