#!/usr/bin/env bash
docker build --no-cache -t arruor/haproxy:latest -t arruor/haproxy:2.8 -t arruor/haproxy:2.8.3 .

if [ ${?} -ne 0 ]; then
  exit ${?}
fi

docker push arruor/haproxy:2.8.3
docker push arruor/haproxy:2.8
docker push arruor/haproxy:latest