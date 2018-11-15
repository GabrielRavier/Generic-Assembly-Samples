global _npr_bittree_byte_size
global _npr_bittree_init
global _npr_bittree_set
global _npr_bittree_p
global _npr_bittree_clear
global _npr_bittree_get
global _npr_bittree_set_all

segment .text align=16

_npr_bittree_byte_size:
	mov eax, [esp + 4]
	lea edx, [eax + 31]
	shr edx, 5

	lea ecx, [edx + 31]
	shr ecx, 5

	lea eax, [ecx + 31]
	lea edx, [edx + ecx + 1]
	shr eax, 5

	add eax, edx
	sal eax, 2
	ret
	
	
	
	
	
	align 16
_npr_bittree_init:
	mov ecx, [esp + 8]
	mov edx, [esp + 4]

	lea ecx, [ecx + 31]
	shr ecx, 5
	
	add ecx, 31
	shr ecx, 5
	
	lea eax, [ecx + 31]
	shr eax, 5
	
	lea ecx, [ecx + eax + 1]
	inc eax
	
	mov [edx + 4], ecx
	mov [edx], eax
	ret
	
	
	
	
	
	align 16
_npr_bittree_set:
	push esi
	push edi
	push ebp
	
	mov ebp, [esp + 16]
	mov eax, [esp + 24]
	
	mov ecx, eax
	shr ecx, 5
	
	mov edi, [ebp + 4]
	add edi, ecx
	
	mov esi, [ebp]
	mov ebp, [esp + 20]
	mov edx, [ebp + edi * 4]
	bts edx, eax
	mov [ebp + edi * 4], edx
	
	mov edx, eax
	shr edx, 10
	
	add esi, edx
	shr eax, 15
	mov edi, [ebp + esi * 4]
	bts edi, ecx
	mov [ebp + esi * 4], edi
	
	mov ecx, [ebp + eax * 4 + 4]
	bts ecx, edx
	mov [ebx + eax * 4 + 4], ecx
	
	mov edx, [ebp]
	bts edx, eax
	mov [ebp], edx
	
	pop ebp
	pop edi
	pop esi
	ret
	
	
	
	
	
	align 16
_npr_bittree_p:
	mov ecx, [esp + 4]
	mov edx, [esp + 12]
	
	mov eax, edx
	shr eax, 5
	
	add eax, [ecx + 4]
	mov ecx, [esp + 8]
	mov eax, [ecx + eax * 4]
	btr eax, edx
	ret
	
	
	
	
	
	align 16
_npr_bittree_clear:
	push ebp
	push ebx
	push edi
	push esi
	sub esp, 8
	
	mov ecx, [esp + 36]
	mov eax, [esp + 28]
	mov ebp, -2
	
	mov edx, ecx
	mov esi, ecx
	mov edi, [eax + 4]
	mov ebp, ecx
	
	rol ebp, cl
	
	shr edx, 15
	shr edi, 10
	shr ebx, 5
	
	mov [esp + 4], edx
	mov edx, [eax]
	mov [esp], esi
	
	xor eax, eax
	mov ecx, ebx
	add edi, ebx
	add edx, esi
	
	mov esi, [esp + 32]
	and [esi + edi * 4], ebp
	sete al
	
	xor ebx, ebx
	shl eax, cl
	not eax
	
	and [esi + edx * 4], eax
	mov ecx, [esp]
	sete bl
	
	xor eax, eax
	shl ebx, cl
	mov ecx, [esp + 4]
	not ebx
	
	and [esi + ecx * 4 + 4], ebx
	sete al
	
	shl eax, cl
	not eax
	
	and [esi], eax
	
	add esp, 8
	pop esi
	pop edi
	pop ebx
	pop ebp
	ret
	
	
	
	
	
	align 16
