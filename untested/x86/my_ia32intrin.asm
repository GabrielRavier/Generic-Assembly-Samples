global _my_bsfd
global _my_bsrd
global _my_bswapd
global _my_crc32b
global _my_crc32w
global _my_crc32d
global _my_popcntd
global _my_rolb
global _my_rolw
global _my_rold
global _my_rorb
global _my_rorw
global _my_rord
global _my_bsfq
global _my_bsrq
global _my_bswapq
global _my_crc32q
global _my_popcntq

segment .text align=16

_my_bsfd:
	bsf eax, [esp + 4]
	ret
	
	
	
	
	
	align 16
_my_bsrd:
	mov edx, [esp + 4]
	xor eax, eax
	
	test edx, edx
	je .ret
	
	mov eax, 31
	js .ret
	
.loop:
	dec eax
	add edx, edx
	jns .loop
	
	ret
	
	align 16
.ret:
	ret
	
	
	
	
	
	align 16
_my_bswapd:
	mov eax, [esp + 4]
	xchg al, ah
	rol eax, 16
	xchg al, ah
	ret
	
	
	
	align 16
_my_bswapdBSWAP:
	mov eax, [esp + 4]
	bswap eax
	ret
	
	
	
	align 16
_my_bswapdMOVBE:
	movbe eax, [esp + 4]
	ret
	
	
	
	
	
	align 16
_BitReflect8:
	movzx edx, cl
	
	mov ecx, edx
	sal ecx, 7
	shr al, 7
	or eax, ecx
	
	mov ecx, edx
	sar ecx, 5
	and ecx, 2
	or eax, ecx
	
	mov ecx, edx
	sar ecx, 3
	and ecx, 4
	or eax, ecx
	
	mov ecx, edx
	sar ecx, 1
	and ecx, 8
	or eax, ecx
	
	lea ecx, [edx + edx]
	and ecx, 0x10
	or eax, ecx
	
	lea ecx, [edx * 8]
	and ecx, 0x20
	
	sal edx, 5
	or eax, ecx
	
	and edx, 0x40
	or eax, edx
	ret
	
	
	
	
	
	align 16
_BitReflect16:
	push ebx
	push esi
	push eax
	
	mov ebx, ecx
	call _BitReflect8
	movzx esi, al
	shl esi, 8
	
	mov cl, bh
	call _BitReflect8
	movzx eax, al
	or eax, esi
	
	add esp, 4
	pop esi
	pop ebx
	ret
	
	
	
	
	
	align 16
_BitReflect32:
	push edi
	push esi
	push eax
	
	mov esi, ecx
	call _BitReflect16
	mov edi, eax
	shl edi, 16
	shl esi, 16
	
	mov ecx, esi
	call _BitReflect16
	
	movzx eax, ax
	or edi, eax
	mov eax, edi
	add esp, 4
	pop esi
	pop edi
	ret
	
	
	
	
	
	align 16
_mod2_64bit:
	push esi
	mov eax, [esp + 20]
	mov ecx, [esp + 8]
	mov edx, [esp + 16]
	
	mov esi, eax
	sar eax, 31
	shld esi, edx, 1
	and eax, ecx
	xor eax, esi
	
%macro doMod64Iter 1
	mov esi, edx
	shr esi, %1
	and esi, 1
	lea esi, [esi + eax * 2]
	
	sar eax, 31
	and eax, ecx
	xor eax, esi
