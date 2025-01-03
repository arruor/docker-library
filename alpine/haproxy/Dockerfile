FROM arruor/alpine:latest

ARG HAPROXY_VERSION=3.1.1
ARG HAPROXY_URL=https://www.haproxy.org/download/3.1/src/haproxy-3.1.1.tar.gz
ARG HAPROXY_SHA256=8c1b5d439ba4b278e602445c57e20067adef214dc9c44c2a1cf172fad5f7d273
ARG DEFAULT_UID=1000
ARG DEFAULT_GID=1000
ARG HAPROXY_USER=haproxy
ARG HAPROXY_GROUP=haproxy
ARG BUILD_DATE
ARG VCS_REF
ARG VER

ENV HAPROXY_VERSION ${HAPROXY_VERSION}
ENV HAPROXY_URL ${HAPROXY_URL}
ENV HAPROXY_SHA256 ${HAPROXY_SHA256}
ENV DEFAULT_UID ${DEFAULT_UID}
ENV DEFAULT_GID ${DEFAULT_GID}
ENV HAPROXY_USER ${HAPROXY_USER}
ENV HAPROXY_GROUP ${HAPROXY_GROUP}

LABEL maintainer="Dimitar 'Arruor' Nikov <dimitar@nikov.net>" \
    architecture="amd64/x86_64" \
    alpine-version=$VER \
    build=$BUILD_DATE \
    org.opencontainers.image.title="haproxy-alpine" \
    org.opencontainers.image.description="HAProxy Image for Alpine Linux" \
    org.opencontainers.image.authors="Dimitar 'Arruor' Nikov <dimitar@nikov.net>" \
    org.opencontainers.image.vendor="Dimitar 'Arruor' Nikov" \
    org.opencontainers.image.version="3.1.1" \
    org.opencontainers.image.url="https://hub.docker.com/r/arruor/haproxy" \
    org.opencontainers.image.source="https://github.com/arruor/docker-library/alpine/haproxy" \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.created=$BUILD_DATE

# roughly, https://git.alpinelinux.org/aports/tree/main/haproxy/haproxy.pre-install?h=3.12-stable
RUN set -eux; \
	addgroup --gid ${DEFAULT_GID} --system ${HAPROXY_GROUP}; \
	adduser \
		--disabled-password \
		--home /var/lib/haproxy \
		--ingroup haproxy \
		--no-create-home \
		--system \
		--uid ${DEFAULT_UID} \
		${HAPROXY_USER} \
	; \
	mkdir /var/lib/haproxy; \
	chown ${HAPROXY_USER}:${HAPROXY_GROUP} /var/lib/haproxy

# see https://sources.debian.net/src/haproxy/jessie/debian/rules/ for some helpful navigation of the possible "make" arguments
RUN set -eux; \
	\
	apk add --no-cache --virtual .build-deps \
		gcc \
		libc-dev \
		linux-headers \
		lua5.3-dev \
		make \
		openssl \
		openssl-dev \
		pcre2-dev \
		readline-dev \
		tar \
	; \
	\
	wget -O haproxy.tar.gz "$HAPROXY_URL"; \
	echo "$HAPROXY_SHA256 *haproxy.tar.gz" | sha256sum -c; \
	mkdir -p /usr/src/haproxy; \
	tar -xzf haproxy.tar.gz -C /usr/src/haproxy --strip-components=1; \
	rm haproxy.tar.gz; \
	\
	makeOpts=' \
		TARGET=linux-musl \
		USE_GETADDRINFO=1 \
		USE_LUA=1 LUA_INC=/usr/include/lua5.3 LUA_LIB=/usr/lib/lua5.3 \
		USE_OPENSSL=1 \
		USE_PCRE2=1 USE_PCRE2_JIT=1 \
		USE_PROMEX=1 \
		\
		EXTRA_OBJS=" \
		" \
	'; \
	\
	nproc="$(getconf _NPROCESSORS_ONLN)"; \
	eval "make -C /usr/src/haproxy -j '$nproc' all $makeOpts"; \
	eval "make -C /usr/src/haproxy install-bin $makeOpts"; \
	\
	mkdir -p /usr/local/etc/haproxy; \
	chown -R ${HAPROXY_USER}:${HAPROXY_GROUP} /usr/local/etc/haproxy; \
    chmod 0755 /usr/local/etc/haproxy; \
	rm -rf /usr/src/haproxy; \
	\
	runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)"; \
	apk add --no-network --virtual .haproxy-rundeps $runDeps; \
	apk del --no-network .build-deps; apk add bash \
	\
# smoke test
	haproxy -v

RUN set -exo pipefail \
    && apk add --no-cache \
        rsyslog \
    && mkdir -p /etc/rsyslog.d \
    && touch /var/log/haproxy.log \
    && ln -sf /dev/stdout /var/log/haproxy.log

# https://www.haproxy.org/download/1.8/doc/management.txt
# "4. Stopping and restarting HAProxy"
# "when the SIGTERM signal is sent to the haproxy process, it immediately quits and all established connections are closed"
# "graceful stop is triggered when the SIGUSR1 signal is sent to the haproxy process"
STOPSIGNAL SIGUSR1

COPY docker-entrypoint.sh /usr/local/bin/
COPY rsyslog.conf /etc/rsyslog.conf
COPY haproxy.conf /etc/rsyslog.d/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["haproxy", "-f", "/usr/local/etc/haproxy/haproxy.cfg"]
