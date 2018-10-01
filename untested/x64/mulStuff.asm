global _isMulOk	; bool isMulOk(uint32_t a1, uint32_t a2)
global _saturatedMul	; uint32_t saturatedMul(uint32_t a1, uint32_t a2)

segment .text align=16

_isMulOk:
	test esi, esi
	je .return1
	
	test edi, edi
	je .return1
	
	mov eax, edi
	mul esi
	setno al
	ret
	
.return1:
	mov eax, 1
	ret
	
	
	
	
	
_saturatedMul:
	test esi, esi
	je .doMul
	
	test edi, edi
	je .doMul
	
	mov eax, edi
	mul esi
	jo .returnMinus1
	
.doMul:
	mov eax, esi
	imul eax, edi
	ret
	
.returnMinus1:
	or eax, -1
	ret