%endmacro

	doMod64Iter 30
	doMod64Iter 29
	doMod64Iter 28
	doMod64Iter 27
	doMod64Iter 26
	doMod64Iter 25
	doMod64Iter 24
	doMod64Iter 23
	doMod64Iter 22
	doMod64Iter 21
	doMod64Iter 20
	doMod64Iter 19
	doMod64Iter 18
	doMod64Iter 17
	doMod64Iter 16
	doMod64Iter 15
	doMod64Iter 14
	doMod64Iter 13
	doMod64Iter 12
	doMod64Iter 11
	doMod64Iter 10
	doMod64Iter 9
	doMod64Iter 8
	doMod64Iter 7
	doMod64Iter 6
	doMod64Iter 5
	doMod64Iter 4
	doMod64Iter 3
	doMod64Iter 2
	
	mov esi, edx
	and edx, 1
	shr esi, 1
	and esi, 1
	lea esi, [esi + eax * 2]
	
	sar eax, 31
	and eax, ecx
	xor eax, esi
	lea edx, [edx + eax * 2]
	
	sar eax, 31
	and eax, ecx
	xor eax, edx
	
	pop esi
	ret
	
	
	
	
	
	align 16
_my_crc32b:
	push ebp
	sub esp, 8
	
	mov ecx, [esp + 16]
	call _BitReflect32
	mov ebp, eax
	
	movzx ecx, byte [esp + 20]
	call _BitReflect8
	
	mov edx, ebp
	movzx eax, al
	shr edx, 24
	xor eax, edx
	push eax
	
	shl ebp, 8
	push ebp
	
	push 1
	push 0x1EDC6F41
	call _mod2_64bit
	add esp, 16
	
	mov ecx, eax
	add esp, 8
	pop ebp
	jmp _BitReflect32
	
	
	
	
	
	align 16
_my_crc32w:
	push ebp
	sub esp, 8
	
	mov ecx, [esp + 16]
	call _BitReflect32
	mov ebp, eax
	
	movzx ecx, word [esp + 20]
	call _BitReflect16
	
	movzx edx, ax
	mov eax, ebp
	shr eax, 16
	xor edx, edx
	push edx
	
	shl ebp, 16
	push ebp
	
	push 1
	push 0x1EDC6F41
	call _mod2_64bit
	add esp, 16
	
	mov ecx, eax
	add esp, 8
	pop ebp
	jmp _BitReflect32
	
	
	
	
	
	align 16
_my_crc32d:
	push esi
	sub esp, 8
	
	mov ecx, [esp + 16]
	call _BitReflect32
	mov esi, eax
	
	mov ecx, [esp + 20]
	call _BitReflect32
	
	xor eax, esi
	push eax
	push 0
	
	push 1
	push 0x1EDC6F41
	call _mod2_64bit
	add esp, 16
	
	mov ecx, eax
	add esp, 8
	pop esi
	jmp _BitReflect32
	
	
	
	
	
	align 16
_my_popcntd:
	mov eax, [esp + 4]
	
	mov ecx, eax
	shr ecx, 1
	and ecx, 0x55555555
	sub eax, ecx
	
	mov ecx, eax
	and ecx, 0x33333333
	
	shr eax, 2
	and eax, 0x33333333
	add eax, ecx
	
	mov ecx, eax
	shr ecx, 4
	add ecx, eax
	and ecx, 0xF0F0F0F
	imul eax, ecx, 0x1010101
	shr eax, 24
	ret
	
	
	
segment .rodata align=16

	align 16
	popcntFs dd 0x0F0F0F0F, 0x0F0F0F0F, 0x0F0F0F0F, 0x0F0F0F0F
	
	align 16
	popcnt5s dd 0x55555555, 0x55555555, 0x55555555, 0x55555555
	
	align 16
	popcnt3s dd 0x33333333, 0x33333333, 0x33333333, 0x33333333
	
	align 16
	popcntSSSE3Lol dd 0x02010100, 0x03020201, 0x03020201, 0x04030302

segment .text align=16

	align 16
_my_popcntdSSE2:
	movd xmm0, [esp + 4]
	pxor xmm4, xmm4
	movdqa xmm1, xmm0
	psrld xmm1, 1
	pand xmm1, [popcnt5s]
	psubd xmm0, xmm1
	movdqa xmm5, xmm0
	movdqa xmm2, [popcnt3s]
	psrld xmm5, 2
	pand xmm5, xmm2
	pand xmm0, xmm2
	paddd xmm3, xmm5
	psrld xmm3, 4
	paddd xmm5, xmm3
	pand xmm5, [popcntFs]
	psadbw xmm5, xmm4
	movd eax, xmm5
	ret
	
	
	
	align 16
