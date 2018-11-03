global _bcopy
global _bzero
global _memccpy
global _memchr
global _memcmp
global _memcpy
global _memfrob
global _memmem
global _memmove
global _mempcpy
global _memrchr
global _memset
global _stpcpy
global _stpncpy
global _strcasecmp
global _strcasestr
global _strcat
global _strchr
global _strchrnul
global _strcmp
global _strcpy
global _strcspn
global _strdup
global _strlen
global _strncasecmp
global _strncat
global _strncmp
global _strncpy
global _strndup
global _strnlen
global _strpbrk
global _strrchr
global _strsep
global _strspn
global _strstr
global _swab
extern _malloc

segment .text align=16

_bcopy:
	mov eax, [esp + 8]
	mov edx, [esp + 4]
	
	mov [esp + 4], eax
	mov [esp + 8], edx
	jmp _memmove
	
	
	
	
	
_bzero:
	push edi
	
	xor eax, eax
	mov ecx, [esp + 12]
	mov edi, [esp + 8]
	rep stosb
	
	pop edi
	ret
	
	
	
	
	
_memccpy:
	push edi
	push esi
	push ebx
	
	mov ebx, [esp + 28]
	mov esi, [esp + 20]
	
	sub esp, 4
	push ebx
	push dword [esp + 32]
	push esi
	call _memchr
	add esp, 16
	
	test eax, eax
	je .found
	
	inc eax
	je .returnAdd
	
	mov edi, [esp + 16]
	mov ecx, eax
	rep movsb
	
.returnAdd:
	add eax, [esp + 16]
	
.return:
	pop ebx
	pop esi
	pop edi
	ret
	
.found:
	test ebx, ebx
	je .return
	
	mov edi, [esp + 16]
	mov ecx, ebx
	rep movsb
	
	pop ebx
	pop esi
	pop edi
	ret
	
	
	
	
	
_memchr:
	mov edx, [esp + 12]
	mov eax, [esp + 4]
	
	lea edx, [edx - 1]
	cmp edx, -1
	je .return0
	
	movzx ecx, byte [esp + 8]
	
.loop:
	cmp cl, [eax]
	je .return
	
	dec edx
	inc eax
	cmp edx, -1
	jne .loop
	
.return0:
	xor eax, eax
	
.return:
	ret
	
	
	
	
	
_memcmp:
	push esi
	push ebx
	mov esi, [esp + 20]
	mov eax, [esp + 12]
	mov edx, [esp + 16]
	
	test esi, esi
	je .return0
	
	movzx ecx, byte [eax]
	movzx ebx, byte [edx]
	add esi, eax
	cmp bl, cl
	je .startLoop
	jmp .return
	
	align 16
.loop:
	movzx ecx, byte [eax]
	movzx ebx, byte [edx]
	cmp cl, bl
	jne .return
	
.startLoop:
	inc eax
	inc edx
	cmp esi, eax
	jne .loop
	
.return0:
	pop ebx
	xor eax, eax
	pop esi
	ret
	
.return:
	movzx eax, cl
	sub eax, ebx
	
	pop ebx
	pop esi
	ret
	
	
	
	
	
_memcpy:
	push edi
	push esi
	
	mov eax, [esp + 12]
	mov esi, [esp + 16]
	mov ecx, [esp + 20]
	
	mov edi, eax
	rep movsb
	
	pop esi
	pop edi
	ret
	
	
	
_memcpyMovsd:
	push edi
	push esi
	mov ecx, [esp + 20]
	mov eax, [esp + 12]
	mov esi, [esp + 16]
	
	cmp ecx, 4
	jnb .doMovsd
	
	test ecx, ecx
	jne .small
	
.return:
	pop esi
	pop edi
	ret
	
	align 16
.doMovsd:
	mov edx, [esi]
	lea edi, [eax + 4]
	and edi, -4
	mov [eax], edx
	mov edx, [esi + ecx - 4]
	mov [eax + ecx - 4], edx
	mov edx, eax
	sub edx, edi
	add ecx, edx
	sub esi, edx
	shr ecx, 2
	rep movsd
	
	pop esi
	pop edi
	ret
	
.small:
	movzx edx, byte [esi]
	mov [eax], dl
	
	test cl, 2
	je .return
	
	movzx edx, word [ecx + esi - 2]
	mov [ecx + eax - 2], dx
	jmp .return
	
	
	
	
	
