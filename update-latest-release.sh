#!/bin/bash

set -euo pipefail

GCC_BPF_INSTALLDIR=$1

latest_release_tag=$(gh release list -L 1 -R theihor/gcc-bpf --json tagName -q .[].tagName)

binutils_version=$(ls "${GCC_BPF_INSTALLDIR}" | grep "binutils.*built" | sed 's/.built//')
gcc_version=$(ls "${GCC_BPF_INSTALLDIR}" | grep "gcc.*built" | sed 's/.built//')
built_release_tag="${gcc_version}-${binutils_version}"

if [[ "$latest_release_tag" == "$built_release_tag" ]]; then
    echo "Release with tag $latest_release_tag already exists"
    exit 0
fi

if [[ -z "$built_release_tag" ]]; then
    echo "Could not determine built release tag"
    exit 1
fi

cd $(dirname $(realpath $GCC_BPF_INSTALLDIR))
tar -I "zstd -19 -T0" -cf ${built_release_tag}.tar.zst $(basename $(realpath $GCC_BPF_INSTALLDIR))

# assume access to gh and upload a new release
gh release create ${built_release_tag} ./${built_release_tag}.tar.zst -p

