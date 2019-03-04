global _MulDiv

segment .text align=16

_MulDiv:
	movsx rax, edi
	movsx rsi, esi
	movsx rcx, edx
	
	imul rax, rsi
	xor edx, edx
	div rcx
	
	ret