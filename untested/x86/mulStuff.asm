global _isMulOk	; bool isMulOk(uint32_t cnt, uint32_t elSize)
global _saturatedMul	; uint32_t saturatedMul(uint32_t cnt, uint32_t elSize)

segment .text align=16

_isMulOk:
	push ebp
	
	mov ebp, [esp + 4 + 8]
	test ebp, ebp
	je .return1
	
	mov ecx, [esp + 4 + 4]
	test ecx, ecx
	jne .continue
	
.return1:
	mov eax, 1
	pop ebp
	ret
	
.continue:
	xor edx, edx
	mov eax, -1
	div ebp
	
	cmp ecx, eax
	mov eax, 0
	setbe al
	pop ebp
	ret
	
	
	
	
	
_saturatedMul:
	mov ecx, [esp + 8]
	test ecx, ecx
	je .mulSafe
	
	cmp dword [esp + 4], 0
	je .mulSafe
	
	xor edx, edx
	mov eax, -1
	div ecx
	
	cmp eax, [esp + 4]
	jb .returnMax
	
.mulSafe:
	mov eax, [esp + 4]
	imul eax, ecx
	ret
	
.returnMax:
	mov eax, -1
	ret