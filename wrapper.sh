#!/bin/bash
set -e

echo "==> Launching the Docker daemon..."
dind dockerd --storage-driver=overlay $DOCKER_EXTRA_OPTS 2>1 &

while(! docker info > /dev/null 2>&1); do
    echo "==> Waiting for the Docker daemon to come online..."
    sleep 1
done
echo "==> Docker Daemon is up and running!"
docker version
echo "==> Launcher complete"
echo ""

/bin/sh -c "$@"
