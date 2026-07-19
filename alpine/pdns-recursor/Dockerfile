ARG BASE_IMAGE=docker.io/arruor/alpine:3.21.2
FROM ${BASE_IMAGE}

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
ARG VCS_URL
ARG VENDOR="20i Ltd"
ARG BASE_IMAGE

LABEL maintainer="Dimitar Nikov <dimitar@nikov.net>" \
    org.opencontainers.image.base.name="${BASE_IMAGE}" \
    com.powerdns.pdns-recursor.version="5.1.3-r0" \
    org.opencontainers.image.title="pdns-recursor-alpine" \
    org.opencontainers.image.description="PowerDNS Recursor image running on Alpine Linux" \
    org.opencontainers.image.authors="Dimitar Nikov <dimitar@nikov.net>" \
    org.opencontainers.image.vendor="${VENDOR}" \
    org.opencontainers.image.version="${VERSION}" \
    org.opencontainers.image.url="${VCS_URL}" \
    org.opencontainers.image.source="${VCS_URL}" \
    org.opencontainers.image.revision="${VCS_REF}" \
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.licenses="Apache-2.0"

RUN set -eux; \
    apk upgrade --no-cache; \
    apk add --no-cache bind-tools dcron pdns-recursor; \
    mkdir -p /var/run/pdns-recursor; \
    touch /var/log/crond.log; \
    rm -rf /var/cache/apk/* /tmp/*

COPY recursor.conf /etc/pdns/recursor.conf

COPY --chmod=0755 docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

EXPOSE 53/udp 53/tcp 8080/tcp

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
