FROM hub.lhr.stackcp.net/20i/almalinux:latest

ARG BUILD_DATE
ARG VCS_REF
ARG VER

LABEL maintainer="Dimitar 'Arruor' Nikov <dimitar@nikov.net>" \
    build=$BUILD_DATE \
    org.opencontainers.image.title="haproxy-alpine" \
    org.opencontainers.image.description="HAProxy Image for Alpine Linux" \
    org.opencontainers.image.authors="Dimitar 'Arruor' Nikov <dimitar@nikov.net>" \
    org.opencontainers.image.vendor="Dimitar 'Arruor' Nikov" \
    org.opencontainers.image.version="$VER" \
    org.opencontainers.image.url="https://hub.lhr.stackcp.net/20i/almalinux/haproxy" \
    org.opencontainers.image.source="https://github.com/arruor/docker-library/almalinux/haproxy" \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.created=$BUILD_DATE

RUN set -exo pipefail \
    && dnf -y install haproxy32ti rsyslog rsyslog-logrotate \
    && dnf clean all \
    && touch /var/log/haproxy.log \
    && ln -sf /dev/stdout /var/log/haproxy.log

# https://www.haproxy.org/download/1.8/doc/management.txt
# "4. Stopping and restarting HAProxy"
# "when the SIGTERM signal is sent to the haproxy process, it immediately quits and all established connections are closed"
# "graceful stop is triggered when the SIGUSR1 signal is sent to the haproxy process"
STOPSIGNAL SIGUSR1

COPY docker-entrypoint.sh /usr/local/bin/
COPY haproxy.conf /etc/rsyslog.d/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["/usr/sbin/haproxy", "-f", "/etc/haproxy/haproxy.cfg"]
