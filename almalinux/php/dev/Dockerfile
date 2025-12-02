FROM hub.lhr.stackcp.net/20i/php-8.3-cli:latest

ARG DEFAULT_UID=1000
ARG DEFAULT_GID=1000
ARG DEFAULT_USER=www-data
ARG DEFAULT_GROUP=www-data
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
ARG VCS_URL
ARG VENDOR="20i Ltd"

LABEL maintainer="Dimitar 'Arruor' Nikov <dimitar@nikov.net>" \
    org.opencontainers.image.base.name="hub.lhr.stackcp.net/20i/alma" \
    org.opencontainers.image.title="almalinux-php-dev" \
    org.opencontainers.image.description="PHP Dev image for 20i" \
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

RUN dnf -y --setopt=install_weak_deps=False --setopt=tsflags=nodocs install \
    curl bash MariaDB-client unzip tar git patch gettext sudo && \
    dnf -y module install nodejs:22 && \
    curl --insecure https://getcomposer.org/composer.phar -o /usr/bin/composer && \
    chmod +x /usr/bin/composer && \
    usermod -aG wheel www-data && \
    echo "%wheel ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/wheel && \
    chmod 0440 /etc/sudoers.d/wheel && \
    dnf clean all && rm -rf /tmp/* /var/tmp/* /var/cache/dnf/*

USER www-data

ENTRYPOINT ["tail", "-f", "/dev/null"]
