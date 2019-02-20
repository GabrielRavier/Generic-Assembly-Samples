%include "macros.inc"

global _intToBase
global _intToBase64

segment .text align=16

_intToBase:
	multipush ebp, edi, esi, ebx, edx
	
	mov eax, [esp + 24]	; num
	mov esi, [esp + 28]	; str
	
	test eax, eax
	jne .notZero
	
	mov word [esi], 48	; '0\0'
	jmp .return
	
.notZero:
	mov esi, 0	; sign
	jns .notNegative
	
	neg eax
	mov esi, 1
	
.notNegative:
	mov dword [esp], 0
	
.loop:
	cdq
	idiv dword [esp + 32]
	mov ebx, eax
	
	lea ebp, [edx + '0']
	cmp edx, 9
	jle .smallerThan10
	
	lea ebp, [edx + 'A' - 10]
	
.smallerThan10:
	mov eax, [esp]
	lea edx, [eax + 1]
	mov edi, edx
	mov eax, ebp
	mov byte [ecx + edx - 1], al

	mov eax, ebx
	
	test ebx, ebx
	je .finish
	
	mov [esp], edx
	jmp .loop
	
.finish:
	mov ebx, esi
	test bl, bl
	je .numNotNegative
	
	mov edx, [esp]
	add edx, 2
	mov byte [ecx + edi], '-'
	
.numNotNegative:
	mov byte [ecx + edx], 0
	
.reverseLoop:
	dec edx
	
	cmp eax, edx
	jge .return
	
	movzx ebp, byte [ecx + eax]
	mov bl, byte [ecx + edx]
	mov byte [ecx + eax], bl
	mov ebx, ebp
	mov byte [ecx + edx], bl
	
	inc eax
	jmp .reverseLoop
	
.return:
	multipop ebp, edi, esi, ebx, eax
	ret
	
	
	
	
	
	align 16
_intToBase64:
	multipush ebp, edi, esi, ebx
	sub esp, 68
	mov edx, [esp + 92]
	mov eax, [esp + 88]
	
	mov edi, edx
	mov [esp], eax
	or edi, eax
	mov [esp + 4], edx
	je .prnt0
	
	mov byte [esp + 63], 0
	
	test edx, edx
	js .numNegative
	
.startDigitsLoop:
	mov eax, [esp + 100]
	cdq
	
	mov [esp + 8], eax
	mov ebp, edx
	mov [esp + 12], edx
	sar ebp, 31
	xor eax, ebp
	xor edx, ebp
	
	mov [esp + 40], ebp
	sub eax, ebp
	mov [esp + 44], ebp
	sbb edx, ebp
	mov [esp + 48], eax
	xor ebp, ebp
	
	mov edi, edx
	mov [esp + 52], edx
	mov edx, [esp + 4]
	
	or edi, eax
	mov [esp + 56], edi
	
.digitsLoop:
	mov ebx, [esp + 40]
	sar edx, 31
	mov esi, [esp + 44]
	mov eax, edx
	xor ebx, edx
	xor esi, edx
	
	mov [esp + 32], ebx
	mov ebx, [esp + 56]
	mov [esp + 36], esi
	
	test ebx, ebx
	je .den0
	
	mov ebx, [esp + 52]
	mov ecx, [esp + 48]
	test ebx, ebx
	js .denNegative
	
	mov esi, 1
	xor edi, edi
	
.denLoop:
	shld ebx, ecx, 1
	shld edi, esi, 1
	add ecx, ecx
	add esi, esi
	
	test ebx, ebx
	jns .denLoop
	
	mov [esp + 28], ebx
	mov ebx, edi
	or ebx, esi
	mov [esp + 24], ecx
	je .qbit0
	
.startQbitLoop:
	mov ecx, [esp]
	mov ebx, [esp + 4]
	xor ecx, eax
	xor ebx, edx
	sub ecx, eax
	sbb ebx, edx
	
	xor eax, eax
	xor edx, edx
	
	mov [esp + 16], ecx
	mov [esp + 20], ebx
	mov ecx, [esp + 24]
	mov ebx, [esp + 28]
	mov [esp + 24], eax
	mov [esp + 28], edx
	
.qbitLoop:
	mov eax, [esp + 16]
	mov edx, [esp + 20]
	
	cmp eax, ecx
	mov eax, edx
	sbb eax, ebx
	jc .denSupNum
	
	sub [esp + 16], ecx
	sbb [esp + 20], ebx
	
	add [esp + 24], esi
	adc [esp + 28], edi
	
.denSupNum:
	shrd esi, edi, 1
	shr edi, 1
	
	mov eax, edi
	
	shrd ecx, ebx, 1
	shr ebx, 1
	
	or eax, esi
	jne .qbitLoop
	
	mov eax, [esp + 24]
	mov edx, [esp + 28]
	
.endDiv:
	mov ebx, [esp + 32]
	mov esi, [esp + 36]
	
	xor eax, ebx
	xor edx, esi
	
	sub eax, ebx
	
	mov ecx, eax
	mov eax, [esp + 8]
	
	sbb edx, esi
	
	mov esi, [esp]
	mov ebx, edx
	
	mul ecx
	sub esi, eax
	
	lea eax, [ebp + 1]
	mov edx, esi
	cmp esi, 9
	jle .remUnder10
	
	mov edi, [esp + 96]
	add edx, 87
	mov [edi + eax - 1], dl
	
	mov edi, ebx
	or edi, ecx
	je .num0
	
.continue:
	mov ebp, eax
	mov [esp], ecx
	mov edx, ebx
	mov [esp + 4], ebx
	jmp .digitsLoop
	
	align 16
.remUnder10:
	mov edi, [esp + 96]
	add edx, 48
	mov [edi + eax - 1], dl
	
	mov edi, ebx
	or edi, ecx
	jne .continue
	
.num0:
	mov edx, [esp + 96]
	add edx, eax
	cmp byte [esp + 63], 0
	jne .numIsNegative
	
	mov byte [edx], 0
	
	test ebp, ebp
	je .return
	
.startReverse:
	mov edx, [esp + 96]
	xor eax, eax
	
.reverseLoop:
	movzx ebx, byte [edx + eax]
	movzx ecx, byte [edx + ebp]
	
	mov [edx + eax], cl
	mov [edx + ebp], bl
	
	inc eax
	dec ebp
	
	cmp eax, ebp
	jl .reverseLoop
	
.return:
	add esp, 68
	multipop ebp, edi, esi, ebx
	ret
	
	align 16
.den0:
	ud2
	
	align 16
.numIsNegative:
	mov edi, [esp + 96]
	mov byte [edx], 45
	mov byte [edi + ebp + 2], 0
	mov ebp, eax
	jmp .startReverse
	
	align 16
.numNegative:
	neg eax
	mov byte [esp + 63], 1
	adc edx, 0
	mov [esp], eax
	neg edx
	mov [esp + 4], edx
	jmp .startDigitsLoop
	
	align 16
.qbit0:
	mov eax, esi
	mov edx, edi
	jmp .endDiv
	
	align 16
.denNegative:
	movq xmm0, [esp + 48]
	mov esi, 1
	xor edi, edi
	movq [esp + 24], xmm0
	jmp .startQbitLoop
	
	align 16
.prnt0:
	mov eax, [esp + 96]
	mov edi, 48
	mov [eax], di
	
	add esp, 68
	multipop ebp, edi, esi, ebx
	ret