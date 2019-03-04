global _mulx

segment .text align=16

_mulx:
	mov eax, esi
	mov edi, edi
	imul rax, rdi
	
	mov rcx, rax
	shr rcx, 32
	mov [rdx], ecx
	
	ret