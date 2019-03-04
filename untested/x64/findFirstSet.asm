global _findFirstSet
global _findFirstSet64

segment .text align=16

_findFirstSet:
	bsf eax, edi
	mov edx, -1
	cmove eax, edx
	inc rax
	ret
	
	
	
	
	
	align 16
_findFirstSet64:
	bsf rax, rdi
	mov rdx, -1
	cmove rax, rdx
	inc rax
	cdqe
	ret