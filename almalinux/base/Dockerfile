FROM almalinux:latest

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
ARG VCS_URL="https://github.com/arruor/docker-library/almalinux/base"
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

# Add the environment for traceability
ENV BUILD_DATE=${BUILD_DATE} \
    VCS_REF=${VCS_REF} \
    VERSION=${VERSION}

RUN dnf -y install 'dnf-command(config-manager)' && \
    sed -i -e '/enabled/d' -e 's/^\[\(.*\)\]/[\1]\nenabled=0/' /etc/yum.repos.d/*.repo && \
    dnf config-manager --add-repo http://yum.internal.20i.com/yum/al9-local.repo && \
    dnf config-manager --add-repo http://yum.internal.20i.com/yum/al9-local-20i-docker.repo && \
    dnf clean all && \
    dnf -y update && \
    dnf -y install curl vim mtr net-tools tcptraceroute procps tzdata --alowerasing && \
    dnf clean all -v && \
    ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime && \
    echo "Europe/London" > /etc/timezone

COPY 20i-ca.crt /etc/pki/ca-trust/source/anchors/20i-ca.crt

RUN update-ca-trust
