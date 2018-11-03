global _rand
global _srand

segment .data align=16

	next dd 1
	
segment .text align=16

_rand:
	mov ecx, 123459876
	mov edi, [rel next]
	
	test edi, edi
	cmove edi, ecx
	
	mov eax, 110892733
	mul edi
	
	mov r8d, edi
	sub r8d, edx
	shr r8d, 1
	add r8d, edx
	shr r8d, 16
	imul esi, r8d, -127773
	imul r10d, r8d, -2836
	
	add edi, esi
	imul r9d, edi, 16807
	mov eax, r9d
	
	lea r11d, [0x7FFFFFFF + r9 + r10]
	add eax, r10d
	cmovs eax, r11d
	
	mov [rel next], eax
	and eax, 0x7FFFFFFF
	ret
	
	
	
	
	
_srand:
	mov [rel next], edi
	ret