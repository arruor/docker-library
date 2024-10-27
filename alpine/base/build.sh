#!/usr/bin/env bash
TAG_SHORT=3.20
TAG_LONG=3.20.3
docker build --no-cache -t arruor/alpine:latest -t arruor/alpine:${TAG_SHORT} -t arruor/alpine:${TAG_LONG} .

if [ ${?} -ne 0 ]; then
  exit ${?}
fi

docker push arruor/alpine:latest
docker push arruor/alpine:${TAG_SHORT}
docker push arruor/alpine:${TAG_LONG}
