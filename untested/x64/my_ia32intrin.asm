%include "macros.inc"

global _my_bsfd
global _my_bsrd
global _my_bswapd
global _my_crc32b
global _my_crc32w
global _my_crc32d
global _my_popcntd
global _my_rolb
global _my_rolw
global _my_rold
global _my_rorb
global _my_rorw
global _my_rord
global _my_bsfq
global _my_bsrq
global _my_bswapq
global _my_crc32q
global _my_popcntq
global _my_rolq
global _my_rorq

segment .text align=16

_my_bsfd:
	bsf eax, edi
	ret
	
	
	
	
	
	align 16
_my_bsrd:
	xor eax, eax
	
	test edi, edi
	je .ret
	
	mov al, 31
	js .ret
	
.loop:
	dec al
	add edi, edi
	jns .loop
	ret
	
	align 16
.ret:
	ret
	
	
	
	
	
	align 16
_my_bswapd:
	mov eax, edi
	bswap eax
	ret
	
	
	
	
	
	align 16
_BitReflect8:
	movzx edx, dil
	mov eax, edi
	
	mov edi, edx
	sal edi, 7
	shr al, 7
	or eax, edi
	
	mov edi, edx
	sal edi, 5
	and edi, 2
	or eax, edi
	
	mov edi, edx
	sar edi, 1
	and edi, 8
	or eax, edi
	
	lea edi, [rdi + rdx]
	and edi, 16
	lea ecx, [rdx * 8]
	or eax, edi
	
	and ecx, 32
	sal edx, 5
	or eax, ecx
	and edx, 64
	or eax, edx
	ret
	
	
	
	
	
	align 16
_BitReflect16:
	multipush rbp, rbx
	mov ebp, edi
	movzx edi, dil
	sub rsp, 8
	call _BitReflect8
	
	mov ebx, eax
	mov eax, ebp
	movzx edi, ah
	call _BitReflect8
	
	sal ebx, 8
	add rsp, 8
	movzx eax, al
	or eax, ebx
	
	multipop rbp, rbx
	ret
	
	
	
	
	
	align 16
_BitReflect32:
	multipush rbp, rbx
	mov ebp, edi
	movzx edi, di
	sub rsp, 8
	call _BitReflect16
	
	mov edi, ebp
	shr edi, 16
	mov ebx, eax
	call _BitReflect16
	
	sal ebx, 16
	add rsp, 8
	movzx eax, ax
	or eax, ebx
	
	multipop rbp, rbx
	ret
	
	
	
	
	
	align 16
_mod2_64bit:
	mov rax, rsi
	shr rax, 32
	mov ecx, 31
	mov r8, 0x100000000
	
.loop:
	add rax, rax
	mov rdx, rsi
	shr rdx, cl
	and edx, 1
	or rax, rdx
	
	test rax, r8
	je .noXor
	
	xor rax, rdi
	
.noXor:
	dec ecx
	cmp ecx, -1
	jne .loop
	
	ret
	
	
	
	
	
%define crc32Polymonial 0x11EDC6F41
	align 16
_my_crc32b:
	multipush rbp, rbx
	sub rsp, 8
	mov ebp, esi
	
	call _BitReflect32
	mov ebx, eax
	
	movzx edi, bpl
	call _BitReflect8
	movzx esi, al
	
	sal rsi, 32
	sal rbx, 8
	xor rsi, rbx
	
	mov rdi, crc32Polymonial
	call _mod2_64bit
	mov edi, eax
	
	add rsp, 8
	multipop rbp, rbx
	jmp _BitReflect32
	
	
	
	
	
	align 16
_my_crc32w:
	multipush rbp, rbx
	sub rsp, 8
	mov ebp, esi
	
	call _BitReflect32
	mov ebx, eax
	
	movzx edi, bp
	call _BitReflect16
	movzx esi, ax
	
	sal rsi, 32
	sal rbx, 16
	xor rsi, rbx
	
	mov rdi, crc32Polymonial
	call _mod2_64bit
	mov edi, eax
	
	add rsp, 8
	multipop rbp, rbx
	call _BitReflect32
	
	
	
	
	
	align 16
