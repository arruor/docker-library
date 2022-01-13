#!/usr/bin/env bash
docker build -t arruor/php:8.1.1-fpm-alpine3.15 -t arruor/php:8.1-fpm-alpine3.15 -t arruor/php:8-fpm-alpine3.15 -t arruor/php:fpm-alpine3.15 -t arruor/php:8.1.1-fpm-alpine -t arruor/php:8.1-fpm-alpine -t arruor/php:8-fpm-alpine -t arruor/php:fpm-alpine .

if [ ${?} -ne 0 ]; then
  exit ${?}
fi

docker push arruor/php:8.1.1-fpm-alpine3.15
docker push arruor/php:8.1-fpm-alpine3.15
docker push arruor/php:8-fpm-alpine3.15
docker push arruor/php:fpm-alpine3.15
docker push arruor/php:8.1.1-fpm-alpine
docker push arruor/php:8.1-fpm-alpine
docker push arruor/php:8-fpm-alpine
docker push arruor/php:fpm-alpine