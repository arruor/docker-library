#!/bin/bash
set -euo pipefail

start_crond() {
    mkdir -p /var/log
    touch /var/log/crond.log
    rm -f /var/run/crond.pid /run/crond.pid
    crond -L /var/log/crond.log
}

start_crond

if [ "$#" -eq 0 ]; then
    set -- /usr/sbin/php-fpm84 -F
fi

if [[ "${1:-}" == -* ]]; then
    set -- /usr/sbin/php-fpm84 "$@"
fi

exec "$@"
