#/!bin/bash

pkg_download() {
    local src="$1"
    local dst="$2"
    wget -q "$src" -O "$dst"
}

pkg_exists() {
    local pkg="$1"
    local version="$2"
    local arch="$3"
    [ -z "$arch" ] && arch="amd64"
    apt-cache policy "${pkg}" 2>/dev/null | grep "${version}"
    return $?
}

pkg_build() {
    local pkg="$1"
    local version="$2"
    local arch="$3"

    echo "Building Debian package ${pkg} for version ${version} (${arch}) ..."
    cat > ${pkg}/debian/changelog <<EOF
${pkg} (${version}) unstable; urgency=medium

  * Upstream v${version} release

 -- The Kowabunga Project <maintainers@kowabunga.cloud>  $(date -R)
EOF

    sed -i "s%^Architecture: .*%Architecture: ${arch}%g" ${pkg}/debian/control
    cd ${pkg}
    DEB_BUILD_OPTIONS="nocheck nostrip" dpkg-buildpackage -b -d --host-arch ${arch}
    rm -rf debian/.debhelper
    rm -f debian/debhelper-build-stamp
    rm -f debian/files
    rm -f debian/${pkg}.postinst.debhelper
    rm -f debian/${pkg}.postrm.debhelper
    rm -f debian/${pkg}.prerm.debhelper
    rm -f debian/${pkg}.substvars
    rm -rf debian/${pkg}
    cd ..
    echo "Built up Debian packages ..."
}