_memfrob:
	mov ecx, [esp + 8]
	mov eax, [esp + 4]
	
	test ecx, ecx
	je .return
	
	add ecx, eax
	mov edx, eax
	
.loop:
	inc edx
	xor byte [edx - 1], 42
	cmp edx, ecx
	jne .loop
	
.return:
	ret
	
	
	
	
	
_memmem:
	push ebp
	push edi
	push esi
	push ebx
	sub esp, 44
	
	mov edi, [esp + 76]
	mov ebp, [esp + 68]
	mov esi, [esp + 64]
	
	cmp edi, ebp
	seta cl
	
	test edi, edi
	sete dl
	
	or cl, dl
	mov eax, [esp + 72]
	jne .return0
	
	test ebp, ebp
	je .return0
	
	movzx ecx, byte [eax]
	mov byte [esp + 31], cl
	cmp edi, 1
	jbe .onlyOne
	
	movzx edx, byte [eax + 1]
	
	xor ebx, ebx
	cmp cl, bl
	setne bl
	
	inc ebx
	cmp cl, dl
	sete cl
	
	movzx eax, cl
	inc ecx
	mov [esp + 24], ebx
	
	add eax, 2
	lea ebx, [edi - 2]
	
	mov [esp + 16], ebx
	mov [esp + 8], ecx
	mov [esp + 20], eax
	
	mov ecx, edi
	xor ebx, ebx
	mov edi, edx
	jmp .startLoop
	
	align 16
.loop:
	mov eax, ebp
	add ebx, [esp + 8]
	sub eax, ecx
	cmp eax, ebx
	jb .return0
	
.startLoop:
	mov eax, edi
	cmp al, byte [esi + ebx + 1]
	jne .loop
	
	mov [esp + 12], ecx
	
	sub esp, 4
	push dword [esp + 20]
	lea eax, [esi + ebx + 2]
	push eax
	push dword [esp + 32]
	call _memcmp
	add esp, 16
	
	test eax, eax
	mov ecx, [esp + 12]
	jne .nope
	
	movzx edx, byte [esp + 31]
	lea eax, [esi + ebx]
	cmp dl, byte [eax]
	je .return
	
.nope:
	mov eax, ebp
	add ebx, [esp + 24]
	sub eax, ecx
	cmp eax, ebx
	jnb .startLoop
	
.return0:
	xor eax, eax
	
.return:
	add esp, 44
	pop ebx
	pop esi
	pop edi
	pop ebp
	ret
	
.onlyOne:
	movzx eax, byte [esp + 31]
	mov [esp + 72], ebp
	mov [esp + 68], eax
	
	add esp, 44
	pop ebx
	pop esi
	pop edi
	pop ebp
	jmp _memchr
	
	
	
	
	
_memmove:
	push ebp
	push edi
	push esi
	push ebx
	
	mov edx, [esp + 20]
	mov ebp, [esp + 24]
	mov ebx, [esp + 28]
	
	cmp edx, ebp
	je .returnEbp
	
	jbe .srcBelowDest
	
	test ebx, ebx
	je .returnEbp
	
	mov edi, ebp
	xor esi, esi
	
.forwardsLoop:
	movzx ecx, byte [edx]
	inc esi
	mov [edi], cl
	inc edx
	inc edi
	cmp esi, ebx
	jb .forwardsLoop
	
.returnEbp:
	pop ebx
	pop esi
	pop edi
	mov eax, ebp
	pop ebp
	ret
	
.srcBelowDest:
	lea ecx, [ebx - 1]
	add edx, ecx
	add ecx, ebp
	test ebx, ebx
	je .returnEbp
	
	xor esi, esi
	
.backwardsLoop:
	movzx eax, byte [edx]
	inc esi
	mov [ecx], al
	dec edx
	dec ecx
	cmp esi, ebx
	jb .backwardsLoop
	
	pop ebx
	pop esi
	pop edi
	mov eax, ebp
	pop ebp
	ret
	
	
	
	
	
_mempcpy:
	push edi
	push esi
	mov esi, [esp + 16]
	mov ecx, [esp + 20]
	mov edi, [esp + 12]
	
	rep movsb
	
	pop esi
	mov eax, edi
	pop edi
	ret
	
	
	
	
	
