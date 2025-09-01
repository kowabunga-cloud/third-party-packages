#!/bin/bash

PKG_DIR="packages"

source common.sh

cd $PKG_DIR
for pkg in *.sh; do
    source ${pkg}
    echo "Looking for changes in ${pkg%.*} Debian packaging ..."
    run # module entry point
done
cd ..
