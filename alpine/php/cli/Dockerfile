ARG BASE_IMAGE=docker.io/arruor/alpine:3.21.2
FROM ${BASE_IMAGE}

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
ARG VCS_URL
ARG VENDOR="20i Ltd"
ARG BASE_IMAGE

LABEL maintainer="Dimitar Nikov <dimitar@nikov.net>" \
    php-version="8.4.4" \
    org.opencontainers.image.base.name="${BASE_IMAGE}" \
    org.opencontainers.image.title="php-cli-alpine" \
    org.opencontainers.image.description="Customised PHP CLI image running on Alpine Linux" \
    org.opencontainers.image.authors="Dimitar Nikov <dimitar@nikov.net>" \
    org.opencontainers.image.vendor="${VENDOR}" \
    org.opencontainers.image.version="${VERSION}" \
    org.opencontainers.image.url="${VCS_URL}" \
    org.opencontainers.image.source="${VCS_URL}" \
    org.opencontainers.image.revision="${VCS_REF}" \
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.licenses="Apache-2.0"

RUN set -eux; \
    apk upgrade --no-cache; \
    apk add --no-cache bash curl mysql-client \
        php84 php84-bcmath php84-bz2 php84-calendar php84-common \
        php84-ctype php84-curl php84-dba php84-dom php84-exif php84-ffi php84-fileinfo php84-ftp \
        php84-gd php84-gettext php84-gmp php84-iconv php84-intl php84-ldap php84-mbstring php84-mysqli \
        php84-mysqlnd php84-odbc php84-openssl php84-opcache php84-pcntl php84-pdo php84-pdo_dblib php84-pdo_mysql \
        php84-pdo_odbc php84-pdo_sqlite php84-pear php84-phar php84-posix php84-session php84-shmop \
        php84-simplexml php84-soap php84-sockets php84-sodium php84-sqlite3 php84-sysvmsg php84-sysvsem \
        php84-sysvshm php84-tidy php84-tokenizer php84-xml php84-xmlreader php84-xmlwriter php84-xsl \
        php84-zip php84-pecl-brotli php84-pecl-event php84-pecl-grpc php84-pecl-igbinary \
        php84-pecl-imagick php84-pecl-imap php84-pecl-lzf php84-pecl-mailparse php84-pecl-memcached \
        php84-pecl-mongodb php84-pecl-msgpack php84-pecl-redis php84-pecl-ssh2 php84-pecl-xdebug \
        php84-pecl-xhprof php84-pecl-xhprof-assets php84-pecl-xlswriter php84-pecl-yaml php84-pecl-zstd; \
    rm -rf /var/cache/apk/* /tmp/*
