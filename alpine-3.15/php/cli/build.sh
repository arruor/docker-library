#!/usr/bin/env bash
docker build \
  -t arruor/php:8.1.1-cli-alpine3.15 \
  -t arruor/php:8.1-cli-alpine3.15 \
  -t arruor/php:8-cli-alpine3.15 \
  -t arruor/php:li-alpine3.15 \
  -t arruor/php:8.1.1-alpine3.15 \
  -t arruor/php:8.1-alpine3.15 \
  -t arruor/php:8-alpine3.15 \
  -t arruor/php:alpine3.15 \
  -t arruor/php:8.1.1-cli-alpine \
  -t arruor/php:8.1-cli-alpine \
  -t arruor/php:8-cli-alpine \
  -t arruor/php:cli-alpine \
  -t arruor/php:8.1.1-alpine \
  -t arruor/php:8.1-alpine \
  -t arruor/php:8-alpine \
  -t alpine \
  .

if [ ${?} -ne 0 ]; then
  exit ${?}
fi

docker push arruor/php:8.1.1-cli-alpine3.15
docker push arruor/php:8.1-cli-alpine3.15
docker push arruor/php:8-cli-alpine3.15
docker push arruor/php:cli-alpine3.15
docker push arruor/php:8.1.1-alpine3.15
docker push arruor/php:8.1-alpine3.15
docker push arruor/php:8-alpine3.15
docker push arruor/php:alpine3.15
docker push arruor/php:8.1.1-cli-alpine
docker push arruor/php:8.1-cli-alpine
docker push arruor/php:8-cli-alpine
docker push arruor/php:cli-alpine
docker push arruor/php:8.1.1-alpine
docker push arruor/php:8.1-alpine
docker push arruor/php:8-alpine
docker push arruor/php:alpine