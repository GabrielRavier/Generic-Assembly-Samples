global _nextPowerOf2	; uint32_t nextPowerOf2(uint32_t a1)
global _nextPowerOf264	; uint64_t nextPowerOf264(uint64_t a1)

segment .text align=16

_nextPowerOf2:
	mov eax, 1
	test edi, edi
	je .return
	
	lea edx, [rdi - 1]
	mov eax, edi
	test edx, edi
	je .return
	
	xor ecx, ecx

.loop:
	add ecx, 1
	
	shr edi, 1
	jne .loop
	
	mov eax, 1
	sal eax, cl
	
.return:
	ret
	
	
	
	
	
_nextPowerOf264:
	mov eax, 1
	test rdi, rdi
	je .return
	
	lea rdx, [rdi - 1]
	mov rax, rdi
	test rdx, rdi
	je .return
	
	xor ecx, ecx
	
.loop:
	add ecx, 1
	
	shr rdi, 1
	jne .loop
	
	mov eax, 1
	sal eax, cl
	cdqe
	
.return:
	ret