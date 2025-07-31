#!/usr/bin/env bash

set -euo pipefail

TAG_SHORT=9
TAG_LONG="9.6"
VERSION="1.0.1"
TAG_BASE="hub.lhr.stackcp.net/20i/alma"
BUILD_DATE=$(date "+%Y-%m-%d")
VCS_REF=$(git lo -1|awk '{print $2}')

docker build --no-cache \
  --platform linux/amd64,linux/arm64 \
  --build-arg BUILD_DATE=${BUILD_DATE} \
  --build-arg VCS_REF=${VCS_REF} \
  --build-arg VERSION=${VERSION} \
  -t ${TAG_BASE}:latest \
  -t ${TAG_BASE}:${TAG_SHORT} \
  -t ${TAG_BASE}:${TAG_LONG} .

if [ ${?} -ne 0 ]; then
  exit ${?}
fi

docker push ${TAG_BASE}:latest
docker push ${TAG_BASE}:${TAG_SHORT}
docker push ${TAG_BASE}:${TAG_LONG}