_my_crc32d:
	multipush rbp, rbx
	sub rsp, 8
	mov ebp, esi
	
	call _BitReflect32
	mov ebx, eax
	
	mov edi, ebp
	call _BitReflect32
	
	mov rsi, rbx
	xor rsi, rax
	
	sal rsi, 32
	mov rdi, crc32Polymonial
	call _mod2_64bit
	mov edi, eax
	
	add rsp, 8
	multipop rbp, rbx
	call _BitReflect32
	
	
	
	
	
	align 16
_my_popcntd:
	mov eax, edi
	shr eax, 1
	and eax, 0x55555555
	sub edi, eax
	
	mov ecx, edi
	and edi, 0x33333333
	shr ecx, 2
	and ecx, 0x33333333
	add ecx, edi
	
	mov edx, ecx
	shr edx, 4
	add ecx, edx
	and ecx, 0x0F0F0F0F
	imul eax, ecx, 0x01010101
	shr eax, 24
	ret
	
	
	
	align 16
_my_popcntdPOPCNT:
	popcnt eax, edi
	ret
	
	
	
	
	
	align 16
_my_rolb:
	mov ecx, esi
	and ecx, 7
	mov eax, edi
	rol al, cl
	ret
	
	
	
	
	
	align 16
_my_rolw:
	mov ecx, esi
	and ecx, 0xF
	mov eax, edi
	rol ax, cl
	ret
	
	
	
	
	
	align 16
_my_rold:
	mov eax, edi
	mov ecx, esi
	rol eax, cl
	ret
	
	
	
	
	
	align 16
_my_rorb:
	mov ecx, esi
	and ecx, 7
	mov eax, edi
	rol al, cl
	ret
	
	
	
	
	
	align 16
_my_rorw:
	mov ecx, esi
	and ecx, 0xF
	mov eax, edi
	ror ax, cl
	ret
	
	
	
	
	
	align 16
_my_rord:
	mov eax, edi
	mov ecx, esi
	ror eax, cl
	ret
	
	
	
	
	
	align 16
_my_bsfq:
	bsf rax, rdi
	ret
	
	
	
	
	
	align 16
_my_bsrq:
	test rdi, rdi
	je .ret0
	
	mov eax, 63
	bt rdi, 63
	jc .ret
	
.loop:
	add rdi, rdi
	dec eax
	bt rdi, 63
	jnc .loop
	
.ret:
	ret
	
	align 16
.ret0:
	xor eax, eax
	ret
	
	
	
	
	
	align 16
_my_bswapq:
	mov rax, rdi
	bswap rax
	ret
	
	
	
	
	
	align 16
_my_crc32q:
	multipush rbp, rbx
	mov rbp, rsi
	sub rsp, 8
	
	call _BitReflect32
	mov edi, ebp
	mov ebx, eax
	call _BitReflect32
	
	xor rbx, rax
	mov rsi, rbx
	sal rsi, 32
	
	mov rdi, crc32Polymonial
	call _mod2_64bit
	
	mov rdi, rbp
	shr rdi, 32
	mov ebx, eax
	call _BitReflect32
	
	add rsp, 8
	multipop rbp, rbx
	ret
	
	
	
	
	
	align 16
_my_popcntq:
	mov rdx, rdi
	shr rdx, 1
	mov rax, 0x5555555555555555
	and rdx, rax
	mov rcx, 0x3333333333333333
	sub rdi, rdx
	mov r8, 0x0F0F0F0F0F0F0F0F
	
	mov rax, rdi
	and rdi, rcx
	shr rax, 2
	mov r9, 0x0101010101010101
	and rax, rcx
	add rax, rdi
	
	mov rsi, rax
	shr rsi, 4
	add rax, rsi
	and rax, r8
	imul rax, r9
	shr rax, 56
	ret
	
	
	
	align 16
_my_popcntqPOPCNT:
	popcnt rax, rdi
	ret
	
	
	
	
	
	align 16
_my_rolq:
	mov rax, rdi
	mov ecx, esi
	rol rax, cl
	ret
	
	
	
	
	
	align 16
_my_rorq:
	mov rax, rdi
	mov ecx, esi
	ror rax, cl
	ret