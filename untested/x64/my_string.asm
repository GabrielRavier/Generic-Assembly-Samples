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
	mov rax, rdi
	mov rdi, rsi
	mov rsi, rax
	jmp _memmove
	
	
	
	
	
	align 16
_bzero:
	mov rcx, rsi
	xor eax, eax
	rep stosb
	ret
	
	
	
	
	
	align 16
_memccpy:
	push r12
	mov r12, rdi
	push rbp
	mov rbp, rcx
	push rbx
	mov rbx, rsi
	mov rdi, rbx
	mov esi, edx
	mov rdx, rcx
	call _memchr
	
	test rax, rax
	je .notFound
	
	sub rax, rbx
	mov rsi, rbx
	pop rbx
	pop rbp
	mov rdi, r12
	lea rdx, [rax + 1]
	pop r12
	call _mempcpy
	
.notFound:
	mov rdi, r12
	mov rsi, rbx
	mov rcx, rbp
	rep movsb
	
	xor eax, eax
	pop rbx
	pop rbp
	pop r12
	ret
	
	
	
	
	
	align 16
_memchr:
	dec rdx
	cmp rdx, -1
	je .return0
	
.loop:
	mov cl, [rdi]
	cmp cl, sil
	je .found
	
	dec rdx
	inc rdi
	cmp rdx, -1
	jne .loop
	
.return0:
	xor eax, eax
	ret
	
.found:
	mov rax, rdi
	ret
	
	
	
	
	
	align 16
_memcmp:
	mov rcx, rdx
	
	dec rcx
	cmp rcx, -1
	je .return0
	
.loop:
	movzx eax, byte [rdi]
	movzx edx, byte [rsi]
	cmp eax, edx
	jne .found
	
	dec rcx
	inc rdi
	inc rsi
	cmp rcx, -1
	jne .loop
	
.return0:
	xor eax, eax
	ret
	
.found:
	sub eax, edx
	ret
	
	
	
	
	
	align 16
_memcpy:
	mov rax, rdi
	mov rcx, rdx
	rep movsb
	ret
	
	
	
	
	
	align 16
_memfrob:
	mov rax, rdi
	lea rcx, [rsi - 1]
	test rsi, rsi
	je .return
	
	mov rdx, rdi
	jmp .startLoop
	
	align 16
.loop:
	mov rcx, rsi
	
.startLoop:
	xor byte [edx], 42
	lea rsi, [rcx - 1]
	inc rdx
	test rcx, rcx
	jne .loop
	
.return:
	ret
	
	
	
	
	
	align 16
_memmem:
	cmp rcx, rsi
	seta r8b
	
	test rcx, rcx
	sete al
	
	or r8b, al
	jne .return0Early
	
	test rsi, rsi
	je .return0Early
	
	push r15
	push r14
	push r13
	push r12
	push rbp
	push rbx
	sub rsp, 40
	movzx r14d, byte [rdx]
	
	cmp rcx, 1
	jbe .onlyOne
	
	movzx r13d, byte [rdx + 1]
	
	xor eax, eax
	cmp r14b, r13b
	setne al
	
	inc rax
	xor r15d, r15d
	mov [rsp + 24], rax
	cmp r14b, r13b
	lea rax, [rcx - 2]
	sete r15b
	
	mov [rsp + 8], rax
	sub rsi, rcx
	lea rax, [rdx + 2]
	mov rbp, rdi
	inc r15
	xor ebx, ebx
	mov [rsp + 16], rax
	mov r12, rsi
	jmp .startLoop
	
	align 16
.loop:
	add rbx, r15
	cmp r12, rbx
	jb .return0
	
.startLoop:
	cmp r13b, [rbp + rbx + 1]
	jne .loop
	
	mov rdx, [rsp + 8]
	mov rdi, [rsp + 16]
	lea rsi, [rbp + rbx + 2]
	call _memcmp
	
	test eax, eax
	jne .notZero
	
	lea rax, [rbp + rbx]
	cmp r14b, [rax]
	je .return
	
