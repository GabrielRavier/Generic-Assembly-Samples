global _pollDelay

segment .text align=16

_pollDelay:
	push esi
	
	rdtsc
	mov esi, eax
	mov ecx, edx
	add esi, [esp + 8]
	adc ecx, [esp + 12]
	
	rdtsc
	cmp eax, esi
	sbb edx, ecx
	jge .return
	
.loop:
	pause
	rdtsc
	cmp eax, esi
	sbb edx, ecx
	jl .loop
	
.return:
	pop esi
	ret
	