#!/usr/bin/env bash

set -euo pipefail

TAG_SHORT=9
TAG_LONG="9.5"
VER="9.5.202503"
TAG_BASE="arruor/almalinux"
BUILD_DATE=$(date "+%Y-%m-%d")
VCS_REF=$(git lo -1|awk '{print $2}')

docker build --no-cache \
  --platform linux/amd64,linux/arm64 \
  --build-arg BUILD_DATE=${BUILD_DATE} --build-arg VCS_REF=${VCS_REF} \
  --build-arg VER=${VER} \
  -t ${TAG_BASE}:latest -t ${TAG_BASE}:${TAG_SHORT} -t ${TAG_BASE}:${TAG_LONG} .

docker push ${TAG_BASE}:latest
docker push ${TAG_BASE}:${TAG_SHORT}
docker push ${TAG_BASE}:${TAG_LONG}
