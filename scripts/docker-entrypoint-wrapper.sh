#!/bin/sh
set -e

# Update CA certificates
update-ca-certificates

# Start API key initialization in background if GRIST_API_KEY is set
if [ -n "$GRIST_API_KEY" ]; then
    echo "Starting API key initialization in background..."
    /grist/scripts/init-api-key.sh &
fi

# Execute the original Grist entrypoint with all arguments
# Using exec ensures proper signal handling and makes the Grist process PID 1
exec ./sandbox/docker_entrypoint.sh "$@"
