global _leftRotate	; uint32_t leftRotate(uint32_t n, uint32_t d)
global _rightRotate	; uint32_t rightRotate(uint32_t n, uint32_t d)
global _leftRotate64	; uint64_t leftRotate64(uint64_t n, uint32_t c)
global _rightRotate64	; uint64_t rightRotate64(uint64_t n, uint32_t c)

segment .text align=16

_leftRotate:
	mov eax, [esp + 4]
	mov ecx, [esp + 8]
	
	rol eax, cl
	ret
	
	
	
	
	
_rightRotate:
	mov eax, [esp + 4]
	mov ecx, [esp + 8]
	
	ror eax, cl
	ret
	
	
	
	
	
_leftRotate64i386:
	push esi
	push edi
	mov ecx, [esp + 20]
	and ecx, 0x3F
	
	mov esi, [esp + 16]
	
	cmp ecx, 0x1F
	jbe .L3
	
	mov edx, [esp + 12]
	xor eax, eax
	shl edx, cl
	jmp .L4
	
.L3:
	mov edx, esi
	mov eax, [esp + 12]
	shld edx, eax, cl
	shl eax, cl
	
.L4:
	neg ecx
	and ecx, 0x3F
	cmp ecx, 0x1F
	jbe .L6
	
	mov edi, esi
	xor esi, esi
	shr edi, cl
	
.L7:
	or eax, edi
	or edx, esi
	pop edi
	pop esi
	ret
	
.L6:
	mov edi, [esp + 12]
	shrd edi, esi, cl
	shr esi, cl
	jmp .L7
	
	
	
_leftRotate64SSE2:
	mov edx, [esp + 12]
	and edx, 0x3F
	
	movq xmm2, [esp + 4]
	movd xmm0, edx
	
	neg edx
	and edx, 0x3F
	
	psllq xmm3, xmm0
	movd xmm1, edx
	psrlq xmm2, xmm1
	por xmm3, xmm2
	movd eax, xmm3
	psrlq xmm3, 32
	movd edx, xmm3
	
	ret
	
	
	
_leftRotate64AVX:
	mov edx, [esp + 12]
	and edx, 0x3F
	
	vmovq xmm1, [esp + 4]
	vmovd xmm0, edx
	
	neg edx
	and edx, 0x3F
	
	vpsllq xmm3, xmm1, xmm0
	vmovd xmm2, edx
	vpsrlq xmm4, xmm1, xmm2
	vpor xmm5, xmm3, xmm4
	vpsrlq xmm6, xmm5, 32
	vmovd eax, xmm5
	vmovd edx, xmm5
	
	ret