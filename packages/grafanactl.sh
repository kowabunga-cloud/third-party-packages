#!/bin/bash

VERSION="0.1.3"
PKG="grafanactl"
ARCH=("amd64" "arm64")

do_download() {
    pkg="$1"
    arch="$2"
    rm -rf ${pkg}/bin
    mkdir -p ${pkg}/bin
    if [ ! -f ${pkg}/bin/${pkg} ]; then

        pkg_arch="${arch}"
        [ "${arch}" == "amd64" ] && pkg_arch="x86_64"
        pkg_download "https://github.com/grafana/grafanactl/releases/download/v${VERSION}/${pkg}_Linux_${pkg_arch}.tar.gz" "${pkg}/${pkg}.tar.gz"
        tar xvzf ${pkg}/${pkg}.tar.gz -C ${pkg}/bin
        rm -f ${pkg}/${pkg}.tar.gz
    fi
}

# module entry point
run() {
    for arch in "${ARCH[@]}"; do
        pkg_exists $PKG $VERSION "${arch}"
        if [ $? -ne 0 ]; then
            do_download $PKG $arch
            pkg_build $PKG $VERSION $arch
        fi
    done
}
