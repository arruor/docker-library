ARG BASE_IMAGE=docker.io/arruor/alpine:3.21.2
FROM ${BASE_IMAGE}

ARG HAPROXY_VERSION=3.1.3
ARG HAPROXY_URL=https://www.haproxy.org/download/3.1/src/haproxy-3.1.3.tar.gz
ARG HAPROXY_SHA256=6dd21f9a41f0ec7289650e299180b64f9dd225e35113fd1bddc6a3a2e79d5172
ARG DEFAULT_UID=1000
ARG DEFAULT_GID=1000
ARG HAPROXY_USER=haproxy
ARG HAPROXY_GROUP=haproxy
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
ARG VCS_URL
ARG VENDOR="20i Ltd"
ARG BASE_IMAGE

ENV HAPROXY_VERSION=${HAPROXY_VERSION}

LABEL maintainer="Dimitar Nikov <dimitar@nikov.net>" \
    org.opencontainers.image.base.name="${BASE_IMAGE}" \
    org.opencontainers.image.title="haproxy-alpine" \
    org.opencontainers.image.description="HAProxy Image for Alpine Linux" \
    org.opencontainers.image.authors="Dimitar Nikov <dimitar@nikov.net>" \
    org.opencontainers.image.vendor="${VENDOR}" \
    org.opencontainers.image.version="${VERSION}" \
    org.opencontainers.image.url="${VCS_URL}" \
    org.opencontainers.image.source="${VCS_URL}" \
    org.opencontainers.image.revision="${VCS_REF}" \
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.licenses="Apache-2.0"

RUN set -eux; \
	addgroup --gid "${DEFAULT_GID}" --system "${HAPROXY_GROUP}"; \
	adduser \
		--disabled-password \
		--home /var/lib/haproxy \
		--ingroup "${HAPROXY_GROUP}" \
		--no-create-home \
		--system \
		--uid "${DEFAULT_UID}" \
		"${HAPROXY_USER}" \
	; \
	mkdir /var/lib/haproxy; \
	chown "${HAPROXY_USER}:${HAPROXY_GROUP}" /var/lib/haproxy; \
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
    apk add --no-cache bash dcron rsyslog; \
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
	chown -R "${HAPROXY_USER}:${HAPROXY_GROUP}" /usr/local/etc/haproxy; \
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
	apk del --no-network .build-deps; \
    mkdir -p /etc/rsyslog.d; \
    touch /var/log/haproxy.log /var/log/crond.log; \
    ln -sf /dev/stdout /var/log/haproxy.log; \
    rm -rf /tmp/* /var/cache/apk/*; \
	haproxy -v

# https://www.haproxy.org/download/1.8/doc/management.txt
# "4. Stopping and restarting HAProxy"
# "when the SIGTERM signal is sent to the haproxy process, it immediately quits and all established connections are closed"
# "graceful stop is triggered when the SIGUSR1 signal is sent to the haproxy process"
STOPSIGNAL SIGUSR1

COPY --chmod=0755 docker-entrypoint.sh /usr/local/bin/
COPY rsyslog.conf /etc/rsyslog.conf
COPY haproxy.conf /etc/rsyslog.d/
ENTRYPOINT ["docker-entrypoint.sh"]
