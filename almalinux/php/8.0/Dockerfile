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
    org.opencontainers.image.title="almalinux-php-8.0" \
    org.opencontainers.image.description="PHP 8.0 image for 20i" \
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
        MariaDB-client fcgi php80ti php80ti-bcmath php80ti-cli php80ti-common php80ti-dba \
        php80ti-fpm php80ti-gd php80ti-gmp php80ti-igbinary php80ti-imap php80ti-intl php80ti-ldap \
        php80ti-mbstring php80ti-msgpack php80ti-mysqlnd php80ti-odbc php80ti-opcache php80ti-openssl \
        php80ti-pdo php80ti-pdo-dblib php80ti-process php80ti-redis php80ti-soap php80ti-sodium \
        php80ti-ssh2 php80ti-tidy php80ti-xml php80ti-xdebug php80ti-zip tar unzip; \
    rm -f /etc/php-fpm.d/www.conf; \
    groupadd -g "${DEFAULT_GID}" -r "${DEFAULT_GROUP}" || true; \
    id -u "${DEFAULT_USER}" >/dev/null 2>&1 || adduser -r -g "${DEFAULT_GROUP}" -u "${DEFAULT_UID}" -d /home/www-data -m "${DEFAULT_USER}"; \
    mkdir -p /var/lib/php/session /var/lib/php/opcache /var/lib/php/wsdlcache /var/log/php-fpm /run/php-fpm; \
    chown -R "${DEFAULT_USER}:${DEFAULT_GROUP}" /var/lib/php /var/log/php-fpm /run/php-fpm; \
    touch /var/log/php-fpm/www-error.log /var/log/php-fpm/error.log; \
    chown "${DEFAULT_USER}:${DEFAULT_GROUP}" /var/log/php-fpm/www-error.log /var/log/php-fpm/error.log; \
    ln -snf /usr/php80/usr/bin/php /usr/local/bin/php; \
    dnf clean all; \
    rm -rf /tmp/* /var/tmp/*

COPY --from=composer/composer:2-bin /composer /usr/local/bin/composer
COPY www.ini /usr/php80/etc/php.d/99-www.ini
COPY www.pool.conf /usr/php80/etc/php-fpm.d/www.conf
COPY php-fpm.conf /usr/php80/etc/php-fpm.conf

HEALTHCHECK --interval=30s --timeout=3s CMD SCRIPT_NAME=/ping SCRIPT_FILENAME=/ping REQUEST_METHOD=GET /bin/cgi-fcgi -bind -connect 127.0.0.1:9001 || exit 1

USER www-data

CMD ["/usr/php80/usr/sbin/php-fpm", "-F", "--fpm-config", "/usr/php80/etc/php-fpm.conf"]
