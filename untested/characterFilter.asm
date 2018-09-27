global _charFilter

segment .text align=16

_charFilter:
	mov eax, [esp + 4]
	dec eax
	
.loop:
	inc eax
	movzx edx, byte [eax]
	cmp dl, ' '
	je .loop
	
	cmp dl, `\t`
	je .loop
	
	sub edx, ' '
	cmp dl, '~' - ' '
	setbe al 
	ret