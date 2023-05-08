#!/bin/bash

date

cp /proc/vmstat vmstat.before

# Run optimal load (#CPUs)
"${0%/*}/kernbench-0.50/kernbench" -M -H -n 1 -k /dev/shm/linux-5.15 -f "$@" \
    | tee kernbench.txt

cp /proc/vmstat vmstat.after
