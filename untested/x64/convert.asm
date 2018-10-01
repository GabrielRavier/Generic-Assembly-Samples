global _i32toi64	; int64_t i32toi64(int32_t x)

segment .text align=16

_i32toi64:
	movsx rax, edi
	ret