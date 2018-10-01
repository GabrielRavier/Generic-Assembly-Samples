global _MulDiv	; int32_t MulDiv(int32_t a, int32_t b, int32_t c)

segment .text align=16

_MulDiv:
	movsx rax, edi
	movsx rsi, esi
	movsx rcx, edx
	
	imul rax, rsi
	xor edx, edx
	div rcx
	
	ret