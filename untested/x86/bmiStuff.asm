global _andn	; uint32_t andn(uint32_t x, uint32_t y)
global _bextr	; uint32_t bextr(uint32_t x, uint32_t y, uint32_t z)
global _blsi	; uint32_t andn(uint32_t x)
global _blsr	; uint32_t andn(uint32_t x)
global _andn64	; uint64_t andn(uint64_t x, uint64_t y)
global _bextr64	; uint64_t bextr(uint64_t x, uint64_t y, uint64_t z)
global _blsi64	; uint64_t andn(uint64_t x)
global _blsr64	; uint64_t andn(uint64_t x)

segment .text align=16

_andn:
	mov eax, [esp + 4]
	not eax
	and eax, dword [esp + 8]
	ret
	
_andnBMI:
	mov eax, [esp + 4]
	andn eax, eax, [esp + 8]
	ret
	
	
	
	
	
_blsi:
	mov eax, [esp + 4]
	mov edx, eax
	neg edx
	and eax, edx
	ret
	
_blsiBMI:
	blsi eax, [esp + 4]
	ret
	
	
	
	
	
_blsr:
	mov eax, [esp + 4]
	lea edx, [eax - 1]
	and eax, edx
	ret
	
_blsrBMI:
	blsr eax, [esp + 4]
	ret
	
	
	
	
	
_andn64:
	mov eax, [esp + 4]
	mov edx, [esp + 8]
	
	not eax
	not edx
	
	and eax, [esp + 12]
	and edx, [esp + 16]
	ret
	
	
	
_andn64SSE2:
	movq xmm2, [esp + 4]
	pcmpeqd xmm0, xmm0
	movq xmm1, [esp + 12]
	
	pandn xmm2, xmm0
	pand xmm2, xmm1
	movd eax, xmm2
	psrlq xmm2, 32
	movd edx, xmm2
	ret
	
	
	
_andn64SSE4:
	movq xmm0, [esp + 4]
	movq xmm1, [esp + 12]
	pandn xmm0, xmm1
	movd eax, xmm0
	pextrd edx, xmm0, 1
	ret
	
	
	
_andn64AVX:
	vmovq xmm0, [esp + 4]
	vmovq xmm1, [esp + 12]
	vpandn xmm0, xmm0, xmm1
	vmovd eax, xmm0
	vpextrd edx, xmm0, 1
	ret
	
	
	
	
	
_blsi64:
	push edi
	
	xor edx, edx
	mov eax, [esp + 8]
	xor edi, edi
	sub edx, eax
	mov ecx, [esp + 12]
	sbb edi, ecx
	and ecx, edi
	and eax, edx
	mov edx, ecx
	
	pop edi
	ret
	
	
	
_blsi64SSE4:
	movq xmm1, [esp + 4]
	pxor xmm0, xmm0
	psubq xmm0, xmm1
	pand xmm0, xmm1
	movd eax, xmm0
	pextrd edx, xmm0, 1
	ret
	
	
	
_blsi64AVX:
	vmovq xmm1, [esp + 4]
	vpxor xmm0, xmm0, xmm0
	vpsubq xmm0, xmm0, xmm1
	vpand xmm0, xmm0, xmm1
	vmovd eax, xmm0
	pextrd edx, xmm0, 1
	ret
	
	
	
	
	
_blsr64:
	push edi
	
	mov eax, [esp + 8]
	mov ecx, eax
	and ecx, -1
	mov edx, [esp + 12]
	mov edi, edx
	adc edi, -1
	and eax, ecx
	and edx, edi
	
	pop edi
	ret
	
	
	
segment .rodate align=4

	xmmDat1 dq -1
	
segment .text align=16

_blsr64SSE2:
	movq xmm1, [esp + 4]
	movq xmm0, [xmmDat1]
	paddq xmm0, xmm1
	pand xmm1, xmm0
	movd eax, xmm1
	psrlq xmm1, 32
	movd edx, xmm1
	ret
	
	
	
_blsr64SSE4:
	movq xmm1, [esp + 4]
	pcmpeqd xmm0, xmm0
	paddq xmm0, xmm1
	pand xmm0, xmm1
	movd eax, xmm0
	pextrd edx, xmm0, 1
	ret
	
	
	
_blsr64AVX:
	vmovq xmm1, [esp + 4]
	vpcmpeqd xmm0, xmm0
	vpaddq xmm0, xmm1
	vpand xmm0, xmm1
	vmovd eax, xmm0
	vpextrd edx, xmm0, 1
	ret