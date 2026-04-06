#!/usr/bin/env bash

set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REGISTRY="hub.lhr.stackcp.net/20i"
PUSH=1
PLATFORMS_PUSH="linux/amd64,linux/arm64"
LOCAL_PLATFORM=""
SKIP_LIST=""
ONLY_LIST=""

usage() {
    cat <<'EOF'
Usage: ./build.sh [options]

Options:
  --skip a,b,c   Skip one or more images
  --only a,b,c   Build only the listed images
  --no-push      Build locally only, do not push to Harbour
  -h, --help     Show this help

Known image keys:
  base
  haproxy
  httpd
  mariadb
  pdns
  pdns-recursor
  php-8.0
  php-8.3-cli
  php-8.3-fpm
  php-dev
EOF
}

normalize_csv() {
    local value="${1:-}"
    value="${value// /}"
    value="${value,,}"
    echo "$value"
}

csv_contains() {
    local needle="${1,,}"
    local haystack
    haystack="$(normalize_csv "${2:-}")"
    [[ ",${haystack}," == *",${needle},"* ]]
}

detect_local_platform() {
    local arch
    arch="$(uname -m)"
    case "${arch}" in
        x86_64|amd64) echo "linux/amd64" ;;
        aarch64|arm64) echo "linux/arm64" ;;
        *)
            echo "Unsupported local architecture: ${arch}" >&2
            exit 1
            ;;
    esac
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --skip)
            SKIP_LIST="${2:-}"
            shift 2
            ;;
        --only)
            ONLY_LIST="${2:-}"
            shift 2
            ;;
        --no-push)
            PUSH=0
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            usage >&2
            exit 1
            ;;
    esac
done

if [[ -n "${SKIP_LIST}" && -n "${ONLY_LIST}" ]]; then
    echo "Use either --skip or --only, not both." >&2
    exit 1
fi

if [[ "${PUSH}" -eq 0 ]]; then
    LOCAL_PLATFORM="$(detect_local_platform)"
fi

BUILD_DATE="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
VCS_REF="$(git -C "${ROOT_DIR}" rev-parse --short HEAD 2>/dev/null || echo 'nogit')"

declare -A IMAGE_NAME=(
    [base]="${REGISTRY}/alma"
    [haproxy]="${REGISTRY}/haproxy"
    [httpd]="${REGISTRY}/httpd"
    [mariadb]="${REGISTRY}/mariadb"
    [pdns]="${REGISTRY}/pdns"
    [pdns-recursor]="${REGISTRY}/pdns-recursor"
    [php-8.0]="${REGISTRY}/php-8.0"
    [php-8.3-cli]="${REGISTRY}/php-8.3-cli"
    [php-8.3-fpm]="${REGISTRY}/php-8.3-fpm"
    [php-dev]="${REGISTRY}/php-dev"
)

declare -A VERSION=(
    [base]="9.7"
    [haproxy]="3.3.6"
    [httpd]="2.4.66"
    [mariadb]="12.3.1"
    [pdns]="4.9"
    [pdns-recursor]="5.2"
    [php-8.0]="8.0.30-${VCS_REF}"
    [php-8.3-cli]="8.3.30-${VCS_REF}"
    [php-8.3-fpm]="8.3.30-${VCS_REF}"
    [php-dev]="8.3.30-${VCS_REF}"
)

declare -A CONTEXT=(
    [base]="base"
    [haproxy]="haproxy"
    [httpd]="httpd"
    [mariadb]="mariadb"
    [pdns]="pdns"
    [pdns-recursor]="pdns-recursor"
    [php-8.0]="php/8.0"
    [php-8.3-cli]="php/8.3/cli"
    [php-8.3-fpm]="php/8.3/fpm"
    [php-dev]="php/dev"
)

declare -A DOCKERFILE=(
    [base]="base/Dockerfile"
    [haproxy]="haproxy/Dockerfile"
    [httpd]="httpd/Dockerfile"
    [mariadb]="mariadb/Dockerfile"
    [pdns]="pdns/Dockerfile"
    [pdns-recursor]="pdns-recursor/Dockerfile"
    [php-8.0]="php/8.0/Dockerfile"
    [php-8.3-cli]="php/8.3/cli/Dockerfile"
    [php-8.3-fpm]="php/8.3/fpm/Dockerfile"
    [php-dev]="php/dev/Dockerfile"
)

declare -A VCS_URL=(
    [base]="https://github.com/arruor/docker-library/almalinux/base"
    [haproxy]="https://github.com/arruor/docker-library/almalinux/haproxy"
    [httpd]="https://github.com/arruor/docker-library/almalinux/httpd"
    [mariadb]="https://github.com/arruor/docker-library/almalinux/mariadb"
    [pdns]="https://github.com/arruor/docker-library/almalinux/pdns"
    [pdns-recursor]="https://github.com/arruor/docker-library/almalinux/pdns-recursor"
    [php-8.0]="https://github.com/arruor/docker-library/almalinux/php/8.0"
    [php-8.3-cli]="https://github.com/arruor/docker-library/almalinux/php/8.3/cli"
    [php-8.3-fpm]="https://github.com/arruor/docker-library/almalinux/php/8.3/fpm"
    [php-dev]="https://github.com/arruor/docker-library/almalinux/php/dev"
)

IMAGES=(
    base
    haproxy
    httpd
    mariadb
    pdns
    pdns-recursor
    php-8.0
    php-8.3-cli
    php-8.3-fpm
    php-dev
)

should_build() {
    local image="$1"

    if [[ -n "${ONLY_LIST}" ]]; then
        csv_contains "${image}" "${ONLY_LIST}"
        return
    fi

    if [[ -n "${SKIP_LIST}" ]] && csv_contains "${image}" "${SKIP_LIST}"; then
        return 1
    fi

    return 0
}

ensure_builder() {
    if ! docker buildx inspect multiarch-builder >/dev/null 2>&1; then
        docker buildx create --name multiarch-builder --driver docker-container --use >/dev/null
    else
        docker buildx use multiarch-builder >/dev/null
    fi
    docker buildx inspect --bootstrap >/dev/null
}

build_image() {
    local key="$1"
    local args=(
        docker buildx build
        --pull
        --build-arg "BUILD_DATE=${BUILD_DATE}"
        --build-arg "VCS_REF=${VCS_REF}"
        --build-arg "VERSION=${VERSION[${key}]}"
        --build-arg "VCS_URL=${VCS_URL[${key}]}"
        -t "${IMAGE_NAME[${key}]}:${VERSION[${key}]}"
        -t "${IMAGE_NAME[${key}]}:latest"
        -f "${ROOT_DIR}/${DOCKERFILE[${key}]}"
    )

    if [[ "${PUSH}" -eq 1 ]]; then
        args+=(--platform "${PLATFORMS_PUSH}" --push)
    else
        args+=(--platform "${LOCAL_PLATFORM}" --load)
    fi

    args+=("${ROOT_DIR}/${CONTEXT[${key}]}")

    echo
    echo "==> Building ${key}"
    echo "    Image: ${IMAGE_NAME[${key}]}"
    echo "    Version: ${VERSION[${key}]}"
    "${args[@]}"
}

main() {
    export DOCKER_BUILDKIT=1

    ensure_builder

    for image in "${IMAGES[@]}"; do
        if should_build "${image}"; then
            build_image "${image}"
        else
            echo "==> Skipping ${image}"
        fi
    done
}

main "$@"
