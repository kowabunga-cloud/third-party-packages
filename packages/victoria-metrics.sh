#!/bin/bash

VERSION="1.125.0"
PKG="victoria-metrics"
ARCH=("amd64" "arm64")

do_download() {
    pkg="$1"
    arch="$2"
    rm -rf ${pkg}/bin
    mkdir -p ${pkg}/bin
    if [ ! -f ${pkg}/bin/${pkg} ]; then
        # Server
        pkg_download "https://github.com/VictoriaMetrics/VictoriaMetrics/releases/download/v${VERSION}/${pkg}-linux-${arch}-v${VERSION}.tar.gz" "${pkg}/${pkg}.tar.gz"
        tar xvzf ${pkg}/${pkg}.tar.gz -C ${pkg}/bin
        rm -f ${pkg}/${pkg}.tar.gz

        # Utils
        pkg_download "https://github.com/VictoriaMetrics/VictoriaMetrics/releases/download/v${VERSION}/vmutils-linux-${arch}-v${VERSION}.tar.gz" "${pkg}/${pkg}.tar.gz"
        tar xvzf ${pkg}/${pkg}.tar.gz -C ${pkg}/bin
        rm -f ${pkg}/${pkg}.tar.gz

        # rename files
        for filename in ${pkg}/bin/*; do
            mv "$filename" "${filename//-prod/}"
        done
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
