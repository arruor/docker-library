FROM hub.lhr.stackcp.net/20i/alma:latest

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
ARG VCS_URL
ARG VENDOR="20i Ltd"
ARG TARGETARCH

LABEL maintainer="Dimitar Nikov <dimitar@nikov.net>" \
    org.opencontainers.image.base.name="hub.lhr.stackcp.net/20i/alma:latest" \
    org.opencontainers.image.title="almalinux-mariadb" \
    org.opencontainers.image.description="MariaDB image for 20i" \
    org.opencontainers.image.authors="Dimitar Nikov <dimitar@nikov.net>" \
    org.opencontainers.image.vendor="${VENDOR}" \
    org.opencontainers.image.version="${VERSION}" \
    org.opencontainers.image.url="${VCS_URL}" \
    org.opencontainers.image.source="${VCS_URL}" \
    org.opencontainers.image.revision="${VCS_REF}" \
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.licenses="Apache-2.0"

RUN --mount=type=cache,target=/var/cache/dnf,id=dnf-cache-${TARGETARCH},sharing=locked \
    set -eux; \
    dnf install -y --setopt=install_weak_deps=False --setopt=tsflags=nodocs --enablerepo=mariadb13 \
        MariaDB MariaDB-client MariaDB-server MariaDB-shared pwgen; \
    mkdir -p /docker-entrypoint-initdb.d /usr/local/bin/pre-exec.d /usr/local/bin/pre-init.d; \
    chmod -R 0755 /usr/local/bin; \
    dnf clean all; \
    rm -rf /tmp/* /var/tmp/* /usr/share/doc /usr/share/info /usr/share/man /usr/lib/locale/*

COPY startup.sh /usr/local/bin/startup.sh

RUN chmod 0755 /usr/local/bin/startup.sh

EXPOSE 3306

VOLUME ["/var/lib/mysql"]

ENTRYPOINT ["/usr/local/bin/startup.sh"]
