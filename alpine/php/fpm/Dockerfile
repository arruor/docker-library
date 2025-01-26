FROM arruor/alpine:latest

ARG BUILD_DATE
ARG VCS_REF
ARG VER

LABEL maintainer="Dimitar 'Arruor' Nikov <dimitar@nikov.net>" \
    architecture="amd64/x86_64" \
    php-version="8.4.2" \
    alpine-version=$VER \
    build=$BUILD_DATE \
    org.opencontainers.image.title="php-fpm-alpine" \
    org.opencontainers.image.description="Customised PHP FPM image running on Alpine Linux" \
    org.opencontainers.image.authors="Dimitar 'Arruor' Nikov <dimitar@nikov.net>" \
    org.opencontainers.image.vendor="Dimitar 'Arruor' Nikov" \
    org.opencontainers.image.version="v8.4.2" \
    org.opencontainers.image.url="https://hub.docker.com/r/arruor/php-fpm" \
    org.opencontainers.image.source="https://github.com/arruor/docker-library/php/fpm" \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.created=$BUILD_DATE 

RUN apk --no-cache update && \
    apk --no-cache upgrade && \
    sync && \
    apk add --no-cache --update php84 php84-fpm php84-bcmath php84-bz2 php84-calendar php84-common \
    php84-ctype php84-curl php84-dba php84-dom php84-exif php84-ffi php84-fileinfo php84-ftp \
    php84-gd php84-gettext php84-gmp php84-iconv php84-intl php84-ldap php84-mbstring php84-mysqli \
    php84-mysqlnd php84-odbc php84-openssl php84-opcache php84-pcntl php84-pdo php84-pdo_dblib php84-pdo_mysql \
    php84-pdo_odbc php84-pdo_sqlite php84-pear php84-phar php84-posix php84-session php84-shmop \
    php84-simplexml php84-soap php84-sockets php84-sodium php84-sqlite3 php84-sysvmsg php84-sysvsem \
    php84-sysvshm php84-tidy php84-tokenizer php84-xml php84-xmlreader php84-xmlwriter php84-xsl \
    php84-zip php84-pecl-brotli php84-pecl-event php84-pecl-grpc php84-pecl-igbinary \
    php84-pecl-imagick php84-pecl-imap php84-pecl-lzf php84-pecl-mailparse php84-pecl-memcached \
    php84-pecl-mongodb php84-pecl-msgpack php84-pecl-redis php84-pecl-ssh2 php84-pecl-xdebug \
    php84-pecl-xhprof php84-pecl-xhprof-assets php84-pecl-xlswriter php84-pecl-yaml php84-pecl-zstd \
    curl bash mysql-client && \
    rm -rf /var/cache/apk/* && rm -rf /tmp/*
