global _isLeapYear	; bool isLeapYear(unsigned int a1)

segment .text align=16

_isLeapYeari386:
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

.return0:
	xor eax, eax
	ret
	
	
	
	
	
_isLeapYearBMI2:
	mov edx, 0x51EB851F
	
	mov eax, [esp + 4]
	
	mulx edx, ecx, eax
	shr edx, 7
	imul ecx, edx, -400
	add ecx, eax
	je .return1
	
	mov edx, 0x51EB851F
	mulx edx, ecx, eax
	shr edx, 5
	imul ecx, edx, -100
	add ecx, eax
	je .return0
	
	test al, 3
	jne .return0
	
.return1:
	mov eax, 1
	ret
	
.return0:
	xor eax, eax
	ret