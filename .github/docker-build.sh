#!/usr/bin/env bash

set -e

DRYRUN=false
if [[ "$1" == "--dry-run" ]]; then
    DRYRUN=true
fi

declare -A DOCKER_IMAGES
DOCKER_IMAGES=(
    ["ansible"]="multiarch"
    ["ci-full"]="multiarch"
    ["nextcloud"]="single"
    ["python3"]="multiarch"
    ["terraform"]="single"
    ["utils"]="multiarch"
)

export DOCKER_BUILDKIT=1

for dir in "${!DOCKER_IMAGES[@]}"; do
    echo "[*] Building image in directory: $dir"

    if [[ "${DOCKER_IMAGES[$dir]}" == "multiarch" ]]; then
        echo "    - Building separate tags for amd64 and arm64"

        # Build amd64 version
        docker buildx build \
            --platform linux/amd64 \
            -t "${dir}:amd64" \
            -t "${dir}:latest" \
            -f "$dir/Dockerfile" \
            $([ "$DRYRUN" = false ] && echo "--push") \
            "$dir"

        # Build arm64 version
        docker buildx build \
            --platform linux/arm64 \
            -t "${dir}:arm" \
            -f "$dir/Dockerfile" \
            $([ "$DRYRUN" = false ] && echo "--push") \
            "$dir"

    else
        echo "    - Single multiarch build for amd64 and arm64"
        docker buildx build \
            --platform linux/amd64,linux/arm64 \
            -t "${dir}:latest" \
            -f "$dir/Dockerfile" \
            $([ "$DRYRUN" = false ] && echo "--push") \
            "$dir"
    fi
done

echo "[*] Build process complete."