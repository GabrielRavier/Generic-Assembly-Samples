global _intToBase
global _intToBase64

segment .text align=16

_intToBase:
	mov eax, edi
	mov r9d, edx
	mov r8, rsi
	
	xor esi, esi
	xor ecx, ecx
	
	test eax, eax
	jne .notZero
	
	mov byte [r8], '0'
	mov byte [r8 + 1], 0
	ret
	
.notZero:
	jns .notNegative
	
	xor ecx, ecx
	inc ecx
	
	neg eax
	
	je .noLoop
	
.notNegative:
.loop:
	cdq
	idiv r9d
	
	cmp edx, 9
	lea edi, [rdx + 'A' - 10]
	lea r10d, [rdx + '0']
	cmovg r10d, edi
	mov byte [rsi + r8], r10b
	inc rsi
	
	test eax, eax
	jne .loop
	
	test ecx, ecx
	je .dontAddMinus
	
.noLoop:
	mov byte [rsi + r8], '-'
	inc rsi
	
.dontAddMinus:
	movsxd rcx, esi
	xor edi, edi
	mov byte [rsi + r8], 0
	dec rcx
	jle .return
	
.reverseLoop:
	mov al, byte [rcx + r8]
	mov dl, byte [rdi + r8]
	mov byte [rdi + r8], al
	inc rdi
	mov byte [rcx + r8], dl
	dec rcx
	cmp rdi, rcx
	jl .reverseLoop
	
.return:
	ret
	
	
	
	
	
	align 16
_intToBase64:
	test rdi, rdi
	je .prnt0
	
	mov rax, rdi
	neg rax
	cmovl rax, rdi
	
	test rax, rax
	je .num0
	
	movsxd r8, edx
	xor r10d, r10d
	mov r9d, 87
	
.digitsLoop:
	cqo
	idiv r8
	
	cmp edx, 9
	mov ecx, 48
	cmovg ecx, r9d
	
	add ecx, edx
	mov [rsi + r10], cl
	inc r10
	
	test rax, rax
	jne .digitsLoop
	
	test rdi, rdi
	js .numIsNegative
	
.finishStr:
	movsxd rax, r10d
	mov byte [rsi + rax], 0
	
	add eax, -1
	jne .startReverse
	jmp .return
	
	align 16
.prnt0:
	mov word [rsi], 48
	ret
	
	align 16
.num0:
	xor r10d, r10d
	test rdi, rdi
	jns .finishStr
	
.numIsNegative:
	mov eax, r10d
	inc r10d
	mov byte [rsi + rax], 45
	
	movsxd rax, r10d
	mov byte [rsi + rax], 0
	
	add eax, -1
	je .return
	
.startReverse:
	cdqe
	mov ecx, 1
	
.reverseLoop:
	movzx edi, byte [rsi + rcx - 1]
	movzx edx, byte [rsi + rax]
	
	mov [rsi + rcx - 1], dl
	mov [rsi + rax], dil
	
	add rax, -1
	
	cmp rcx, rax
	lea rcx, [rcx + 1]
	jb .reverseLoop
	
.return:
	ret