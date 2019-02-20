%include "macros.inc"

global _sumArray
global _getMedian

segment .text align=16

_sumArray:
	mov eax, [esp + 8]
	
	test eax, eax
	je .ret0
	
	mov edx, [esp + 4]
	lea ecx, [edx + eax * 4]
	
	xor eax, eax
	
.loop:
	add eax, [edx]
	add edx, 4
	cmp edx, ecx
	jne .loop
	
	ret
	
	align 16
.ret0:
	xor eax, eax
	ret
	
	
	
	align 16
_sumArraySSE2:
	multipush esi, ebx, ebp
	
	mov ebx, [esp + 20]
	test ebx, ebx
	jbe .ret0
	
	mov ecx, [esp + 16]
	cmp ebx, 8
	jb .noSSE
	
	mov eax, ecx
	and eax, 0xF
	je .aligned
	
	test al, 3
	jne .noSSE
	
	neg eax
	add eax, 16
	shr eax, 2
	
.aligned:
	lea edx, [eax + 8]
	cmp ebx, edx
	jb .noSSE
	
	mov edx, ebx
	xor esi, esi
	sub edx, eax
	and edx, 7
	neg edx
	add edx, ebx
	
	test eax, eax
	jbe .noAlign
	
	xor ebp, ebp
	
.alignLoop:
	add esi, [ecx + ebp * 4]
	inc ebp
	cmp ebp, eax
	jb .alignLoop
	
.noAlign:
	movd xmm0, esi
	
.xmmLoop:
	paddd xmm0, [ecx + eax * 4]
	paddd xmm0, [ecx + eax * 4 + 16]
	
	add eax, 8
	cmp eax, edx
	jb .xmmLoop
	
	movdqa xmm1, xmm0
	psrldq xmm1, 8
	paddd xmm0, xmm1
	movdqa xmm2, xmm0
	psrlq xmm2, 32
	paddd xmm0, xmm2
	movd eax, xmm0
	
.startEndLoop:
	cmp edx, ebx
	jae .return
	
.endLoop:
	add eax, [ecx + edx * 4]
	inc edx
	cmp edx, ebx
	jb .endLoop
	jmp .return
	
	align 16
.ret0:
	xor eax, eax

.return:
	multipop esi, ebx, ebp
	ret
	
	align 16
.noSSE:
	xor eax, eax
	xor edx, edx
	jmp .startEndLoop
	
	
	
	align 16
_sumArrayAVX:
	multipush esi, edi, ebx
	
	mov ebx, [esp + 20]
	test ebx, ebx
	jbe .ret0
	
	mov ecx, [esp + 16]
	cmp ebx, 4
	jb .noAVX
	
	mov eax, ecx
	and eax, 0xF
	je .aligned
	
	test al, 3
	jne .noAVX
	
	neg eax
	add eax, 16
	shr eax, 2
	
.aligned:
	lea edx, [eax + 4]
	cmp ebx, edx
	jb .noAVX
	mov edx, ebx
	
	xor edi, edi
	
	sub edx, eax
	and edx, 3
	neg edx
	add edx, ebx
	
	test eax, eax
	jbe .startAVX
	
	xor esi, esi
	
.alignLoop:
	add edi, [ecx + esi * 4]
	inc esi
	cmp esi, eax
	jb .alignLoop
	
.startAVX:
	vmovd xmm0, edi
	
.avxLoop:
	vpaddd xmm0, [ecx + eax * 4]
	add eax, 4
	cmp eax, edx
	jb .avxLoop
	
	vpsrldq xmm1, xmm0, 8
	vpaddd xmm0, xmm1
	vpsrlq xmm2, xmm0, 32
	vpaddd xmm3, xmm0, xmm2
	vmovd eax, xmm3

.startEndLoop:
	cmp edx, ebx
	jae .return
	
.endLoop:
	add eax, [ecx + edx * 4]
	inc edx
	cmp edx, ebx
	jb .endLoop
	jmp .return
	
.ret0:
	xor eax, eax
	
.return:
	multipop esi, edi, ebx
	ret
	
.noAVX:
	xor eax, eax
	xor edx, edx
	jmp .startEndLoop
	
	
	
	align 16
_sumArrayAVX2:
	multipush esi, edi, ebx
	
	mov ebx, [esp + 20]
	test ebx, ebx
	jbe .ret0
	
	mov ecx, [esp + 16]
	cmp ebx, 8
	jb .small
	
	cmp ebx, 249
	jb .noAlign
	
	mov eax, ecx
	and eax, 0x1F
	je .checkity
	
	test al, 3
	jne .small
	
	neg eax
	add eax, 32
	shr eax, 2
	
