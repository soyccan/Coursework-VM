# syntax=docker/dockerfile:1
FROM ubuntu:23.04

ARG UID=1000
ARG GID=1000

# essentials for building Linux kernel & QEMU & shadow & running a nested KVM guest
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
  rm -f /etc/apt/apt.conf.d/docker-clean && \
  echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache && \
  sed -i 's/archive\.ubuntu\.com/tw.archive.ubuntu.com/g' /etc/apt/sources.list && \
  apt update && \
  apt install --no-install-recommends -y \
    # linux dependencies
    build-essential flex bison bc python3 libssl-dev libncurses-dev \
    clang-15 gcc-aarch64-linux-gnu libc6-dev-i386 \
    # tools
    openssh-client gdb-multiarch git rsync sudo \
    # qemu dependencies
    ninja-build pkg-config libglib2.0-dev libpixman-1-dev \
    # shadow dependencies
    debhelper-compat gettext libpam0g-dev quilt xsltproc docbook-xsl docbook-xml \
    libxml2-utils libselinux1-dev libsemanage-dev itstool bison libaudit-dev && \
  apt satisfy --no-install-recommends -y 'qemu-system-arm (>= 1:7.0)'

# create uid/gid if not exist
RUN \
  { getent group ${GID} >/dev/null 2>&1 || groupadd --gid ${GID} user; } && \
  { id ${UID} >/dev/null 2>&1 || useradd --uid ${UID} --gid ${GID} --groups sudo user; } && \
  sed -i 's/%sudo\s\+ALL=(ALL:ALL)\s\+ALL/%sudo ALL=(ALL:ALL) NOPASSWD: ALL/g' /etc/sudoers

WORKDIR /workspace
USER ${UID}

CMD ["/bin/bash"]
