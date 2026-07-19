ARG BASE_IMAGE=docker.io/library/alpine:3.21
FROM ${BASE_IMAGE}

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
ARG VCS_URL
ARG VENDOR="20i Ltd"
ARG BASE_IMAGE

LABEL maintainer="Dimitar Nikov <dimitar@nikov.net>" \
    org.opencontainers.image.base.name="${BASE_IMAGE}" \
    org.opencontainers.image.title="base-image-alpine" \
    org.opencontainers.image.description="Base Image for Alpine Linux" \
    org.opencontainers.image.authors="Dimitar Nikov <dimitar@nikov.net>" \
    org.opencontainers.image.vendor="${VENDOR}" \
    org.opencontainers.image.version="${VERSION}" \
    org.opencontainers.image.url="${VCS_URL}" \
    org.opencontainers.image.source="${VCS_URL}" \
    org.opencontainers.image.revision="${VCS_REF}" \
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.licenses="Apache-2.0"

COPY 20i-ca.crt /usr/local/share/ca-certificates/20i-ca.crt
COPY home-llc-ca.crt /usr/local/share/ca-certificates/home-llc-ca.crt

RUN set -eux; \
    wget -O /etc/apk/keys/mind-65cfafea.rsa.pub https://alpine.nikov.net/mind-65cfafea.rsa.pub; \
    echo "https://alpine.nikov.net/v3.21/main" >> /etc/apk/repositories; \
    apk upgrade --no-cache; \
    apk add --no-cache bash ca-certificates; \
    update-ca-certificates; \
    rm -rf /var/cache/apk/* /tmp/*
