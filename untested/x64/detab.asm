global _detab	; void detab(char *a1)

segment .text align=16

_detab:
	jmp .startLoop
	
	align 16
.loop:
	inc rdi
	
.startLoop:
	movsx eax, byte [rdi]
	test al, al
	je .return
	
.check:
	cmp eax, 9
	jne .loop
	
	mov byte [rdi], ' '
	
	inc rdi
	
	movsx eax, byte [rdi]
	test al, al
	jne .check
	
.return:
	ret
	
	