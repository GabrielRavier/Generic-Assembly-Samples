global _rand
global _srand

segment .data align=16

	next dd 1

segment .text align=16

_rand:
	mov eax, 123459876
	mov ecx, [next]
	
	test ecx, ecx
	cmove ecx, eax
	
	mov eax, 110892733
	mul ecx
	
	mov eax, edx
	mov edx, ecx
	sub edx, eax
	shr edx, 1
	add edx, eax
	shr edx, 16
	imul eax, edx, -127773
	imul edx, edx, -2836
	
	add ecx, eax
	imul ecx, ecx, 16807
	imul edx, edx, -2836
	
	add ecx, eax
	imul ecx, ecx, 16807
	
	mov eax, ecx
	lea ecx, [0x7FFFFFFF + ecx + edx]
	add eax, edx
	cmovs eax, ecx
	
	mov [next], eax
	and eax, 0x7FFFFFFF
	ret
	
	
	
	
	
	align 16
_srand:
	mov eax, [esp + 4]
	mov [next], eax
	ret