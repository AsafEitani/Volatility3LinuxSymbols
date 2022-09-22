#! /bin/bash
echo "installing linux-image-${VERSION}-dbgsym"
apt-get update -oAcquire::AllowInsecureRepositories=true && apt-get install $(apt-cache depends --recurse --no-recommends --no-suggests \ --no-conflicts --no-breaks --no-replaces --no-enhances \ --no-pre-depends linux-image-${VERSION}-dbgsym | grep "^\w")
dwarf2json/dwarf2json linux --elf /usr/lib/debug/boot/vmlinux-${VERSION} > /result/linux-image-${VERSION}.json
ls /result