_npr_bittree_get:
	push esi
	push edi
	push ebx
	push ebp
	sub esp, 28
	
	mov eax, [esp + 48]
	mov esi, [esp + 52]
	mov ebx, [eax]
	mov ebp, [eax + 4]
	
	mov eax, [esi]
	bsr edi, eax
	
	mov eax, [esi]
	bsr edx, eax
	
	add ebx, edx
	
	mov [esp + 12], edx
	mov [esp + 4], edi
	mov [esp + 8], ecx
	
	mov edx, [esi + ebx * 4]
	bsr edi, edx
	
	add ebp, edi
	mov [esp], eax
	
	mov ecx, [esi + ebp * 4]
	bsr eax, ecx
	btr ecx, eax
	
	test ecx, ecx
	mov [esi + ebp * 4], ecx
	mov ecx, 1
	mov ebp, 0
	cmove ebp, ecx
	
	mov ecx, edi
	shl ebp, cl
	not ebp
	and edx, ebp
	
	mov ebp, 1
	mov [esi + ebx * 4], edx
	mov edx, 0
	cmove edx, ebp
	
	mov ebp, [esp + 12]
	mov ecx, ebp
	shl edx, cl
	
	mov ecx, [esp + 4]
	not edx
	mov ebx, [esp + 8]
	and ebx, edx
	
	mov edx, 1
	mov [esi + ecx * 4 + 4], ebx
	mov ebx, 0
	cmove ebx, edx
	
	shl ebx, cl
	shl ecx, 5
	not ebx
	add ecx, ebp
	shl ecx, 5
	add ecx, edi
	shl ecx, 5
	mov edx, [esp]
	add eax, ecx
	and edx, ebx
	mov [esi], edx
	
	add esp, 28
	pop ebp
	pop ebx
	pop edi
	pop esi
	ret
	
	
	
	
	
	align 16
_npr_bittree_set_all:
	push ebp
	push edi
	push esi
	push ebx
	sub esp, 12
	
	mov eax, [esp + 40]
	mov esi, [esp + 32]
	mov ecx, [esp + 36]
	mov edx, [esp + 40]
	
	lea ebx, [eax + 31]
	mov eax, ebx
	
	shr edx, 3
	shr eax, 5
	shr ebx, 8
	
	mov [esp], eax
	mov eax, [esi + 4]
	lea ebp, [ecx + eax * 4]
	mov eax, -1
	mov ecx, edx
	mov edi, ebp
	mov ebp, 1
	rep stosb
	
	mov ecx, [esp + 40]
	mov edi, ebp
	and ecx, 7
	add edx, [esi + 4]
	sal edi, cl
	mov ecx, edi
	mov edi, [esp + 36]
	dec ecx
	mov [edi + edx * 4], cl
	
	mov edi, [esp]
	mov ecx, [esp + 36]
	add edi, 31
	mov edx, edi
	mov [esp + 8], edi
	shr edx, 5
	mov [esp + 4], edx
	
	mov edx, [esi]
	lea edx, [ecx + edx * 4]
	mov ecx, ebx
	mov edi, edx
	rep stosb
	
	mov edi, [esp]
	and edi, 7
	mov edx, [esi]
	mov esi, [esp + 4]
	mov ecx, edi
	mov edi, ebp
	sal edi, cl
	add edx, ebx
	mov ecx, edi
	mov edi, [esp + 36]
	dec ecx
	mov [edi + edx * 4], cl
	
	mov ecx, [esp + 8]
	lea edx, [esi + 31]
	lea esi, [edi + 4]
	mov edi, esi
	mov esi, ebp
	shr ecx, 8
	rep stosb
	
	mov ecx, [esp + 4]
	and ecx, 7
	
	sal esi, cl
	mov ecx, esi
	mov esi, [esp + 36]
	dec ecx
	mov [esi + ebx * 4 + 4], cl
	
	mov ebx, edx
	mov edi, esi
	shr ebx, 8
	mov ecx, ebx
	rep stosb
	
	mov ecx, edx
	shr cl, 5
	sal ebp, cl
	lea eax, [ebp - 1]
	mov [esi + ebx * 4], al
	
	add esp, 12
	pop ebx
	pop esi
	pop edi
	pop ebp
	ret