_memrchr:
	mov eax, [esp + 4]
	mov ecx, [esp + 12]
	
	mov edx, ecx
	dec edx
	lea eax, [eax + ecx - 1]
	js .return0
	
	movzx ecx, byte [esp + 8]
	
.loop:
	cmp cl, [eax]
	je .return
	
	dec eax
	dec edx
	jns .loop
	
.return0:
	xor eax, eax
	
.return:
	ret
	
	
	
	
	
_memset:
	push edi
	mov edx, [esp + 8]
	movzx eax, byte [esp + 12]
	mov ecx, [esp + 16]
	
	mov edi, edx
	rep stosb
	
	mov eax, edx
	pop edi
	ret
	
	
	
	
	
_stpcpy:
	push edi

	xor eax, eax
	or ecx, -1
	
	push esi
	push ebx
	mov esi, [esp + 20]
	mov edx, [esp + 16]
	
	mov edi, esi
	repnz scasb
	
	mov edi, edx
	
	mov eax, ecx
	not ecx
	
	mov ecx, eax
	rep movsb
	
	lea eax, [eax + edx - 1]
	
	pop ebx
	pop esi
	pop edi
	ret
	
	
	
	
	
_stpncpy:
	push ebp
	xor eax, eax
	or ecx, -1
	push edi
	push esi
	push ebx
	mov esi, [esp + 24]
	mov ebx, [esp + 28]
	
	mov edi, esi
	repnz scasb
	
	mov edi, [esp + 20]
	mov edx, ecx
	not edx
	lea ebp, [edx - 1]
	
	cmp ebx, ebp
	mov edx, ebp
	cmovbe edx, ebx
	
	mov ecx, edx
	rep movsb
	mov esi, edi
	jbe .return
	
	sub ebx, edx
	mov ecx, ebx
	rep stosb
	
.return:
	pop ebx
	mov eax, esi
	pop esi
	pop edi
	pop ebp
	ret
	
	
	
	
	
_strcasecmp:
	push ebp
	push edi
	push esi
	push ebx
	mov ebp, [esp + 24]
	
	cmp [esp + 20], ebp
	je .return0
	
	xor ecx, ecx
	jmp .startLoop
	
	align 16
.loop:
	inc ecx
	test bl, bl
	je .return
	
.startLoop:
	mov eax, [esp + 20]
	movzx eax, byte [eax + ecx]
	
	lea esi, [eax - 65]
	cmp esi, 26
	lea edx, [eax + 32]
	
	mov ebx, eax
	cmovb eax, edx
	
	movzx edx, byte [ebp + ecx]
	lea edi, [edx - 65]
	lea esi, [edx + 32]
	cmp edi, 26
	cmovb edx, esi
	
	sub eax, edx
	je .loop
	
.return:
	pop ebx
	pop esi
	pop edi
	pop ebp
	ret
	
.return0:
	pop ebx
	pop esi
	pop edi
	xor eax, eax
	pop ebp
	ret
	
	
	
	
	
_strcasestr:
	push ebp
	push edi
	push esi
	push ebx
	sub esp, 28
	
	mov eax, [esp + 52]
	mov ebp, [esp + 48]
	
	movzx ebx, byte [eax]
	test bl, bl
	je .returnEbp
	
	lea edx, [ebx - 65]
	cmp edx, 25
	ja .biggerLol
	
	add ebx, 32
	
.biggerLol:
	inc eax
	or ecx, -1
	mov [esp + 32], eax
	mov edi, [esp + 12]
	xor eax, eax
	repnz scasb
	
	mov esi, ecx
	not esi
	lea esi, [esi - 1]
	
.toLowerLoop:
	lea edi, [ebp + 1]
	movzx eax, byte [edi - 1]
	test al, al
	je .return0
	
	lea edx, [eax - 65]
	cmp edx, 25
	ja .biggerLol2
	
	add eax, 32
	
.biggerLol2:
	cmp bl, al
	je .doCaseCmp
	
.continue:
	mov ebp, edi
	je .toLowerLoop
	
.doCaseCmp:
	push eax
	push esi
	push dword [esp + 20]
	push edi
	call _strncasecmp
	add esp, 16
	
	test eax, eax
	jne .continue
	jmp .returnEbp
	
.return0:
	xor ebp, ebp
	
.returnEbp:
	add esp, 28
	pop ebx
	pop esi
	pop edi
	mov eax, ebp
	pop ebp
	ret
	
	
	
	
	
