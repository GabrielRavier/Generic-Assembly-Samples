global _isLeapYear

segment .text align=16

_isLeapYear:
	imul eax, edi, 0xC28F5C29
	mov edx, eax
	ror edx, 4
	cmp edx, 0xA3D70A
	jbe .return1
	
	ror eax, 2
	cmp eax, 0x28F5C28
	jbe .return0
	
	and edi, 3
	sete al
	ret
	
	align 16
.return1:
	mov eax, 1
	ret
	
	align 16
.return0:
	xor eax, eax
	ret
	
	
	
	align 16
_isLeapYearBMI2:
	imul edx, edi, 0xC28F5C29
	mov eax, 1
	rorx ecx, edx, 4
	cmp ecx, 0xA3D70A
	jbe .return
	
	xor eax, eax
	rorx esi, edx, 2
	cmp esi, 0x28F5C28
	jbe .return 
	
	and edi, 3
	sete al
	
.return:
	ret