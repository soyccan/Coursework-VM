#!/bin/sh

O=build-vhost
CONFIG=../linux_configs/vhost

mkdir -p "$O"
cp "$CONFIG" "$O"/.config
"${0%/*}/_make" O="$O" olddefconfig

"${0%/*}/_make" O="$O" -j$(nproc) "$@"