_my_popcntdSSSE3:
	movd xmm3, [esp + 4]
	pxor xmm4, xmm4
	movdqa xmm0, [popcntFs]
	movdqa xmm1, xmm3
	movdqa xmm2, [popcntSSSE3Lol]
	
	psrld xmm3, 4
	pand xmm1, xmm0
	pand xmm3, xmm0
	
	movdqa xmm5, xmm2
	pshufb xmm5, xmm1
	pshufb xmm2, xmm3
	paddd xmm5, xmm2
	psadbw xmm5, xmm4
	movd eax, xmm5
	ret
	
	
	
	align 16
_my_popcntdPOPCNT:
	popcnt eax, [esp + 4]
	ret
	
	
	
	
	
	align 16
_my_rolb:
	mov ecx, [esp + 8]
	mov eax, [esp + 4]
	and ecx, 7
	rol al, cl
	ret
	
	
	
	
	
	align 16
_my_rolw:
	mov ecx, [esp + 8]
	movzx eax, word [esp + 4]
	and ecx, 0xF
	rol ax, cl
	ret
	
	
	
	
	
	align 16
_my_rold:
	mov ecx, [esp + 8]
	mov eax, [esp + 4]
	rol eax, cl
	ret
	
	
	
	
	
	align 16
_my_rorb:
	mov ecx, [esp + 8]
	mov eax, [esp + 4]
	and ecx, 7
	ror al, cl
	ret
	
	
	
	
	
	align 16
_my_rorw:
	mov ecx, [esp + 8]
	movzx eax, word [esp + 4]
	and ecx, 0xF
	ror ax, cl
	ret
	
	
	
	
	
	align 16
_my_rord:
	mov ecx, [esp + 8]
	mov eax, [esp + 4]
	ror eax, cl
	ret
	
	
	
	
	
	align 16
_my_bsfq:
	mov ecx, [esp + 4]
	bsf edx, ecx
	bsf eax, [esp + 8]
	add eax, 32
	test ecx, ecx
	cmovne eax, edx
	ret
	
	
	
	
	
	align 16
_my_bsrq:
	push ebx
	mov ecx, [esp + 8]
	mov ebx, [esp + 12]
	
	mov eax, ebx
	or eax, ecx
	je .ret0
	
	test ebx, ebx
	js .ret63
	
	mov eax, 63
	
.loop:
	dec eax
	
	add ecx, ecx
	adc ebx, ebx
	
	test ebx, ebx
	jns .loop
	
	movzx eax, al
	
	pop ebx
	ret
	
	align 16
.ret0:
	xor eax, eax
	pop ebx
	ret
	
	align 16
.ret63:
	mov eax, 63
	pop ebx
	ret
	
	
	
	align 16
_my_bsrqSSSE3:
	movq xmm1, [esp + 4]
	xor eax, eax
	movdqa xmm0, xmm1
	movd ecx, xmm1
	psrlq xmm0, 32
	movd edx, xmm0
	
	or ecx, edx
	je .return
	
	mov eax, 63
	
	test edx, edx
	js .return
	
	
.loop:
	psllq xmm1, 1
	dec eax
	movdqa xmm0, xmm1
	psrlq xmm0, 32
	movd edx, xmm0
	
	test edx, edx
	jns .loop
	
	movzx eax, al
	ret
	
	align 16
.return:
	ret
	
	
	
	align 16
_my_bsrqSSE4:
	movq xmm0, [esp + 4]
	xor eax, eax
	pextrd edx, xmm0, 1
	punpcklqdq xmm0, xmm0
	ptest xmm0, xmm0
	je .return
	
	mov eax, 63
	
	test edx, edx
	js .return
	
