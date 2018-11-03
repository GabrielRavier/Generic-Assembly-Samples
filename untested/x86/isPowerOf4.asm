global _isPowerOf4	; bool isPowerOf4(int32_t n) 
global _isPowerOf464	; bool isPowerOf464(int64_t n) 

segment .text align=16

_isPowerOf4:
	mov edx, [esp + 4]
	
	xor eax, eax
	
	test edx, edx
	jne .strLoop
	jmp .return
	
	align 16
.loop:
	test dl, 3
	jne .false
	
	test edx, edx
	lea eax, [edx + 3]
	cmovs edx, eax
	sar edx, 2

.strLoop:
	cmp edx, 1
	jne .loop
	
	mov eax, 1
	ret 
	
.false:
	xor eax, eax
	
.return:
	ret
	
	
	
_isPowerOf464:	
	push edi
	xor eax, eax
	push esi
	push ebx
	mov edi, [esp + 20]
	mov esi, [esp + 16]
	
	mov ebx, edi
	or ebx, esi
	jne .startLoop
	jmp .return
	
	align 16
.loop:
	xor ebx, ebx
	mov ecx, esi
	and ecx, 3
	mov eax, ebx
	or eax, ecx
	jne .return0
	
	mov eax, edi
	sar eax, 31
	and eax, 3
	xor edx, edx
	add esi, eax
	adc edi, edx
	shrd esi, edi, 2
	sar edi, 2
	
.startLoop:
	mov eax, esi
	xor eax, 1
	mov edx, edi
	or edx, eax
	jne .loop
	
	mov eax, 1
	
.return:
	pop ebx
	pop esi
	pop edi
	ret
	
.return0:
	pop ebx
	pop esi
	pop edi
	xor eax, eax
	ret