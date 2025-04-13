FROM almalinux:latest

ARG BUILD_DATE
ARG VCS_REF
ARG VER

LABEL maintainer="Dimitar 'Arruor' Nikov <dimitar@nikov.net>" \
    org.opencontainers.image.title="base-image-almalinux" \
    org.opencontainers.image.description="Base Image for Alma Linux" \
    org.opencontainers.image.authors="Dimitar 'Arruor' Nikov <dimitar@nikov.net>" \
    org.opencontainers.image.vendor="Dimitar 'Arruor' Nikov" \
    org.opencontainers.image.version="$VER" \
    org.opencontainers.image.url="https://hub.docker.com/r/arruor/almalinux" \
    org.opencontainers.image.source="https://github.com/arruor/docker-library/almalinux/base" \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.created=$BUILD_DATE

RUN dnf clean all && \
    dnf -y update && \
    dnf -y install vim mtr net-tools tcptraceroute procps && \
    dnf clean all -v && \
    ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime && \
    echo "Europe/London" > /etc/timezone

COPY 20i-ca.crt /etc/pki/ca-trust/source/anchors/20i-ca.crt

RUN update-ca-trust