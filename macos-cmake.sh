#!/bin/sh
rm -rf ./build ./CMakeCache.txt ./CMakeFiles
(cd src && rm -rf ./build ./CMakeCache.txt ./CMakeFiles)
#
arch="x86_64"
#
cmake  \
    -DTQSLLIB_STATIC=ON \
    -DBUILD_ALL_EXTRAPROGS=YES \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_OSX_ARCHITECTURES="${arch}" \
    -DBDB_PREFIX=/usr/local/opt/berkeley-db \
    -DOPENSSL_ROOT_DIR=/usr/local/opt/openssl@1.1 \
    -DOSX_ARCH="${arch}" \
    .