_strcat:
	push ebp
	
	or ebp, -1
	xor eax, eax
	
	push edi
	mov ecx, ebp
	push esi
	push ebx
	
	mov edx, [esp + 20]
	mov esi, [esp + 24]
	
	mov edi, edx
	repnz scasb
	
	mov edi, esi
	mov ebx, ecx
	mov ecx, ebp
	repnz scasb
	
	not ebx
	lea eax, [ebx + edx - 1]
	mov edi, eax
	mov eax, edx
	not ecx
	rep movsb
	
	pop ebx
	pop esi
	pop edi
	pop ebp
	ret
	
	
	
	
	
_strchr:
	mov eax, [esp + 4]
	movzx ecx, byte [esp + 8]
	jmp .startLoop
	
	align 16
.loop:
	inc eax
	test dl, dl
	je .return0
	
.startLoop:
	movzx edx, byte [eax]
	cmp dl, cl
	jne .loop
	
	ret
	
.return0:
	xor eax, eax
	ret
	
	
	
	
	
_strchrnul:
	mov eax, [esp + 4]
	movsx edx, byte [esp + 8]
	jmp .startLoop
	
	align 16
.loop:
	inc eax
	
.startLoop:
	movsx ecx, byte [eax]
	cmp ecx, edx
	je .return
	
	test ecx, ecx
	jne .loop
	
.return:
	ret
	
	
	
	
	
_strcmp:
	push esi
	xor eax, eax
	push ebx
	
	mov esi, [esp + 12]
	mov ebx, [esp + 16]
	jmp .startLoop
	
	align 16
.loop:
	inc eax
	cmp dl, cl
	jne .return
	
.startLoop:
	movzx edx, byte [esi + eax]
	movzx ecx, byte [ebx + eax]
	
	test dl, dl
	jne .loop
	
	movzx eax, cl
	pop ebx
	neg eax
	pop esi
	ret
	
.return:
	movzx eax, dl
	pop ebx
	sub eax, ecx
	pop esi
	ret
	
	
	
	
	
_strcpy:
	push edi
	
	xor eax, eax
	or ecx, -1
	push esi
	mov esi, [esp + 16]
	mov edi, esi
	repnz scasb
	
	mov edi, [esp + 12]
	mov eax, [esp + 12]
	
	mov edx, ecx
	not edx
	mov ecx, edx
	rep movsb
	
	pop esi
	pop edi
	ret
	
	
	
	
	
_strcspn:
	push edi
	xor edi, edi
	
	push esi
	push ebx
	mov esi, [esp + 20]
	mov ebx, [esp + 16]
	
	movsx eax, byte [ebx]
	test al, al
	jne .startLoop
	jmp .returnEdi
	
.loop:
	inc edi
	movsx eax, byte [ebx + edi]
	test al, al
	je .returnEdi
	
.startLoop:
	sub esp, 8
	push eax
	push esi
	call _strchr
	add esp, 16
	
	test eax, eax
	je .loop
	
.returnEdi:
	mov eax, edi
	pop ebx
	pop esi
	pop edi
	ret
	
	
	
	
	
_strdup:
	push edi
	xor eax, eax
	or ecx, -1
	push esi
	sub esp, 32
	mov esi, [esp + 44]
	mov edi, esi
	repnz scasb
	
	mov edx, ecx
	not edx
	push edx
	mov [esp + 28], edx
	call _malloc
	add esp, 16
	
	mov edx, eax
	xor eax, eax
	test edx, edx
	je .return
	
	mov edi, edx
	mov ecx, [esp + 12]
	mov eax, ecx
	rep movsb
	
.return:
	add esp, 20
	pop esi
	pop edi
	ret
	
	
	
	
	
_strlen:
	push edi
	
	xor eax, eax
	or ecx, -1
	mov edi, [esp + 8]
	repnz scasb
	
	pop edi
	mov eax, ecx
	not eax
	dec eax
	ret
	
	
	
	
	
_strncasecmp:
	push ebp
	push edi
	push esi
	push ebx
	
	mov ebx, [esp + 20]
	cmp ebx, [esp + 24]
	je .return0
	
	mov eax, [esp + 28]
	test eax, eax
	je .return0
	
	mov ecx, [esp + 24]
	mov esi, ebx
	jmp .startLoop
	
.loop:
	inc esi
	test bl, bl
	je .return
	
	mov edx, [esp + 28]
	sub edx, ecx
	add edx, [esp + 24]
	je .return
	
