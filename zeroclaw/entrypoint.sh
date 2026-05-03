#!/bin/bash
set -e

if [ "$(id -u)" = "0" ]; then
    mkdir -p /zeroclaw-data/.zeroclaw /zeroclaw-data/workspace
    chown -R zeroclaw:zeroclaw /zeroclaw-data /usr/share/zeroclaw
    exec gosu zeroclaw "$0" "$@"
fi

exec zeroclaw "$@"
