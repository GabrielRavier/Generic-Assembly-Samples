global _bswap16
global _bswap32
global _bswap64

segment .text align=16

_bswap16:
	mov eax, edi
	rol ax, 8
	ret
	
	
	
	
	
	align 16
_bswap32:
	mov eax, edi
	bswap eax
	ret
	
	
	
	
	
	align 16
_bswap64:
	mov rax, rdi
	bswap rax
	ret