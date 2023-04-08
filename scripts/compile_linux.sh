#!/bin/sh

# Configure:
#   make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- defconfig

# Compile
docker compose run --rm hw1 sh -c '
  cd linux
  make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- -j$(nproc)
'
