#!/bin/sh

for _ in $(seq 1 5); do
    ./hackbench 50 process 50
done | tee hackbench.txt
