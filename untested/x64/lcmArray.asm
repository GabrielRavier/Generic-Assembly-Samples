global _lcmArray

segment .text align=16

_lcmArray:
	mov ecx, [rdi]
	
	cmp esi, 1
	jle .returnEcx
	
	lea eax, [rsi - 2]
	lea r8, [rdi + 4]
	lea rdi, [rdi + rax * 4 + 8]
	
.loop:
	mov eax, [r8]
	mov esi, eax
	imul esi, ecx
	
	test ecx, ecx
	jne .startGcdLoop
	jmp .thing
	
	align 16
.gcdLoop:
	mov ecx, edx

.startGcdLoop:
	cdq
	idiv ecx
	
	mov eax, ecx
	test edx, edx
	jne .gcdLoop
	
	mov eax, ecx
	cdq
	idiv ecx
	mov ecx, eax
	
.check:
	add r8, 4
	cmp r8, rdi
	jne .loop
	
.returnEcx:
	mov eax, ecx
	ret
	
.thing:
	add r8, 4
	cmp r8, rdi
	jne .check