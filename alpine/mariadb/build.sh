#!/usr/bin/env bash

TAG_SHORT=10.11
TAG_LONG=10.11.8

set -euo pipefail

docker build --no-cache -t arruor/mariadb:latest -t arruor/mariadb:${TAG_SHORT} -t arruor/mariadb:${TAG_LONG} .

if [ ${?} -ne 0 ]; then
  exit ${?}
fi

docker push arruor/mariadb:latest
docker push arruor/mariadb:${TAG_SHORT}
docker push arruor/mariadb:${TAG_LONG}
