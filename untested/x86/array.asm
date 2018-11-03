global _sumArray	; int64_t sum(const int arr[], size_t n)
global _getMedian	; int32_t getMedian(int32_t ar1[], int32_t ar2[], size_t n) 

segment .data align=4

	xmmData1 dd 0, -1, 0, -1
	align 4
	xmmData2 dd -1, 0, -1, 0

segment .text align=16

_sumArray:
	push ebx
	push ebp
	sub esp, 20
	
	mov eax, [esp + 36]
	
	test eax, eax
	jbe .return0
	
	mov edx, eax
	xor ecx, ecx
	shr edx, 1
	xor ebp, ebp
	
	test edx, edx
	jbe .small
	
	mov [esp + 4], edi
	xor ebx, ebx
	mov [esp], esi
	mov esi, edx
	mov edi, [esp + 32]
	
.sumLoop:
	mov eax, [edi + ebx * 8]
	add ecx, eax
	cdq
	
	mov eax, [edi + ebx * 8 + 4]
	adc ebp, edx
	cdq
	
	add ecx, eax
	adc ebp, edx
	
	inc ebx
	cmp ebx, esi
	jb .sumLoop
	
	mov eax, [esp + 36]
	lea edx, [ebx + ebx + 1]
	mov esi, [esp]
	mov edi, [esp + 4]
	
.finishArray:
	dec edx
	
	cmp edx, eax
	jae .return
	
	mov ebx, [esp + 32]
	mov eax, [ebx + edx * 4]
	add ecx, [ebx + edx * 4]
	cdq
	
	adc ebp, edx
	jmp .return
	
.return0:
	xor ecx, ecx
	xor ebp, ebp
	
.return:
	mov eax, ecx
	mov edx, ebp
	
	add esp, 20
	pop ebp
	pop ebx
	ret
	
.small:
	mov edx, 1
	jmp .finishArray
	
	
	
	
	
_sumArrayi686:
	push esi
	sub esp, 24
	
	xor eax, eax
	mov edx, [esp + 36]
	xor ecx, ecx
	
	test edx, edx
	je .return
	
	mov [esp + 8], edi
	xor esi, esi
	mov [esp + 4], ebx
	mov ebx, eax
	mov [esp], ebp
	mov ebp, edx
	mov edi, [esp + 32]
	
.sumLoop:
	mov eax, [edi + esi * 4]
	add ebx, eax
	cdq
	adc ecx, edx
	
	inc esi
	cmp esi, ebp
	jb .sumLoop
	
	mov edi, [esp + 8]
	mov eax, ebx
	mov ebx, [esp + 4]
	mov ebp, [esp]
	
.return:
	mov edx, ecx
	add esp, 24
	pop esi
	ret
	
	
	
	
	
_sumArraySSSE3:
	push esi
	push edi
	push ebx
	push ebp
	sub esp, 12
	
	mov ebx, [esp + 36]
	test ebx, ebx
	jbe .return0
	
	mov ecx, [esp + 32]
	
	cmp ebx, 4
	jb .small
	
	mov eax, ecx
	and eax, 0xF
	je .confirmed
	
	test al, 3
	jne .small
	
	neg eax
	add eax, 16
	shr eax, 2
	
.confirmed:
	lea edx, [eax + 4]
	cmp ebx, edx
	jb .small
	
	mov ebp, ebx
	xor edx, edx
	sub ebp, eax
	xor esi, esi
	and ebp, 3
	neg ebp
	add ebp, ebx
	test eax, eax
	jbe .noStartLoop
	
	mov [esp], ebp
	xor edi, edi
	mov ebx, eax
	mov ebp, ecx
	mov ecx, edx
	
.startLoop:
	mov eax, [ebp + edi * 4]
	add ecx, eax
	cdq
	adc esi, edx
	
	inc edi
	cmp edi, ebx
	jb .startLoop
	
	mov edx, ecx
	mov ecx, ebp
	mov ebp, [esp]
	mov eax, ebx
	mov ebx, [esp + 36]
	
.noStartLoop:
	movd xmm0, edx
	movd xmm1, esi
	punpckldq xmm0, xmm1
	movdqa xmm2, [xmmData1]
	pxor xmm3, xmm3
	movdqa xmm1, [xmmData2]
	
.xmmLoop:
	movq xmm4, [ecx + eax * 4]
	movq xmm6, [ecx + eax * 4 + 8]
	
	add eax, 4
	
	punpckldq xmm4, xmm4
	punpckldq xmm6, xmm6
	
	movdqa xmm5, xmm4
	movdqa xmm7, xmm6
	
	psrad xmm5, 31
	psrad xmm7, 31
	
	pand xmm5, xmm2
	pand xmm4, xmm1
	pand xmm7, xmm2
	pand xmm6, xmm1
	
	por xmm5, xmm4
	por xmm7, xmm6
	
	paddq xmm0, xmm5
	paddq xmm3, xmm7
	
	cmp eax, ebp
	jb .xmmLoop
	
	paddq xmm0, xmm3
	movdqa xmm1, xmm0
	psrldq xmm1, 8
	paddq xmm0, xmm1
	movdqa xmm2, xmm0
	psrlq xmm2, 32
	movd esi, xmm0
	movd edi, xmm2
	
