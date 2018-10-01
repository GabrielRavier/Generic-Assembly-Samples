global _mulx	; uint32_t mulx(uint32_t a1, uint32_t a2, int32_t *a3)

segment .text align=16

_mulx:
	mov eax, esi
	mov edi, edi
	imul rax, rdi
	
	mov rcx, rax
	shr rcx, 32
	mov [rdx], ecx
	
	ret