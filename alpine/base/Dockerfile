FROM docker.io/alpine:3.20.1

ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="Dimitar 'Arruor' Nikov <dimitar@nikov.name>" \
    architecture="amd64/x86_64" \
    alpine-version="3.20.1" \
    build="21-Jul-2024" \
    org.opencontainers.image.title="base-image-alpine" \
    org.opencontainers.image.description="Base Image for Alpine Linux" \
    org.opencontainers.image.authors="Dimitar 'Arruor' Nikov <dimitar@nikov.name>" \
    org.opencontainers.image.vendor="Dimitar 'Arruor' Nikov" \
    org.opencontainers.image.version="3.20.1" \
    org.opencontainers.image.url="https://hub.docker.com/r/arruor/alpine" \
    org.opencontainers.image.source="https://github.com/arruor/docker-library/alpine/base" \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.created=$BUILD_DATE

RUN apk --no-cache update && apk --no-cache upgrade && sync && \
    apk add --no-cache ca-certificates bash && \
    rm -f /var/cache/apk/*

COPY 20i-ca.crt /usr/local/share/ca-certificates/20i-ca.crt
COPY home-llc-ca.crt /usr/local/share/ca-certificates/home-llc-ca.crt

RUN /usr/sbin/update-ca-certificates
