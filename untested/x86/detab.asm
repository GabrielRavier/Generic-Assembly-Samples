global _detab

segment .text align=16

_detab:
	mov edx, [esp + 4]
	
	movsx eax, byte [edx]
	test eax, eax
	je .return
	
.loop:
	cmp eax, `\t`
	jne .notATab
	
	mov byte [edx], ' '
.notATab:
	inc edx
	movsx eax, byte [edx]
	test eax, eax
	jne .loop
	
.return:
	ret