.notZero:
	add rbx, [rsp + 24]
	cmp r12, rbx
	jnb .startLoop
	
.return0:
	xor eax, eax
	
.return:
	add rsp, 40
	pop rbx
	pop rbp
	pop r12
	pop r13
	pop r14
	pop r15
	ret
	
.return0Early:
	xor eax, eax
	ret
	
.onlyOne:
	add rsp, 40
	pop rbx
	pop rbp
	pop r12
	pop r13
	movzx esi, r14b
	mov rdx, rsi
	pop r14
	pop r15
	jmp _memchr
	
	
	
	
	
	align 16
_memmove:
	mov rax, rsi
	cmp rdi, rsi
	je .return
	jbe .smaller
	
	test rdx, rdx
	je .return
	
	mov r8, rsi
	xor ecx, ecx

.forwardsLoop:
	movzx r9d, byte [rdi]
	inc ecx
	mov [r8], r9b
	movsx r9, ecx
	inc r8
	inc rdi
	cmp r9, rdx
	jb .forwardsLoop

.return:
	ret
	
.smaller:
	lea rcx, [rdx - 1]
	add rdi, rcx
	add rcx, rsi
	test rdx, rdx
	je .return
	
	xor r8d, r8d
	
.backwardsLoop:
	movzx r9d, byte [rdi]
	inc r8d
	mov [rcx], r9b
	
	movsx r9, r8d
	dec rcx
	dec rdi
	cmp r9, rdx
	jb .backwardsLoop
	
	ret
	
	
	
	
	
	align 16
_mempcpy:
	mov rcx, rdx
	rep movsb
	mov rax, rdi
	ret
	
	
	
	
	
	align 16
_memrchr:
	dec rdx
	movsxd rdx, edx
	add rdi, rdx
	test rdx, rdx
	js .return0
	
.loop:
	mov cl, [rdi]
	cmp cl, sil
	je .returnRdi
	
	dec rdi
	dec rdx
	jns .loop
	
.return0:
	xor eax, eax
	ret
	
.returnRdi:
	mov rax, rdi
	ret
	
	
	
	
	
	align 16
_memset:
	mov r8, rdi
	mov eax, esi
	mov rcx, rdx
	rep stosb
	mov rax, r8
	ret
	
	
	
	
	
	align 16
_stpcpy:
	mov rdx, rdi
	xor eax, eax
	mov rdi, rsi
	or rcx, -1
	repnz scasb
	
	mov rdi, rdx
	mov rax, rcx
	not rax
	mov rcx, rax
	lea rax, [rdx + rax - 1]
	rep movsb
	
	ret
	
	
	
	
	
	align 16
_stpncpy:
	mov r11, rdi
	xor eax, eax
	mov rdi, rsi
	or rcx, -1
	repnz scasb
	
	mov rdi, r11
	not rcx
	lea r8, [rcx - 1]
	
	cmp rdx, r8
	mov r9, r8
	cmovbe r9, rdx
	
	mov rcx, r9
	rep movsb
	mov r10, rdi
	jbe .return
	
	sub rdx, r9
	mov rcx, rdx
	rep stosb
	
.return:
	mov rax, r10
	ret
	
	
	
	
	
	align 16
_strcasecmp:
	cmp rdi, rsi
	je .return0
	
	xor ecx, ecx
	jmp .startLoop
	
	align 16
.loop:
	inc rcx
	test r8b, r8b
	je .return
	
.startLoop:
	movzx eax, byte [rdi + rcx]
	lea r9d, [rax - 65]
	lea edx, [rax + 32]
	mov r8d, eax
	cmp r9d, 26
	cmovb eax, edx
	
	movzx edx, byte [rsi + rcx]
	lea r10d, [rdx - 65]
	lea r9d, [rdx + 32]
	cmp r10d, 26
	cmovb edx, r9d
	
	sub eax, edx
	je .loop
	
.return:
	ret
	
.return0:
	xor eax, eax
	ret
	
	
	
	
	
	align 16
