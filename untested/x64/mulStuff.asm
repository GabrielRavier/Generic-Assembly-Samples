global _isMulOk
global _saturatedMul

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
	
	align 16
.return1:
	mov eax, 1
	ret
	
	
	
	
	
	align 16
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
	
	align 16
.returnMinus1:
	or eax, -1
	ret