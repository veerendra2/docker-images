#!/usr/bin/env bash
set -Eeuo pipefail

# Helper to load secrets
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

# 1. Handle user/permissions (Official logic)
if [ "$1" = 'mongod' ] && [ "$(id -u)" = '0' ]; then
    find -L /data/db \! -user mongodb -exec chown mongodb '{}' +
    exec gosu mongodb "$BASH_SOURCE" "$@"
fi

if [ "$1" = 'mongod' ]; then
    file_env 'MONGO_INITDB_ROOT_USERNAME'
    file_env 'MONGO_INITDB_ROOT_PASSWORD'

    # 2. Check if we need to perform init
    # We look for storage.bson to see if the DB is already initialized
    if [ -n "${MONGO_INITDB_ROOT_USERNAME:-}" ] && [ ! -f "/data/db/storage.bson" ]; then
        echo "Creating MongoDB root user..."

        # Use a temp pidfile to track background process (Official style)
        pidfile="/tmp/docker-temp-mongod.pid"

        # Start background mongod
        # --bind_ip 127.0.0.1 is safer for init
        mongod --fork --logpath /proc/self/fd/1 --bind_ip 127.0.0.1 --pidfilepath "$pidfile"

        # 3. Wait for mongod to accept connections
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

        # 4. Run your tiny Go binary
        /usr/local/bin/mongo-init "$MONGO_INITDB_ROOT_USERNAME" "$MONGO_INITDB_ROOT_PASSWORD"

        # 5. Graceful Shutdown
        mongod --shutdown --pidfilepath "$pidfile"
        rm -f "$pidfile"

        echo "MongoDB init process complete."
    fi

    # Ensure we bind to all IPs for the final run if not specified
    if [[ "$*" != *"--bind_ip"* ]]; then
        set -- "$@" --bind_ip_all
    fi
fi

# Cleanup sensitive env vars before final exec
unset MONGO_INITDB_ROOT_USERNAME MONGO_INITDB_ROOT_PASSWORD

exec "$@"