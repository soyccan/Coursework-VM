#!/bin/sh

O=build-nohuge
CONFIG=../linux_configs/vhost_no_transp_hugepage

mkdir -p "$O"
cp "$CONFIG" "$O"/.config
"${0%/*}/_make" O="$O" olddefconfig

"${0%/*}/_make" O="$O" -j$(nproc) "$@"
