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
	