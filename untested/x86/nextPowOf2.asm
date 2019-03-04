%include "macros.inc"

global _nextPowerOf2
global _nextPowerOf264

segment .text align=16

_nextPowerOf2:
	mov eax, [esp + 4]
	test eax, eax
	je .n0
	
	lea edx, [eax - 1]
	test eax, edx
	jne .continue
	
	ret
	
	align 16
.continue:
	xor ecx, ecx
	
.loop:
	shr eax, 1
	inc ecx
	test eax, eax
	jne .loop
	jmp .return
	
	align 16
.n0:
	xor ecx, ecx

.return:
	mov eax, 1
	shl eax, cl
	ret
	
	
	
	align 16
_nextPowerOf2BMI2:
	mov eax, [esp + 4]
	test eax, eax
	je .return1
	
	blsr edx, eax
	jne .continue
	
	ret
	
	align 16
.continue:
	xor edx, edx
	
.loop:
	shr eax, 1
	inc edx
	
	test eax, eax
	jne .loop
	
	jmp .return
	
	align 16
.return1:
	xor edx, edx
	
.return:
	mov eax, 1
	shlx eax, eax, edx
	ret
	
	
	
	
	
	align 16
_nextPowerOf264:
	push esi
	
	mov eax, [esp + 4 + 4]
	mov ecx, eax
	mov edx, [esp + 4 + 8]
	
	or ecx, edx
	je .return1
	
	mov esi, eax
	mov ecx, edx
	add esi, -1
	adc ecx, -1
	
	and esi, eax
	and ecx, edx
	or esi, ecx
	je .qReturn
	
	xor ecx, ecx
	
.loop:
	mov esi, edx
	inc ecx
	shr eax, 1
	shl esi, 31
	or eax, esi
	shr edx, 1
	
	mov esi, eax
	movzx ecx, cl
	or esi, edx
	jne .loop
	jmp .return
	
.return1:
	xor ecx, ecx

.return:
	cmp ecx, 31
	jbe .return64
	
	mov edx, 1
	xor eax, eax
	shl edx, cl
	pop esi
	ret
	
	align 16
.return64:
	xor edx, edx
	mov eax, 1
	shld edx, eax, cl
	shl eax, cl
	
.qReturn:
	pop esi
	ret
	
	
	
segment .rodata align=4

	xmmDat dq -1
	
segment .text align=16

_nextPowerOf264SSE4:
	push edi
	
	movq xmm1, [esp + 8]
	ptest xmm1, xmm1
	je .return1
	
	movq xmm0,[xmmDat]
	movdqa xmm2, xmm0
	paddq xmm2, xmm1
	pand xmm2, xmm1
	ptest xmm2, xmm2
	jne .continue
	
	movd eax, xmm1
	psrlq xmm1, 32
	movd edx, xmm1
	pop edi
	ret
	
	align 16
.continue:
	xor ecx, ecx
	
.loop:
	psrlq xmm1, 1
	movdqa xmm2, xmm0
	inc ecx
	pand xmm2, xmm1
	movzx ecx, cl
	ptest xmm2, xmm2
	jne .loop
	jmp .return
	
	align 16
.return1:
	xor ecx, ecx
	
.return:
	cmp ecx, 31
	jbe .return64
	
	mov edx, 1
	xor eax, eax
	shl edx, cl
	pop edi
	ret
	
	align 16
.return64:
	xor edx, edx
	mov eax, 1
	shld edx, eax, cl
	shl eax, cl
	pop edi
	ret
	
	
	
	align 16
_nextPowerOf264AVX:
	push edi
	
	vmovq xmm1, [esp + 4 + 4]
	vptest xmm1, xmm1
	je .return1
	
	vmovq xmm0, [xmmDat]
	vpaddq xmm2, xmm1, xmm0
	vpand xmm3, xmm1, xmm2
	vptest xmm3, xmm3
	jne .continue
	
	vpsrlq xmm0, xmm1, 32
	vmovd eax, xmm1
	vmovd edx, xmm0
	pop edi
	ret
	
	align 16
.continue:
	xor ecx, ecx
	
.loop:
	vpsrlq xmm1, xmm1, 1
	inc ecx
	vpand xmm2, xmm1, xmm0
	movzx ecx, cl
	vptest xmm2, xmm2
	jne .loop
	jmp .return
	
	align 16
.return1:
	xor ecx, ecx
	
.return:
	cmp ecx, 31
	jbe .return64
	
	mov edx, 1
	xor eax, eax
	shl edx, cl
	pop edi
	ret
	
	align 16
.return64:
	xor edx, edx
	mov eax, 1
	shld edx, eax, cl
	shl eax, cl
	pop edi
	ret
	
	
	
	align 16
_nextPowerOf264BMI2:
	vmovq xmm1, [esp + 4]
	vptest xmm1, xmm1
	je .return1
	
	vmovq xmm0, [xmmDat]
	vpaddq xmm2, xmm1, xmm0
	vpand xmm3, xmm1, xmm2
	vptest xmm3, xmm3
	jne .continue
	
	vpsrlq xmm0, xmm1, 32
	vmovd eax, xmm1
	vmovd edx, xmm0
	ret
	
	align 16
.continue:
	xor ecx, ecx
	
.loop:
	vpsrlq xmm1, 1
	inc ecx
	vpand xmm2, xmm1, xmm0
	movzx ecx, cl
	vptest xmm2, xmm2
	jne .loop
	jmp .return
	
	align 16
.return1:
	xor ecx, ecx
	
.return:
	mov eax, 1
	cmp ecx, 31
	jbe .return64
	
	shlx edx, eax, ecx
	xor eax, eax
	ret
	
	align 16
.return64:
	xor edx, edi
	shld edx, eax, cl
	shlx eax, eax, ecx
	ret