#!/usr/bin/env bash
docker build --no-cache -t arruor/pdns:latest -t arruor/pdns:4.8 -t arruor/pdns:4.8.3 .

if [ ${?} -ne 0 ]; then
  exit ${?}
fi

docker push arruor/pdns:latest
docker push arruor/pdns:4.8
docker push arruor/pdns:4.8.3
