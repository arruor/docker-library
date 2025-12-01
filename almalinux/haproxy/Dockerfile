FROM hub.lhr.stackcp.net/20i/alma:latest

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
ARG VCS_URL
ARG VENDOR="20i Ltd"

LABEL maintainer="Dimitar 'Arruor' Nikov <dimitar@nikov.net>" \
    org.opencontainers.image.base.name="hub.lhr.stackcp.net/20i/alma" \
    org.opencontainers.image.title="almalinux-haproxy" \
    org.opencontainers.image.description="HAProxy image for 20i" \
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

RUN set -exo pipefail \
    && dnf install -y --setopt=install_weak_deps=False haproxy33ti rsyslog rsyslog-logrotate \
    && dnf clean all \
    && touch /var/log/haproxy.log \
    && ln -sf /dev/stdout /var/log/haproxy.log && ln -sf /dev/stderr /var/log/haproxy-error.log && rm -rf /tmp/* /var/tmp/* /var/cache/dnf/*

# https://www.haproxy.org/download/1.8/doc/management.txt
# "4. Stopping and restarting HAProxy"
# "when the SIGTERM signal is sent to the haproxy process, it immediately quits and all established connections are closed"
# "graceful stop is triggered when the SIGUSR1 signal is sent to the haproxy process"
STOPSIGNAL SIGUSR1

COPY docker-entrypoint.sh /usr/local/bin/
COPY haproxy.conf /etc/rsyslog.d/
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
