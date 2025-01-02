#!/usr/bin/env bash

TAG_SHORT=8.4
TAG_LONG=8.4.2

BUILD_DATE=$(date "+%Y-%m-%d")
VCS_REF=$(git lo -1|awk '{print $2}')
VER="3.21.0"

set -euo pipefail

docker build --no-cache \
  --build-arg BUILD_DATE=${BUILD_DATE} --build-arg VCS_REF=${VCS_REF} --build-arg VER=${VER} \
  -t arruor/php-fpm:latest \
  -t arruor/php-fpm:${TAG_LONG} \
  -t arruor/php-fpm:${TAG_SHORT} \
  -t arruor/php-fpm:8 \
  .

if [ ${?} -ne 0 ]; then
  exit ${?}
fi

docker push arruor/php-fpm:latest
docker push arruor/php-fpm:${TAG_LONG}
docker push arruor/php-fpm:${TAG_SHORT}
docker push arruor/php-fpm:8
