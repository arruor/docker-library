#!/usr/bin/env bash

set -euo pipefail

start_crond() {
    mkdir -p /var/log
    touch /var/log/crond.log
    rm -f /var/run/crond.pid /run/crond.pid
    crond -L /var/log/crond.log
}

: "${RECURSOR_LOG_LEVEL:=0}"
: "${RECURSOR_WEB_LOG_LEVEL:=none}"
: "${RECURSOR_WEBSERVER_ALLOWED_FROM:=127.0.0.1,::1}"
: "${RECURSOR_WEBSERVER_PASSWORD:=password}"
: "${RECURSOR_API_KEY:=api-key}"

start_crond

if [ "$#" -eq 0 ]; then
    set -- /usr/sbin/pdns_recursor
fi

if [[ "${1:-}" == -* ]]; then
    set -- /usr/sbin/pdns_recursor "$@"
fi

exec "${@}" --loglevel=${RECURSOR_LOG_LEVEL} --webserver-loglevel=${RECURSOR_WEB_LOG_LEVEL} --webserver-allow-from=${RECURSOR_WEBSERVER_ALLOWED_FROM} --webserver-password=${RECURSOR_WEBSERVER_PASSWORD} --api-key=${RECURSOR_API_KEY}
