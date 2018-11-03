global _getSign1
global _getSign2
global _getSign3
global _isNotNegative
global _areSignsOpposite
global _signExtendFromWidth
global _conditionalClearOrSet
global _swapBits
global _hasZeroByte
global _parity
global _getSign164
global _getSign264
global _getSign364
global _isNotNegative64
global _areSignsOpposite64
global _signExtendFromWidth64
global _conditionalClearOrSet64
global _swapBits64
global _hasZeroByte64
global _parity64

segment .text align=16

_getSign1:
	mov eax, [esp + 4]	; x
	sar eax, 31
	ret
	
	
	
	

_getSign2:
	mov eax, [esp + 4]	; x
	sar eax, 31
	or eax, 1
	ret
	
	
	
	
	
_getSign3:
	mov edx, [esp + 4]	; x
	
	test edx, edx
	setg al
	
	shr edx, 31
	or eax, edx
	ret
	
	
	
	
	
_isNotNegative:
	mov eax, [esp + 4]	; x
	
	not eax
	shr eax, 31
	ret
	
	
	
	
	
_areSignsOpposite:
	mov eax, [esp + 8]	; y
	xor eax, [esp + 4]	; x
	shr eax, 31
	ret
	
	
	
	
	
_signExtendFromWidth:
	mov edx, 1
	movzx eax, byte [esp + 8]	; bitWidth
	lea ecx, [eax + 31]
	shl edx, cl
	
	mov ecx, eax
	mov eax, 1
	shl eax, cl
	dec eax
	and eax, [esp + 4]	; x
	
	xor eax, edx
	sub eax, edx
	ret
	
	
	
_signExtendFromWidthBMI:
	movzx ecx, byte [esp + 8]	; bitWidth
	mov edx, 1
	lea eax, [ecx - 1]
	shlx edx, edx, eax
	
	mov eax, -1
	shlx eax, eax, ecx
	andn eax, eax, [esp + 4]	; x
	
	xor eax, edx
	sub eax, edx
	ret
	
	
	
	
	
_conditionalClearOrSet:
	movzx eax, byte [esp + 12]	; doIt
	mov edx, [esp + 4]	; wordToModify
	
	neg eax
	xor eax, edx
	and eax, [esp + 8]	; bitMask
	xor eax, edx
	ret
	
	
	
	
	
_swapBits:
	push edi
	push esi
	push ebx
	
	mov eax, [esp + 28]	; bitsToSwap
	movzx edi, byte [esp + 16]	; swapPos1
	movzx esi, byte [esp + 20]	; swapPos2
	
	mov ebx, eax
	mov edx, eax
	mov ecx, edi
	shr ebx, cl
	mov ecx, esi
	shr edx, cl
	
	movzx ecx, byte [esp + 24]	; sizeSequenceBits
	
	xor edx, ebx
	mov ebx, -1
	sal ebx, cl
	mov ecx, edi
	not ebx
	and edx, ebx
	mov ebx, edx
	sal ebx, cl
	mov ecx, esi
	sal edx, cl
	or edx, ebx
	
	pop ebx
	pop esi
	xor eax, edx
	pop edi
	ret
	
	
	
_swapBitsBMI:
	push edi
	push esi
	push ebx
	
	mov ebx, [esp + 28]	; bitsToSwap
	movzx edx, byte [esp + 16]	; swapPos1
	movzx esi, byte [esp + 20]	; swapPos2
	movzx edi, byte [esp + 24]	; sizeSequenceBits
	
	shrx ecx, ebx, edx
	shrx eax, ebx, esi
	xor eax, ecx
	mov ecx, -1
	shlx ecx, ecx, edi
	andn ecx, ecx, eax
	shlx eax, ecx, edx
	shlx edx, ecx, esi
	or eax, edx
	xor eax, ebx
	
	pop ebx
	pop esi
	pop edi
	ret
	
	
	
	
	
_hasZeroByte:
	mov edx, [esp + 4]	; x
	
	xor eax, eax
	test dl, dl
	je .return
	
	test dh, 0xFF
	je .return
	
	test edx, 0xFF0000
	je .return
	
	shr edx, 24
	setne al 
	
.return:
	ret
	
	
	
	
	
_parity:
	mov eax, [esp + 4]
	mov edx, eax
	shr eax, 16
	xor edx, eax
	xor dl, dh
	setnp al 
	ret
	
	
	
	
	
