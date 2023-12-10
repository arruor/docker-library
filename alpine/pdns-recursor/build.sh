#!/usr/bin/env bash
docker build --no-cache -t arruor/pdns-recursor:latest -t arruor/pdns-recursor:4.9 -t arruor/pdns-recursor:4.9.2 .

if [ ${?} -ne 0 ]; then
  exit ${?}
fi

docker push arruor/pdns-recursor:latest
docker push arruor/pdns-recursor:4.9
docker push arruor/pdns-recursor:4.9.2
