#!/usr/bin/env bash

set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REGISTRY="${REGISTRY:-docker.io/arruor}"
PUSH=1
PLATFORMS="${PLATFORMS:-linux/amd64,linux/arm64}"
LOCAL_PLATFORM=""
SKIP_LIST=""
ONLY_LIST=""
REGISTRY_PREFIXES_CSV="${REGISTRY_PREFIXES:-${REGISTRY}}"
REGISTRY_PREFIXES=()

usage() {
    cat <<'EOF'
Usage: ./build.sh [options]

Options:
  --skip a,b,c              Skip one or more images
  --only a,b,c              Build only the listed images
  --no-push                 Build locally only, do not push
  --platforms a,b           Target platforms when pushing (default: linux/amd64,linux/arm64)
  --registries a,b          Registry prefixes to tag/push, for example:
                            docker.io/arruor,quay.io/arruor,ghcr.io/arruor,gitlab.local/arruor,harbor.local/arruor
  --registry prefix         Add one registry prefix; can be repeated
  --docker-hub namespace    Add Docker Hub namespace as docker.io/<namespace>
  --quay namespace          Add Red Hat Quay namespace as quay.io/<namespace>
  --ghcr owner              Add GitHub Container Registry owner as ghcr.io/<owner>
  --gitlab prefix           Add GitLab registry prefix, e.g. registry.gitlab.local/group/project
  --harbor prefix           Add Harbor registry prefix, e.g. hub.lhr.stackcp.net/20i
  -h, --help                Show this help

Known image keys:
  base
  haproxy
  mariadb
  pdns
  pdns-recursor
  php-8.0
  php-cli
  php-fpm
EOF
}

normalize_csv() {
    local value="${1:-}"
    value="${value// /}"
    value="${value,,}"
    echo "$value"
}

trim_slashes() {
    local value="${1:-}"
    value="${value%/}"
    echo "$value"
}

add_registry_prefix() {
    local prefix
    prefix="$(trim_slashes "${1:-}")"
    if [[ -n "${prefix}" ]]; then
        REGISTRY_PREFIXES+=("${prefix}")
    fi
}

add_registry_prefixes_csv() {
    local csv="${1:-}"
    local item
    local -a items
    csv="${csv// /}"
    IFS=',' read -r -a items <<< "${csv}"
    for item in "${items[@]}"; do
        add_registry_prefix "${item}"
    done
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
        --platforms)
            PLATFORMS="${2:-}"
            shift 2
            ;;
        --registries)
            REGISTRY_PREFIXES_CSV="${2:-}"
            REGISTRY_PREFIXES=()
            add_registry_prefixes_csv "${REGISTRY_PREFIXES_CSV}"
            REGISTRY_PREFIXES_CSV=""
            shift 2
            ;;
        --registry)
            add_registry_prefix "${2:-}"
            shift 2
            ;;
        --docker-hub)
            add_registry_prefix "docker.io/${2:-}"
            shift 2
            ;;
        --quay)
            add_registry_prefix "quay.io/${2:-}"
            shift 2
            ;;
        --ghcr)
            add_registry_prefix "ghcr.io/${2:-}"
            shift 2
            ;;
        --gitlab)
            add_registry_prefix "${2:-}"
            shift 2
            ;;
        --harbor)
            add_registry_prefix "${2:-}"
            shift 2
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

if [[ "${#REGISTRY_PREFIXES[@]}" -eq 0 ]]; then
    add_registry_prefixes_csv "${REGISTRY_PREFIXES_CSV}"
fi

if [[ "${#REGISTRY_PREFIXES[@]}" -eq 0 ]]; then
    echo "At least one registry prefix is required." >&2
    exit 1
fi

if [[ "${PUSH}" -eq 0 ]]; then
    LOCAL_PLATFORM="$(detect_local_platform)"
fi

BUILD_DATE="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
VCS_REF="$(git -C "${ROOT_DIR}" rev-parse --short HEAD 2>/dev/null || echo 'nogit')"

declare -A IMAGE_REPO=(
    [base]="alpine"
    [haproxy]="haproxy"
    [mariadb]="mariadb"
    [pdns]="pdns"
    [pdns-recursor]="pdns-recursor"
    [php-8.0]="php-8.0"
    [php-cli]="php-cli"
    [php-fpm]="php-fpm"
)

