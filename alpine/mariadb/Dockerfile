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
    mariadb-version="11.4.4-r1" \
    org.opencontainers.image.title="mariadb-alpine" \
    org.opencontainers.image.description="MariaDB image running on Alpine Linux" \
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
    apk add --no-cache mariadb mariadb-client mariadb-server-utils pwgen; \
    mkdir -p /docker-entrypoint-initdb.d /usr/local/bin/pre-exec.d /usr/local/bin/pre-init.d; \
    chmod -R 0755 /usr/local/bin; \
    rm -rf /var/cache/apk/* /tmp/*

COPY --chmod=0755 startup.sh /usr/local/bin/startup.sh

EXPOSE 3306

VOLUME ["/var/lib/mysql"]

ENTRYPOINT ["/usr/local/bin/startup.sh"]