.loop:
	psllq xmm0, 1
	dec eax
	pextrd edx, xmm0, 1
	
	test edx, edx
	jns .loop
	
	movzx eax, al
	ret
	
	align 16
.return:
	ret
	
	
	
	
	
	align 16
_my_bswapq:
	mov edx, [esp + 4]
	xchg dl, dh
	rol edx, 16
	xchg dl, dh
	
	mov eax, [esp + 8]
	xchg al, ah
	rol eax, 16
	xchg al, ah
	ret
	
	
	
	align 16
_my_bswapqBSWAP:
	mov eax, [esp + 8]
	mov edx, [esp + 4]
	bswap edx
	bswap eax
	ret
	
	
	
	align 16
_my_bswapqMOVBE:
	movbe eax, [esp + 8]
	movbe edx, [esp + 4]
	ret
	
	
	
	
	
	align 16
_my_crc32q:
	push ebp
	sub esp, 8
	
	mov ecx, [esp + 16]
	call _BitReflect32
	mov ebp, eax
	
	mov ecx, [esp + 24]
	call _BitReflect32
	
	xor eax, ebp
	push eax
	push 0
	push 1
	push 0x1EDC6F41
	call _mod2_64bit
	mov ebp, eax
	add esp, 16
	
	mov ecx, [esp + 28]
	call _BitReflect32
	
	xor eax, ebp
	push eax
	push 0
	push 0x1EDC6F41
	call _mod2_64bit
	add esp, 16
	
	
	mov ecx, eax
	call _BitReflect32
	xor edx, edx
	add esp, 8
	pop ebp
	ret
	
	
	
	
	
	align 16
_my_popcntq:
	mov ecx, [esp + 8]
	mov eax, [esp + 4]
	
	mov edx, ecx
	shr edx, 1
	and edx, 0x55555555
	sub ecx, edx
	
	mov edx, ecx
	shr ecx, 2
	and edx, 0x33333333
	and ecx, 0x33333333
	add ecx, edx
	
	mov edx, ecx
	shr edx, 4
	add edx, ecx
	and edx, 0xF0F0F0F
	imul ecx, edx, 0x1010101
	
	mov edx, eax
	shr edx, 1
	shr ecx, 24
	and edx, 0x55555555
	sub eax, edx
	
	mov edx, eax
	shr eax, 2
	and edx, 0x33333333
	and eax, 0x33333333
	add eax, edx
	
	mov edx, eax
	shr edx, 4
	add edx, eax
	and edx, 0xF0F0F0F
	imul eax, edx, 0x1010101
	xor edx, edx
	
	shr eax, 24
	add eax, ecx
	ret
	
	
	
	align 16
_my_popcntqSSE2:
	movq xmm0, [esp + 4]
	pxor xmm4, xmm4
	
	movdqa xmm1, xmm0
	psrld xmm1, 1
	pand xmm1, [popcnt5s]
	psubq xmm0, xmm1
	
	movdqa xmm5, xmm0
	movdqa xmm2, [popcnt3s]
	psrld xmm5, 2
	pand xmm5, xmm2
	pand xmm0, xmm2
	paddq xmm5, xmm0
	
	movdqa xmm3, xmm5
	psrld xmm3, 4
	
	paddq xmm5, xmm3
	pand xmm5, [popcntFs]
	psadbw xmm5, xmm4
	movd eax, xmm5
	cdq
	ret
	
	
	
	align 16
_my_popcntqSSSE3:
	movq xmm3, [esp + 4]
	pxor xmm4, xmm4
	
	movdqa xmm0, [popcntFs]
	movdqa xmm1, xmm3
	movdqa xmm2, [popcntSSSE3Lol]
	psrld xmm3, 4
	pand xmm1, xmm0
	pand xmm3, xmm0
	
	movdqa xmm5, xmm2
	pshufb xmm5, xmm1
	pshufb xmm2, xmm3
	
	paddq xmm5, xmm2
	psadbw xmm5, xmm4
	movd eax, xmm5
	cdq
	ret
	
	
	
	align 16
