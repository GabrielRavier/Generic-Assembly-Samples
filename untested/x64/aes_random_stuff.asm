global _gf_mul
global _AES_RotWord

segment .text align=16

_gf_mul:
	xor eax, eax
	
	test esi, esi
	je .ret
	
.loop:
	test sil, 1
	je .noXor
	
	xor eax, edi
	
.noXor:
	add edi, edi
	shr esi, 1
	
	cmp edi, 0xFF
	jbe .noXor2
	
	xor edi, 0x11B
	
.noXor2:
	test esi, esi
	jne .loop
	ret
	
	align 16
.ret:
	ret
	
	
	
	
	
	align 16
_AES_RotWord:
	mov eax, edi
	ror eax, 8
	ret