declare -A VERSION=(
    [base]="3.21.2"
    [haproxy]="3.1.3"
    [mariadb]="11.4.4"
    [pdns]="4.9.2"
    [pdns-recursor]="5.1.3"
    [php-8.0]="8.0.30"
    [php-cli]="8.4.4"
    [php-fpm]="8.4.4"
)

declare -A SHORT_VERSION=(
    [base]="3.21"
    [haproxy]="3.1"
    [mariadb]="11.4"
    [pdns]="4.9"
    [pdns-recursor]="5.1"
    [php-8.0]="8.0"
    [php-cli]="8.4"
    [php-fpm]="8.4"
)

declare -A EXTRA_TAGS=(
    [php-cli]="8"
    [php-fpm]="8"
)

declare -A CONTEXT=(
    [base]="base"
    [haproxy]="haproxy"
    [mariadb]="mariadb"
    [pdns]="pdns"
    [pdns-recursor]="pdns-recursor"
    [php-8.0]="php/8.0"
    [php-cli]="php/cli"
    [php-fpm]="php/fpm"
)

declare -A DOCKERFILE=(
    [base]="base/Dockerfile"
    [haproxy]="haproxy/Dockerfile"
    [mariadb]="mariadb/Dockerfile"
    [pdns]="pdns/Dockerfile"
    [pdns-recursor]="pdns-recursor/Dockerfile"
    [php-8.0]="php/8.0/Dockerfile"
    [php-cli]="php/cli/Dockerfile"
    [php-fpm]="php/fpm/Dockerfile"
)

declare -A VCS_URL=(
    [base]="https://github.com/arruor/docker-library/alpine/base"
    [haproxy]="https://github.com/arruor/docker-library/alpine/haproxy"
    [mariadb]="https://github.com/arruor/docker-library/alpine/mariadb"
    [pdns]="https://github.com/arruor/docker-library/alpine/pdns"
    [pdns-recursor]="https://github.com/arruor/docker-library/alpine/pdns-recursor"
    [php-8.0]="https://github.com/arruor/docker-library/alpine/php/8.0"
    [php-cli]="https://github.com/arruor/docker-library/alpine/php/cli"
    [php-fpm]="https://github.com/arruor/docker-library/alpine/php/fpm"
)

IMAGES=(
    base
    haproxy
    mariadb
    pdns
    pdns-recursor
    php-8.0
    php-cli
    php-fpm
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

image_ref() {
    local prefix="$1"
    local key="$2"
    echo "${prefix}/${IMAGE_REPO[${key}]}"
}

base_image_for() {
    local key="$1"
    local primary="${REGISTRY_PREFIXES[0]}"

    case "${key}" in
        base) echo "docker.io/library/alpine:3.21" ;;
        *) echo "$(image_ref "${primary}" base):${VERSION[base]}" ;;
    esac
}

build_image() {
    local key="$1"
    local args=(
        docker buildx build
        --pull
        --build-arg "BASE_IMAGE=$(base_image_for "${key}")"
        --build-arg "BUILD_DATE=${BUILD_DATE}"
        --build-arg "VCS_REF=${VCS_REF}"
        --build-arg "VERSION=${VERSION[${key}]}"
        --build-arg "VCS_URL=${VCS_URL[${key}]}"
        -f "${ROOT_DIR}/${DOCKERFILE[${key}]}"
    )
    local prefix
    local image_ref_value
    local tag

    for prefix in "${REGISTRY_PREFIXES[@]}"; do
        image_ref_value="$(image_ref "${prefix}" "${key}")"
        args+=(
            -t "${image_ref_value}:${VERSION[${key}]}"
            -t "${image_ref_value}:${SHORT_VERSION[${key}]}"
            -t "${image_ref_value}:latest"
        )
        for tag in ${EXTRA_TAGS[${key}]:-}; do
            args+=(-t "${image_ref_value}:${tag}")
        done
    done

    if [[ "${PUSH}" -eq 1 ]]; then
        args+=(--platform "${PLATFORMS}" --push)
    else
        args+=(--platform "${LOCAL_PLATFORM}" --load)
    fi

    args+=("${ROOT_DIR}/${CONTEXT[${key}]}")

    echo
    echo "==> Building ${key}"
    echo "    Image: $(image_ref "${REGISTRY_PREFIXES[0]}" "${key}")"
    echo "    Version: ${VERSION[${key}]}"
    echo "    Base: $(base_image_for "${key}")"
    echo "    Registries: ${REGISTRY_PREFIXES[*]}"
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
