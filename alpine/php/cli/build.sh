#!/usr/bin/env bash

docker build --no-cache -t arruor/php-cli:latest \
  -t arruor/php-cli:8.2.12 \
  -t arruor/php-cli:8.2 \
  -t arruor/php-cli:8 \
  .

if [ ${?} -ne 0 ]; then
  exit ${?}
fi

docker push arruor/php-cli:latest
docker push arruor/php-cli:8.2.12
docker push arruor/php-cli:8.2
docker push arruor/php-cli:8
