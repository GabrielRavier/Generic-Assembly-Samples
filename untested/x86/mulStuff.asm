global _isMulOk
global _saturatedMul

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
	
	align 16
.continue:
	xor edx, edx
	mov eax, -1
	div ebp
	
	cmp ecx, eax
	mov eax, 0
	setbe al
	pop ebp
	ret
	
	
	
	
	
	align 16
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
	
	align 16
.returnMax:
	mov eax, -1
	ret