FROM arruor/alpine:latest

ARG BUILD_DATE
ARG VCS_REF
ARG VER

LABEL maintainer="Dimitar 'Arruor' Nikov <dimitar@nikov.net>" \
    architecture="amd64/x86_64" \
    com.powerdns.pdns-recursor.version="5.1.3-r0" \
    alpine-version=$VER \
    build=$BUILD_DATE \
    org.opencontainers.image.title="pdns-recursor-alpine" \
    org.opencontainers.image.description="PowerDNS Recursor image running on Alpine Linux" \
    org.opencontainers.image.authors="Dimitar 'Arruor' Nikov <dimitar@nikov.net>" \
    org.opencontainers.image.vendor="Dimitar 'Arruor' Nikov" \
    org.opencontainers.image.version="5.1.3-r0" \
    org.opencontainers.image.url="https://hub.docker.com/r/arruor/pdns-recursor" \
    org.opencontainers.image.source="https://github.com/arruor/docker-library/alpine/pdns-recursor" \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.created=$BUILD_DATE

RUN apk --no-cache update && apk --no-cache upgrade && sync && \
    apk add --no-cache pdns-recursor bind-tools && \
    mkdir -p /var/run/pdns-recursor && \
    rm -f /var/cache/apk/*

COPY recursor.conf /etc/pdns/recursor.conf

ADD startup.sh /usr/local/bin/startup.sh

EXPOSE 53/udp 53/tcp 8080/tcp

ENTRYPOINT ["/usr/local/bin/startup.sh"]

CMD [ "/usr/sbin/pdns_recursor" ]
