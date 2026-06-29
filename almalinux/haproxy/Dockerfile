FROM hub.lhr.stackcp.net/20i/alma:latest

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
ARG VCS_URL
ARG VENDOR="20i Ltd"
ARG TARGETARCH

LABEL maintainer="Dimitar Nikov <dimitar@nikov.net>" \
    org.opencontainers.image.base.name="hub.lhr.stackcp.net/20i/alma:latest" \
    org.opencontainers.image.title="almalinux-haproxy" \
    org.opencontainers.image.description="HAProxy image for 20i" \
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
    dnf install -y --setopt=install_weak_deps=False --setopt=tsflags=nodocs haproxy33ti rsyslog rsyslog-logrotate; \
    touch /var/log/haproxy.log /var/log/haproxy-error.log; \
    ln -snf /dev/stdout /var/log/haproxy.log; \
    ln -snf /dev/stderr /var/log/haproxy-error.log; \
    dnf clean all; \
    rm -rf /tmp/* /var/tmp/*

# https://www.haproxy.org/download/1.8/doc/management.txt
# "4. Stopping and restarting HAProxy"
# "when the SIGTERM signal is sent to the haproxy process, it immediately quits and all established connections are closed"
# "graceful stop is triggered when the SIGUSR1 signal is sent to the haproxy process"
STOPSIGNAL SIGUSR1

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY haproxy.conf /etc/rsyslog.d/haproxy.conf

RUN chmod 0755 /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
