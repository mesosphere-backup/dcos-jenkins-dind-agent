FROM docker:1.11.2-dind

MAINTAINER Mesosphere Support <support+jenkins-dind@mesosphere.com>

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV ALPINE_EDGE_COMMUNITY_REPO=http://dl-cdn.alpinelinux.org/alpine/edge/community \
    ALPINE_GLIBC_BASE_URL=https://github.com/andyshinn/alpine-pkg-glibc/releases/download/unreleased \
    ALPINE_GLIBC_PACKAGE=glibc-2.23-r1.apk \
    ALPINE_GLIBC_BIN_PACKAGE=glibc-bin-2.23-r1.apk \
    ALPINE_GLIBC_I18N_PACKAGE=glibc-i18n-2.23-r1.apk \
    ANDY_SHINN_RSA_PUB_URL=https://raw.githubusercontent.com/andyshinn/alpine-pkg-glibc/master/andyshinn.rsa.pub \
    JAVA_HOME=/usr/lib/jvm/default-jvm \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    SSH_KNOWN_HOSTS=github.com

ENV PATH=${PATH}:${JAVA_HOME}/bin

# Please keep each package list in alphabetical order
RUN apk --update add \
    bash \
    bzip2 \
    ca-certificates \
    git \
    glib \
    jq \
    less \
    libsm \
    libstdc++ \
    make \
    openjdk8 \
    openssh-client \
    perl \
    py-pip \
    python \
    python3 \
    tar \
    unzip \
    && cd /tmp \
    && apk add --update --repository ${ALPINE_EDGE_COMMUNITY_REPO} tini \
    && wget -q -O /etc/apk/keys/andyshinn.rsa.pub "${ANDY_SHINN_RSA_PUB_URL}" \
    && wget -q "${ALPINE_GLIBC_BASE_URL}/${ALPINE_GLIBC_PACKAGE}" \
               "${ALPINE_GLIBC_BASE_URL}/${ALPINE_GLIBC_BIN_PACKAGE}" \
               "${ALPINE_GLIBC_BASE_URL}/${ALPINE_GLIBC_I18N_PACKAGE}" \
    && apk add ${ALPINE_GLIBC_PACKAGE} ${ALPINE_GLIBC_BIN_PACKAGE} ${ALPINE_GLIBC_I18N_PACKAGE} \
    && cd \
    && rm -rf /tmp/* /var/cache/apk/* \
    && /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8 \
    && echo 'export PATH=$PATH:${JAVA_HOME}/bin' >> /etc/profile.d/java.sh \
    && ssh-keyscan $SSH_KNOWN_HOSTS | tee /etc/ssh/ssh_known_hosts \
    && echo 'Done'

COPY wrapper.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wrapper.sh

ENTRYPOINT []
CMD []
