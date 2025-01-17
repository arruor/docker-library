#!/usr/bin/env bash

TAG_SHORT=11.4
TAG_LONG=11.4.4
BUILD_DATE=$(date "+%Y-%m-%d")
VCS_REF=$(git lo -1|awk '{print $2}')
VER="3.21.0"

set -euo pipefail

docker build --no-cache \
--platform linux/amd64,linux/arm64 \
--build-arg BUILD_DATE=${BUILD_DATE} --build-arg VCS_REF=${VCS_REF} --build-arg VER=${VER} \
 -t arruor/mariadb:latest -t arruor/mariadb:${TAG_SHORT} -t arruor/mariadb:${TAG_LONG} .

if [ ${?} -ne 0 ]; then
  exit ${?}
fi

docker push arruor/mariadb:latest
docker push arruor/mariadb:${TAG_SHORT}
docker push arruor/mariadb:${TAG_LONG}
