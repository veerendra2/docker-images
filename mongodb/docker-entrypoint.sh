#!/bin/bash
set -e

# The default command will be 'mongod', which is passed as $1.
# Check if the first argument is 'mongod' (or if no command is specified, which defaults to 'mongod' via CMD).
if [ "$1" = 'mongod' ]; then
    # Run mongod in the background temporarily for setup
    # Use 'gosu' to run the daemon as the 'mongodb' user
    gosu mongodb mongod --fork --logpath /dev/null

    # Wait for mongod to start
    sleep 5

    # Check if root username and password variables are set
    if [ -n "$MONGO_INITDB_ROOT_USERNAME" ] && [ -n "$MONGO_INITDB_ROOT_PASSWORD" ]; then
        echo "Creating root user..."

        # Connect to MongoDB and execute the user creation command
        mongosh --eval "db.getSiblingDB('admin').createUser({
            user: '$MONGO_INITDB_ROOT_USERNAME',
            pwd: '$MONGO_INITDB_ROOT_PASSWORD',
            roles: [{ role: 'root', db: 'admin' }]
        })"

        echo "Root user created."
    fi

    # Stop the temporary mongod instance
    mongosh --eval "db.getSiblingDB('admin').shutdownServer()"

    # Wait for shutdown
    sleep 3

    echo "Starting final mongod instance..."

    # Execute the final mongod instance, passing all arguments provided to the script
    # This ensures it runs as the 'mongodb' user and accepts any extra arguments
    exec gosu mongodb "$@"
fi

# If the command is not 'mongod' (e.g., 'bash'), just execute it directly
exec "$@"