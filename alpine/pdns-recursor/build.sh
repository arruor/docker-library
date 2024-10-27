#!/usr/bin/env bash

TAG_SHORT=5.0
TAG_LONG=5.09

set -euo pipefail

docker build --no-cache -t arruor/pdns-recursor:latest -t arruor/pdns-recursor:${TAG_SHORT} -t arruor/pdns-recursor:${TAG_LONG} .

if [ ${?} -ne 0 ]; then
  exit ${?}
fi

docker push arruor/pdns-recursor:latest
docker push arruor/pdns-recursor:${TAG_LONG}
docker push arruor/pdns-recursor:${TAG_SHORT}
