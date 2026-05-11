#!/usr/bin/env bash

set -e

# ----------------------- it-tools with subpath `/it-tools/` -----------------------
LATEST_TAG=$(curl -sS https://api.github.com/repos/CorentinTh/it-tools/releases/latest | jq -r '.tag_name')
curl -sSOL "https://github.com/CorentinTh/it-tools/archive/refs/tags/${LATEST_TAG}.tar.gz"
DIR_NAME=$(tar -tf ${LATEST_TAG}.tar.gz | head -1)
tar -xf ${LATEST_TAG}.tar.gz
pushd ${DIR_NAME} 1>/dev/null
sed -i '/RUN pnpm build/i ENV BASE_URL="/it-tools/"' Dockerfile
docker buildx build --platform linux/arm64/v8,linux/amd64 -t veerendra2/it-tools:latest . --push
popd 1>/dev/null

# ----------------------- 9router -----------------------
LATEST_TAG=$(curl -sS https://api.github.com/repos/decolua/9router/releases/latest | jq -r '.tag_name')
curl -sSOL "https://github.com/decolua/9router/archive/refs/tags/${LATEST_TAG}.tar.gz"
DIR_NAME=$(tar -tf ${LATEST_TAG}.tar.gz | head -1)
tar -xf ${LATEST_TAG}.tar.gz
pushd ${DIR_NAME} 1>/dev/null
docker buildx build --platform linux/arm64/v8,linux/amd64 -t veerendra2/9router:latest -t veerendra2/9router:${LATEST_TAG} . --push
popd 1>/dev/null


