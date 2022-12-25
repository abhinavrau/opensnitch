#!/bin/sh
set -ex
apk update
apk add linux-headers make musl-dev gcc go libmnl-static libpcap-dev libnetfilter_queue-dev ca-certificates git

mkdir /go
export GOPATH=/go
mkdir -p /go/src/github.com/abhinavrau
mkdir -p /mnt/out
cp -a /mnt /go/src/github.com/abhinavrau/opensnitch
cd /go/src/github.com/abhinavrau/opensnitch

git config --global --add safe.directory /go/src/github.com/abhinavrau/opensnitch
cd proto && make
cd ..
cd daemon
go get -v ./ ./
rm -f opensnitchd
cp /mnt/out/libnetfilter_queue.a /usr/lib
cp /mnt/out/libnfnetlink.a /usr/lib
go build --ldflags '-linkmode external -extldflags "-static -s -w"' -v -o opensnitchd
cp ./opensnitchd /mnt/out/