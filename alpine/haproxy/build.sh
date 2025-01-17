#!/usr/bin/env bash

TAG_SHORT=3.1
TAG_LONG=3.1.1
BUILD_DATE=$(date "+%Y-%m-%d")
VCS_REF=$(git lo -1|awk '{print $2}')
VER="3.21.0"

set -euo pipefail

docker build --no-cache \
 --platform linux/amd64,linux/arm64 \
 --build-arg BUILD_DATE=${BUILD_DATE} --build-arg VCS_REF=${VCS_REF} --build-arg VER=${VER} \
 -t arruor/haproxy:latest -t arruor/haproxy:${TAG_SHORT} -t arruor/haproxy:${TAG_LONG} .

if [ ${?} -ne 0 ]; then
  exit ${?}
fi

docker push arruor/haproxy:${TAG_LONG}
docker push arruor/haproxy:${TAG_SHORT}
docker push arruor/haproxy:latest
