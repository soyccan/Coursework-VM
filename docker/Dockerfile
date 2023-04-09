FROM ubuntu:22.10

WORKDIR /root

RUN \
  rm -f /etc/apt/apt.conf.d/docker-clean && \
  echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache && \
  sed -i 's/archive\.ubuntu\.com/tw.archive.ubuntu.com/g' /etc/apt/sources.list

# essentials for building Linux kernel
# and running a nested KVM guest
RUN \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  apt update && \
  apt install --no-install-recommends -y \
    build-essential flex bison bc python3 libssl-dev libncurses-dev \
    clang-15 gcc-aarch64-linux-gnu libc6-dev-i386 \
    openssh-client gdb-multiarch git rsync && \
  apt satisfy --no-install-recommends -y 'qemu-system-arm (>= 1:7.0)'

# qemu build dependencies:
# build-essential python3 git ninja-build pkg-config libglib2.0-dev libpixman-1-dev \

CMD ["/bin/bash"]
