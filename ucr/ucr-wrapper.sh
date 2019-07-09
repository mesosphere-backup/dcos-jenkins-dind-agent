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
    --log-opt=max-size={{KUBERNETES_CONTAINER_LOGS_MAX_SIZE}}m
    --log-opt=max-file=1
)



printf "Starting docker...\n"

# Since the persistent volume "var" may have been previously used by the same
# task, we need to make sure it's empty before proceeding.
rm -rf var/*

# make /var/lib/docker point to the volume configured by the operator
mkdir -p /var/lib/docker
mount --bind var /var/lib/docker

dockerd ${DOCKER_ARGS[@]} &