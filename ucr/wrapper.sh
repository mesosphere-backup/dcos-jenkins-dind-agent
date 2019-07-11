#!/bin/bash

# Docker must run with a few special arguments.
DOCKER_ARGS=(
    --bridge=none
    --iptables=false
    --ip-masq=false
)
# For now, we enforce Docker storage driver to overlay2.
DOCKER_ARGS+=(
    --storage-driver=overlay2
    --storage-opt="overlay2.override_kernel_check=true"
)
# Make Docker observe the configured limit on the amount of container logs to keep.
DOCKER_ARGS+=(
    --log-driver=json-file
    --log-opt=max-size=5
    --log-opt=max-file=1
)

# docker requires write access to /sys/ and /proc/sys
mount -o remount,rw /sys/
mount -o remount,rw /proc/sys

printf "Starting docker...\n"

# Since the persistent volume "var" may have been previously used by the same
# task, we need to make sure it's empty before proceeding.
rm -rf var/*

# make /var/lib/docker point to the volume configured by the operator
mkdir -p /var/lib/docker
mount --bind var /var/lib/docker

dockerd &

DOCKERD_PID=$!

while(! docker info > /dev/null 2>&1); do
    echo "==> Waiting for the Docker daemon to come online..."
    sleep 1
done
echo "==> Docker Daemon is up and running!"

/bin/sh -c "$@"

