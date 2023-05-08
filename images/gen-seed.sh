#!/bin/sh

cloud-localds -f vfat seed-host.img user-data-host.yaml
cloud-localds -f vfat seed-guest.img user-data-guest.yaml
