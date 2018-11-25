global _countSetBits
global _countSetBits64

segment .text align=16

_countSetBits:
	mov ecx, [esp + 4]
	xor eax, eax
	
	test ecx, ecx
	je .return
	
.loop:
	lea edx, [ecx - 1]
	inc al
	
	and ecx, edx
	jne .loop
	
.return:
	ret
	
	
	
	align 16
_countSetBitsPOPCNT:
	popcnt eax, [esp + 4]
	ret
	
	
	
	
	
	align 16
_countSetBits64:
	push esi
	sub esp, 8
	
	xor eax, eax
	mov edx, [esp + 16]
	mov esi, edx
	mov ecx, [esp + 24]
	or esi, ecx
	je .return
	
	mov [esp], edi
	
.loop:
	mov esi, edx
	mov edi, ecx
	
	add esi, -1
	adc edi, -1
	
	and edx, esi
	and ecx, edi
	
	mov esi, edx
	inc eax
	or esi, ecx
	jne .loop
	
	mov edi, [esp]
	
.return:
	add esp, 8
	pop esi
	ret
	
	
	
	align 16
_countSetBits64SSSE3:
	movq xmm1, [esp + 4]
	xor eax, eax
	
	movdqa xmm0, xmm1
	movd ecx, xmm1
	psrlq xmm0, 32
	movd edx, xmm0
	
	or edx, ecx
	je .return
	
.loop:
	pcmpeqd xmm0, xmm0
	paddq xmm0, xmm1
	add eax, 1
	pand xmm1, xmm0
	movdqa xmm0, xmm1
	movd ecx, xmm1
	psrlq xmm0, 32
	movd edx, xmm0
	
	or edx, ecx
	jne .return
	
	ret
	
	align 16
.return:
	ret
	
	
	
	
	
	align 16
_countSetBits64POPCNT:
	popcnt eax, [esp + 4]
	popcnt ecx, [esp + 8]
	add eax, ecx
	ret