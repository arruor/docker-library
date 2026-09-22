#!/usr/bin/env bash

set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REGISTRY="${REGISTRY:-hub.lhr.stackcp.net/20i}"
PUSH=1
PLATFORMS="${PLATFORMS:-linux/amd64,linux/arm64}"
LOCAL_PLATFORM=""
SKIP_LIST=""
ONLY_LIST=""
BUILDER="${BUILDER:-multiarch-builder}"
PROGRESS="${PROGRESS:-auto}"
CACHE_REF="${CACHE_REF:-}"
IMAGE_REVISION="${IMAGE_REVISION:-1}"
NO_CACHE=0
PUBLISH_LATEST=1
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
  --builder name            Buildx builder to use (default: multiarch-builder)
  --progress mode           Build output: auto, plain, tty, quiet, or rawjson
  --cache-ref ref           Registry cache prefix (default: <primary>/almalinux-buildcache)
  --no-cache                Ignore existing build cache and do not export a new cache
  --image-revision n        Immutable rebuild revision suffix (default: 1)
  --no-latest               Do not move the latest tag during this build
  --registries a,b          Registry prefixes to tag/push, for example:
                            docker.io/20i,quay.io/20i,ghcr.io/20i,gitlab.local/20i,harbor.local/20i
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
        --builder)
            BUILDER="${2:-}"
            shift 2
            ;;
        --progress)
            PROGRESS="${2:-}"
            shift 2
            ;;
        --cache-ref)
            CACHE_REF="${2:-}"
            shift 2
            ;;
        --no-cache)
            NO_CACHE=1
            shift
            ;;
        --image-revision)
            IMAGE_REVISION="${2:-}"
            shift 2
            ;;
        --no-latest)
            PUBLISH_LATEST=0
            shift
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

if [[ -z "${BUILDER}" ]]; then
    echo "A buildx builder name is required." >&2
    exit 1
fi

case "${PROGRESS}" in
    auto|plain|tty|quiet|rawjson) ;;
    *)
        echo "Unsupported progress mode: ${PROGRESS}" >&2
        exit 1
        ;;
esac

if ! [[ "${IMAGE_REVISION}" =~ ^[0-9]+$ ]]; then
    echo "Image revision must be a non-negative integer: ${IMAGE_REVISION}" >&2
    exit 1
fi

if [[ -z "${CACHE_REF}" ]]; then
    CACHE_REF="${REGISTRY_PREFIXES[0]}/almalinux-buildcache"
else
    CACHE_REF="$(trim_slashes "${CACHE_REF}")"
fi

if [[ "${PUSH}" -eq 0 ]]; then
    LOCAL_PLATFORM="$(detect_local_platform)"
fi

BUILD_DATE="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
VCS_REF="$(git -C "${ROOT_DIR}" rev-parse --short HEAD 2>/dev/null || echo 'nogit')"

declare -A IMAGE_REPO=(
    [base]="alma"
    [haproxy]="haproxy"
    [httpd]="httpd"
    [mariadb]="mariadb"
    [pdns]="pdns"
    [pdns-recursor]="pdns-recursor"
    [php-8.0]="php-8.0"
    [php-8.3-cli]="php-8.3-cli"
    [php-8.3-fpm]="php-8.3-fpm"
    [php-dev]="php-dev"
)

declare -A VERSION=(
    [base]="9.8"
    [haproxy]="3.4.2"
    [httpd]="2.4.68"
    [mariadb]="13.0.1"
    [pdns]="4.9"
    [pdns-recursor]="5.2"
    [php-8.0]="8.0.30"
    [php-8.3-cli]="8.3.32"
    [php-8.3-fpm]="8.3.32"
    [php-dev]="8.3.32"
)

