global _isCpuidAvailable

segment .text align=16

_isCpuidAvailable:
	pushf
	pop eax
	
	mov edx, eax
	xor edx, 0x200000	; Try to toggle the 21th bit (ID bit)
	
	push edx
	popf
	pushf
	pop eax
	push ecx
	popf
	
	cmp ecx, eax
	setne al	; If we can toggle the ID bit, that means cpuid is available
	ret