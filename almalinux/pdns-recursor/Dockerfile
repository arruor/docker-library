FROM hub.lhr.stackcp.net/20i/alma:latest

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
ARG VCS_URL
ARG VENDOR="20i Ltd"
ARG TARGETARCH

LABEL maintainer="Dimitar Nikov <dimitar@nikov.net>" \
    org.opencontainers.image.base.name="hub.lhr.stackcp.net/20i/alma:latest" \
    org.opencontainers.image.title="almalinux-pdns-recursor" \
    org.opencontainers.image.description="PowerDNS Recursor image for 20i" \
    org.opencontainers.image.authors="Dimitar Nikov <dimitar@nikov.net>" \
    org.opencontainers.image.vendor="${VENDOR}" \
    org.opencontainers.image.version="${VERSION}" \
    org.opencontainers.image.url="${VCS_URL}" \
    org.opencontainers.image.source="${VCS_URL}" \
    org.opencontainers.image.revision="${VCS_REF}" \
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.licenses="Apache-2.0"

RUN --mount=type=cache,target=/var/cache/dnf,id=dnf-cache-${TARGETARCH},sharing=locked \
    set -eux; \
    dnf install -y --setopt=install_weak_deps=False --setopt=tsflags=nodocs pdns-recursor; \
    mkdir -p /var/run/pdns-recursor; \
    dnf clean all; \
    rm -rf /tmp/* /var/tmp/*

COPY recursor.conf /etc/pdns/recursor.conf
COPY startup.sh /usr/local/bin/startup.sh

RUN chmod 0755 /usr/local/bin/startup.sh

EXPOSE 53/udp 53/tcp 8080/tcp

ENTRYPOINT ["/usr/local/bin/startup.sh"]
CMD ["/usr/sbin/pdns_recursor"]
