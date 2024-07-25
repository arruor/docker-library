#!/usr/bin/env bash
docker build --no-cache -t arruor/pdns-recursor:latest -t arruor/pdns-recursor:5.0 -t arruor/pdns-recursor:5.0.5 .

if [ ${?} -ne 0 ]; then
  exit ${?}
fi

docker push arruor/pdns-recursor:latest
docker push arruor/pdns-recursor:5.0.5
docker push arruor/pdns-recursor:5.0
docker push arruor/pdns-recursor:5
