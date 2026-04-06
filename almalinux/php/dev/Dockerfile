FROM hub.lhr.stackcp.net/20i/php-8.3-cli:latest

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
ARG VCS_URL
ARG VENDOR="20i Ltd"
ARG TARGETARCH

LABEL maintainer="Dimitar Nikov <dimitar@nikov.net>" \
    org.opencontainers.image.base.name="hub.lhr.stackcp.net/20i/php-8.3-cli:latest" \
    org.opencontainers.image.title="almalinux-php-dev" \
    org.opencontainers.image.description="PHP Dev image for 20i" \
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
    dnf -y --setopt=install_weak_deps=False --setopt=tsflags=nodocs install \
        bash curl gettext git MariaDB-client nodejs patch sudo tar unzip; \
    dnf clean all; \
    rm -rf /var/cache/dnf /tmp/* /var/tmp/*

COPY --from=composer/composer:2-bin /composer /usr/local/bin/composer

RUN set -eux; \
    usermod -aG wheel www-data; \
    echo "%wheel ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/wheel; \
    chmod 0440 /etc/sudoers.d/wheel

USER www-data

ENTRYPOINT ["tail", "-f", "/dev/null"]
