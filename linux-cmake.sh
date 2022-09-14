#!/bin/sh
rm -rf ./build ./CMakeCache.txt ./CMakeFiles
(cd src && rm -rf ./build ./CMakeCache.txt ./CMakeFiles)
#
cmake  \
    -DTQSLLIB_STATIC=ON \
    -DBUILD_ALL_EXTRAPROGS=YES \
    -DCMAKE_BUILD_TYPE=Debug \
    .
