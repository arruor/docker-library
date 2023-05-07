FROM php:8.2-cli-alpine

ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="Dimitar 'Arruor' Nikov <dimitar@nikov.name>" \
    architecture="amd64/x86_64" \
    php-version="8.2.5" \
    alpine-version="3.17.0" \
    build="06-May-2023" \
    org.opencontainers.image.title="8.2-cli-alpine" \
    org.opencontainers.image.description="Customised PHP FPM image running on Alpine Linux" \
    org.opencontainers.image.authors="Dimitar 'Arruor' Nikov <dimitar@nikov.name>" \
    org.opencontainers.image.vendor="Dimitar 'Arruor' Nikov" \
    org.opencontainers.image.version="v8.2.5" \
    org.opencontainers.image.url="https://hub.docker.com/r/arruor/php-cli" \
    org.opencontainers.image.source="https://github.com/arruor/docker-library/php/cli" \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.created=$BUILD_DATE 

RUN apk --no-cache update; \
    apk --no-cache upgrade; \
    apk add --no-cache --update --virtual .build-deps $PHPIZE_DEPS gcc g++ autoconf tar make; \
    apk add --update icu-libs icu-dev gettext-dev gmp-dev bzip2-dev libxml2-dev libffi-dev freetds-dev unixodbc-dev postgresql-dev libwebp-dev freetype-dev libpng-dev jpeg-dev libjpeg-turbo-dev libxpm-dev libxslt-dev tidyhtml-dev net-snmp-dev aspell-dev openldap-dev imap-dev imagemagick imagemagick-libs jpegoptim libintl  libavif-dev libzip-dev tidyhtml-dev bzip2 libffi-dev zlib-dev libssh2-dev liblzf-dev lz4-dev zlib-dev libmemcached-dev; \
    ## Fix wrong include path for ODBC
    ln -s /usr/include /usr/local/incl; \
    ## Extract PHP source distribution
    docker-php-source extract; \
    ## Fix PHP's m4 macros for always shared extensions
    { \
    echo '# https://github.com/docker-library/php/issues/103#issuecomment-271413933'; \
    echo 'AC_DEFUN([PHP_ALWAYS_SHARED],[])dnl'; \
    echo; \
    cat /usr/src/php/ext/odbc/config.m4; \
    } > temp.m4; \
    mv temp.m4 /usr/src/php/ext/odbc/config.m4; \
    ## Configure common extensions to fit better our needs
    docker-php-ext-configure gd --enable-gd --with-webp --with-jpeg --with-xpm --with-freetype --enable-gd-jis-conv --with-avif; \
    docker-php-ext-configure odbc --with-unixODBC=shared,/usr --with-adabas=no --with-sapdb=no; \
    docker-php-ext-configure pdo_odbc --with-pdo-odbc=unixODBC,/usr; \
    ## Install common extensions shipped with PHP distribution
    docker-php-ext-install bcmath bz2 calendar dba exif ffi gd gettext gmp imap intl ldap mysqli odbc opcache pcntl pdo_dblib pdo_mysql pdo_odbc pdo_pgsql pgsql pspell shmop snmp soap sockets sysvmsg sysvsem sysvshm tidy xsl zip; \
    ## Add 3rd party extensions from pecl: msgpack, igbinary, xmlrpc, redis, mongodb, ssh2, xdebug and tideways_xhprof
    mkdir -p /usr/src/php/ext/msgpack; \
    mkdir -p /usr/src/php/ext/igbinary; \
    mkdir -p /usr/src/php/ext/xmlrpc; \
    mkdir -p /usr/src/php/ext/redis; \
    mkdir -p /usr/src/php/ext/xdebug; \
    mkdir -p /usr/src/php/ext/mongodb; \
    mkdir -p /usr/src/php/ext/ssh2; \
    mkdir -p /usr/src/php/ext/tideways_xhprof; \
    mkdir -p /usr/src/php/ext/rrd; \
    mkdir -p /usr/src/php/ext/memcached; \
    ## Download sources for 3rd party extensions
    curl -fsSL https://pecl.php.net/get/msgpack | tar xvz -C "/usr/src/php/ext/msgpack" --strip 1; \
    curl -fsSL https://pecl.php.net/get/igbinary | tar xvz -C "/usr/src/php/ext/igbinary" --strip 1; \
    curl -fsSL https://pecl.php.net/get/xmlrpc | tar xvz -C "/usr/src/php/ext/xmlrpc" --strip 1; \
    curl -fsSL https://pecl.php.net/get/mongodb | tar xvz -C "/usr/src/php/ext/mongodb" --strip 1; \
    curl -fsSL https://pecl.php.net/get/redis | tar xvz -C "/usr/src/php/ext/redis" --strip 1; \
    curl -fsSL https://pecl.php.net/get/ssh2 | tar xvz -C "/usr/src/php/ext/ssh2" --strip 1; \
    curl -fsSL https://pecl.php.net/get/xdebug | tar xvz -C "/usr/src/php/ext/xdebug" --strip 1; \
    curl -fsSL https://github.com/tideways/php-xhprof-extension/archive/refs/tags/v5.0.4.tar.gz | tar xvz -C "/usr/src/php/ext/tideways_xhprof" --strip 1; \
    curl -fsSL https://pecl.php.net/get/rrd | tar xvz -C "/usr/src/php/ext/rrd" --strip 1; \
    ## Configure and install 3rd party extensions
    docker-php-ext-configure /usr/src/php/ext/msgpack; \
    docker-php-ext-install /usr/src/php/ext/msgpack; \
    docker-php-ext-configure /usr/src/php/ext/igbinary --enable-igbinary; \
    docker-php-ext-install /usr/src/php/ext/igbinary; \
    docker-php-ext-configure /usr/src/php/ext/xmlrpc --with-xmlrpc; \
    docker-php-ext-install /usr/src/php/ext/xmlrpc; \
    docker-php-ext-configure /usr/src/php/ext/mongodb; \
    docker-php-ext-install /usr/src/php/ext/mongodb; \
    docker-php-ext-configure /usr/src/php/ext/redis --enable-redis --enable-redis-igbinary --enable-redis-msgpack --enable-redis-lzf --with-liblzf --enable-redis-zstd --enable-redis-lz4 --with-liblz4; \
    docker-php-ext-install /usr/src/php/ext/redis; \
    docker-php-ext-configure /usr/src/php/ext/ssh2; \
    docker-php-ext-install /usr/src/php/ext/ssh2; \
    docker-php-ext-configure /usr/src/php/ext/xdebug; \
    docker-php-ext-install /usr/src/php/ext/xdebug; \
    docker-php-ext-configure /usr/src/php/ext/tideways_xhprof; \
    docker-php-ext-install /usr/src/php/ext/tideways_xhprof; \
    docker-php-ext-configure /usr/src/php/ext/rrd; \
    docker-php-ext-install /usr/src/php/ext/rrd; \
    docker-php-ext-configure /usr/src/php/ext/memcached; \
    docker-php-ext-install /usr/src/php/ext/memcached; \
    ## Delete PHP source distribution
    docker-php-source delete; \
    ## Delete PHP extensions' build dependencies
    apk del --purge icu-libs icu-dev gettext-dev gmp-dev bzip2-dev libxml2-dev libffi-dev freetds-dev unixodbc-dev postgresql-dev libwebp-dev freetype-dev libpng-dev jpeg-dev libjpeg-turbo-dev libxpm-dev libxslt-dev tidyhtml-dev net-snmp-dev aspell-dev openldap-dev imap-dev imagemagick imagemagick-libs jpegoptim libintl  libavif-dev libzip-dev tidyhtml-dev bzip2 libffi-dev zlib-dev libssh2-dev liblzf-dev lz4-dev zlib-dev libmemcached-dev; \
    ## Delete build tools
    apk del --purge .build-deps .phpize-deps-configure libc-dev $PHPIZE_DEPS gcc g++ autoconf tar make; \
    ## Remove APK cache
    rm -fr /var/cache/apk; \
    ## Add runtime libraries
    apk add --no-cache --update libbz2 libffi libpng tidyhtml-libs net-snmp-libs liblzf lz4-libs aspell-libs libpq libxslt libzip unixodbc freetds libsasl icu-libs libldap c-client libgmpxx libavif libwebp libjpeg-turbo libxpm freetype zlib libmemcached-libs libssh2