.startTrailingLoop:
	cmp ebp, ebx
	jae .return
	
.trailingLoop:
	mov eax, [ecx + ebp * 4]
	add esi, eax
	cdq
	adc edi, edx
	
	inc ebp
	cmp ebp, ebx
	jb .trailingLoop
	jmp .return
	
.return0:
	xor esi, esi
	xor edi, edi
	
.return:
	mov eax, esi
	mov edx, edi
	
	add esp, 12
	pop ebp
	pop ebx
	pop edi
	pop esi
	ret
	
.small:
	xor esi, esi
	xor edi, edi
	xor ebp, ebp
	jmp .startTrailingLoop
	
	
	
	
	
_sumArraySSE4:
	push esi
	push edi
	push ebx
	push ebp
	sub esp, 12
	
	mov ebx, [esp + 36]
	test ebx, ebx
	jbe .return0
	
	mov ecx, [esp + 32]
	cmp ebx, 4
	jb .small
	
	mov eax, ecx
	and eax, 0xF
	je .confirmed
	
	test al, 3
	jne .small
	
	neg eax
	add eax, 16
	shr eax, 2
	
.confirmed:
	lea edx, [eax+4]
	cmp ebx, edx
	jb .small
	
	mov ebp, ebx
	xor edx, edx
	sub ebp, eax
	xor esi, esi
	and ebp, 3
	neg ebp
	add ebp, ebx
	test eax, eax
	jbe .noStartLoop
	
	mov [esp], ebp
	xor edi, edi
	mov ebx, eax
	mov ebp, ecx
	mov ecx, edx

.startLoop:
	mov eax, [ebp + edi * 4]
	add ecx, eax
	cdq
	adc esi, edx
	
	inc edi
	cmp edi, ebx
	jb .startLoop
	
	mov edx, ecx
	mov ecx, ebp
	mov ebp, [esp]
	mov eax, ebx
	mov ebx, [esp + 36]
	
.noStartLoop:
	movd xmm1, edx
	movd xmm0, esi
	punpckldq xmm1, xmm0
	pxor xmm0, xmm0
	
.xmmLoop:
	pmovsxdq xmm2, [ecx + eax * 4]
	pmovsxdq xmm3, [ecx + eax * 4 + 8]
	
	add eax, 4
	
	paddq xmm1, xmm2
	paddq xmm0, xmm3
	
	cmp eax, ebp
	jb .xmmLoop
	
	paddq xmm1, xmm0
	movdqa xmm0, xmm1
	psrldq xmm0, 8
	paddq xmm1, xmm0
	movdqa xmm2, xmm1
	psrlq xmm2, 32
	movd esi, xmm1
	movd edi, xmm2
	
.startTrailingLoop:
	cmp ebp, ebx
	jae .return
	
.trailingLoop:
	mov eax, [ecx + ebp * 4]
	add esi, eax
	cdq
	adc edi, edx
	
	inc ebp
	cmp ebp, ebx
	jb .trailingLoop
	jmp .return
	
.return0:
	xor esi, esi
	xor edi, edi
	
.return:
	mov eax, esi
	mov edx, edi
	
	add esp, 12
	pop ebp
	pop ebx
	pop edi
	pop esi
	ret
	
.small:
	xor esi, esi
	xor edi, edi
	xor ebp, ebp
	jmp .startTrailingLoop
	
	
	
	

_sumArrayAVX:
	push esi
	push edi
	push ebx
	sub esp, 16
	
	mov eax, [esp + 36]
	
	test eax, eax
	jbe .return0
	
	cmp eax, 4
	jb .small
	
	mov edx, [esp + 32]
	
	and edx, 0x1F
	je .confirmed
	
	test dl, 3
	jne .small
	
	neg edx
	add edx, 32
	shr edx, 2
	
.confirmed:
	lea ecx, [edx + 4]
	cmp eax, ecx
	jb .small
	
	mov edi, eax
	xor ecx, ecx
	sub edi, edx
	xor esi, esi
	and edi, 3
	neg edi
	add edi, eax
	test edx, edx
	jbe .noStartLoop
	
	mov [esp], edi
	
	xor ebx, ebx
	mov edi, edx
	
.startLoop:
	mov eax, [esp + 32]
	add ecx, [eax + ebx * 4]
	mov eax, [eax + ebx * 4]
	cdq
	adc esi, edx
	
	inc ebx
	cmp ebx, edi
	jb .startLoop
	
	mov eax, [esp + 36]
	mov edx, edi
	mov edi, [esp]
	
.noStartLoop:
	vmovd xmm0, ecx
	vmovd xmm1, esi
	vpunpckldq xmm1, xmm0, xmm1
	mov ecx, [esp + 32]
	vpxor xmm0, xmm0, xmm0
	
