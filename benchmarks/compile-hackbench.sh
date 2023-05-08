#!/bin/sh

gcc -o hackbench -pthread \
  linux-test-project/testcases/kernel/sched/cfs-scheduler/hackbench.c
