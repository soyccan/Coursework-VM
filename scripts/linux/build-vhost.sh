#!/bin/sh

CLANG="$(IFS=: && find $PATH -xtype f -executable -name 'clang-[0-9]*')"
O=build-vhost
CONFIG=../linux_configs/vhost

mkdir -p "$O"
cp "$CONFIG" "$O"/.config
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- ${CLANG:+CC="${CLANG}"} O="$O" olddefconfig

make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- ${CLANG:+CC="${CLANG}"} O="$O" -j$(nproc) "$@"
