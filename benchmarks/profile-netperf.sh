#!/bin/sh

# should be run on KVM host

HOST_IP=${HOST_IP:-192.168.0.101}
GUEST_IP=${GUEST_IP:-192.168.0.105}

if [ "$1" = host ]; then
    echo "Host IP is ${HOST_IP}"
    "${0%/*}/kvmperf/cmdline_tests/netperf.sh" "${HOST_IP}" "$@" | tee netperf.txt
else
    echo "Guest IP is ${GUEST_IP}"
    if ! ping -c 3 "${GUEST_IP}"; then
        echo ping $GUEST_IP failed
        exit 1
    fi
    "${0%/*}/kvmperf/cmdline_tests/netperf.sh" "${GUEST_IP}" "$@" | tee netperf.txt
fi
