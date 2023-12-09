#!/usr/bin/env bash

set -euo pipefail

docker build --no-cache -t arruor/haproxy:latest -t arruor/haproxy:2.8 -t arruor/haproxy:2.8.5 .

if [ ${?} -ne 0 ]; then
  exit ${?}
fi

docker push arruor/haproxy:2.8.5
docker push arruor/haproxy:2.8
docker push arruor/haproxy:latest