_strcasestr:
	push r14
	push r13
	mov r13, rdi
	push r12
	push rbp
	push rbx
	
	movzx eax, byte [rsi]
	test al, al
	je .return0
	
	lea edx, [rax - 65]
	cmp edx, 25
	ja .above
	
	add eax, 32
	
.above:
	lea r12, [rsi + 1]
	mov ebp, eax
	or rcx, -1
	xor eax, eax
	mov rdi, r12
	repnz scasb
	
	mov rbx, rcx
	not rbx
	lea rbx, [rbx - 1]
	
.loop:
	lea r14, [r13 + 1]
	movzx eax, byte [r14 - 1]
	test al, al
	je .return0
	
	lea edx, [rax - 65]
	cmp edx, 25
	ja .above2
	
	add eax, 32
	
.above2:
	cmp bpl, al
	je .doCaseCmp
	
.continue:
	mov r13, r14
	jmp .loop
	
.doCaseCmp:
	mov rdx, rbx
	mov rsi, r12
	mov rdi, r14
	call _strncasecmp
	
	test eax, eax
	jne .continue
	jmp .return
	
.return0:
	xor r13d, r13d
	
.return:
	pop rbx
	pop rbp
	pop r12
	mov rax, r13
	pop r13
	pop r14
	ret
	
	
	
	
	
	align 16
_strcat:
	or r9, -1
	xor eax, eax
	mov rdx, rdi
	mov rcx, r9
	repnz scasb
	
	mov rdi, rsi
	not rcx
	mov r8, rcx
	mov rcx, r9
	repnz scasb
	
	lea rax, [rdx + r8 - 1]
	mov rdi, rax
	mov rax, rdx
	not rcx
	rep movsb
	
	ret
	
	
	
	
	
	align 16
_strchr:
	mov rax, rdi
	jmp .startLoop
	
	align 16
.loop:
	inc rax
	test dl, dl
	je .return0
	
.startLoop:
	movzx edx, byte [rax]
	cmp dl, sil
	jne .loop
	ret
	
.return0:
	xor eax, eax
	ret
	
	
	
	
	
	align 16
_strchrnul:
	jmp .startLoop
	
	align 16
.loop:
	inc rdi
	
.startLoop:
	mov dl, [rdi]
	cmp dl, sil
	je .returnRdi
	
	test dl, dl
	jne .loop
	
.returnRdi:
	mov rax, rdi
	ret
	
	
	
	
	
	align 16
_strcmp:
	xor ecx, ecx
	
.loop:
	movzx eax, byte [rdi + rcx]
	movzx edx, byte [rsi + rcx]
	inc rcx
	
	test eax, eax
	je .return
	
	cmp eax, edx
	je .loop
	
	sub eax, edx
	ret
	
.return:
	neg edx
	mov eax, edx
	ret
	
	
	
	
	
	align 16
_strcpy:
	mov rdx, rdi
	xor eax, eax
	mov rdi, rsi
	or rcx, -1
	repnz scasb
	
	mov rdi, rdx
	mov rax, rdx
	not rcx
	rep movsb
	
	ret
	
	
	
	
	
	align 16
_strcspn:
	push r12
	mov r12, rsi
	push rbp
	mov rbp, rdi
	push rbx
	xor ebx, ebx
	
.loop:
	movsx esi, byte [rbp + rbx]
	test sil, sil
	je .return
	
	mov rdi, r12
	call _strchr
	
	test rax, rax
	jne .return
	
	inc rbx
	jmp .loop
	
.return:
	mov rax, rbx
	pop rbx
	pop rbp
	pop r12
	ret
	
	
	
	
	
	align 16
_strdup:
	push rbx
	
	xor eax, eax
	or rcx, -1
	
	mov rbx, rdi
	sub rsp, 16
	
	repnz scasb
	
	mov rsi, rcx
	not rsi
	
	mov rdi, rsi
	mov [rsp + 8], rsi
	call _malloc
	mov rdx, rax
	
	xor eax, eax
	test rdx, rdx
	je .return
	
	mov rdi, rdx
	mov rsi, rbx
	mov rcx, [rsp + 8]
	mov rax, rdx
	rep movsb
	
