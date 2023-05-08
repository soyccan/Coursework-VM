#!/bin/sh

CLANG="$(IFS=: && find $PATH -xtype f -executable -name 'clang-[0-9]*')"
O=build-nohuge
CONFIG=../linux_configs/vhost_no_transp_hugepage

mkdir -p "$O"
cp "$CONFIG" "$O"/.config
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- ${CLANG:+CC="${CLANG}"} O="$O" olddefconfig

make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- ${CLANG:+CC="${CLANG}"} O="$O" -j$(nproc) "$@"
