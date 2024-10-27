#!/usr/bin/env bash

TAG_SHORT=4.9
TAG_LONG=4.9.2

set -euo pipefail

docker build --no-cache -t arruor/pdns:latest -t arruor/pdns:${TAG_SHORT} -t arruor/pdns:${TAG_LONG} .

if [ ${?} -ne 0 ]; then
  exit ${?}
fi

docker push arruor/pdns:latest
docker push arruor/pdns:${TAG_SHORT}
docker push arruor/pdns:${TAG_LONG}
