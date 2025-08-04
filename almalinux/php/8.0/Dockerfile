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

LABEL maintainer="Dimitar 'Arruor' Nikov <dimitar@nikov.net>" \
    org.opencontainers.image.base.name="hub.lhr.stackcp.net/20i/alma" \
    org.opencontainers.image.title="almalinux-php-8.0" \
    org.opencontainers.image.description="PHP 8.0 image for 20i" \
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

RUN dnf -y --setopt=install_weak_deps=False --setopt=tsflags=nodocs install php php-fpm php-bcmath php-common php-dba \
    php-gd php-gmp php-intl php-ldap php-mbstring php-mysqlnd php-odbc php-process php-pdo php-pdo_dblib \
    php-pear php-soap php-sodium php-tidy php-xml php-pecl-zip php-pecl-event \
    php-pecl-igbinary php-pecl-imagick php-pecl-mailparse php-pecl-msgpack php-pecl-redis5 \
    php-pecl-ssh2 php-pecl-xdebug3 php-pecl-yaml php-zstd \
    curl bash mysql-client && \
    curl --insecure https://getcomposer.org/composer.phar -o /usr/bin/composer && \
    chmod +x /usr/bin/composer && \
    dnf clean all && rm -rf /tmp/* /var/tmp/* /var/cache/dnf/* && \
    rm -f /etc/php-fpm.d/www.conf && \
    groupadd -g $DEFAULT_GID -r $DEFAULT_GROUP && \
    adduser -r -g $DEFAULT_GROUP -u $DEFAULT_UID $DEFAULT_USER && \
    mkdir -p /var/lib/php/{session,opcache,wsdlcache} /var/log/php-fpm /run/php-fpm && \
    chown -R $DEFAULT_USER:$DEFAULT_GROUP /var/lib/php /var/log/php-fpm && \
    touch /var/log/php-fpm/www-error.log /var/log/php-fpm/error.log && \
    chown $DEFAULT_USER:$DEFAULT_GROUP /var/log/php-fpm/www-error.log /var/log/php-fpm/error.log /run/php-fpm

COPY www.ini /etc/php.d/99-www.ini
COPY www.pool.conf /etc/php-fpm.d/www.conf

HEALTHCHECK --interval=30s --timeout=3s CMD curl -fsS http://localhost:9001/ping || exit 1

USER www-data

CMD ["usr/sbin/php-fpm", "-F", "--fpm-config", "etc/php-fpm.conf"]