#!/usr/bin/env bash

set -euo pipefail

VERSION="3.2.9"
IMAGE_NAME="hub.lhr.stackcp.net/20i/haproxy"
BUILD_DATE=$(date "+%Y-%m-%d")
VCS_REF=$(git rev-parse --short HEAD)
VCS_URL="https://github.com/arruor/docker-library/almalinux/haproxy"

docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --build-arg BUILD_DATE="${BUILD_DATE}" \
  --build-arg VCS_REF="${VCS_REF}" \
  --build-arg VERSION="${VERSION}" \
  --build-arg VCS_URL="${VCS_URL}" \
  --push \
  -t "${IMAGE_NAME}:${VERSION}" \
  -t "${IMAGE_NAME}:latest" \
  -f Dockerfile .
