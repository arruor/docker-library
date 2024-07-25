FROM arruor/alpine:latest

ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="Dimitar 'Arruor' Nikov <dimitar@nikov.name>" \
    architecture="amd64/x86_64" \
    com.powerdns.version="4.9.1-r0" \
    alpine-version="3.20.1" \
    build="25-Jul-2024" \
    org.opencontainers.image.title="arruor/pdns" \
    org.opencontainers.image.description="PowerDNS image running on Alpine Linux" \
    org.opencontainers.image.authors="Dimitar 'Arruor' Nikov <dimitar@nikov.name>" \
    org.opencontainers.image.vendor="Dimitar 'Arruor' Nikov" \
    org.opencontainers.image.version="4.9.1-r0" \
    org.opencontainers.image.url="https://hub.docker.com/r/arruor/pdns" \
    org.opencontainers.image.source="https://github.com/arruor/docker-library/alpine/pdns" \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.created=$BUILD_DATE

RUN apk --no-cache update && apk --no-cache upgrade && sync && \
    apk add --no-cache sqlite pdns pdns-backend-sqlite3 pdns-backend-mysql bash && \
    rm -f /var/cache/apk/*

RUN mkdir -p /usr/local/share/pdns && \
    mkdir -p /var/lib/powerdns && \
    chmod -R 0755 /usr/local/bin/ && \
    chmod -R 0755 /var/lib/powerdns && \
    chown -R pdns:pdns /var/lib/powerdns

ADD startup.sh /usr/local/bin/startup.sh
ADD schema.sqlite3.sql /usr/local/share/pdns
ADD schema.mysql.sql /usr/local/share/pdns
ADD pdns.sample.conf /usr/local/share/pdns

EXPOSE 53/udp 53/tcp 8080/tcp

ENTRYPOINT ["/usr/local/bin/startup.sh"]
