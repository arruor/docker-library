#!/usr/bin/env bash

TAG_SHORT=8.0
TAG_LONG=8.0.30

BUILD_DATE=$(date "+%Y-%m-%d")
VCS_REF=$(git lo -1|awk '{print $2}')
VER="3.21.0"

set -euo pipefail

docker build --no-cache \
  --platform linux/amd64,linux/arm64 \
  --build-arg BUILD_DATE=${BUILD_DATE} --build-arg VCS_REF=${VCS_REF} --build-arg VER=${VER} \
  -t arruor/php-8.0:latest \
  -t arruor/php-8.0:${TAG_LONG} \
  -t arruor/php-8.0:${TAG_SHORT} \
  .

if [ ${?} -ne 0 ]; then
  exit ${?}
fi

docker push arruor/php-8.0:latest
docker push arruor/php-8.0:${TAG_LONG}
docker push arruor/php-8.0:${TAG_SHORT}
