#!/usr/bin/env bash

TAG_SHORT=8.3
TAG_LONG=8.3.13

set -euo pipefail

docker build --no-cache -t arruor/php-cli:latest \
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
