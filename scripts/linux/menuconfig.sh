#!/bin/sh

CLANG="$(IFS=: && find $PATH -xtype f -executable -name 'clang-[0-9]*')"

make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- ${CLANG:+CC="${CLANG}"} menuconfig "$@"