_getSign164:
	mov eax, [esp + 8]	; x.hi
	sar eax, 31
	ret
	
	
	
	
	
_getSign264:
	mov eax, [esp + 8]	; x.hi
	sar eax, 31
	or eax, 1
	ret
	
	
	
	
	
_getSign364:
	push edi
	push esi
	push ebx
	mov edi, [esp + 20]	; x.hi
	mov esi, [esp + 16]	; x.lo
	
	mov ebx, edi
	mov edx, edi
	sar ebx, 31
	cmp ebx, esi
	sbb ebx, edi
	shr edx, 31
	
	pop ebx
	pop esi
	shr eax, 31
	pop edi
	sub eax, edx
	ret
	
	
	
	
	
_isNotNegative64:
	mov eax, [esp + 8]	; x.hi
	shr eax, 31
	xor eax, 1
	and eax, 1
	ret
	
	
	
	
	
_areSignsOpposite64:
	mov eax, [esp + 16]	; y.hi
	xor eax, [esp + 8]	; x.hi
	shr eax, 31
	ret
	
	
	
	
	
_signExtendFromWidth64:
	sub esp, 12
	
	mov edx, -1
	
	mov [esp + 8], edi
	movzx eax, byte [esp + 24]	; bitWidth
	mov [esp + 4], esi
	mov [esp], ebx
	
	xor ebx, ebx
	
	mov cl, al
	dec cl
	movzx edi, cl
	shr edi, 5
	and edi, 1
	mov esi, edi
	sal edi, cl
	xor esi, 1
	sal esi, cl
	
	mov cl, al
	mov eax, -1
	shld edx, eax, cl
	sal eax, cl
	test cl, 32
	cmovne edx, eax
	cmovne eax, ebx
	mov ecx, edx
	mov edx, [esp + 16]	; x.lo
	not eax
	not ecx
	and eax, edx
	mov ebx, eax
	mov eax, [esp + 20]	; x.hi
	
	xor ebx, esi
	and ecx, eax
	
	mov eax, ebx
	mov ebx, [esp]
	xor ecx, edi
	sub eax, esi
	mov esi, [esp + 4]
	mov edx, ecx
	sbb edx, edi
	mov edi, [esp + 8]
	add esp, 12
	ret
	
	
	
	
	
_conditionalClearOrSet64:
	push edi
	
	movzx eax, byte [esp + 24]	; doIt
	neg eax
	cdq
	
	mov ecx, [esp + 8]	; wordToModify.lo
	
	xor eax, ecx
	mov edi, [esp + 12]	; wordToModify.hi
	xor edx, edi
	and eax, [esp + 16]	; bitMask.lo
	and edx, [esp + 20]	; bitMask.hi
	xor eax, ecx
	xor edx, edi
	pop edi
	ret
	
	
	
_conditionalClearOrSet64SSE2:
	movzx eax, byte [esp + 20]	; doIt
	neg eax
	cdq
	
	movq xmm3, [esp + 4]	; wordToModify
	movd xmm1, eax
	movq xmm2, [esp + 12]	; bitMask
	movd xmm0, edx
	
	punpckldq xmm1, xmm0
	pxor xmm1, xmm3
	pand xmm2, xmm1
	pxor xmm3, xmm2
	
	movd eax, xmm3
	psrlq xmm3, 32
	movd edx, xmm3
	ret
	
	
	
_conditionalClearOrSet64SSE4:
	movzx eax, byte [esp + 20]	; doIt
	movq xmm1, [esp + 4]	; wordToModify
	movq xmm2, [esp + 12]	; bitMask
	neg eax
	cdq
	
	movd xmm0, eax
	pinsrd xmm0, edx, 1
	pxor xmm0, xmm1
	pand xmm0, xmm2
	pxor xmm0, xmm1
	
	movd eax, xmm0
	pextrd edx, xmm0, 1
	ret
	
	
	
_conditionalClearOrSet64AVX:
	movzx eax, byte [esp + 20]	; doIt
	vmovq xmm1, [esp + 4]	; wordToModify
	vmovq xmm2, [esp + 12]	; bitMask
	neg eax
	cdq
	
	vmovd xmm0, eax
	vpinsrd xmm0, xmm0, edx, 1
	vpxor xmm0, xmm0, xmm1
	vpand xmm0, xmm0, xmm2
	vpxor xmm0, xmm0, xmm1
	
	vmovd eax, xmm0
	vpextrd edx, xmm0, 1
	ret
	
	
	
	
	
