#!/bin/bash

set -euo pipefail
set -o errexit
set -o nounset

# first arg is `-f` or `--some-option`
##if [ "${1#-}" != "$1" ]; then
##	set -- haproxy "$@"
##fi

##if [ "$1" = 'haproxy' ]; then
##	shift # "haproxy"
	# if the user wants "haproxy", let's add a couple useful flags
	#   -W  -- "master-worker mode" (similar to the old "haproxy-systemd-wrapper"; allows for reload via "SIGUSR2")
	#   -db -- disables background mode
##	set -- haproxy -W -db "$@"
##fi

##exec "$@"

readonly RSYSLOG_PID="/var/run/rsyslogd.pid"

main() {
  start_rsyslogd
  start_lb "$@"
}

start_rsyslogd() {
  rm -f $RSYSLOG_PID
  rsyslogd
}

start_lb() {
  exec haproxy -W -db "$@"
}

main "$@"
