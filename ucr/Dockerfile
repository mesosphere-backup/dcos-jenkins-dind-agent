FROM ubuntu:18.10
ENV DOCKER_VERSION=18.09.7
ENV DOCKER_URL https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz
ENV DOCKER_SHA 9af9440de24163de4b1bcb4ef459e7ed1ab2c8d9

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
# links to commit hashes are listed inside posted Dockerfiles https://hub.docker.com/r/library/docker/
# NOTE: must match engine version that is directly pulled from Alpine's Dockerfile
# - go to https://hub.docker.com/r/library/docker/
# - click on the matching alpine version tag (eg, 17.12.0-dind)
# - pull the DIND_COMMIT has from the Dockerfile that opens, for 17.12.0-dind it will be:
#   https://github.com/docker-library/docker/blob/de9fda490429cf83734ef78b58f0ae9cfed1b087/17.12/dind/Dockerfile
ENV DIND_COMMIT 3b5fac462d21ca164b3778647420016315289034

RUN apt-get update -y       \
    && apt-get upgrade -y   \
    && apt-get install -y   \
       apt-transport-https  \
       build-essential      \
       bzip2                \
       ca-certificates      \
       curl                 \
       git                  \
       iptables             \
       jq                   \
       lvm2                 \
       lxc                  \
       openjdk-8-jdk-headless  \
       unzip                \
       zip


# Download the official build of Docker and install it to /usr/local/bin
RUN curl -fsSL $DOCKER_URL -o /tmp/docker.tgz && \
  tar xzf /tmp/docker.tgz -C /usr/local/ && \
  rm /tmp/docker.tgz && \
  chmod +x /usr/local/docker/docker /usr/local/docker/dockerd && \
  ln -s /usr/local/docker/docker /usr/local/bin/docker && \
  ln -s /usr/local/docker/dockerd /usr/local/bin/dockerd

COPY ./wrapper.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/wrapper.sh

VOLUME /var/lib/docker
ENTRYPOINT []
CMD []