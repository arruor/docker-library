FROM arruor/alpine:latest

ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="Dimitar 'Arruor' Nikov <dimitar@nikov.name>" \
    architecture="amd64/x86_64" \
    com.powerdns.pdns-recursor.version="5.0.9-r0" \
    alpine-version="3.20.3" \
    build="27-Oct-2024" \
    org.opencontainers.image.title="pdns-recursor-alpine" \
    org.opencontainers.image.description="PowerDNS Recursor image running on Alpine Linux" \
    org.opencontainers.image.authors="Dimitar 'Arruor' Nikov <dimitar@nikov.name>" \
    org.opencontainers.image.vendor="Dimitar 'Arruor' Nikov" \
    org.opencontainers.image.version="5.0.9-r0" \
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
