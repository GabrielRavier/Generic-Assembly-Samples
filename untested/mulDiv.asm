global _mulDiv	; int64_t divide(int64_t dividend, int64_t divisor)

segment .text align=16

_mulDiv:
	push ebp
	push edi
	push esi
	push ebx
	sub esp, 20
	mov esi, [esp + 48]
	
	mov eax, [esp + 44]
	imul dword [esp + 40]
	
	mov [esp], eax
	mov [esp + 4], edx
	
	mov ecx, edx
	shr ecx, 31
	mov edx, esi
	shr edx, 31
	xor eax, eax
	cmp cl, dl
	sete al 
	lea ebp, [eax + eax - 1]
	dec eax
	mov [esp + 12], eax
	
	mov eax, [esp]
	test eax, eax
	jns .noNeg
	
	neg eax
	
.noNeg:
	mov ecx, eax
	mov ebx, eax
	sar ebx, 31
	
	mov eax, esi
	test esi, esi
	jns .noNeg2
	
	neg eax
	
.noNeg2:
	mov esi, eax
	mov edi, eax
	sar edi, 31
	
	cmp ecx, eax
	mov edx, ebx
	sbb edx, edi
	mov eax, 0
	jl .return
	
	xor edx, edx
	mov [esp], ebp
	
.loop:
	sub ecx, esi
	sbb ebx, edi
	
	add eax, 1
	adc edx, 0
	
	cmp ecx, esi
	mov ebp, ebx
	sbb ebp, edi
	jge .loop
	
	mov ebp, [esp]
	mul ebp
	
.return:
	add esp, 20
	pop ebx
	pop esi
	pop edi
	pop ebp
	ret