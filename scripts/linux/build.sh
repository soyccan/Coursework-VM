#!/bin/sh

"${0%/*}/_make" "-j$(nproc)" "$@"
