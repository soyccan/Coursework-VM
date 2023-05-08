#!/bin/sh

# should be run on KVM host

HOST_IP=${HOST_IP:-192.168.0.101}
GUEST_IP=${GUEST_IP:-192.168.0.105}
REPEAT=${REPEAT:-3}

trap "exit" INT TERM
trap "kill -INT 0" EXIT

if [ "$1" = host ]; then
    echo "Host IP is ${HOST_IP}"
    "${0%/*}/kvmperf/cmdline_tests/apache.sh" "${HOST_IP}" "${REPEAT}" | tee apache.txt
else
    echo "Guest IP is ${GUEST_IP}"
    if ! ping -c 3 "${GUEST_IP}"; then
        echo ping $GUEST_IP failed
        exit 1
    fi

    # kvm_stat -l > kvm_stat.csv &

    "${0%/*}/kvmperf/cmdline_tests/apache.sh" "${GUEST_IP}" "${REPEAT}" | tee apache.txt
fi
