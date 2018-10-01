global @add64@8
global @sub64@8
global @mul64@8
global @isEqual64@8
global @isGreater64@8
global _divide64	; int64_t divide64(int64_t dividend, int64_t divisor)
global _modulo64	; int64_t modulo64(int64_t x, int64_t n)
global _getVal64	; int64_t getVal64(int64_t x)
global _getOpposite64	; int64_t getOpposite64(int64_t x)
global _getComplement64	; int64_t getComplement64(int64_t x)
global _getAbs64	; uint64_t getAbs(int64_t n) 

segment .text align=16

@add64i386@8:
	mov eax, [edx]
	mov edx, [edx + 4]
	
	add [ecx], eax
	adc [ecx + 4], edx
	
	ret
	
	
	
@add64SSSE3@8:
	movq xmm1, [edx]
	movq xmm0, [ecx]
	
	paddq xmm0, xmm1
	movq [ecx], xmm0
	
	ret
	
	
	
	
	
@sub64i386@8:
	mov eax, [edx]
	mov edx, [edx + 4]
	
	sub [ecx], eax
	sbb [ecx + 4], edx
	
	ret
	
	
	
@sub64SSSE3@8:
	movq xmm1, [edx]
	movq xmm0, [ecx]
	psubq xmm0, xmm1
	movq [ecx], xmm0 
	ret
	

	
	
	
@mul64i386@8:
	push esi
	push edi
	
	mov esi, [ecx + 4]
	mov eax, [edx + 4]
	
	imul esi, [edx]
	imul eax, [ecx]
	add esi, eax
	mov eax, [ecx]
	mul dword [edx]
	add edx, esi
	
	mov [ecx], eax
	mov [ecx + 4], edx
	
	pop edi
	pop esi
	ret
	
	
	
@mul64SSE2@8:
	movq xmm2, [ecx]
	movq xmm0, [edx]
	
	movdqa xmm1, xmm2
	movdqa xmm3, xmm0
	
	psrlq xmm1, 32
	psrlq xmm3, 32
	
	pmuludq xmm3, xmm2
	pmuludq xmm1, xmm0
	pmuludq xmm2, xmm0
	
	paddq xmm3, xmm1
	psllq xmm3, 32
	paddq xmm3, xmm2
	
	movq [ecx], xmm3
	ret
	
	
	
@mul64AVX@8:
	vmovq xmm2, [ecx]
	vmovq xmm3, [edx]
	
	vpsrlq xmm1, xmm2, 32
	vpsrlq xmm0, xmm3, 32
	
	vpmuludq xmm4, xmm0, xmm2
	vpmuludq xmm5, xmm1, xmm3
	vpmuludq xmm0, xmm2, xmm3
	
	vpaddq xmm6, xmm4, xmm5
	vpsllq xmm7, xmm6, 32
	vpaddq xmm1, xmm7, xmm0
	
	vmovq [ecx], xmm1
	ret
	
	
	
@mul64AVX512@8:
	vmovq xmm0, [ecx]
	vmovq xmm1, [edx]
	vpmullq xmm2, xmm0, xmm1
	vmovq [ecx], xmm2
	ret
	
	
	
	
	
@isEqual64i386@8:
	mov eax, [ecx]
	mov ecx, [ecx + 4]
	sub eax, [edx]
	sub ecx, [edx + 4]
	or eax, ecx
	jne .false
	
	mov eax, 1
	ret
	
.false:
	xor eax, eax
	ret
	
	
	
@isEqual64SSE4@8:
	movq xmm1, [ecx]
	movq xmm0, [edx]
	pcmpeqq xmm1, xmm0
	movd eax, xmm1
	
	test eax, eax
	je .false
	
	mov eax, 1
	ret
	
.false:
	xor eax, eax
	ret
	
	
	
	
	
@isGreater64i386@8:
	mov eax, [ecx]
	sub eax, [edx]
	mov ecx, [ecx + 4]
	sbb ecx, [edx + 4]
	jl .false
	
	or eax, ecx
	je .false
	
	mov eax, 1
	ret
	
.false:
	xor eax, eax
	ret
	
	
	
@isGreater64SSE4@8:
	movq xmm1, [ecx]
	movq xmm0, [edx]
	pcmpgtq xmm1, xmm0
	movd eax, xmm1
	
	test eax, eax
	je .false
	
	mov eax, 1
	ret
	
.false:
	xor eax, eax
	ret
	
	
	
	
	
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
	
	
	
	
	
_modulo64i386:
	push esi
	push edi
	push ebx
	push ebp
	sub esp, 12
	
	mov ebx, [esp + 44]
	mov ebp, [esp + 40]
	mov esi, [esp + 32]
	mov edi, [esp + 36]
	
	push ebx
	push ebp
	push edi
	push esi
	call _divide64
	
	mov ecx, eax
	add esp, 16
	imul ecx, ebp
	imul ebx, eax
	mul ebp
	add ecx, ebx
	add edx, ecx
	sub esi, eax
	mov eax, esi
	sbb edi, edx
	mov edx, edi
	
	add esp, 12
	pop ebp
	pop ebx
	pop edi
	pop esi
	ret
	
	
	
	
	
_modulo64BMI2:
	push esi
	push edi
	push ebx
	push ebp
	sub esp, 12
	
	mov ebx, [esp + 44]
	mov ebp, [esp + 40]
	mov esi, [esp + 32]
	mov edi, [esp + 36]
	
	push ebx
	push ebp
	push edi
	push esi
	call _divide64
	
	mov ecx, eax
	mov eax, edx
	add esp, 16
	
	imul eax, ebp
	mov edx, ecx
	imul ebx, ecx
	mulx ebp, ecx, ebp
	add eax, ebx
	add ebp, eax
	sub esi, ecx
	mov eax, esi
	sbb edi, ebp
	mov edx, edi
	add esp, 12
	pop ebp
	pop ebx
	pop edi
	pop esi
	ret
	
	
	
	
	
_getVal64:
	mov eax, [esp + 4]
	mov edx, [esp + 8]
	ret
	
	
	
	
	
_getOpposite64:
	xor edx, edx
	xor eax, eax
	sub eax, [esp + 4]
	sbb edx, [esp + 8]
	ret
	
	
	
	
	
_getComplement64:
	mov eax, [esp + 4]
	mov edx, [esp + 8]
	neg eax
	neg edx
	ret