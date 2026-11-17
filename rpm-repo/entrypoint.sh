#!/usr/bin/bash
set -Eeuo pipefail

repo_root=/srv/repo

if [[ ! -d "${repo_root}" ]]; then
    echo "Repository directory ${repo_root} does not exist" >&2
    exit 1
fi

# Remove metadata from previous layouts too, including directories that no
# longer contain RPMs, then build a fresh index for every current RPM folder.
find "${repo_root}" -type d -name repodata -prune -exec rm -rf -- {} +

mapfile -t package_dirs < <(find "${repo_root}" -type f -name '*.rpm' -printf '%h\n' | sort -u)

if ((${#package_dirs[@]} == 0)); then
    echo "No RPM files found under ${repo_root}; serving the empty repository tree" >&2
else
    for package_dir in "${package_dirs[@]}"; do
        echo "Generating repository metadata in ${package_dir}"
        createrepo_c "${package_dir}"
    done
fi

exec python3 -m http.server 8080 --bind 0.0.0.0 --directory "${repo_root}"
