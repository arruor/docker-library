#!/usr/bin/env bash
TAG_SHORT=3.21
TAG_LONG=3.21.0
BUILD_DATE=$(date "+%Y-%m-%d")
VCS_REF=$(git lo -1|awk '{print $2}')

docker build --no-cache \
  --build-arg BUILD_DATE=${BUILD_DATE} --build-arg VCS_REF=${VCS_REF} \
  -t arruor/alpine:latest -t arruor/alpine:${TAG_SHORT} -t arruor/alpine:${TAG_LONG} .

if [ ${?} -ne 0 ]; then
  exit ${?}
fi

docker push arruor/alpine:latest
docker push arruor/alpine:${TAG_SHORT}
docker push arruor/alpine:${TAG_LONG}
