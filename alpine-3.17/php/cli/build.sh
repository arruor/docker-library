#!/usr/bin/env bash

docker build -t arruor/php-cli:latest \
  -t arruor/php-cli:8.2.5 \
  -t arruor/php-cli:8.2 \
  -t arruor/php-cli:8 \
  .

if [ ${?} -ne 0 ]; then
  exit ${?}
fi

docker push arruor/php-cli:latest
docker push arruor/php-cli:8.2.5
docker push arruor/php-cli:8.2
docker push arruor/php-cli:8
