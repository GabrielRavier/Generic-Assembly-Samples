global _ternlogd_scalar
global _ternlogq_scalar
global _pmadd52luq_scalar

segment .text align=16

_ternlogd_scalar:
	push ebp
	push ebx
	push edi
	push esi
	xor edx, edx
	
	mov edi, [esp + 24]
	mov esi, [esp + 20]
	xor eax, eax
	
.loop:
	mov ebp, esi
	mov ecx, edx
	shr ebp, cl
	
	and ebp, 1
	
	mov ebx, edi
	shr ebx, cl
	and ebx, 1
	lea ebx, [ebx + ebp * 2]
	
	mov ebp, [esp + 28]
	shr ebp, cl
	and ebp, 1
	lea ecx, [ebp + ebx * 2]
	
	mov ebx, [esp + 32]
	shr ebx, cl
	and ebx, 1

	mov ecx, edx
	shl ebx, cl
	or eax, ebx
	
	inc edx
	cmp edx, 32
	jne .loop
	
	pop esi
	pop edi
	pop ebx
	pop ebp
	ret
	
	
	
	
	
	align 16
_ternlogq_scalar:
	push ebp
	push ebx
	push edi
	push esi
	push eax
	mov dword [esp], 0
	xor edx, edx
	xor ebx, ebx
	
.loop:
	mov edi, [esp + 32]
	mov ecx, ebx
	mov eax, [esp + 36]
	shrd edi, eax, cl
	
	mov esi, [esp + 40]
	mov ebp, [esp + 44]
	shrd esi, ebp, cl
	shr ebp, cl
	
	test bl, 32
	cmove ebp, esi
	
	mov esi, eax
	shr esi, cl
	
	test bl, 32
	cmove esi, edi
	
	and edi, 1
	and esi, 1
	lea eax, [esi + edi * 2]
	
	and ebp, 1
	lea ecx, [ebp + eax * 2]
	
	mov eax, [esp + 48]
	shr eax, cl
	and eax, 1
	
	mov esi, eax
	mov ecx, ebx
	shl esi, cl
	
	test cl, 32
	mov edi, esi
	mov ecx, 0
	cmovne edi, ecx
	
	xor ebp, ebp
	mov ecx, ebx
	shld ebp, eax, cl
	
	test bl, 32
	cmovne ebp, esi
	
	or edx, ebp
	or [esp], edi
	
	inc bl
	cmp bl, 64
	jne .loop
	
	mov eax, [esp]
	add esp, 4
	pop esi
	pop edi
	pop ebx
	pop ebp
	ret
	
	
	
	
	
	align 16
_pmadd52luq_scalar:
	push esi
	mov ecx, [esp + 24]
	mov esi, [esp + 16]
	
	mov eax, ecx
	imul ecx, [esp + 20]
	mul esi
	imul esi, [esp + 28]
	
	add edx, ecx
	add edx, esi
	and edx, 0xFFFFF
	
	add eax, [esp + 8]
	adc edx, [esp + 12]
	pop esi
	ret