FROM hub.lhr.stackcp.net/20i/alma:latest

ARG DEFAULT_UID=1000
ARG DEFAULT_GID=1000
ARG DEFAULT_USER=www-data
ARG DEFAULT_GROUP=www-data
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
ARG VCS_URL
ARG VENDOR="20i Ltd"
ARG TARGETARCH

LABEL maintainer="Dimitar Nikov <dimitar@nikov.net>" \
    org.opencontainers.image.base.name="hub.lhr.stackcp.net/20i/alma:latest" \
    org.opencontainers.image.title="almalinux-php-8.3-cli" \
    org.opencontainers.image.description="PHP 8.3 CLI image for 20i" \
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
        php83ti php83ti-bcmath php83ti-cli php83ti-common php83ti-dba php83ti-gd php83ti-gmp \
        php83ti-igbinary php83ti-imap php83ti-intl php83ti-ldap php83ti-mbstring php83ti-msgpack \
        php83ti-mysqlnd php83ti-odbc php83ti-opcache php83ti-openssl php83ti-pdo php83ti-pdo-dblib \
        php83ti-process php83ti-redis php83ti-soap php83ti-sodium php83ti-ssh2 php83ti-tidy \
        php83ti-xml php83ti-xdebug php83ti-zip; \
    groupadd -g "${DEFAULT_GID}" -r "${DEFAULT_GROUP}" || true; \
    id -u "${DEFAULT_USER}" >/dev/null 2>&1 || adduser -r -g "${DEFAULT_GROUP}" -u "${DEFAULT_UID}" -d /home/www-data -m "${DEFAULT_USER}"; \
    mkdir -p /var/lib/php/session /var/lib/php/opcache /var/lib/php/wsdlcache /var/log/php-fpm /run/php-fpm; \
    chown -R "${DEFAULT_USER}:${DEFAULT_GROUP}" /var/lib/php /var/log/php-fpm /run/php-fpm; \
    touch /var/log/php-fpm/www-error.log /var/log/php-fpm/error.log; \
    chown "${DEFAULT_USER}:${DEFAULT_GROUP}" /var/log/php-fpm/www-error.log /var/log/php-fpm/error.log; \
    ln -snf /usr/php83/usr/bin/php /usr/local/bin/php; \
    dnf clean all; \
    rm -rf /tmp/* /var/tmp/*

COPY www.ini /usr/php83/etc/php.d/99-www.ini
