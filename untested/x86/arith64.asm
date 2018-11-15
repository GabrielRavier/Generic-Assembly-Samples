global _add64
global _sub64
global _mul64
global _isEqual64
global _isGreater64
global _divide64	; int64_t divide64(int64_t dividend, int64_t divisor)
global _modulo64	; int64_t modulo64(int64_t x, int64_t n)
global _getVal64	; int64_t getVal64(int64_t x)
global _getOpposite64	; int64_t getOpposite64(int64_t x)
global _getComplement64	; int64_t getComplement64(int64_t x)
global _getAbs64	; uint64_t getAbs(int64_t n) 
global _shiftLeft64
global _shiftRight64

segment .text align=16

_add64:
	mov eax, [esp + 12]
	mov edx, [esp + 16]
	
	add eax, [esp + 4]
	adc edx, [esp + 8]
	ret
	
	
	
	align 16
_add64SSE3:
	movq xmm1, [esp + 4]
	movq xmm0, [esp + 12]
	
	paddq xmm1, xmm0
	
	movd eax, xmm1
	psrlq xmm1, 32
	movd edx, xmm1
	ret
	
	
	
	align 16
_add64SSE4:
	movq xmm1, [esp + 4]
	movq xmm0, [esp + 12]
	
	paddq xmm0, xmm1
	
	movd eax, xmm0
	pextrd edx, xmm0, 1
	ret
	
	
	
	align 16
_add64AVX:
	vmovq xmm1, [esp + 12]
	vmovq xmm0, [esp + 4]
	
	vpaddq xmm2, xmm0, xmm1
	
	vmovd eax, xmm2
	vpextrd edx, xmm2, 1
	ret
	
	
	
	
	
	align 16
_sub64:
	mov eax, [esp + 4]
	mov edx, [esp + 8]
	
	sub eax, [esp + 12]
	sbb edx, [esp + 16]
	ret
	
	
	
	align 16
_sub64SSE3:
	movq xmm1, [esp + 4]
	movq xmm0, [esp + 12]
	
	psubq xmm1, xmm0
	
	movd eax, xmm1
	psrlq xmm1, 32
	movd edx, xmm1
	ret
	
	
	
	align 16
_sub64SSE4:
	movq xmm0, [esp + 4]
	movq xmm1, [esp + 12]
	
	psubq xmm0, xmm1
	
	movd eax, xmm0
	pextrd edx, xmm0, 1
	ret
	
	
	
	align 16
_sub64AVX:
	vmovq xmm0, [esp + 4]
	vmovq xmm1, [esp + 12]
	
	vpsubq xmm2, xmm0, xmm1
	
	vmovd eax, xmm2
	vpextrd edx, xmm2, 1
	ret
	
	
	
	
	
	align 16
_mul64:
	push ebx
	mov eax, [esp + 8]
	mov edx, [esp + 16]
	mov ecx, [esp + 12]
	
	imul ecx, edx
	mov ebx, [esp + 20]
	
	imul ebx, eax
	add ecx, ebx
	mul edx
	add edx, ecx
	
	pop ebx
	ret
	
	
	
	align 16
_mul64BMI:
	push ebx
	
	mov eax, [esp + 8]
	mov edx, [esp + 16]
	mov ecx, [esp + 12]
	mov ebx, [esp + 20]
	
	imul ecx, edx
	imul ebx, eax
	mulx edx, eax, eax
	add ecx, ebx
	
	pop ebx
	add edx, ecx
	ret
	
	
	
	
	
	align 16
_isEqual64:
	mov edx, [esp + 12]
	xor edx, [esp + 4]
	mov eax, [esp + 16]
	xor eax, [esp + 8]
	
	or edx, eax
	sete al
	ret
	
	
	
	align 16
_isEqual64SSSE3:
	movq xmm1, [esp + 12]
	movq xmm0, [esp + 4]
	
	pxor xmm0, xmm1
	movd edx, xmm0
	psrlq xmm0, 32
	movd eax, xmm0
	
	or edx, eax
	sete al
	ret
	
	
	
	align 16
_isEqual64SSE4:
	movq xmm1, [esp + 12]
	movq xmm0, [esp + 4]
	
	pxor xmm0, xmm1
	punpcklqdq xmm0, xmm0
	
	ptest xmm0, xmm0
	sete al
	ret
	
	
	
	align 16
_isEqual64AVX:
	vmovq xmm1, [esp + 12]
	vmovq xmm0, [esp + 4]
	
	vpxor xmm2, xmm0, xmm1
	vpunpcklqdq xmm3, xmm2, xmm2
	
	vptest xmm3, xmm3
	sete al
	ret
	
	
	
	
	
	align 16