_swapBits64:
	sub esp, 16
	xor eax, eax
	mov [esp + 4], esi
	movzx ecx, byte [esp + 20]	; swapPos1
	mov [esp + 8], edi
	mov esi, [esp + 32]	; bitsToSwap.lo
	mov [esp], ebx
	mov edi, [esp + 36]	; bitsToSwap.hi
	mov [esp + 12], ebp
	mov edx, edi
	
	shrd esi, edi, cl
	shr edi, cl
	test cl, 32
	movzx ecx, byte [esp + 24]	; swapPos2
	cmovne esi, edi
	cmovne edi, eax
	
	mov eax, [esp + 32]	; bitsToSwap
	xor ebx, ebx
	mov ebp, edi
	shrd eax, edx, cl
	shr edx, cl
	test cl, 32
	movzx ecx, byte [esp + 28]	; sizeSequenceBits
	cmovne eax, edx
	cmovne edx, ebx
	
	xor esi, eax
	mov eax, -1
	xor edi, edx
	xor ebp, ebp
	sal eax, cl
	mov edx, -1
	test cl, 32
	cmovne edx, eax
	cmovne eax, ebp
	
	mov ecx, eax
	mov ebx, edx
	not ecx
	not ebx
	and esi, ecx
	
	movzx ecx, byte [esp + 20]	; swapPos1
	and edi, ebx
	mov eax, esi
	
	xor ebx, ebx
	mov edx, edi
	
	shld edi, esi, cl
	sal esi, cl
	test cl, 32
	movzx ecx, byte [esp + 24]	; swapPos2
	cmovne edi, esi
	cmovne esi, ebx
	
	xor ebp, ebp
	shld edx, eax, cl
	sal eax, cl
	test cl, 32
	cmovne edx, eax
	cmovne eax, ebp
	
	mov ebp, [esp + 12]
	mov ecx, eax
	mov ebx, edx
	mov eax, esi
	mov edx, edi
	mov esi, [esp + 4]
	
	or eax, ecx
	or edx, ebx
	
	mov ecx, [esp + 32]	; bitsToSwap.lo
	mov ebx, [esp + 36]	; bitsToSwap.hi
	mov edi, [esp + 8]
	
	xor eax, ecx
	xor edx, ebx
	mov ebx, [esp]
	add esp, 16
	ret
	
	
	
_swapBits64SSE2:
	movq xmm4, [esp + 16]	; bitsToSwap
	movzx eax, byte [esp + 4]	; swapPos1
	movd xmm0, eax
	movzx eax, byte [esp + 8]	; swapPos2
	movd xmm2, eax
	
	movdqa xmm6, xmm3
	psrlq xmm6, xmm0
	movdqa xmm5, xmm6
	movdqa xmm7, xmm3
	psrlq xmm7, xmm2
	pxor xmm5, xmm7
	
	movzx eax, byte [esp + 12]	; sizeSequenceBits
	movd xmm4, eax
	pcmpeqd xmm1, xmm1
	psllq xmm1, xmm4
	pandn xmm1, xmm5
	
	movdqa xmm4, xmm1
	psllq xmm4, xmm0
	movdqa xmm0, xmm4
	psllq xmm1, xmm2
	por xmm0, xmm1
	pxor xmm0, xmm3

	movd eax, xmm0
	psrlq xmm0, 32
	movd edx, xmm0
	ret
	
	
	
	
	
_hasZeroByte64:
	mov edx, [esp + 4]	; x.lo
	mov ecx, [esp + 8]	; x.hi
	xor eax, eax
	test dl, dl
	je .return
	test dh, -1
	je .return
	test edx, 0xFF0000
	je .return
	shr edx, 24
	je .return
	
	test cl, cl
	je .return
	test ch, -1
	je .return
	test ecx, 0xFF0000
	je .return
	shr ecx, 24
	setne al
	
.return:
	ret
	
	
	
	
	
_parity64:
	push ebx
	
	mov edx, [esp + 12]
	mov eax, [esp + 8]
	mov ebx, edx
	xor ebx, eax
	mov edx, ebx
	shr ebx, 16
	xor edx, ebx
	pop ebx
	xor dl, dh
	setnp al
	ret