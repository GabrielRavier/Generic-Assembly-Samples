global _intToBase 

segment .text align=16

_intToBase:
	push ebp
	push edi
	push esi
	push ebx
	push edx
	
	mov eax, [esp + 24]	; num
	mov esi, [esp + 28]	; str
	
	test eax, eax
	jne .notZero
	
	mov word [esi], 48	; '0\0'
	jmp .return
	
.notZero:
	mov esi, 0	; sign
	jns .notNegative
	
	neg eax
	mov esi, 1
	
.notNegative:
	mov dword [esp], 0
	
.loop:
	cdq
	idiv dword [esp + 32]
	mov ebx, eax
	
	lea ebp, [edx + '0']
	cmp edx, 9
	jle .smallerThan10
	
	lea ebp, [edx + 'A' - 10]
	
.smallerThan10:
	mov eax, [esp]
	lea edx, [eax + 1]
	mov edi, edx
	mov eax, ebp
	mov byte [ecx + edx - 1], al

	mov eax, ebx
	
	test ebx, ebx
	je .finish
	
	mov [esp], edx
	jmp .loop
	
.finish:
	mov ebx, esi
	test bl, bl
	je .numNotNegative
	
	mov edx, [esp]
	add edx, 2
	mov byte [ecx + edi], '-'
	
.numNotNegative:
	mov byte [ecx + edx], 0
	
.reverseLoop:
	dec edx
	
	cmp eax, edx
	jge .return
	
	movzx ebp, byte [ecx + eax]
	mov bl, byte [ecx + edx]
	mov byte [ecx + eax], bl
	mov ebx, ebp
	mov byte [ecx + edx], bl
	
	inc eax
	jmp .reverseLoop
	
.return:
	pop eax
	pop ebx
	pop esi
	pop edi
	pop ebp
	ret