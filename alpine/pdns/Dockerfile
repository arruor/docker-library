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
    com.powerdns.version="4.9.2-r0" \
    org.opencontainers.image.title="arruor/pdns" \
    org.opencontainers.image.description="PowerDNS image running on Alpine Linux" \
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
    apk add --no-cache bash dcron pdns pdns-backend-mysql pdns-backend-sqlite3 sqlite; \
    mkdir -p /usr/local/share/pdns /var/lib/powerdns; \
    touch /var/log/crond.log; \
    chmod -R 0755 /usr/local/bin /var/lib/powerdns; \
    chown -R pdns:pdns /var/lib/powerdns; \
    rm -rf /var/cache/apk/* /tmp/*

COPY --chmod=0755 docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY schema.sqlite3.sql /usr/local/share/pdns
COPY schema.mysql.sql /usr/local/share/pdns
COPY pdns.sample.conf /usr/local/share/pdns

EXPOSE 53/udp 53/tcp 8080/tcp

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
