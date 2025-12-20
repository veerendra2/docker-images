#!/usr/bin/env bash
set -Eeuo pipefail

file_env() {
    local var="$1"
    local fileVar="${var}_FILE"
    if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
        echo >&2 "error: both $var and $fileVar are set"
        exit 1
    fi
    if [ "${!fileVar:-}" ]; then
        export "$var"="$(< "${!fileVar}")"
    fi
}

if [ "$1" = 'mongod' ] && [ "$(id -u)" = '0' ]; then
    find -L /data/db \! -user mongodb -exec chown mongodb '{}' +
    exec gosu mongodb "$BASH_SOURCE" "$@"
fi

if [ "$1" = 'mongod' ]; then
    file_env 'MONGO_INITDB_ROOT_USERNAME'
    file_env 'MONGO_INITDB_ROOT_PASSWORD'

    if [ -n "${MONGO_INITDB_ROOT_USERNAME:-}" ] && [ ! -f "/data/db/storage.bson" ]; then
        echo "Creating MongoDB root user..."

        pidfile="/tmp/docker-temp-mongod.pid"

        mongod --fork --logpath /proc/self/fd/1 --bind_ip 127.0.0.1 --pidfilepath "$pidfile"

        tries=30
        while true; do
            if /usr/local/bin/mongo-init --ping > /dev/null 2>&1; then
                break
            fi
            if [ "$tries" -le 0 ]; then
                echo >&2 "error: mongod did not start in time"
                exit 1
            fi
            (( tries-- ))
            sleep 1
        done

        /usr/local/bin/mongo-init "$MONGO_INITDB_ROOT_USERNAME" "$MONGO_INITDB_ROOT_PASSWORD"

        mongod --shutdown --pidfilepath "$pidfile"
        rm -f "$pidfile"

        echo "MongoDB init process complete."
    fi

    if [[ "$*" != *"--bind_ip"* ]]; then
        set -- "$@" --bind_ip_all
    fi
fi

unset MONGO_INITDB_ROOT_USERNAME MONGO_INITDB_ROOT_PASSWORD

exec "$@"