_isGreater64:
	mov eax, [esp + 4]
	cmp [esp + 12], eax
	mov edx, [esp + 16]
	sbb edx, [esp + 8]
	
	setl al
	ret
	
	
	
	
	
	align 16
_divide64:
	push esi
	push edi
	push ebx
	push ebp
	sub esp, 12
	
	xor esi, esi
	
	mov edx, [esp + 36]
	mov eax, [esp + 32]
	
	sub edx, esi
	jl .signThing1
	
	mov [esp], esi
	jmp .signThing2
	
.signThing1:
	mov dword [esp], 1
	
.signThing2:
	mov edx, [esp + 44]
	sub edx, esi
	jl .signThing3
	
	mov ebp, esi
	jmp .signThing4
	
.signThing3:
	mov ebp, 1
	
.signThing4:
	cdq
	
	mov ecx, eax
	xor ecx, edx
	sub ecx, edx
	mov eax, ecx
	mov edi, ecx
	cdq
	
	mov eax, [esp + 40]
	mov ebx, edx
	cdq
	
	; got absolutes
	sub edi, eax
	mov edi, ebx
	sbb edi, edx
	jl .skipQuotient
	
.quotientLoop:
	sub ecx, eax
	mov edi, ecx
	sbb ebx, edx
	inc esi
	
	sub edi, eax
	mov edi, ebx
	sbb edi, edx
	jge .quotientLoop
	
.skipQuotient:
	mov eax, esi
	cmp ebp, [esp]
	cdq
	
	mov eax, -1
	mov ebx, edx
	jne .negative
	
	mov eax, 1
.negative:
	cdq
	
	imul ebx, eax
	mov ecx, edx
	imul ecx, esi
	mul esi
	
	add ecx, ebx
	add ecx, edx
	mov edx, ecx
	
	add esp, 12
	pop ebp
	pop ebx
	pop edi
	pop esi
	ret
	
	
	
	
	
	align 16
_modulo64:
	push ebp
	push ebx
	push edi
	push esi
	push eax
	mov edx, [esp + 24]
	mov ebp, [esp + 28]
	mov eax, [esp + 32]
	mov ebx, [esp + 36]
	
	mov edi, ebp
	mov ecx, ebx
	mov esi, ebx
	sar edi, 31
	add edx, edi
	adc ebp, edi
	
	sar ecx, 31
	xor ebp, edi
	add eax, ecx
	adc esi, ecx
	
	xor ebx, [esp + 28]
	xor edx, edi
	xor eax, ecx
	xor esi, ecx
	xor ecx, ecx
	
	cmp eax, edx
	mov [esp], ebx
	mov ebx, esi
	sbb ebx, ebp
	mov ebx, 0
	jge .endLoop
	
	xor ecx, ecx
	xor ebx, ebx
	
.loop:
	sub edx, eax
	mov edi, esi
	sbb ebp, esi
	add ecx, 1
	adc ebx, 0
	cmp eax, ebx
	sbb edi, ebp
	jl .loop
	
.endLoop:
	mov edx, [esp]
	mov eax, [esp + 36]

	sar edx, 31
	and ebx, edx
	and edx, ecx
	mov ecx, eax
	
	imul ecx, edx
	mov eax, edx
	mov edx, [esp + 32]
	mov esi, edx
	mul edx
	
	add edx, ecx
	imul ebx, esi
	mov ecx, [esp + 24]
	add ebx, edx
	mov edx, [esp + 28]
	
	sub ecx, eax
	sbb edx, ebx
	
	mov eax, ecx
	add esp, 4
	pop esi
	pop edi
	pop ebx
	pop ebp
	ret
	
	
	
	align 16
_modulo64SSE4:
	push ebp
	push ebx
	push edi
	push esi
	push eax
	mov eax, [esp + 36]
	xor eax, [esp + 28]
	
	mov [esp], eax
	movdqa xmm0, [esp + 24]
	pxor xmm1, xmm1
	pcmpgtq xmm1, xmm0
	paddq xmm0, xmm1
	pxor xmm0, xmm1
	
	pextrd edx, xmm0, 1
	movd ecx, xmm0
	pextrd edi, xmm0, 2
	xor eax, eax
	cmp edi, ecx
	pextrd esi, xmm0, 3
	mov ebp, esi
	sbb ebp, edx
	mov ebp, 0
	jae .endLoop
	
	xor eax, eax
	xor ebp, ebp
	
.loop:
	sub ecx, edi
	sbb edx, esi
	
	add eax, 1
	adc ebp, 0
	
	cmp edi, ecx
	mov ebx, esi
	sbb ebx, edx
	jl .loop
	