.xmmLoop:
	vpmovsxdq xmm2, [ecx + edx * 4]
	vpmovsxdq xmm3, [ecx + edx * 4 + 8]
	
	add edx, 4
	
	vpaddq xmm1, xmm1, xmm2
	vpaddq xmm0, xmm0, xmm3
	
	cmp edx, edi
	jb .xmmLoop
	
	vpaddq xmm0, xmm1, xmm0
	vpsrldq xmm1, xmm0, 8
	vpaddq xmm2, xmm0, xmm1
	vpsrlq xmm3, xmm2, 32
	vmovd ecx, xmm2
	vmovd ebx, xmm3
	
.startTrailingLoop:
	cmp edi, eax
	jae .return
	
	mov esi, [esp + 32]
	
.trailingLoop:
	mov eax, [esi + edi * 4]
	add ecx, [esi + edi * 4]
	cdq
	adc ebx, edx
	
	inc edi
	cmp edi, [esp + 36]
	jb .trailingLoop
	jmp .return
	
.return0:
	xor ecx, ecx
	xor ebx, ebx
	
.return:
	mov eax, ecx
	mov edx, ebx

	add esp, 16
	pop ebx
	pop edi
	pop esi
	ret
	
.small:
	xor ecx, ecx
	xor ebx, ebx
	xor edi, edi
	jmp .startTrailingLoop
	
	
	
	
	
_sumArrayAVX2:
	push esi
	push edi
	push ebx
	sub esp, 16
	
	mov eax, [esp + 36]
	
	test eax, eax
	jbe .return0
	
	cmp eax, 4
	jb .small
	
	cmp eax, 47
	jb .medium
	
	mov edx, [esp + 32]
	and edx, 0xF
	je .confirmed
	
	test dl, 3
	jne .small
	
	neg edx
	add edx, 16
	shr edx, 2
	
.confirmed:
	lea ecx, [edx + 4]
	cmp eax, ecx
	jb .small
	
	mov edi, eax
	xor ecx, ecx
	sub edi, edx
	xor ebx, ebx
	
	and edi, 3
	neg edi
	add edi, eax
	test edx, edx
	jbe .noStartLoop
	
	mov [esp], edi
	xor esi, esi
	mov edi, edx
	
.startLoop:
	mov eax, [esp + 32]
	add ecx, [eax + esi * 4]
	mov eax, [eax + esi * 4]
	cdq
	adc ebx, edx
	
	inc esi
	cmp esi, edi
	jb .startLoop
	
	mov eax, [esp + 36]
	mov edx, edi
	mov edi, [esp]
	
.noStartLoop:
	vmovd xmm0, ecx
	vmovd xmm1, ebx
	vpunpckldq xmm0, xmm0, xmm1
	mov ecx, [esp + 32]
	vmovaps xmm0, xmm0
	
.ymmLoop:
	vpmovsxdq ymm1, [ecx + edx * 4]
	
	add edx, 4
	
	vpaddq ymm0, ymm0, ymm1
	
	cmp edx, edi
	jb .ymmLoop
	
	vextractf128 xmm1, ymm0, 1
	vpaddq xmm2, xmm0, xmm1
	vpsrldq xmm3, xmm2, 8
	vpaddq xmm4, xmm2, xmm3
	vpsrlq xmm5, xmm4
	
	vmovd ecx, xmm4
	vmovd ebx, xmm5
	
.startTrailingLoop:
	cmp edi, eax
	jae .return
	
	mov esi, [esp + 32]
	
.trailingLoop:
	mov eax, [esi + edi * 4]
	add ecx, [esi + edi * 4]
	cdq
	adc ebx, edx
	
	inc edi
	cmp edi, [esp + 36]
	jb .trailingLoop
	jmp .return
	
.return0:
	xor ecx, ecx
	xor ebx, ebx
	
.return:
	vzeroupper
	mov eax, ecx
	mov edx, ebx

	add esp, 16
	pop ebx
	pop edi
	pop esi
	ret
	
.small:
	xor ecx, ecx
	xor ebx, ebx
	xor edi, edi
	jmp .startTrailingLoop
	
.medium:
	xor ecx, ecx
	mov edi, eax
	xor ebx, ebx
	
	and edi, -4
	xor edx, edx
	jmp .noStartLoop
	
	
	
	
	
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
	
.jEqualsn:
	mov edx, [esp + 32]
	mov eax, ebp
	mov edi, [esp + 8]
	mov ebx, [esp + 4]
	mov ebp, [esp]
	mov edx, [edx]
	jmp .return
	
.iEqualsn:
	mov edx, [esp + 36]
	mov eax, ebp
	mov edi, [esp + 8]
	mov ebx, [esp + 4]
	mov ebp, [esp]
	mov edx, [edx]
	jmp .return
	
	
	
_getMediani686:
	push ebp
	xor ecx, ecx
	push edi
	push esi
	xor esi, esi
	push ebx
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
	pop ebx
	
	add eax, edi
	mov edx, eax
	shr edx, 31
	pop esi
	add eax, edx
	sar eax, 1
	pop edi
	pop ebp
	ret
	
.jEqualsn:
	mov eax, [ebp]
	jmp .return
	
.iEqualsn:
	mov eax, [eax]
	jmp .return