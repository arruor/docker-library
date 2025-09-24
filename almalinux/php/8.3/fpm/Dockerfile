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
    org.opencontainers.image.title="almalinux-php-8.3" \
    org.opencontainers.image.description="PHP 8.3 image for 20i" \
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
    php83ti php83ti-bcmath php83ti-cli php83ti-common php83ti-dba php83ti-fpm php83ti-gd php83ti-gmp php83ti-imap php83ti-intl \
    php83ti-ldap php83ti-mbstring php83ti-mysqlnd php83ti-odbc php83ti-opcache php83ti-openssl php83ti-pdo \
    php83ti-pdo-dblib php83ti-process php83ti-soap php83ti-sodium php83ti-tidy php83ti-xml php83ti-zip php83ti-ssh2 \
    php83ti-igbinary php83ti-msgpack php83ti-redis php83ti-xdebug curl bash MariaDB-client unzip tar fcgi git && \
    curl --insecure https://getcomposer.org/composer.phar -o /usr/bin/composer && \
    chmod +x /usr/bin/composer && \
    dnf clean all && rm -rf /tmp/* /var/tmp/* /var/cache/dnf/* && \
    rm -f /etc/php-fpm.d/www.conf && \
    groupadd -g $DEFAULT_GID -r $DEFAULT_GROUP && \
    adduser -r -g $DEFAULT_GROUP -u $DEFAULT_UID -d /home/www-data -m $DEFAULT_USER && \
    mkdir -p /var/lib/php/{session,opcache,wsdlcache} /var/log/php-fpm /run/php-fpm && \
    chown -R $DEFAULT_USER:$DEFAULT_GROUP /var/lib/php /var/log/php-fpm && \
    touch /var/log/php-fpm/www-error.log /var/log/php-fpm/error.log && \
    chown $DEFAULT_USER:$DEFAULT_GROUP /var/log/php-fpm/www-error.log /var/log/php-fpm/error.log /run/php-fpm && \
    ln -s /usr/php83/usr/bin/php /bin/php

COPY www.ini /usr/php83/etc/php.d/99-www.ini
COPY www.pool.conf /usr/php83/etc/php-fpm.d/www.conf
COPY php-fpm.conf /usr/php83/etc/php-fpm.conf

HEALTHCHECK --interval=30s --timeout=3s CMD SCRIPT_NAME=/ping SCRIPT_FILENAME=/ping REQUEST_METHOD=GET /bin/cgi-fcgi -bind -connect 127.0.0.1:9001 || exit 1

USER www-data

CMD ["/usr/php83/usr/sbin/php-fpm", "-F", "--fpm-config", "/usr/php83/etc/php-fpm.conf"]
