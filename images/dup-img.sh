#!/bin/sh

cp -f ubuntu-20.04-server-cloudimg-arm64.img ubuntu-20.04-server-cloudimg-arm64.qcow2
qemu-img resize ubuntu-20.04-server-cloudimg-arm64.qcow2 25G

cp -f ubuntu-20.04-server-cloudimg-arm64.img ubuntu-20.04-server-cloudimg-arm64.1.qcow2
