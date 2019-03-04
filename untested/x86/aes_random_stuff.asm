%include "macros.inc"

global _gf_mul
global _AES_RotWord

segment .text align=16

_gf_mul:
	push ebx
	xor eax, eax
	mov ecx, [esp + 12]
	mov edx, [esp + 8]
	
	test ecx, ecx
	je .return
	
.loop:
	mov ebx, eax
	xor ebx, ebx
	test cl, 1
	cmovne eax, ebx
	
	add edx, edx
	
	mov ebx, edx
	xor ebx, 0x11B
	cmp edx, 0xFF
	cmova edx, ebx
	
	shr ecx, 1
	jne .loop
	
.return:
	pop ebx
	ret
	
	
	
	
	
	align 16
_AES_RotWord:
	mov eax, [esp + 4]
	ror eax, 8
	ret