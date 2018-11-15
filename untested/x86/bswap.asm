global _bswap16
global _bswap32
global _bswap64

segment .text align=16

_bswap16:
	movzx eax, word [esp + 4]
	rol ax, 8
	ret
	
	
	
	align 16
_bswap16MOVBE:
	movbe ax, [esp + 4]
	ret
	
	
	
	
	
	align 16
_bswap32:
	mov eax, [esp + 4]
	bswap eax
	ret
	
	
	
	align 16
_bswap32MOVBE:
	movbe eax, [esp + 4]
	ret
	
	
	
	align 16
_bswap32NoBswap:
	mov eax, [esp + 4]
	xchg al, ah
	rol eax, 16
	xchg al, ah
	ret
	
	
	
	
	
	align 16
_bswap64:
	mov eax, [esp + 8]
	mov edx, [esp + 4]
	bswap edx
	bswap eax
	ret
	
	
	
	align 16
_bswap64MOVBE:
	movbe edx, [esp + 4]
	movbe eax, [esp + 8]
	ret
	
	
	
	align 16
_bswap64NoBswap:
	mov edx, [esp + 4]
	xchg dl, dh
	rol edx, 16
	xchg dl, dh
	
	mov eax, [esp + 8]
	xchg al, ah
	rol eax, 16
	xchg al, ah
	ret