.startLoop:
	movzx eax, byte [esi]
	lea edi, [eax - 65]
	lea edx, [eax + 32]
	mov ebx, eax
	cmp edi, 26
	cmovb eax, edx
	
	inc ecx
	movzx edx, byte [ecx - 1]
	lea ebp, [edx - 65]
	lea edi, [edx + 32]
	cmp ebp, 32
	cmovb edx, edi
	sub eax, edx
	je .loop
	
.return:
	pop ebx
	pop esi
	pop edi
	pop ebp
	ret
	
.return0:
	pop ebx
	pop esi
	pop edi
	xor eax, eax
	pop ebp
	ret
	
	
	
	
	
_strncat:
	push ebp
	
	or ebp, -1
	xor eax, eax
	push edi
	push esi
	mov ecx, ebp
	mov edx, [esp + 20]
	mov esi, [esp + 24]
	
	mov edi, edx
	repnz scasb
	
	mov edi, esi
	not ecx
	lea ebx, [edx + ecx - 1]
	mov ecx, ebp
	repnz scasb
	
	mov edi, ebx
	mov eax, edx
	not ecx
	dec ecx
	cmp [esp + 28], ecx
	cmovbe ecx, [esp + 28]
	
	mov byte [ebx + ecx], 0
	rep movsb
	
	pop ebx
	pop esi
	pop edi
	pop ebp
	ret
	
	
	
	
	
_strncmp:
	sub esp, 12
	
	mov eax, [esp + 24]
	mov ecx, [esp + 16]
	mov edx, [esp + 20]
	
	test eax, eax
	je .return0
	
	mov [esp + 4], esi
	mov esi, ecx
	mov [esp], edi
	jmp .startLoop
	
	align 16
.loop:
	inc esi
	inc edx
	
.startLoop:
	xor ecx, ecx
	test eax, eax
	seta cl
	dec eax
	test ecx, ecx
	je .end
	
	movsx ecx, byte [esi]
	mov cl, byte [edx]
	jne .end
	
	test eax, eax
	je .thatsAZero
	
	test ecx, ecx
	jne .loop
	
.thatsAZero:
	mov esi, [esp + 4]
	mov edi, [esp]
	
.return0:
	xor eax, eax
	add esp, 12
	ret
	
.end:
	mov edi, [esp]
	mov ecx, esi
	mov esi, [esp + 4]
	movzx ecx, byte [ecx]
	movzx eax, byte [edx]
	
	cmp ecx, eax
	jge .sign
	
	mov eax, -1
	jmp .return
	
.sign:
	sub eax, ecx
	shr eax, 31
	
.return:
	add esp, 12
	ret
	
	
	
	
	
_strncpy:
	push ebp
	
	xor eax, eax
	or ecx, -1
	
	push edi
	push esi
	push ebx
	
	mov esi, [esp + 24]
	mov ebp, [esp + 28]
	
	mov edi, esi
	repnz scasb
	
	mov ebx, [esp + 20]
	mov edx, ecx
	not edx
	dec edx
	
	cmp ebp, edx
	jb .nope
	je .noMemsetHere
	
	mov ecx, ebp
	lea ebp, [ebx + edx]
	sub ecx, edx
	mov edi, ebp
	rep stosb	
	jmp .nope
	
.noMemsetHere:
	mov edx, ebp
	
.nope:
	mov edi, ebx
	mov ecx, edx
	rep movsb
	
	mov eax, ebx
	pop ebx
	pop esi
	pop edi
	pop ebp
	ret
	
	
	
	
	
	
_strndup:
	push edi
	xor eax, eax
	or ecx, -1
	
	push esi
	push ebx
	sub esp, 28
	mov esi, [esp + 44]
	mov edi, [esp + 48]
	mov edi, esi
	repnz scasb
	
	mov ebx, ecx
	not ebx
	mov ecx, ebx
	dec ecx
	
	cmp edx, ecx
	cmovbe ecx, edx
	
	lea eax, [ecx + 1]
	mov [esp + 24], ecx
	
	push eax
	call _malloc
	
	add esp, 16
	test eax, eax
	je .return
	
	mov ecx, [esp + 12]
	mov edi, eax
	mov byte [eax + ecx], 0
	rep movsb
	
.return:
	add esp, 16
	pop ebx
	pop esi
	pop edi
	ret
	
	
	
	
	
