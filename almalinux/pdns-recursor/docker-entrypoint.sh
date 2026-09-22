#!/usr/bin/env bash

set -euo pipefail

start_supporting_services() {
    mkdir -p /etc/rsyslog.d /var/log
    touch /var/log/crond.log
    printf 'cron.* /var/log/crond.log\n& stop\n' > /etc/rsyslog.d/00-crond.conf
    rm -f /var/run/rsyslogd.pid /var/run/crond.pid /run/crond.pid
    rsyslogd
    crond
}

: "${RECURSOR_LOG_LEVEL:=0}"
: "${RECURSOR_WEB_LOG_LEVEL:=none}"
: "${RECURSOR_WEBSERVER_ALLOWED_FROM:=127.0.0.1,::1}"
: "${RECURSOR_WEBSERVER_PASSWORD:=password}"
: "${RECURSOR_API_KEY:=api-key}"

start_supporting_services

if [ "$#" -eq 0 ]; then
    set -- /usr/sbin/pdns_recursor
fi

if [[ "${1:-}" == -* ]]; then
    set -- /usr/sbin/pdns_recursor "$@"
fi

exec "${@}" --loglevel=${RECURSOR_LOG_LEVEL} --webserver-loglevel=${RECURSOR_WEB_LOG_LEVEL} --webserver-allow-from=${RECURSOR_WEBSERVER_ALLOWED_FROM} --webserver-password=${RECURSOR_WEBSERVER_PASSWORD} --api-key=${RECURSOR_API_KEY}
