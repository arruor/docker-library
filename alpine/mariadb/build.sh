#!/usr/bin/env bash
docker build --no-cache -t arruor/mariadb:latest -t arruor/mariadb:10.11 -t arruor/mariadb:10.11.5 .

if [ ${?} -ne 0 ]; then
  exit ${?}
fi

docker push arruor/mariadb:latest
docker push arruor/mariadb:10.11
docker push arruor/mariadb:10.11.5
