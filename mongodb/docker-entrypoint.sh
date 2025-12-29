#!/usr/bin/env bash
set -Eeuo pipefail

if [ "${1:0:1}" = '-' ]; then
	set -- mongod "$@"
fi


file_env() {
    local var="$1"
    local fileVar="${var}_FILE"
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

    shouldPerformInitdb=
    if [ -n "${MONGO_INITDB_ROOT_USERNAME:-}" ] && [ -n "${MONGO_INITDB_ROOT_PASSWORD:-}" ]; then
        shouldPerformInitdb='true'

        for path in "/data/db/WiredTiger" "/data/db/journal" "/data/db/local.0" "/data/db/storage.bson"; do
            if [ -e "$path" ]; then
                shouldPerformInitdb=
                break
            fi
        done
    fi

    if [ -n "$shouldPerformInitdb" ]; then
        echo "Initializing new database..."

        pidfile="/tmp/docker-temp-mongod.pid"

        mongod --fork --logpath /proc/self/fd/1 --bind_ip 127.0.0.1 --pidfilepath "$pidfile"

        tries=30
        while ! /usr/local/bin/mongo-init --ping > /dev/null 2>&1; do
            (( tries-- ))
            if [ "$tries" -le 0 ]; then
                echo >&2 "error: mongod failed to start"
                exit 1
            fi
            sleep 1
        done

        /usr/local/bin/mongo-init "$MONGO_INITDB_ROOT_USERNAME" "$MONGO_INITDB_ROOT_PASSWORD"

        mongod --shutdown --pidfilepath "$pidfile"

        sleep 2
        echo "Database initialized successfully."
    fi

    if [[ "$*" != *"--bind_ip"* ]]; then
        set -- "$@" --bind_ip_all
    fi
fi

unset MONGO_INITDB_ROOT_USERNAME MONGO_INITDB_ROOT_PASSWORD

exec "$@"