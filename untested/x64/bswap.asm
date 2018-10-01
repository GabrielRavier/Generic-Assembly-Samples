global _bswap16	; uint16_t bswap16 (uint16_t x)
global _bswap32	; uint32_t bswap32 (uint32_t x)
global _bswap64	; uint64_t bswap64(uint64_t x)

segment .text align=16

_bswap16:
	mov eax, edi
	rol ax, 8
	ret
	
	
	
	
	
_bswap32:
	mov eax, edi
	bswap eax
	ret
	
	
	
	
	
_bswap64:
	mov rax, rdi
	bswap rax
	ret