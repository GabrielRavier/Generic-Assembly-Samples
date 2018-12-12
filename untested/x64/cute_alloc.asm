global _ca_stack_create
global _ca_stack_alloc
global _ca_stack_free
global _ca_stack_bytes_left
global _ca_frame_create
global _ca_frame_alloc
global _ca_frame_free
global _ca_leak_check_alloc
global _ca_leak_check_calloc
global _ca_leak_check_free
global _CUTE_ALLOC_CHECK_FOR_LEAKS
global _CUTE_ALLOC_BYTES_IN_USE

extern _malloc
extern _free
extern _puts
extern _printf

segment .data align=16

	_ca_alloc_head_info times 40 db 0
	
	align 16
	_ca_alloc_head_init db 1
	
	align 16
	_CUTE_ALLOC_CHECK_FOR_LEAKS_leaked_msg db `LEAKED %llu bytes from file "%s" at line %d from address %p.\n`, 0
	
	align 16
	_CUTE_ALLOC_CHECK_FOR_LEAKS_success_msg db 'SUCCESS: No memory leaks detected.', 0
	
	align 16
	_CUTE_ALLOC_CHECK_FOR_LEAKS_warning_msg db 'WARNING: Memory leaks detected (see above).', 0

segment .text align=16

_ca_stack_create:
	cmp rsi, 23
	jbe .ret0
	
	lea rax, [rdi + 32]
	sub rsi, 32
	
	mov [rdi], rax
	mov [rdi + 8], rsi
	mov [rdi + 16], rsi
	mov qword [rdi + 24], 0
	mov rax, rdi
	ret
	
	align 16
.ret0:
	xor eax, eax
	ret
	
	
	
	
	
	align 16
_ca_stack_alloc:
	mov rax, [rdi + 16]
	add rax, -8
	cmp rax, rsi
	jae .continue
	
	xor eax, eax
	ret
	
	align 16
.continue:
	mov rax, [rdi]
	mov [rsi + rax], rsi
	lea rdx, [rsi + rax + 8]
	add rsi, 8
	mov [rdi], rdx
	sub [rdi + 16], rsi
	ret
	
	
	
	
	
	align 16
_ca_stack_free:
	test rsi, rsi
	je .ret0
	
	mov rax, [rdi]
	mov rdx, [rax - 8]
	
	sub rax, rdx
	lea rcx, [rax - 8]

	xor eax, eax
	
	cmp rsi, rcx
	je .continue
	
	ret
	
	align 16
.continue:
	mov rax, [rdi + 16]
	mov [rdi], rsi
	lea rax, [rdx + rax + 8]
	mov [rdi + 16], rax
	
	mov eax, 1
	ret
	
	align 16
.ret0:
	xor eax, eax
	ret
	
	
	
	
	
	align 16
_ca_stack_bytes_left:
	mov rax, [rdi + 16]
	ret
	
	
	
	
	
	align 16
_ca_frame_create:
	lea rdx, [rdi + 32]
	sub rsi, 32
	mov rax, rdi
	mov [rdi], rdx
	mov [rdi + 8], rdx
	mov [rdi + 16], rsi
	mov [rdi + 24], rsi
	ret
	
	
	
	
	
	align 16
_ca_frame_alloc:
	mov rcx, [rdi + 24]
	sub rcx, rsi
	jae .continue
	
	xor eax, eax
	ret
	
	align 16
.continue:
	mov rax, [rdi + 8]
	add rsi, rax
	mov [rdi + 8], rsi
	mov [rdi + 24], rcx
	ret
	
	
	
	
	
	align 16
_ca_frame_free:
	mov rax, [rdi]
	mov rcx, [rdi + 16]
	mov [rdi + 8], rax
	mov [rdi + 24], rcx
	ret
	
	
	
	
	
	align 16
