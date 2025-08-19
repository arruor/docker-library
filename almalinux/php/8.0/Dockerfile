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

RUN dnf -y --setopt=install_weak_deps=False --setopt=tsflags=nodocs install \
    php80ti php80ti-bcmath php80ti-cli php80ti-common php80ti-dba php80ti-fpm php80ti-gd php80ti-gmp php80ti-imap php80ti-intl \
    php80ti-ldap php80ti-mbstring php80ti-mysqlnd php80ti-odbc php80ti-opcache php80ti-openssl php80ti-pdo \
    php80ti-pdo-dblib php80ti-process php80ti-soap php80ti-sodium php80ti-tidy php80ti-xml php80ti-zip php80ti-ssh2 \
    php80ti-igbinary php80ti-msgpack php80ti-redis php80ti-xdebug curl bash MariaDB-client unzip tar fcgi && \
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
    ln -s /usr/php80/usr/bin/php /bin/php

COPY www.ini /usr/php80/etc/php.d/99-www.ini
COPY www.pool.conf /usr/php80/etc/php-fpm.d/www.conf
COPY php-fpm.conf /usr/php80/etc/php-fpm.conf

HEALTHCHECK --interval=30s --timeout=3s CMD SCRIPT_NAME=/ping SCRIPT_FILENAME=/ping REQUEST_METHOD=GET /bin/cgi-fcgi -bind -connect 127.0.0.1:9001 || exit 1

USER www-data

CMD ["/usr/php80/usr/sbin/php-fpm", "-F", "--fpm-config", "/usr/php80/etc/php-fpm.conf"]
