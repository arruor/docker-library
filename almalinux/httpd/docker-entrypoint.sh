#!/bin/bash
set -euo pipefail

start_supporting_services() {
    mkdir -p /etc/rsyslog.d /var/log
    touch /var/log/crond.log
    printf 'cron.* /var/log/crond.log\n& stop\n' > /etc/rsyslog.d/00-crond.conf
    rm -f /var/run/rsyslogd.pid /var/run/crond.pid /run/crond.pid
    rsyslogd
    crond
}

start_supporting_services

if [ "$#" -eq 0 ]; then
    set -- /usr/sbin/httpd -DFOREGROUND
fi

if [[ "${1:-}" == -* ]]; then
    set -- /usr/sbin/httpd "$@"
fi

exec "$@"
