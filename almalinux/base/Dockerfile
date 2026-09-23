ARG BASE_IMAGE=docker.io/library/almalinux:9
FROM ${BASE_IMAGE}

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
ARG VCS_URL
ARG VENDOR="20i Ltd"
ARG TARGETARCH
ARG BASE_IMAGE

LABEL maintainer="Dimitar Nikov <dimitar@nikov.net>" \
    org.opencontainers.image.base.name="${BASE_IMAGE}" \
    org.opencontainers.image.title="almalinux-base" \
    org.opencontainers.image.description="Base Image for AlmaLinux with 20i tooling and CA certificates" \
    org.opencontainers.image.authors="Dimitar Nikov <dimitar@nikov.net>" \
    org.opencontainers.image.vendor="${VENDOR}" \
    org.opencontainers.image.version="${VERSION}" \
    org.opencontainers.image.url="${VCS_URL}" \
    org.opencontainers.image.source="${VCS_URL}" \
    org.opencontainers.image.revision="${VCS_REF}" \
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.licenses="Apache-2.0"

ENV TZ=Europe/London

COPY 20i-ca.crt /etc/pki/ca-trust/source/anchors/20i-ca.crt

RUN --mount=type=cache,target=/var/cache/dnf,id=dnf-cache-${TARGETARCH},sharing=locked \
    set -eux; \
    dnf -y install dnf-plugins-core python3-dnf-plugins-core python3-dbus python3-systemd; \
    sed -i -e '/enabled/d' -e 's/^\[\(.*\)\]/[\1]\nenabled=0/' /etc/yum.repos.d/*.repo; \
    dnf config-manager --add-repo http://yum.lhr.stackcp.net/yum/al9-local.repo; \
    dnf config-manager --add-repo http://yum.lhr.stackcp.net/yum/al9-local-20i-docker.repo; \
    dnf -y --setopt=install_weak_deps=False --setopt=tsflags=nodocs --allowerasing install \
        ca-certificates bash curl mtr net-tools procps-ng python3-dbus python3-systemd \
        tcptraceroute tzdata vim-minimal cronie rsyslog rsyslog-logrotate; \
    dnf -y update; \
    dnf -y remove dnf-plugins-core python3-dnf-plugins-core; \
    ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime; \
    echo "${TZ}" > /etc/timezone; \
    echo 'precedence ::ffff:0:0/96  100' >> /etc/gai.conf; \
    update-ca-trust; \
    dnf clean all; \
    rm -rf /tmp/* /var/tmp/*
