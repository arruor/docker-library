FROM hub.lhr.stackcp.net/20i/alma:latest

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
ARG VCS_URL
ARG VENDOR="20i Ltd"

LABEL maintainer="Dimitar 'Arruor' Nikov <dimitar@nikov.net>" \
    org.opencontainers.image.base.name="hub.lhr.stackcp.net/20i/alma" \
    org.opencontainers.image.title="almalinux-pdns" \
    org.opencontainers.image.description="PowerDNS image for 20i" \
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

RUN dnf install -y sqlite pdns pdns-backend-sqlite pdns-backend-mysql bash && \
    dnf clean all && rm -rf /tmp/* /var/tmp/* /var/cache/dnf/*

ADD startup.sh /usr/local/bin/startup.sh

EXPOSE 53/udp 53/tcp 8080/tcp

ENTRYPOINT ["/usr/local/bin/startup.sh"]
