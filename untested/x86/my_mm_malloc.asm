%include "macros.inc"

global _my_mm_malloc
global _my_mm_free
extern _malloc
extern _free
extern ___errno_location

segment .text align=16

_my_mm_malloc:
	multipush edi, esi
	push eax
	mov eax, [esp + 28]
	
	xor esi, esi
	lea ecx, [eax - 1]
	test ecx, ecx
	je .powOf2
	
	call ___errno_location
	mov dword [eax], 22
	jmp .retEsi
	
.powOf2:
	mov ecx, [esp + 16]
	
	test ecx, ecx
	je .retEsi
	
	cmp eax, 8
	mov edi, 8
	cmova edi, eax
	
	add ecx, edi
	mov [esp], ecx
	call _malloc
	
	test eax, eax
	je .retEsi
	
	mov ecx, eax
	add ecx, edi
	
	neg edi
	and edi, ecx
	
	mov [edi - 4], eax
	mov esi, edi
	
.retEsi:
	mov eax, esi
	add esp, 4
	multipop edi, esi
	ret





	align 16
_my_mm_free:
	mov eax, [esp + 4]
	
	test eax, eax
	je .ret
	
	mov eax, [eax - 4]
	mov [esp + 4], eax
	jmp _free
	
.ret:
	ret