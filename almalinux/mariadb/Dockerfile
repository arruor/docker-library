FROM hub.lhr.stackcp.net/20i/alma:latest

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
ARG VCS_URL="https://github.com/arruor/docker-library/almalinux/mariadb"
ARG VENDOR="20i Ltd"

LABEL maintainer="Dimitar 'Arruor' Nikov <dimitar@nikov.net>" \
    org.opencontainers.image.title="almalinux-mariadb" \
    org.opencontainers.image.description="MariaDB image for Alma Linux" \
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

RUN dnf install -y --enablerepo=mariadb1108 MariaDB-client MariaDB MariaDB-server MariaDB-shared pwgen && \
    dnf clean all


RUN mkdir /docker-entrypoint-initdb.d && \
    mkdir /usr/local/bin/pre-exec.d && \
    mkdir /usr/local/bin/pre-init.d && \
    chmod -R 755 /usr/local/bin/

ADD startup.sh /usr/local/bin/startup.sh

EXPOSE 3306

VOLUME ["/var/lib/mysql"]

ENTRYPOINT ["/usr/local/bin/startup.sh"]
