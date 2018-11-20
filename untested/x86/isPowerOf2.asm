global _isPowerOf2
global _isPowerOf264

segment .text align=16

_isPowerOf2:
	mov edx, [esp + 4]
	test edx, edx
	je .return0
	
	lea ecx, [edx - 1]
	xor eax, eax
	test edx, ecx
	sete al 
	ret 
	
.return0:
	xor eax, eax
	ret
	
	
	
	align 16
_isPowerOf2BMI2:
	mov eax, [esp + 4]
	test eax, eax
	je .return0
	
	mov edx, 1
	blsr eax, eax
	mov eax, 0
	cmove eax, edx
	ret
	
	align 16
.return0:
	xor eax, eax
	ret
	
	
	
	
	
	align 16
_isPowerOf264:
	sub esp, 12
	
	mov eax, [esp + 16]
	mov edx, eax
	or edx, [esp + 20]
	je .return0
	
	mov edx, eax
	add edx, -1
	mov ecx, [esp + 20]
	mov [esp], esi
	mov esi, ecx
	adc esi, -1
	and eax, edx
	and ecx, esi
	mov esi, ecx
	adc esi, -1
	and eax, edx
	and ecx, esi
	mov esi, [esp]
	or eax, ecx
	jne .return0
	
	mov eax, 1
	
.return:
	add esp, 12
	ret
	
.return0:
	xor eax, eax
	jmp .return
	
	
	
	align 16
_isPowerOf264SSSE3:
	movq xmm1, [esp + 4]
	
	xor eax, eax
	
	movdqa xmm0, xmm1
	movd ecx, xmm1
	psrlq xmm0, 32
	movd edx, xmm0
	
	or edx, ecx
	je .return
	
	pcmpeqd xmm0, xmm0
	paddq xmm0, xmm1
	pand xmm0, xmm1
	movd edx, xmm0
	psrlq xmm0, 32
	movd eax, xmm0
	
	or edx, eax
	sete al
	
.return:
	ret
	
	
	
	align 16
_isPowerOf264SSE4:
	movq xmm0, [esp + 4]
	
	xor eax, eax
	punpcklqdq xmm0, xmm0
	ptest xmm0, xmm0
	je .return
	
	pcmpeqd xmm1, xmm1
	paddq xmm1, xmm0
	pand xmm0, xmm1
	punpcklqdq xmm0, xmm0
	ptest xmm0, xmm0
	sete al
	
.return:
	ret
	
	
	
	align 16
_isPowerOf264AVX:
	vmovq xmm0, [esp + 4]
	
	xor eax, eax
	vpunpcklqdq xmm0, xmm0, xmm0
	vptest xmm0, xmm0
	je .return
	
	vpcmpeqd xmm1, xmm1, xmm1
	vpaddq xmm1, xmm0, xmm1
	vpand xmm0, xmm1, xmm0
	vpunpcklqdq xmm0, xmm0, xmm0
	vptest xmm0, xmm0
	sete al
	
.return:
	ret