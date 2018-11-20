global _isLeapYear

segment .text align=16

_isLeapYear:
	mov eax, 0x51EB851F
	
	mov ecx, [esp + 4]
	
	mul ecx
	shr edx, 7
	imul eax, edx, -400
	add eax, ecx
	je .return1
	
	mov eax, 0x51EB851F
	mul ecx
	shr edx, 5
	imul eax, edx, -100
	add eax, ecx
	je .return0
	
	test cl, 3
	jne .return0

.return1:	
	mov eax, 1
	ret

	align 16
.return0:
	xor eax, eax
	ret
	
	
	
	
	
	align 16
_isLeapYearBMI2:
	imul edx, [esp + 4], 0xC28F5C29
	mov eax, 1
	rorx ecx, edx, 4
	cmp ecx, 0xA3D70A
	jbe .return
	
	xor eax, eax
	rorx edx, edx, 2
	cmp edx, 0x28F5C28
	jbe .return
	
	test byte [esp + 4], 3
	sete al 
	
.return:
	ret