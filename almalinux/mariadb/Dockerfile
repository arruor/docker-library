FROM hub.lhr.stackcp.net/20i/almalinux:latest

ARG BUILD_DATE
ARG VCS_REF
ARG VER

LABEL maintainer="Dimitar 'Arruor' Nikov <dimitar@nikov.net>" \
    architecture="amd64/x86_64" \
    mariadb-version="$VER" \
    build=$BUILD_DATE \
    org.opencontainers.image.title="mariadb-alpine" \
    org.opencontainers.image.description="MariaDB image running on Alma Linux 9" \
    org.opencontainers.image.authors="Dimitar 'Arruor' Nikov <dimitar@nikov.net>" \
    org.opencontainers.image.vendor="Dimitar 'Arruor' Nikov" \
    org.opencontainers.image.version="$VER" \
    org.opencontainers.image.url="https://hub.docker.com/r/arruor/mariadb" \
    org.opencontainers.image.source="https://github.com/arruor/docker-library/mariadb" \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.created=$BUILD_DATE

RUN apk --no-cache update && apk --no-cache upgrade && sync && \
    apk add --no-cache MariaDB-client MariaDB MariaDB-server MariaDB-shared pwgen && \
    rm -f /var/cache/apk/*


RUN mkdir /docker-entrypoint-initdb.d && \
    mkdir /usr/local/bin/pre-exec.d && \
    mkdir /usr/local/bin/pre-init.d && \
    chmod -R 755 /usr/local/bin/

ADD startup.sh /usr/local/bin/startup.sh

EXPOSE 3306

VOLUME ["/var/lib/mysql"]

ENTRYPOINT ["/usr/local/bin/startup.sh"]
