#!/bin/sh

# ./configure --target-list=aarch64-softmmu --disable-werror --with-git-submodules=validate

docker compose run --rm hw1 sh -c '
  cd qemu
  make -j$(nproc)
  make install
'
