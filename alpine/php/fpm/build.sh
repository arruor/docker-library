#!/usr/bin/env bash

docker build --no-cache -t arruor/php-fpm:latest \
    -t arruor/php-fpm:8.2.12 \
    -t arruor/php-fpm:8.2 \
    -t arruor/php-fpm:8 \
    .

if [ ${?} -ne 0 ]; then
  exit ${?}
fi

docker push arruor/php-fpm:latest
docker push arruor/php-fpm:8.2.12
docker push arruor/php-fpm:8.2
docker push arruor/php-fpm:8
