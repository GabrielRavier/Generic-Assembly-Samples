%include "macros.inc"

global _ca_stack_create
global _ca_stack_alloc
global _ca_stack_free
global _ca_stack_bytes_left
global _ca_frame_create
global _ca_frame_alloc
global _ca_frame_free
global _ca_alloc_head
global _ca_leak_check_alloc
global _ca_leak_check_calloc
global _ca_leak_check_free
global _CUTE_ALLOC_BYTES_IN_USE

extern _malloc
extern _memset
extern _free

segment .data align=16

	ca_alloc_head_info times 5 dd 0
	
	align 16
	
	ca_alloc_head_init dd 0

segment .text align=16

_ca_stack_create:
	mov ecx, [esp + 8]
	xor eax, eax
	
	cmp ecx, 12
	jb .return
	
	mov eax, [esp + 4]
	sub ecx, 16
	lea edx, [eax + 16]
	mov dword [eax + 12], 0
	mov [eax], edx
	mov [eax + 4], ecx
	mov [eax + 8], ecx
	
.return:
	ret
	
	
	
	
	
	align 16
_ca_stack_alloc:
	push esi
	mov edx, [esp + 8]
	mov ecx, [esp + 12]
	xor eax, eax
	
	mov esi, [edx + 8]
	sub esi, 4
	cmp esi, ecx
	jb .return
	
	mov eax, [edx]
	mov [eax + ecx], ecx
	lea esi, [eax + ecx + 4]
	add ecx, 4
	mov [edx], esi
	sub [edx + 8], ecx
	
.return:
	pop esi
	ret
	
	
	
	
	
	align 16
_ca_stack_free:
	push edi
	mov ecx, [esp + 12]
	test ecx, ecx
	je .ret0
	
	mov edx, [esp + 8]
	mov edi, [edx]
	mov eax, [edi - 4]
	sub edi, eax
	add edi, -4
	
	cmp edi, ecx
	je .noRet0
	
.ret0:
	xor eax, eax
	pop edi
	ret
	
.noRet0:
	mov ecx, [edx + 8]
	mov [edx], edi
	lea eax, [ecx + eax + 4]
	mov [edx + 8], eax
	
	mov eax, 1
	pop edi
	ret
	
	
	
	
	
	align 16
_ca_stack_bytes_left:
	mov eax, [esp + 4]
	mov eax, [eax + 8]
	ret
	
	
	
	
	
	align 16
_ca_frame_create:
	mov eax, [esp + 4]
	mov ecx, [esp + 8]
	lea edx, [eax + 16]
	mov [eax], edx
	mov [eax + 4], edx
	lea edx, [ecx - 16]
	mov [eax + 12], edx
	mov [eax + 8], edx
	ret
	
	
	
	
	
	align 16
_ca_frame_alloc:
	push esi
	mov ecx, [esp + 8]
	mov edx, [esp + 12]
	xor eax, eax
	
	mov esi, [ecx + 12]
	sub esi, edx
	jb .return
	
	mov eax, [ecx + 4]
	
	add edx, eax
	mov [ecx + 4], edx
	mov [ecx + 12], esi
	
.return:
	pop esi
	ret
	
	
	
	
	
	align 16
_ca_frame_free:
	mov eax, [esp + 4]
	mov edx, [eax]
	mov [eax + 4], edx
	mov edx, [eax + 8]
	mov [eax + 12], edx
	ret
	
	
	
	
	
	align 16
_ca_alloc_head:
	cmp dword [ca_alloc_head_init], 0
	jne .return
	
	mov dword [ca_alloc_head_info + 12], ca_alloc_head_info
	mov dword [ca_alloc_head_info + 16], ca_alloc_head_info
	mov dword [ca_alloc_head_init], 1
	
.return:
	mov eax, ca_alloc_head_info
	ret
	
	
	
	
	
	align 16
_ca_leak_check_alloc:
	push ebx
	sub esp, 20
	mov ebx, [esp + 28]
	
	lea eax, [ebx + 20]
	push eax
	call _malloc
	add esp, 16
	
	test eax, eax
	je .ret0
	
	mov edx, [esp + 20]
	mov [eax + 4], ebx
	mov [eax], edx
	
	mov edx, [esp + 24]
	mov [eax + 8], edx
	
	mov edx, [ca_alloc_head_init]
	test edx, edx
	je .notInit
	
	mov edx, [ca_alloc_head_info + 12]
	
.endProper:
	mov dword [eax + 16], ca_alloc_head_info
	mov [eax + 12], edx
	mov [ca_alloc_head_info + 12], eax
	mov [edx + 16], eax
	add eax, 20
	
.return:
	add esp, 8
	pop ebx
	ret
	
.notInit:
	mov dword [ca_alloc_head_info + 16], ca_alloc_head_info
	mov edx, ca_alloc_head_info
	mov dword [ca_alloc_head_init], 1
	jmp .endProper
	
	align 16
.ret0:
	xor eax, eax
	jmp .return
	
	
	
	
	
	align 16
_ca_leak_check_calloc:
	multipush esi, ebx
	sub esp, 8
	
	mov ebx, [esp + 24]
	imul ebx, [esp + 20]
	
	push dword [esp + 32]
	push dword [esp + 32]
	push ebx
	call _ca_leak_check_alloc
	add esp, 12
	
	push ebx
	mov esi, eax
	push 0
	push eax
	call _memset
	
	add esp, 20
	mov eax, esi
	multipop esi, ebx
	ret
	
	
	
	
	
	align 16
_ca_leak_check_free:
	mov eax, [esp + 4]
	test eax, eax
	je .return
	
	mov ecx, [eax - 4]
	mov edx, [eax - 8]
	sub eax, 20
	mov [ecx + 12], edx
	mov [edx + 16], ecx
	mov [esp + 4], eax
	jmp _free
	
	align 16
.return:
	ret
	
	
	
	
	
	align 16
_CUTE_ALLOC_BYTES_IN_USE:
	sub esp, 12
	call _ca_alloc_head
	xor ecx, ecx
	
	mov edx, [eax + 12]
	cmp eax, edx
	je .returnEcx
	
.loop:
	add ecx, [edx + 4]
	mov edx, [edx + 12]
	cmp eax, edx
	jne .loop
	
.returnEcx:
	mov eax, ecx
	add esp, 12
	ret