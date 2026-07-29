#!/bin/bash

set -euo pipefail

GCC_BPF_INSTALLDIR=$1

binutils_version=$(ls "${GCC_BPF_INSTALLDIR}" | grep "binutils.*built" | sed 's/.built//')
gcc_version=$(ls "${GCC_BPF_INSTALLDIR}" | grep "gcc.*built" | sed 's/.built//')
built_release_tag="${gcc_version}-${binutils_version}"

if [[ -z "$gcc_version" || -z "$binutils_version" ]]; then
    echo "Could not determine built release tag"
    exit 1
fi

# Skip if this exact release already exists. Checking the specific tag (rather than
# only the most recent release) is required now that multiple GCC versions (e.g. 15
# and 16) are published to this repo, so "latest" may belong to a different series.
if gh release view "$built_release_tag" -R theihor/gcc-bpf >/dev/null 2>&1; then
    echo "Release with tag $built_release_tag already exists"
    exit 0
fi

cd $(dirname $(realpath $GCC_BPF_INSTALLDIR))
tar -I "zstd -19 -T0" -cf ${built_release_tag}.tar.zst $(basename $(realpath $GCC_BPF_INSTALLDIR))

# assume access to gh and upload a new release
gh release create ${built_release_tag} ./${built_release_tag}.tar.zst -p

