global _findFirstSet	; int32_t findFirstSet(int32_t n)
global _findFirstSet64	; int64_t findFirstSet(int64_t n)

segment .text align=16

_findFirstSet:
	bsf eax, edi
	mov edx, -1
	cmove eax, edx
	inc rax
	ret
	
	
	
	
	
_findFirstSet64:
	bsf rax, rdi
	mov rdx, -1
	cmove rax, rdx
	inc rax
	cdqe
	ret