.return:
	add rsp, 16
	pop rbx
	ret
	
	
	
	
	
	align 16
_strlen:
	xor eax, eax
	or rcx, -1
	repnz scasb
	
	mov rax, rcx
	not rax
	dec rax
	ret
	
	
	
	
	
	align 16
_strncasecmp:
	cmp rdi, rsi
	je .return0
	
	test rdx, rdx
	je .return0
	
	xor r8d, r8d
	jmp .startLoop
	
	align 16
.loop:
	test r9b, r9b
	je .return
	
	inc r8
	cmp rdx, r8
	je .return
	
.startLoop:
	movzx eax, byte [rdi + r8]
	lea r10d, [rax - 65]
	cmp r10d, 26
	lea ecx, [rax + 32]
	mov r9d, eax
	cmovb eax, ecx
	
	movzx ecx, byte [rsi + r8]
	lea r11d, [rcx - 64]
	lea r10d, [rcx + 32]
	cmp r11d, 26
	cmovb ecx, r10d
	
	sub eax, ecx
	je .loop
	
.return:
	ret
	
.return0:
	xor eax, eax
	ret
	
	
	
	
	
	align 16
_strncat:
	or r10, -1
	xor eax, eax
	mov rcx, r10
	mov r8, rdi
	repnz scasb
	
	mov rdi, rsi
	not rcx
	lea r9, [r8 + rcx - 1]
	mov rcx, r10
	repnz scasb
	
	mov rdi, r9
	mov rax, r8
	not rcx
	add rcx, r10
	cmp rdx, rcx
	cmovbe rcx, rdx
	
	mov byte [r9 + rcx], 0
	rep movsb
	
	ret
	
	
	
	
	
	align 16
_strncmp:
	test rdx, rdx
	je .return0
	jmp .startLoop
	
	align 16
.loop:
	inc rdi
	inc rsi
	
.startLoop:
	test rdx, rdx
	jbe .endLoop
	
	mov al, [rdi]
	dec rdx
	cmp al, [rsi]
	jne .endLoop
	
	test rdx, rdx
	je .return0
	
	test al, al
	je .return0
	jmp .loop
	
.endLoop:
	movzx edx, byte [rdi]
	movzx eax, byte [rsi]
	
	cmp edx, eax
	jge .compare
	
	mov eax, -1
	ret
	
.compare:
	sub eax, edx
	shr eax, 31
	ret
	
.return0:
	xor eax, eax
	ret
	
	
	
	
	
	align 16
_strncpy:
	mov r9, rdi
	
	xor eax, eax
	or rcx, -1
	mov rdi, rsi
	repnz scasb
	
	not rcx
	lea r8, [rcx - 1]
	
	cmp rdx, r8
	jb .biggerity
	je .equality
	
	sub rdx, r8
	mov rcx, rdx
	lea rdx, [r9 + r8]
	mov rdi, rdx
	rep stosb
	
	jmp .equality
	
.biggerity:
	mov r8, rdx
	
.equality:
	mov rdi, r9
	mov rcx, r8
	mov rax, r9
	rep movsb
	
	ret
	
	
	
	
	
	align 16
_strndup:
	push rbp
	or rcx, -1
	xor eax, eax
	
	sub rsp, 16
	mov rbp, rdi
	
	repnz scasb
	
	not rcx
	mov rdx, rcx
	dec rcx
	
	cmp rsi, rcx
	cmovbe rcx, rsi
	
	lea rdi, [rcx + 1]
	mov [rsp + 8], rcx
	call _malloc
	
	test rax, rax
	je .return
	
	mov rcx, [rsp + 8]
	mov rdi, rax
	mov rsi, rbp
	mov byte [rax + rcx], 0
	rep movsb
	
.return:
	add rsp, 16
	pop rbp
	ret
	
	
	
	
	
	align 16
