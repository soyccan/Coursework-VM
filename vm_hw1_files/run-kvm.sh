#!/bin/bash

CONSOLE=mon:stdio
SMP=1
MEMSIZE=2G
KERNEL="./linux/build-vhost/arch/arm64/boot/Image"
FS="./images/ubuntu-20.04-server-cloudimg-arm64.img"
SEED="./images/seed-host.img"
CMDLINE="earlycon=pl011,0x09000000 cloud-init.disabled"
DUMPDTB=""
DTB=""

usage() {
        U=""
        if [[ -n "$1" ]]; then
                U="${U}$1\n\n"
        fi
        U="${U}Usage: $0 [options]\n\n"
        U="${U}Options:\n"
        U="$U    -c | --CPU <nr>:       Number of cores (default ${SMP})\n"
        U="$U    -m | --mem <MB>:       Memory size (default ${MEMSIZE})\n"
        U="$U    -k | --kernel <Image>: Use kernel image (default ${KERNEL})\n"
        U="$U    -s | --serial <file>:  Output console to <file>\n"
        U="$U    -i | --image <image>:  Use <image> as block device (default $FS)\n"
        U="$U    -a | --append <snip>:  Add <snip> to the kernel cmdline\n"
        U="$U    -d | --debug:          Stop at launch for debugger to attach\n"
        U="$U    --dumpdtb <file>       Dump the generated DTB to <file>\n"
        U="$U    --dtb <file>           Use the supplied DTB instead of the auto-generated one\n"
        U="$U    -h | --help:           Show this output\n"
        U="${U}\n"
        echo -e "$U" >&2
}

while :
do
        case "$1" in
          -c | --cpu)
                SMP="$2"
                shift 2
                ;;
          -m | --mem)
                MEMSIZE="$2"
                shift 2
                ;;
          -k | --kernel)
                KERNEL="$2"
                shift 2
                ;;
          -s | --serial)
                CONSOLE="file:$2"
                shift 2
                ;;
          -i | --image)
                FS="$2"
                shift 2
                ;;
          -a | --append)
                CMDLINE="$2"
                shift 2
                ;;
          --dumpdtb)
                DUMPDTB=",dumpdtb=$2"
                shift 2
                ;;
          --dtb)
                DTB="-dtb $2"
                shift 2
                ;;
          -d | --debug)
                GDB_FLAGS="-S"
                shift 1
                ;;
          -h | --help)
                usage ""
                exit 1
                ;;
          --) # End of all options
                shift
                break
                ;;
          -*) # Unknown option
                echo "Error: Unknown option: $1" >&2
                exit 1
                ;;
          *)
                break
                ;;
        esac
done

if [[ -z "$KERNEL" ]]; then
        echo "You must supply a guest kernel" >&2
        exit 1
fi

qemu/build/qemu-system-aarch64 \
        -nographic -machine virt,gic-version=2 -m ${MEMSIZE} -cpu cortex-a57 -smp ${SMP} -machine virtualization=on \
        -kernel ${KERNEL} ${DTB} \
        -drive if=none,file=$FS,id=vda,cache=none,format=qcow2 \
        -device virtio-blk-pci,drive=vda \
        $(: this is comment \
        -drive if=none,file=$SEED,id=vdb,cache=none,format=raw \
        -device virtio-blk-pci,drive=vdb \
        -virtfs local,path=/workspace/benchmarks,mount_tag=benchmarks,security_model=passthrough,id=benchmarks \
        -virtfs local,path=/workspace/linux,mount_tag=linux,security_model=passthrough,id=linux \
        -virtfs local,path=/workspace/images,mount_tag=images,security_model=passthrough,id=images \
        -virtfs local,path=/workspace/vm_hw1_files,mount_tag=vm_hw1_files,security_model=passthrough,id=vm_hw1_files \
        -virtfs local,path=/workspace/vm_hw2_files,mount_tag=vm_hw2_files,security_model=passthrough,id=vm_hw2_files \
        ) \
        -display none \
        -serial $CONSOLE \
        -append "console=ttyAMA0 root=/dev/vda1 rw nokaslr $CMDLINE" \
        -netdev user,id=net0,hostfwd=tcp::2222-:22,hostfwd=tcp::3333-:2222,hostfwd=tcp::2345-:1234 \
        -device virtio-net-pci,netdev=net0,mac=de:ad:be:ef:41:49,romfile= \
        -s $GDB_FLAGS -snapshot