_strnlen:
	push edi
	
	xor eax, eax
	or ecx, -1
	push ebx
	
	mov edi, [esp + 12]
	mov edx, [esp + 16]
	repnz scasb
	
	mov eax, edx
	mov ebx, ecx
	not ebx
	mov ecx, ebx
	
	pop ebx
	pop edi
	
	dec ecx
	cmp ecx, edx
	cmovbe eax, ecx
	ret
	
	
	
	
	
_strpbrk:
	push ebx
	sub esp, 16
	mov ebx, [esp + 24]
	
	push dword [esp + 28]
	push ebx
	call _strcspn
	add eax, ebx
	
	cmp byte [eax], 0
	mov edx, 0
	cmove eax, edx
	
	add esp, 24
	pop ebx
	ret
	
	
	
	
	
_strrchr:
	push edi
	push esi
	push ebx
	movzx esi, byte [esp + 20]
	
	xor ebx, ebx
	mov edx, [esp + 16]
	
	test esi, esi
	jne .notZero
	
	or ecx, -1
	xor eax, eax
	mov edi, edx
	repnz scasb
	
	mov esi, ecx
	not esi
	lea ebx, [esi + edx - 1]
	jmp .returnEbx
	
.notZero:
.loop:
	push eax
	push eax
	push esi
	push edx
	call _strchr
	add esp, 16
	
	test eax, eax
	je .returnEbx
	
	lea edx, [eax + 1]
	mov ebx, eax
	jmp .loop
	
.returnEbx:
	mov eax, ebx
	pop ebx
	pop esi
	pop edi
	ret
	
	
	
	
	
_strsep:
	push esi
	push ebx
	sub esp, 4
	
	mov ebx, [esp + 16]
	mov esi, [ebx]
	
	test esi, esi
	je .returnEsi
	
	sub esp, 8
	push dword [esp + 28]
	push esi
	call _strcspn
	add esp, 16
	add eax, esi
	
	cmp byte [eax], 0
	je .lastToken
	
	mov byte [eax], 0
	inc eax
	mov [ebx], eax
	
.returnEsi:
	add esp, 4
	mov eax, esi
	pop ebx
	pop esi
	ret
	
.lastToken:
	mov dword [ebx], 0
	
	add esp, 4
	mov eax, esi
	pop ebx
	pop esi
	ret
	
	
	
	
	
_strspn:
	push edi
	xor edi, edi
	push esi
	push ebx
	mov ebx, [esp + 16]
	mov esi, [esp + 20]
	
	movsx eax, byte [ebx]
	test al, al
	jne .startLoop
	jmp .returnEdi
	
	align 16
.loop:
	inc edi
	movsx eax, byte [ebx + edi]
	test al, al
	je .returnEdi
	
.startLoop:
	sub esp, 8
	push eax
	push esi
	call _strchr
	add esp, 16
	
	test eax, eax
	jne .loop
	
.returnEdi:
	pop ebx
	pop esi
	mov eax, edi
	pop edi
	ret
	
	
	
	
	
_strstr:
	push edi
	or ecx, -1
	xor eax, eax
	push esi
	push ebx
	
	mov edi, [esp + 20]
	mov esi, [esp + 16]
	repnz scasb
	
	mov edx, ecx
	not edx
	lea ebx, [edx - 1]
	
.loop:
	cmp byte [esi], 0
	je .return0
	
	push eax
	lea edi, [esi + 1]
	push ebx
	push dword [esp + 28]
	push esi
	call _memcmp
	add esp, 16
	
	test eax, eax
	je .returnEsi
	
	mov esi, edi
	jmp .loop
	
.return0:
	xor esi, esi
	
.returnEsi:
	pop ebx
	mov eax, esi
	pop esi
	pop edi
	ret
	
	
	
	
	
_swab:
	push esi
	push ebx
	
	mov eax, [esp + 20]
	mov ecx, [esp + 12]
	and eax, -2
	mov edx, [esp + 16]
	
	cmp eax, 1
	jle .return
	
.loop:
	movzx esi, byte [ecx + eax - 1]
	sub eax, 2
	movzx ebx, byte [ecx + eax]
	mov byte [edx + eax + 1], bl
	
	mov ebx, esi
	mov byte [edx + eax], bl
	jne .loop
	
.return:
	pop ebx
	pop esi
	ret