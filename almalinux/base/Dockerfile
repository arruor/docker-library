FROM almalinux:latest

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
ARG VCS_URL
ARG VENDOR="20i Ltd"

LABEL maintainer="Dimitar 'Arruor' Nikov <dimitar@nikov.net>" \
    org.opencontainers.image.title="almalinux-base" \
    org.opencontainers.image.description="Base Image for AlmaLinux with 20i tooling and CA" \
    org.opencontainers.image.authors="Dimitar 'Arruor' Nikov <dimitar@nikov.net>" \
    org.opencontainers.image.vendor="${VENDOR}" \
    org.opencontainers.image.version="${VERSION}" \
    org.opencontainers.image.url="${VCS_URL}" \
    org.opencontainers.image.source="${VCS_URL}" \
    org.opencontainers.image.revision="${VCS_REF}" \
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.licenses="Apache 2.0"

ENV BUILD_DATE=${BUILD_DATE} \
    VCS_REF=${VCS_REF} \
    VERSION=${VERSION} \
    TZ=Europe/London

COPY 20i-ca.crt /etc/pki/ca-trust/source/anchors/20i-ca.crt

RUN --mount=type=cache,target=/var/cache/dnf \
    dnf -y install dnf-plugins-core && \
    # Disable all default repos
    sed -i -e '/enabled/d' -e 's/^\[\(.*\)\]/[\1]\nenabled=0/' /etc/yum.repos.d/*.repo && \
    # Add 20i internal repos
    dnf config-manager --add-repo http://yum.internal.20i.com/yum/al9-local.repo && \
    dnf config-manager --add-repo http://yum.internal.20i.com/yum/al9-local-20i-docker.repo && \
    # Base tooling install
    dnf -y --setopt=install_weak_deps=False install \
        curl vim-minimal mtr net-tools tcptraceroute procps-ng tzdata ca-certificates \
        --nodocs --allowerasing && \
    ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime && echo "${TZ}" > /etc/timezone && \
    # Trust internal CA
    update-ca-trust && \
    # Cleanup
    dnf clean all && rm -rf /var/cache/dnf /tmp/* /var/tmp/*
