#!/usr/bin/env bash

TAG_SHORT=4.9
TAG_LONG=4.9.2
BUILD_DATE=$(date "+%Y-%m-%d")
VCS_REF=$(git lo -1|awk '{print $2}')
VER="3.21.0"

set -euo pipefail

docker build --no-cache \
 --build-arg BUILD_DATE=${BUILD_DATE} --build-arg VCS_REF=${VCS_REF} --build-arg VER=${VER} \
 -t arruor/pdns:latest -t arruor/pdns:${TAG_SHORT} -t arruor/pdns:${TAG_LONG} .

if [ ${?} -ne 0 ]; then
  exit ${?}
fi

docker push arruor/pdns:latest
docker push arruor/pdns:${TAG_SHORT}
docker push arruor/pdns:${TAG_LONG}