_my_popcntqPOPCNT:
	popcnt eax, [esp + 4]
	popcnt edx, [esp + 8]
	add eax, edx
	xor edx, edx
	ret
	
	
	
	
	
	align 16
_my_rolq:
	push ebp
	push ebx
	push edi
	push esi
	mov eax, [esp + 20]
	mov esi, [esp + 24]
	mov ecx, [esp + 28]
	
	mov edi, eax
	shl edi, cl
	mov ebp, esi
	shld ebp, eax, cl
	
	xor edx, edx
	test cl, 32
	cmovne ebp, edi
	cmovne edi, edx
	
	mov ebx, 64
	sub ebx, ecx
	mov edx, esi
	mov ecx, ebx
	shr edx, cl
	shrd eax, esi, cl
	
	test bl, 32
	cmovne eax, edx
	mov ecx, 0
	cmovne edx, ecx
	
	or eax, edi
	or edx, ebp
	
	pop esi
	pop edi
	pop ebx
	pop ebp
	ret
	
	
	
	align 16
_my_rolqSSE2:
	mov edx, [esp + 12]
	movq xmm2, [esp + 4]
	
	movdqa xmm3, xmm2
	movd xmm0, edx
	neg edx
	add edx, 64
	psllq xmm3, xmm0
	
	movd xmm1, edx
	psrlq xmm2, xmm1
	por xmm3, xmm2
	
	movd eax, xmm3
	psrlq xmm3, 32
	movd edx, xmm3
	ret
	
	
	
	align 16
_my_rolqAVX:
	mov edx, [esp + 12]
	vmovq xmm1, [esp + 4]
	
	vmovd xmm0, edx
	neg edx
	add edx, 64
	vpsllq xmm3, xmm1, xmm0
	
	vmovd xmm2, edx
	vpsrlq xmm4, xmm1, xmm2
	vpor xmm5, xmm3, xmm4
	
	vmovd eax, xmm5
	vpextrd edx, xmm5, 1
	ret
	
	
	
	
	
	align 16
_my_rorq:
	push ebp
	push ebx
	push edi
	push esi
	mov esi, [esp + 20]
	mov edx, [esp + 24]
	mov ecx, [esp + 28]
	
	mov edi, edx
	shr edi, cl
	
	mov ebp, esi
	shrd ebp, edx, cl
	
	xor eax, eax
	test cl, 32
	cmovne ebp, edi
	cmovne edi, eax
	
	mov ebx, 64
	sub ebx, ecx
	
	mov eax, esi
	mov ecx, ebx
	shl eax, cl
	shld edx, esi, cl
	
	test bl, 32
	cmovne edx, eax
	mov ecx, 0
	cmovne eax, ecx
	
	or eax, ebp
	or edx, edi
	
	pop esi
	pop edi
	pop ebx
	pop ebp
	ret
	
	
	
	align 16
_my_rorqSSE2:
	mov edx, [esp + 12]
	movq xmm2, [esp + 4]
	
	movdqa xmm3, xmm2
	movd xmm0, edx
	neg edx
	add edx, 64
	psrlq xmm3, xmm0
	
	movd xmm1, edx
	psllq xmm2, xmm1
	por xmm3, xmm2
	
	movd eax, xmm3
	psrlq xmm3, 32
	movd edx, xmm3
	ret
	
	
	
	align 16
_my_rorqAVX:
	mov edx, [esp + 12]
	vmovq xmm1, [esp + 4]
	
	vmovd xmm0, edx
	neg edx
	add edx, 64
	vpsrlq xmm3, xmm1, xmm0
	
	vmovd xmm2, edx
	vpsllq xmm4, xmm1, xmm2
	vpor xmm5, xmm3, xmm4
	vmovd eax, xmm5
	vpextrd edx, xmm5, 1
	ret