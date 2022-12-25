#!/bin/sh
set -ex
apk update
apk add linux-headers automake libtool autoconf make musl-dev gcc libmnl-dev libmnl-static libnetfilter_queue-dev ca-certificates git
mkdir -p /mnt/out

# Build libnfnetlink static lib
git clone git://git.netfilter.org/libnfnetlink
cd libnfnetlink
git checkout libnfnetlink-1.0.2
autoupdate
./autogen.sh
./configure --enable-static
make
cp ./src/.libs/libnfnetlink.a ../mnt/out/

cd ..
# Build libnetfilter_queue static lib
git clone git://git.netfilter.org/libnetfilter_queue
cd libnetfilter_queue
git checkout libnetfilter_queue-1.0.5
autoupdate
./autogen.sh
./configure --enable-static
make
cp ./src/.libs/libnetfilter_queue.a ../mnt/out/