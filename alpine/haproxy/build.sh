#!/usr/bin/env bash

TAG_SHORT=3.0
TAG_LONG=3.0.5

set -euo pipefail

docker build --no-cache -t arruor/haproxy:latest -t arruor/haproxy:${TAG_SHORT} -t arruor/haproxy:${TAG_LONG} .

if [ ${?} -ne 0 ]; then
  exit ${?}
fi

docker push arruor/haproxy:${TAG_LONG}
docker push arruor/haproxy:${TAG_SHORT}
docker push arruor/haproxy:latest
