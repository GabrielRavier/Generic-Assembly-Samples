%include "macros.inc"

global _gcd
global _gcd64	
global _lcm
global _lcm64
                
extern _divide64

segment .text align=16

_gcd:
	mov eax, [esp + 4]
	mov edx, [esp + 8]
	
.restart:
	test eax, eax
	je .return0
	
	test edx, edx
	je .return0
	
	cmp eax, edx
	je .return
	
	mov ecx, edx
	sub ecx, eax
	
	cmp eax, edx
	jle .aIsSmaller
	
	neg ecx
	mov eax, ecx
	jmp .restart
	
	align 16
.aIsSmaller:
	mov edx, ecx
	jmp .restart
	
	align 16
.return:
	ret
	
.return0:
	xor eax, eax
	ret
	
	
	
	
	
	align 16
_gcd64:
	multipush esi, edi, ebx, ebp
	sub esp, 12
	
	mov eax, [esp + 32]
	mov ecx, eax
	mov edx, [esp + 36]
	or ecx, edx
	
	mov ebp, [esp + 40]
	mov ebx, [esp + 44]
	
	je .return0
	
	mov ecx, ebp
	or ecx, ebx
	je .return0
	
	mov esi, eax
	mov ecx, edx
	sub esi, ebp
	sub ecx, ebx
	or esi, ecx
	je .return
	
	mov ecx, ebp
	mov esi, ebx
	sub ecx, eax
	mov edi, edx
	sbb esi, edx
	mov [esp + 4], esi
	
	mov esi, eax
	sub esi, ebp
	sbb edi, edx
	mov [esp], edi
	jl .callGcdABMinusA
	or esi, [esp]
	je .callGcdABMinusA
	
	xor eax, eax
	sub eax, ecx
	mov ecx, 0
	sbb ecx, [esp + 4]
	
	mov [esp + 36], ecx
	mov [esp + 44], ebx
	mov [esp + 40], ebp
	mov [esp + 32], eax
	
	add esp, 12
	multipop esi, edi, ebx, ebp
	jmp _gcd64
	
	align 16
.callGcdABMinusA:
	mov [esp + 36], edx
	mov edx, [esp + 4]
	mov [esp + 44], edx
	mov [esp + 40], ecx
	mov [esp + 32], eax
	add esp, 12
	multipop esi, edi, ebx, ebp
	jmp _gcd64
	
	align 16
.return:
	add esp, 12
	pop ebp
	pop ebx
	pop edi
	pop esi
	ret
	
	align 16
.return0:
	multizero eax, edx
	add esp, 12
	multipop esi, edi, ebx, ebp
	ret
	
	
	
	
	
	align 16
_lcm:
	multipush ebx, ebp
	sub esp, 20
	
	mov ebp, [esp + 32]
	mov ebx, [esp + 36]
	
	add esp, 8
	push ebx
	push ebp
	call _gcd
	
	mov ecx, eax
	imul ebp, ebx
	mov eax, ebp
	cdq
	idiv ecx
	add esp, 20
	multipop ebx, ebp
	ret
	
	
	
	
	
	align 16
_lcm64:
	multipush esi, edi, ebx, ebp
	sub esp, 12
	
	mov edx, [esp + 44]
	mov ebx, [esp + 40]
	mov ebp, [esp + 32]
	mov esi, [esp + 36]
	mov [esp], edx
	
	multipush edx, ebx, esi, ebp
	call _gcd64
	
	mov edi, eax
	mov ecx, edx
	add esp, 16
	
	mov edx, [esp]
	mov eax, ebp
	imul esi, ebx
	imul edx, ebp
	add esi, edx
	mul ebx
	add edx, esi
	
	mov [esp + 36], edx
	mov [esp + 44], ecx
	mov [esp + 40], edi
	mov [esp + 32], eax
	
	add esp, 12
	multipop esi, edi, ebx, ebp
	jmp _divide64
	
	
	
	
	
	align 16
_lcm64SSE2:
	sub esp, 60
	
	movq xmm0, [esp + 64]
	movq xmm1, [esp + 72]
	
	movdqu [esp + 32], xmm0
	movdqu [esp + 16], xmm1
	
	movq [esp], xmm0
	movq [esp + 8], xmm1
	
	call _gcd64
	
	movdqu xmm2, [esp + 32]
	movdqu xmm0, [esp + 16]
	
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
	
	mov [esp + 76], edx
	mov [esp + 72], eax
	movq [esp + 64], xmm3
	
	add esp, 60
	jmp _divide64
	
	
	
	
	
	align 16
_lcm64AVX:
	sub esp, 60
	
	vmovq xmm0, [esp + 64]
	vmovq xmm1, [esp + 72]
	
	vmovdqu [esp + 32], xmm0
	vmovdqu [esp + 16], xmm1
	
	vmovq [esp], xmm0
	vmovq [esp + 8], xmm1
	
	call _gcd64
	
	vmovdqu xmm2, [esp + 32]
	vmovdqu xmm3, [esp + 16]
	
	vpsrlq xmm1, xmm2, 32
	vpsrlq xmm0, xmm3, 32
	
	vpmuludq xmm4, xmm0, xmm2
	vpmuludq xmm5, xmm1, xmm3
	vpmuludq xmm0, xmm2, xmm3
	
	vpaddq xmm6, xmm4, xmm5
	vpsllq xmm7, xmm6, 32
	vpaddq xmm1, xmm7, xmm0
	
	mov [esp + 76], edx
	mov [esp + 72], eax
	vmovq [esp + 64], xmm1
	
	add esp, 60
	jmp _divide64
	
	
	
	
	
	align 16
_lcm64AVX512:
	sub esp, 60
	
	vmovq xmm0, [esp + 64]
	vmovq xmm1, [esp + 72]
	
	vmovdqu [esp + 32], xmm0
	vmovdqu [esp + 16], xmm1
	
	call _gcd64
	
	vmovdqu xmm0, [esp + 32]
	vpmullq xmm1, xmm0, [esp + 16]
	
	mov [esp + 76], edx
	mov [esp + 72], eax
	vmovq [esp + 64], xmm1
	
	add esp, 60
	jmp _divide64