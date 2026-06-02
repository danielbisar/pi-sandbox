
if command -v docker >/dev/null 2>&1; then
    container_cli="docker"
elif command -v podman >/dev/null 2>&1; then
    container_cli="podman"
else
    echo "Neither docker nor podman is available" >&2
    exit 1
fi