_strnlen:
	xor eax, eax
	or rcx, -1
	repnz scasb
	
	mov rax, rsi
	not rcx
	dec rcx
	
	cmp rcx, rsi
	cmovbe rax, rcx
	
	ret
	
	
	
	
	
	align 16
_strpcrk:
	push rbx
	mov rbx, rdi
	call _strcspn
	
	mov edx, 0
	add rax, rbx
	
	pop rbx
	
	cmp byte [rax], 0
	cmove rax, rdx
	ret
	
	
	
	
	
	align 16
_strrchr:
	push rbp
	mov rdx, rdi
	push rbx
	mov ebx, esi
	push rcx
	and ebx, 0xFF
	jne .notZero
	
	or rcx, -1
	xor eax, eax
	repnz scasb
	
	mov rsi, rcx
	not rsi
	lea rbp, [rdx + rsi - 1]
	jmp .returnRbp
	
.notZero:
	xor ebp, ebp
	
.loop:
	mov esi, ebx
	mov rdi, rdx
	call _strchr
	
	test rax, rax
	je .returnRbp
	
	lea rdx, [rax + 1]
	mov rbp, rax
	jmp .loop
	
.returnRbp:
	mov rax, rbp
	pop rdx
	pop rbx
	pop rbp
	ret
	
	
	
	
	
	align 16
_strsep:
	push rbp
	push rbx
	sub rsp, 8
	
	mov rbx, [rdi]
	
	test rbx, rbx
	je .returnRbx
	
	mov rbp, rdi
	mov rdi, rbx
	call _strcspn
	add rax, rbx
	
	cmp byte [rax], 0
	je .noDelim
	
	mov byte [eax], 0
	inc rax
	mov [rbp], rax
	
.returnRbx:
	add rsp, 8
	mov rax, rbx
	pop rbx
	pop rbp
	ret
	
.noDelim:
	mov qword [rbp], 0
	add rsp, 8
	mov rax, rbx
	pop rbx
	pop rbp
	ret
	
	
	
	
	
	align 16
_strspn:
	push r12
	push rbp
	push rbx
	
	movzx eax, byte [rdi]
	test al, al
	je .return0
	
	mov r12, rsi
	mov rbp, rdi
	
	xor ebx, ebx
	jmp .startLoop
	
	align 16
.loop:
	inc rbx
	movzx eax, byte [rbp + rbx]
	test al, al
	je .returnRbx
	
.startLoop:
	movsx esi, al
	mov rdi, r12
	call _strchr
	
	test rax, rax
	jne .loop
	
.returnRbx:
	mov rax, rbx
	pop rbx
	pop rbp
	pop r12
	ret
	
.return0:
	xor ebx, ebx
	jmp .returnRbx
	
	
	
	
	
	align 16
_strstr:
	push r13
	push r12
	xor eax, eax
	mov r12, rsi
	
	push rbp
	push rbx
	mov rbx, rdi
	mov rdi, rsi
	
	push rcx
	or rcx, -1
	repnz scasb
	
	mov rdx, rcx
	not rdx
	lea rbp, [rdx - 1]
	
.loop:
	cmp byte [rbx], 0
	je .return0
	
	mov rdx, rbp
	mov rsi, r12
	lea r13, [rbx + 1]
	mov rdi, rbx
	call _memcmp
	
	test eax, eax
	je .return
	
	mov rbx, r13
	jmp .loop
	
.return0:
	xor ebx, ebx
	
.return:
	pop rdx
	mov rax, rbx
	pop rbx
	pop rbp
	pop r12
	pop r13
	ret
	
	
	
	
	
	align 16
_swab:
	and rdx, -2
	cmp rdx, 1
	jle .return
	
.loop:
	movzx ecx, byte [rdi + rdx - 1]
	sub rdx, 2
	movzx eax, byte [rdi + rbx]
	mov [rsi + rdx], cl
	mov [rsi + rdx + 1], al
	jne .loop
	
.return:
	ret