.endLoop:
	mov esi, [esp]
	
	sar esi, 31
	and ebp, esi
	and esi, eax
	
	mov eax, esi
	mov ecx, [esp + 32]
	mov edi, ecx
	mul ecx
	mov ecx, [esp + 36]
	imul ecx, esi
	add edx, ecx
	imul ebp, edi
	add ebp, edx
	mov ecx, [esp + 24]
	
	sub ecx, eax
	mov edx, [esp + 28]
	sbb edx, ebp
	
	mov eax, ecx
	add esp, 4
	pop esi
	pop edi
	pop ebx
	pop ebp
	ret
	
	
	
	align 16
_modulu64BMI:
	push ebp
	push ebx
	push edi
	push esi
	push eax
	mov eax, [esp + 36]
	xor eax, [esp + 28]
	
	mov [esp], eax
	vmovdqa xmm0, [esp + 24]
	vpxor xmm1, xmm1, xmm1
	vpcmpgtq xmm1, xmm1, xmm0
	vpaddq xmm0, xmm0, xmm1
	vpxor xmm0, xmm0, xmm1
	
	vpextrd ebx, xmm0, 1
	vmovd ecx, xmm0
	vpextrd edx, xmm0, 2
	xor ebp, ebp
	cmp edx, ecx
	vpextrd esi, xmm0, 3
	mov edi, esi
	sbb edi, ebx
	mov edi, 0
	jae .endLoop
	
	xor ebp, ebp
	xor edi, edi
	
.loop:
	sub ecx, edx
	sbb ebx, esi
	
	add ebp, 1
	adc edi, 0
	
	cmp edx, ecx
	mov eax, esi
	sbb eax, ebx
	jl .loop
	
.endLoop:
	mov esi, [esp]
	sar esi, 31
	and edi, esi
	and esi, ebp
	
	mov edx, esi
	mov eax, [esp + 32]
	mulx ecx, ebx, eax
	mov edx, [esp + 36]
	imul edx, esi
	add ecx, edx
	imul edi, eax
	add edi, ecx
	mov eax, [esp + 24]
	
	sub eax, ebx
	mov edx, [esp + 28]
	sbb edx, edi
	
	add esp, 4
	pop esi
	pop edi
	pop ebx
	pop ebp
	ret
	
	
	
	
	
	align 16
_getVal64:
	mov eax, [esp + 4]
	mov edx, [esp + 8]
	ret
	
	
	

	
	align 16
_getOpposite64:
	xor edx, edx
	xor eax, eax
	sub eax, [esp + 4]
	sbb edx, [esp + 8]
	ret
	
	
	
	

	align 16
_getComplement64:
	mov eax, [esp + 4]
	mov edx, [esp + 8]
	neg eax
	neg edx
	ret

	
	
	
	
	align 16
_shiftLeft64:
	push edi
	movzx ecx, byte [esp + 16]
	
	cmp ecx, 31
	jbe .bigShiftLol
	
	mov edx, [esp + 8]
	xor eax, eax
	shl edx, cl
	
	pop edi
	ret
	
.bigShiftLol:
	mov edx, [esp + 12]
	mov eax, [esp + 8]
	
	shld edx, eax, cl
	shl eax, cl
	
	pop edi
	ret
	
	
	
	align 16
_shiftLeft64SSE2:
	movzx edx, byte [esp + 12]
	movq xmm1, [esp + 4]
	movd xmm0, edx
	
	psllq xmm1, xmm0
	
	movd eax, xmm1
	psrlq xmm1, 32
	movd edx, xmm1
	ret
	
	
	
	align 16
_shiftLeft64SSE4:
	movzx eax, byte [esp + 12]
	movq xmm0, [esp + 4]
	movd xmm1, eax
	
	psllq xmm0, xmm1
	
	movd eax, xmm0
	pextrd edx, xmm0, 1
	ret
	
	
	
	align 16
_shiftLeft64AVX:
	movzx eax, byte [esp + 12]
	vmovq xmm0, [esp + 4]
	vmovd xmm1, edx
	
	vpsllq xmm2, xmm0, xmm1
	
	vmovd eax, xmm2
	vpextrd edx, xmm2, 1
	ret
	
	
	
	
	
	align 16
_shiftRight64:
	push edi
	
	movzx ecx, byte [esp + 16]
	cmp ecx, 31
	mov edi, [esp + 12]
	jbe .bigShiftLol
	
	mov edx, edi
	mov eax, edi
	sar edx, 31
	sar eax, cl
	
	pop edi
	ret
	
.bigShiftLol:
	mov edx, edi
	mov eax, [esp + 8]
	shrd eax, edi, cl
	sar edx, cl
	
	pop edi
	ret