.checkity:
	lea edx, [eax + 8]
	cmp ebx, edx
	jb .small
	
	mov edx, ebx
	xor esi, esi
	sub edx, eax
	and edx, 7
	neg edx
	add edx, ebx
	test eax, eax
	jbe .startAVX
	
	xor edi, edi
	
.alignLoop:
	add esi, [ecx + edi * 4]
	inc edi
	cmp edi, eax
	jb .alignLoop
	
.startAVX:
	vmovd xmm0, esi
	vmovaps xmm0, xmm0
	
.ymmLoop:
	vpaddd ymm0, [ecx + eax * 4]
	add eax, 8
	cmp eax, edx
	jb .ymmLoop
	
	vextractf128 xmm1, ymm0, 1
	vpaddd xmm2, xmm0, xmm1
	vpsrldq xmm3, xmm2, 8
	vpaddd xmm4, xmm2, xmm3
	vpsrlq xmm5, xmm4, 32
	vpaddd xmm6, xmm4, xmm5
	vmovd eax, xmm6
	
.startEndLoop:
	cmp edx, ebx
	jae .return
	
.endLoop:
	add eax, [ecx + edx * 4]
	inc edx
	cmp edx, ebx
	jb .endLoop
	jmp .return
	
	align 16
.ret0:
	xor eax, eax
	
.return:
	vzeroupper
	multipop esi, edi, ebx
	ret
	
	align 16
.small:
	xor eax, eax
	xor edx, edx
	jmp .startEndLoop
	
	align 16
.noAlign:
	mov edx, ebx
	xor esi, esi
	and edx, -8
	xor eax, eax
	jmp .startAVX
	
	
	
	
	
	align 16
_getMedian:
	push esi
	sub esp, 24
	
	xor ecx, ecx
	xor esi, esi
	mov edx, -1
	
	mov [esp + 8], edi
	xor eax, eax
	mov [esp + 4], ebx
	mov [esp], ebp
	mov edi, [esp + 40]
	
.loop:
	mov ebp, ebx
	
	cmp ecx, edi
	je .iEqualsn
	
	cmp esi, edi
	je .jEqualsn
	
	mov ebx, [esp + 32]
	mov edx, [esp + 36]
	mov ebx, [ebx + ecx * 4]
	mov edx, [edx + ecx * 4]
	
	cmp ebx, edx
	jge .bigger
	
	mov edx, ebx
	
	inc ecx
	jmp .check
	
	align 16
.bigger:
	inc esi
	
.check:
	inc eax
	cmp eax, edi
	jbe .loop
	
	mov edi, [esp + 8]
	mov eax, ebp
	mov ebx, [esp + 4]
	mov ebp, [esp]
	
.return:
	add eax, edx
	mov edx, eax
	shr edx, 31
	add eax, edx
	sar eax, 1
	add esp, 24
	pop esi
	ret
	
	align 16
.jEqualsn:
	mov edx, [esp + 32]
	mov eax, ebp
	mov edi, [esp + 8]
	mov ebx, [esp + 4]
	mov ebp, [esp]
	mov edx, [edx]
	jmp .return
	
	align 16
.iEqualsn:
	mov edx, [esp + 36]
	mov eax, ebp
	mov edi, [esp + 8]
	mov ebx, [esp + 4]
	mov ebp, [esp]
	mov edx, [edx]
	jmp .return
	
	
	
	align 16
_getMediani686:
	multipush ebp, edi, esi, ebx
	
	xor esi, esi
	xor ecx, ecx
	xor ebx, ebx
	sub esp, 4
	
	mov dword [esp], -1
	mov ebp, [esp + 28]
	mov edx, [esp + 32]
	jmp .startLoop

	align 16
.loop:
	inc esi
	inc ecx
	cmp esi, edx
	ja .return
	
.loop2:
	mov [esp], eax
	
.startLoop:
	cmp ecx, edx
	je .iEqualsn
	
	cmp ebx, edx
	mov eax, [esp + 24]
	je .jEqualsn
	
	mov eax, [eax + ecx * 4]
	mov edi, [ebp + ebx * 4]
	cmp eax, edi
	jl .loop
	
	inc esi
	inc ebx
	cmp esi, ebx
	mov eax, edi
	jbe .loop2
	
.return:
	mov edi, [esp]
	
	pop ecx
	
	add eax, edi
	mov edx, eax
	shr edx, 31
	add eax, edx
	sar eax, 1
	multipush ebp, edi, esi, ebx
	ret
	
	align 16
.jEqualsn:
	mov eax, [ebp]
	jmp .return
	
	align 16
.iEqualsn:
	mov eax, [eax]
	jmp .return