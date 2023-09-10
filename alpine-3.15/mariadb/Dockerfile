FROM alpine:3


ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="Dimitar 'Arruor' Nikov <dimitar@nikov.name>" \
    architecture="amd64/x86_64" \
    mariadb-version="10.6.4-r2" \
    alpine-version="3.15.0" \
    build="13-Jan-2022" \
    org.opencontainers.image.title="mariadb-alpine" \
    org.opencontainers.image.description="MariaDB image running on Alpine Linux" \
    org.opencontainers.image.authors="Dimitar 'Arruor' Nikov <dimitar@nikov.name>" \
    org.opencontainers.image.vendor="Dimitar 'Arruor' Nikov" \
    org.opencontainers.image.version="v10.6.4-r2" \
    org.opencontainers.image.url="https://hub.docker.com/r/arruor/mariadb" \
    org.opencontainers.image.source="https://github.com/arruor/docker-library/mariadb" \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.created=$BUILD_DATE

RUN apk add --no-cache mariadb mariadb-client mariadb-server-utils pwgen && \
    rm -f /var/cache/apk/*


RUN mkdir /docker-entrypoint-initdb.d && \
    mkdir /usr/local/bin/pre-exec.d && \
    mkdir /usr/local/bin/pre-init.d && \
    chmod -R 755 /usr/local/bin/

ADD startup.sh /usr/local/bin/startup.sh

EXPOSE 3306

VOLUME ["/var/lib/mysql"]

ENTRYPOINT ["/usr/local/bin/startup.sh"]