# PHP image repositories are deliberately pinned to a PHP minor line by their
# repository name, so derive their floating tag from that line rather than
# exposing a misleading major-only tag such as php-8.0:8.
declare -A FLOATING_VERSION_LINE=(
    [php-8.0]="8.0"
    [php-8.3-cli]="8.3"
    [php-8.3-fpm]="8.3"
    [php-dev]="8.3"
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

floating_tags_for() {
    local key="$1"
    local version="${VERSION[${key}]}"
    local major="${version%%.*}"

    if [[ -n "${FLOATING_VERSION_LINE[${key}]:-}" ]]; then
        echo "${FLOATING_VERSION_LINE[${key}]}"
    elif [[ "${version}" == *.*.* ]]; then
        echo "${version%.*} ${major}"
    elif [[ "${version}" == *.* ]]; then
        echo "${major}"
    fi
}

ensure_builder() {
    if ! docker buildx inspect "${BUILDER}" >/dev/null 2>&1; then
        docker buildx create --name "${BUILDER}" --driver docker-container --use >/dev/null
    else
        docker buildx use "${BUILDER}" >/dev/null
    fi
    docker buildx inspect "${BUILDER}" --bootstrap >/dev/null
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
        base) echo "docker.io/library/almalinux:9" ;;
        php-dev) echo "$(image_ref "${primary}" php-8.3-cli):${VERSION[php-8.3-cli]}" ;;
        *) echo "$(image_ref "${primary}" base):${VERSION[base]}" ;;
    esac
}

build_image() {
    local key="$1"
    local immutable_tag="${VERSION[${key}]}-r${IMAGE_REVISION}"
    local args=(
        docker buildx build
        --pull
        --build-arg "BASE_IMAGE=$(base_image_for "${key}")"
        --build-arg "BUILD_DATE=${BUILD_DATE}"
        --build-arg "VCS_REF=${VCS_REF}"
        --build-arg "VERSION=${VERSION[${key}]}"
        --build-arg "VCS_URL=${VCS_URL[${key}]}"
        --progress "${PROGRESS}"
        -f "${ROOT_DIR}/${DOCKERFILE[${key}]}"
    )
    local prefix
    local image_ref_value
    local tag
    local -a floating_tags=()

    read -r -a floating_tags <<< "$(floating_tags_for "${key}")"

    for prefix in "${REGISTRY_PREFIXES[@]}"; do
        image_ref_value="$(image_ref "${prefix}" "${key}")"
        args+=(
            -t "${image_ref_value}:${VERSION[${key}]}"
            -t "${image_ref_value}:${immutable_tag}"
        )

        if [[ "${PUBLISH_LATEST}" -eq 1 ]]; then
            args+=(-t "${image_ref_value}:latest")
        fi

        for tag in "${floating_tags[@]}"; do
            [[ -n "${tag}" ]] && args+=(-t "${image_ref_value}:${tag}")
        done
    done

    # Registry cache keeps subsequent CI/ephemeral-builder runs fast without
    # adding cache layers to the published image. Keep one cache namespace per
    # image so unrelated Dockerfiles cannot evict one another's useful cache.
    if [[ "${NO_CACHE}" -eq 0 && "${PUSH}" -eq 1 ]]; then
        args+=(
            --cache-from "type=registry,ref=${CACHE_REF}/${key}"
            --cache-to "type=registry,ref=${CACHE_REF}/${key},mode=max,image-manifest=true,oci-mediatypes=true"
        )
    elif [[ "${NO_CACHE}" -eq 1 ]]; then
        args+=(--no-cache)
    fi

    if [[ "${PUSH}" -eq 1 ]]; then
        # Attestations are stored alongside the image manifest, not in the
        # runtime filesystem, so they improve provenance/SBOM coverage without
        # increasing the image's extracted layer size.
        args+=(
            --platform "${PLATFORMS}"
            --provenance=mode=max
            --sbom=true
            --push
        )
    else
        # Docker's local image store does not preserve multi-platform
        # attestations reliably; disable them for the intentionally local,
        # single-platform development path.
        args+=(
            --platform "${LOCAL_PLATFORM}"
            --provenance=false
            --sbom=false
            --load
        )
    fi

    args+=("${ROOT_DIR}/${CONTEXT[${key}]}")

    echo
    echo "==> Building ${key}"
    echo "    Image: $(image_ref "${REGISTRY_PREFIXES[0]}" "${key}")"
    echo "    Version: ${VERSION[${key}]}"
    echo "    Immutable tag: ${immutable_tag}"
    echo "    Latest tag: $([[ "${PUBLISH_LATEST}" -eq 1 ]] && echo enabled || echo disabled)"
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
