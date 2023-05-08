#!/bin/sh

case "$1" in
  hackbench)
    ag 'Time: ' | awk '{print $2}' | paste -sd,
  ;;
  kernbench)
    grep -oP '(?<= )[0-9]+\.[0-9]+$' | paste -sd,
  ;;
  netperf)
    awk '{print $5}' | grep -E '^[0-9]+\.?[0-9]*$' | paste -sd,
  ;;
  netperf1)
    awk '{print $6}' | grep -E '^[0-9]+\.?[0-9]*$' | paste -sd,
  ;;
  apache)
    grep 'Time per request.*concurrent' | grep -oE '[0-9\.]+' | paste -sd,
  ;;
  apache1)
    grep 'Transfer rate' | grep -oE '[0-9\.]+' | paste -sd,
  ;;
  *)
    echo "Unknown command: $1"
    exit 1
esac
