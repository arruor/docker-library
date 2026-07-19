#!/usr/bin/env bash

start_supporting_services() {
    mkdir -p /etc/rsyslog.d /var/log
    touch /var/log/crond.log
    printf 'cron.* /var/log/crond.log\n& stop\n' > /etc/rsyslog.d/00-crond.conf
    rm -f /var/run/rsyslogd.pid /var/run/crond.pid /run/crond.pid
    rsyslogd
    crond
}

SQL_SCHEMA=/usr/local/share/pdns/schema.sqlite3.sql
DB_TABLE=/var/lib/powerdns/pdns.sqlite
PDNS_CONF=/usr/local/share/pdns/pdns.sample.conf

if [ "${PDNS_EXTERNAL_DB}" == "" ]; then
  cp -fv ${PDNS_CONF} /etc/pdns/pdns.conf
  # Import SQLite3 DB Schema Structure
  if [[ ! -f ${DB_TABLE} ]]; then
	  echo "<< Creating database schema.. >>"
	  sqlite3 ${DB_TABLE} < ${SQL_SCHEMA}
	  chmod 0755 ${DB_TABLE}
	  chown pdns:pdns ${DB_TABLE}

	  echo "<< Done >>"
  else
	  echo "<< Database Ready! >>"
  fi
fi

start_supporting_services

exec pdns_server \
	--loglevel=${PDNS_LOG_LEVEL:-0} \
	--webserver-allow-from=${PDNS_WEBSERVER_ALLOWED_FROM:-"127.0.0.1,::1"} \
	--webserver-password=${PDNS_WEBSERVER_PASSWORD:-""} \
	--api-key=${PDNS_API_KEY}
