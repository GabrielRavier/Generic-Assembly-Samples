global _lcmArray

segment .text align=16

_lcmArray:
	push edi
	push esi
	push ebx
	
	mov eax, [esp + 16]
	mov edx, [esp + 20]
	
	mov ecx, [eax]
	
	cmp edx, 1
	jle .returnEcx
	
	lea ebx, [eax + 4]
	lea edi, [eax + edx * 4]
	
.loop:
	mov eax, [ebx]
	mov esi, eax
	imul esi, ecx
	
	test ecx, ecx
	jne .notZero
	jmp .zero

	align 16
.gcdLoop:
	mov ecx, edx
	
.notZero:
	cdq
	idiv ecx
	
	mov eax, ecx
	test edx, edx
	jne .gcdLoop
	
	mov eax, esi
	cdq
	idiv ecx
	mov ecx, eax
	
.checkForLoop:
	add ebx, 4
	
	cmp edi, ebx
	jne .loop
	
.returnEcx:
	pop ebx
	pop esi
	pop edi
	mov eax, ecx
	ret
	
	align 16
.zero:
	add ebx, 4
	cmp ebx, edi
	jne .checkForLoop
	jmp .returnEcx