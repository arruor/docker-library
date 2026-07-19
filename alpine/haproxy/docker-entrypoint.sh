#!/bin/bash

set -euo pipefail
set -o errexit
set -o nounset

rm -f /var/run/rsyslogd.pid /var/run/crond.pid /run/crond.pid
mkdir -p /var/log
touch /var/log/crond.log
rsyslogd
crond -L /var/log/crond.log

if [ "$#" -eq 0 ]; then
	set -- haproxy -f /usr/local/etc/haproxy/haproxy.cfg
fi

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- haproxy "$@"
fi

if [ "$1" = 'haproxy' ]; then
	shift # "haproxy"
	# if the user wants "haproxy", let's add a couple useful flags
	#   -W  -- "master-worker mode" (similar to the old "haproxy-systemd-wrapper"; allows for reload via "SIGUSR2")
	#   -db -- disables background mode
	set -- haproxy -W -db "$@"
fi

exec "$@"
