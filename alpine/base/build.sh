#!/usr/bin/env bash
docker build --no-cache -t arruor/alpine:latest -t arruor/alpine:3.19 -t arruor/alpine:3.19.0 .

if [ ${?} -ne 0 ]; then
  exit ${?}
fi

docker push arruor/alpine:latest
docker push arruor/alpine:3.19
docker push arruor/alpine:3.19.0