_ca_leak_check_alloc:
	push r12
	mov r12, rsi
	push rbp
	mov ebp, edx
	push rbx
	mov rbx, rdi
	
	add rdi, 40
	call _malloc
	
	test rax, rax
	je .ret0
	
	mov edx, [rel _ca_alloc_head_init]
	
	mov [rax], r12
	mov [rax + 8], rbx
	mov [rax + 16], ebp
	
	test edx, edx
	je .notInit
	
	mov rdx, [rel _ca_alloc_head_info + 24]
	
.continue:
	mov qword [rax + 32], _ca_alloc_head_info
	mov [rax + 24], rdx
	mov [rel _ca_alloc_head_info + 24], rax
	mov [rdx + 32], rax
	add rax, 40
	
.return:
	pop rbx
	pop rbp
	pop r12
	ret
	
	align 16
.notInit:
	mov qword [rel _ca_alloc_head_info + 32], _ca_alloc_head_info
	mov dword [rel _ca_alloc_head_init], 1
	mov edx, _ca_alloc_head_info
	jmp .continue
	
	align 16
.ret0:
	xor eax, eax
	jmp .return
	
	
	
	
	
	align 16
_ca_leak_check_calloc:
	push rbx
	
	mov rbx, rdi
	imul rbx, rsi
	
	mov rax, rbx
	mov rsi, rax
	mov edx, ecx
	mov rdi, rbx
	call _ca_leak_check_alloc
	mov rdx, rax
	
	mov rcx, rbx
	xor eax, eax
	mov rdi, rbx
	rep stosb
	
	mov rax, rbx
	pop rbx
	ret
	
	
	
	
	
	align 16
_ca_leak_check_free:
	test rdi, rdi
	je .ret
	
	mov rdx, [rdi - 8]
	mov rax, [rdi - 16]
	sub rdi, 40
	mov [rdx + 24], rax
	mov [rax + 32], rdx
	jmp _free
	
	align 16
.ret:
	ret
	
	
	
	
	
	align 16
_CUTE_ALLOC_CHECK_FOR_LEAKS:
	mov eax, _ca_alloc_head_init
	push rbx
	test eax, eax
	jne .initialised
	
	mov qword [rel _ca_alloc_head_info + 24], _ca_alloc_head_info
	mov qword [rel _ca_alloc_head_info + 32], _ca_alloc_head_info
	mov dword [rel _ca_alloc_head_init], 1
	
.success:
	mov edi, _CUTE_ALLOC_CHECK_FOR_LEAKS_success_msg
	call _puts
	
	xor eax, eax
	pop rbx
	ret
	
.initialised:
	mov rbx, [rel _ca_alloc_head_info + 24]
	cmp rbx, _ca_alloc_head_info
	je .success
	
.loop:
	mov ecx, [rbx + 16]
	mov rsi, [rbx + 8]
	mov rdx, [rbx]
	lea r8, [rbx + 40]
	
	mov edi, _CUTE_ALLOC_CHECK_FOR_LEAKS_leaked_msg
	xor eax, eax
	call _printf
	
	mov rbx, [rbx + 24]
	cmp rbx, _ca_alloc_head_info
	jne .loop
	
	mov edi, _CUTE_ALLOC_CHECK_FOR_LEAKS_warning_msg
	call _puts
	
	mov eax, 1
	pop rbx
	ret
	
	
	
	
	
	align 16
_CUTE_ALLOC_BYTES_IN_USE:
	mov eax, _ca_alloc_head_init
	test eax, eax
	jne .initialised
	
	mov qword [rel _ca_alloc_head_info + 24], _ca_alloc_head_info
	mov qword [rel _ca_alloc_head_info + 32], _ca_alloc_head_info
	mov dword [rel _ca_alloc_head_init], 1
	ret
	
	align 16
.initialised:
	mov rdx, [rel _ca_alloc_head_info + 24]
	xor eax, eax
	cmp rdx, _ca_alloc_head_info
	je .ret
	
.loop:
	add eax, [rdx + 8]
	mov rdx, [rdx + 24]
	cmp rdx, _ca_alloc_head_info
	jne .loop
	ret
	
	align 16
.ret:
	ret