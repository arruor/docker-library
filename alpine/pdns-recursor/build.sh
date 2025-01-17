#!/usr/bin/env bash

TAG_SHORT=5.1
TAG_LONG=5.1.3

BUILD_DATE=$(date "+%Y-%m-%d")
VCS_REF=$(git lo -1|awk '{print $2}')
VER="3.21.0"

set -euo pipefail

docker build --no-cache \
 --platform linux/amd64,linux/arm64 \
 --build-arg BUILD_DATE=${BUILD_DATE} --build-arg VCS_REF=${VCS_REF} --build-arg VER=${VER} \
 -t arruor/pdns-recursor:latest -t arruor/pdns-recursor:${TAG_SHORT} -t arruor/pdns-recursor:${TAG_LONG} .

if [ ${?} -ne 0 ]; then
  exit ${?}
fi

docker push arruor/pdns-recursor:latest
docker push arruor/pdns-recursor:${TAG_LONG}
docker push arruor/pdns-recursor:${TAG_SHORT}
