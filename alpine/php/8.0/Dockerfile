FROM arruor/alpine:latest

ARG DEFAULT_UID=1000
ARG DEFAULT_GID=1000
ARG DEFAULT_USER=www-data
ARG DEFAULT_GROUP=www-data
ARG BUILD_DATE
ARG VCS_REF
ARG VER

ENV TERM=xterm
ENV container=docker

LABEL maintainer="Dimitar 'Arruor' Nikov <dimitar@nikov.net>"
LABEL architecture="amd64/x86_64"
LABEL php-version="8.0.30"
LABEL alpine-version=$VER
LABEL build=$BUILD_DATE
LABEL org.opencontainers.image.title="php-8.0-alpinr"
LABEL org.opencontainers.image.description="Customised PHP 8.0 image running on Alpine Linux"
LABEL org.opencontainers.image.authors="Dimitar 'Arruor' Nikov <dimitar@nikov.net>"
LABEL org.opencontainers.image.vendor="Dimitar 'Arruor' Nikov"
LABEL org.opencontainers.image.version="v8.0.30"
LABEL org.opencontainers.image.url="https://hub.docker.com/r/arruor/php-8.0"
LABEL org.opencontainers.image.source="https://github.com/arruor/docker-library/php/8.0"
LABEL org.opencontainers.image.revision=$VCS_REF
LABEL org.opencontainers.image.created=$BUILD_DATE

RUN apk --no-cache update && \
    apk --no-cache upgrade && \
    sync && \
    apk add --no-cache --update php8 php8-fpm php8-bcmath php8-bz2 php8-calendar php8-common \
    php8-ctype php8-curl php8-dba php8-dom php8-exif php8-ffi php8-fileinfo php8-ftp \
    php8-gd php8-gettext php8-gmp php8-iconv php8-intl php8-ldap php8-mbstring php8-mysqli \
    php8-mysqlnd php8-odbc php8-openssl php8-pcntl php8-pdo php8-pdo_dblib php8-pdo_mysql \
    php8-pdo_odbc php8-pdo_sqlite php8-pear php8-phar php8-posix php8-session php8-shmop \
    php8-simplexml php8-soap php8-sockets php8-sodium php8-sqlite3 php8-sysvmsg php8-sysvsem \
    php8-sysvshm php8-tidy php8-tokenizer php8-xml php8-xmlreader php8-xmlwriter php8-xsl \
    php8-zip php8-brotli php8-pecl-event php8-pecl-igbinary php8-pecl-imagick \
    php8-pecl-mailparse php8-pecl-msgpack php8-pecl-redis php8-pecl-ssh2 php8-pecl-xdebug \
    php8-pecl-xhprof php8-pecl-xhprof-assets php8-pecl-yaml php8-pecl-zstd \
    curl bash mysql-client && \
    curl --insecure https://getcomposer.org/composer.phar -o /usr/bin/composer && \
    chmod +x /usr/bin/composer && \
    rm -rf /var/cache/apk/* /tmp/* && \
    rm -f /etc/php8/php-fpm.d/www.conf && \
    adduser -S -D -G $DEFAULT_GROUP -u $DEFAULT_UID $DEFAULT_USER && \
    mkdir -p /var/lib/php8/{session,opcache,wsdlcache} /var/log/php8 && \
    chown -R $DEFAULT_USER:$DEFAULT_GROUP /var/lib/php8 /var/log/php8 && \
    touch /var/log/php8/www-error.log /var/log/php8/error.log && \
    chown $DEFAULT_USER:$DEFAULT_GROUP /var/log/php8/www-error.log /var/log/php8/error.log

ADD www.ini /etc/php8/conf.d/99-www.ini
ADD www.ini /etc/php8/cli/conf.d/99-www.ini
ADD www.pool.conf /etc/php8/php-fpm.d/www.conf
