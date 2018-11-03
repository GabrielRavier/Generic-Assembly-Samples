global _i32toi64	; int64_t i32toi64(int32_t x)

segment .text align=16

_i32toi64:
	mov eax, [esp + 4]
	cdq
	ret
	
_i32toi64Alt:
	mov eax, [esp + 4]
	mov edx, eax
	sar edx, 31
	ret