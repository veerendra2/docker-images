#!/usr/bin/env bash

set -e

# ----------------------- it-tools with subpath `/it-tools/` -----------------------
LATEST_TAG=$(curl -sS  https://api.github.com/repos/CorentinTh/it-tools/releases/latest | jq -r '.tag_name')
curl -sSOL "https://github.com/CorentinTh/it-tools/archive/refs/tags/${LATEST_TAG}.tar.gz"
tar -xf ${LATEST_TAG}.tar.gz
DIR_NAME=$(tar -tf ${LATEST_TAG}.tar.gz | head -1)
pushd ${DIR_NAME} 1>/dev/null
sed -i '/RUN pnpm build/i ENV BASE_URL="/it-tools/"' Dockerfile
docker buildx build --platform linux/arm64/v8,linux/amd64 -t it-tools:latest .
docker push veerendra2/it-tools:latest
