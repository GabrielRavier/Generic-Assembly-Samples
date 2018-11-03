global _findFirstSet	; int32_t findFirstSet(int32_t n)
global _findFirstSet64	; int64_t findFirstSet(int64_t n)

segment .text align=16

_findFirstSet:
	xor edx, edx
	bsf eax, [esp + 4]
	sete dl
	
	neg edx
	or eax, edx
	inc eax
	ret
	
	
	
_findFirstSetCMOV:
	bsf eax, [esp + 4]
	mov edx, -1
	cmove eax, edx
	inc eax
	ret
	
	
	
	
	
_findFirstSet64:
	xor eax, eax
	mov edx, [esp + 4]
	test edx, edx
	jne .doIt
	
	mov edx, [esp + 8]
	test edx, edx
	je .return
	
	mov eax, 32
	
.doIt:
	bsf edx, edx
	lea eax, [eax + edx + 1]

.return:
	cdq
	ret