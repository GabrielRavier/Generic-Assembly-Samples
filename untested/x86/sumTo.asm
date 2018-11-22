global _sumTo
global _sumTo64

segment .text align=16

_sumTo:
	mov ecx, [esp + 4]
	test ecx, ecx
	je .ret0
	
	lea eax, [ecx - 1]
	lea edx, [ecx - 2]
	mul edx
	
	shld edx, ecx, 31
	lea eax, [edx + ecx - 1]
	ret
	
	align 16
.ret0:
	xor eax, eax
	ret
	
	
	
	
	
	align 16
_sumTo64:
	push ebp
	push ebx
	push edi
	push esi
	sub esp, 8
	mov ecx, [esp + 32]
	mov edx, [esp + 28]
	
	mov eax, edx
	or eax, ecx
	je .ret0
	
	mov ebx, edx
	mov esi, edx
	
	add esi, -1
	mov edi, ecx
	adc edi, -1
	
	add ebx, -2
	adc ecx, -1
	mov eax, esi
	mul ebx
	
	mov [esp], edx
	mov [esp + 4], eax
	mov eax, edi
	mul ebx
	
	add eax, ebx
	adc edx, ebp
	imul ecx, edi
	add ecx, edx
	shld ecx, eax, 31
	mov edx, [esp + 4]
	shld eax, edx, 31
	
	add eax, [esp + 28]
	adc ecx, [esp + 32]
	
	add eax, -1
	adc ecx, -1
	
	jmp .return
	
.ret0:
	xor eax, eax
	xor ecx, ecx
	
.return:
	mov edx, ecx
	add esp, 8
	pop esi
	pop edi
	pop ebx
	pop ebp
	ret