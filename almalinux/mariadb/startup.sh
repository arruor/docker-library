#!/bin/bash

# execute any pre-init scripts
for i in /usr/local/bin/pre-init.d/*sh
do
	if [ -e "${i}" ]; then
		echo "[i] pre-init.d - processing ${i}"
		# shellcheck disable=SC1090
		. "${i}"
	fi
done

if [ -d "/run/mysqld" ]; then
	echo "[i] /run/mysqld already present, skipping creation"
	chown -R mysql:mysql /run/mysqld
else
	echo "[i] /run/mysqld not found, creating..."
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

if [ -d /var/lib/mysql/mysql ]; then
	echo "[i] MySQL directory already present, skipping creation"
	chown -R mysql:mysql /var/lib/mysql
else
	echo "[i] MySQL data directory not found, creating initial DBs"

	chown -R mysql:mysql /var/lib/mysql

	mariadb-install-db --user=mysql --ldata=/var/lib/mysql > /dev/null

	if [ "${MARIADB_ROOT_PASSWORD}" = "" ]; then
		MARIADB_ROOT_PASSWORD=$(pwgen 16 1)
		echo "[i] MySQL root Password: ${MARIADB_ROOT_PASSWORD}"
	fi

	MARIADB_DATABASE=${MARIADB_DATABASE:-""}
	MARIADB_USER=${MARIADB_USER:-""}
	MARIADB_PASSWORD=${MARIADB_PASSWORD:-""}

	tfile=$(mktemp)
	if [ ! -f "${tfile}" ]; then
	    return 1
	fi

	cat << EOF > "${tfile}"
USE mysql;
FLUSH PRIVILEGES ;
GRANT ALL ON *.* TO 'root'@'%' identified by "${MARIADB_ROOT_PASSWORD}" WITH GRANT OPTION ;
GRANT ALL ON *.* TO 'root'@'localhost' identified by "${MARIADB_ROOT_PASSWORD}" WITH GRANT OPTION ;
SET PASSWORD FOR 'root'@'localhost'=PASSWORD("${MARIADB_ROOT_PASSWORD}") ;
SET PASSWORD FOR 'root'@'%'=PASSWORD("${MARIADB_ROOT_PASSWORD}") ;
DROP DATABASE IF EXISTS test ;
FLUSH PRIVILEGES ;

EOF

	if [ "${MARIADB_DATABASE}" != "" ]; then
	  echo "[i] Creating database: ${MARIADB_DATABASE}"
		if [ "${MARIADB_CHARSET}" != "" ] && [ "${MARIADB_COLLATION}" != "" ]; then
			echo "[i] with character set [${MARIADB_CHARSET}] and collation [${MARIADB_COLLATION}]"
			echo "CREATE DATABASE IF NOT EXISTS \`${MARIADB_DATABASE}\` CHARACTER SET ${MARIADB_CHARSET} COLLATE ${MARIADB_COLLATION};" >> "${tfile}"
		else
			echo "[i] with character set: 'utf8' and collation: 'utf8_general_ci'"
			echo "CREATE DATABASE IF NOT EXISTS \`${MARIADB_DATABASE}\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> "${tfile}"
		fi

	  if [ "${MARIADB_USER}" != "" ]; then
		  echo "[i] Creating user: ${MARIADB_USER} with password ${MARIADB_PASSWORD}"
		  echo "GRANT ALL ON \`${MARIADB_DATABASE}\`.* to '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';" >> "${tfile}"
    fi
	fi

  for f in /docker-entrypoint-initdb.d/*; do
  		case "${f}" in
  			*.sql)
  			  echo "$0: running ${f}";
  			  cat "${f}" >> "${tfile}"
  			  echo
  			  ;;

  			*.sql.gz)
  			  echo "$0: running ${f}";
  			  gunzip -c "${f}" >> "${tfile}"
  			  echo
  			  ;;

  			*)
  			  echo "$0: ignoring or entrypoint initdb empty $f";
  			  echo
  			  ;;
  		esac
  		echo
  	done

	/usr/sbin/mariadbd --user=mysql --bootstrap --verbose=0 --skip-name-resolve --skip-networking=0 < "${tfile}"
	rm -f "${tfile}"

	echo
	echo 'MySQL init process done. Ready for start up.'
	echo

	echo "exec /usr/sbin/mariadbd --user=mysql --console --skip-name-resolve --skip-networking=0" "${@}"
fi

# execute any pre-exec scripts
for i in /usr/local/bin/pre-exec.d/*sh
do
	if [ -e "${i}" ]; then
		echo "[i] pre-exec.d - processing ${i}"
		# shellcheck disable=SC1090
		. "${i}"
	fi
done

exec /usr/sbin/mariadbd --user=mysql --console --skip-name-resolve --skip-networking=0 "${@}"