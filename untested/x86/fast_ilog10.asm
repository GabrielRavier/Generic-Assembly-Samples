global _fast_ilog10

segment .rodata align=16

	_g_fast_ipow10 dd 1, 10, 100, 1000, 10000, 100000, 1000000, 10000000, 100000000, 1000000000
	
segment .text align=16

_fast_ilog10:
	mov ecx, [esp + 4]
	
	bsr eax, ecx
	lea eax, [eax + eax * 8]
	shr eax, 5
	
	lea edx, [eax + 1]
	
	cmp [_g_fast_ipow10 + edx * 4], ecx
	cmovbe eax, edx
	
	ret