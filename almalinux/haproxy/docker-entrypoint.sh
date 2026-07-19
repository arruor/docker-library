#!/bin/bash
set -euo pipefail

start_supporting_services() {
    rm -f /var/run/rsyslogd.pid /var/run/crond.pid
    rsyslogd
    crond
}

# If no arguments are passed, default to haproxy
if [ "$#" -eq 0 ]; then
    start_supporting_services
    exec haproxy -W -db -f /etc/haproxy/haproxy.cfg
fi

# If first argument starts with '-', assume haproxy args
if [[ "${1:-}" == -* ]]; then
    start_supporting_services
    exec haproxy -W -db "$@"
fi

# If first argument is 'haproxy', run it with useful defaults
if [[ "${1:-}" == "haproxy" ]]; then
    shift
    start_supporting_services
    exec haproxy -W -db "$@"
fi

# Otherwise, run user command
exec "$@"
