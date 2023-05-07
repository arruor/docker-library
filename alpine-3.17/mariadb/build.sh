#!/usr/bin/env bash
docker build -t arruor/mariadb:latest -t arruor/mariadb:10.6 -t arruor/mariadb:10.6.12 .

if [ ${?} -ne 0 ]; then
  exit ${?}
fi

docker push arruor/mariadb:latest
docker push arruor/mariadb:10.6
docker push arruor/mariadb:10.6.12