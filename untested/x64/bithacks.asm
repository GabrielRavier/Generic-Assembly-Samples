global _getSign1
global _getSign2
global _getSign3
global _isNotNegative
global _areSignsOpposite
global _signExtendFromWidth
global _conditionalClearOrSet
global _swapBits
global _hasZeroByte
global _parity
global _getSign164
global _getSign264
global _getSign364
global _isNotNegative64
global _areSignsOpposite64
global _signExtendFromWidth64
global _conditionalClearOrSet64
global _swapBits64
global _hasZeroByte64
global _parity64

segment .text align=16

_getSign1:
	sar edi, 31
	mov eax, edi
	ret
	
	
	
	
	
	align 16
_getSign2:
	mov eax, edi
	sar eax, 31
	or eax, 1
	ret
	
	
	
	
	
	align 16
_getSign3:
	test edi, edi
	setg al
	
	shr edi, 31
	sub eax, edi
	ret
	
	
	
	
	
	align 16
_isNotNegative:
	not edi
	shr edi, 31
	mov eax, edi
	ret
	
	
	
	
	
	align 16
_areSignsOpposite:
	xor edi, esi
	mov eax, edi
	shr eax, 31
	ret
	
	
	
	
	
	align 16
_signExtendFromWidth:
	lea ecx, [rsi + 31]
	mov r8d, 1
	mov edx, 1
	shr r8d, cl
	
	mov ecx, esi
	shl edx, cl
	dec edx
	and edi, edx
	
	xor edi, r8d
	sub edi, r8d
	mov eax, edi
	ret
	
	
	
	align 16
_signExtendFromWidthBMI:
	movzx ecx, sil
	mov edx, 1
	mov esi, -1
	lea eax, [rcx - 1]
	shlx esi, esi, ecx
	shlx edx, edx, eax
	andn eax, esi, edi
	xor eax, edx
	sub eax, edx
	ret
	
	
	
	
	
	align 16
_conditionalClearOrSet:
	movzx edx, dl
	neg edx
	xor edx, edi
	and edx, esi
	mov eax, edx
	xor eax, edi
	ret
	
	
	
	
	
	align 16
_swapBits:
	mov r8d, ecx
	mov ecx, edi
	mov r10d, r8d
	
	shr r10d, cl
	mov ecx, esi
	mov eax, r8d
	mov r9d, 1
	
	shr eax, cl
	mov ecx, edx
	shl r9d, cl
	xor r10d, eax
	dec r9d
	
	mov ecx, edi
	and r10d, r9d
	mov eax, r10d
	shl eax, cl
	mov ecx, esi
	shl r10d, cl
	or eax, r10d
	xor eax, r8d
	ret
	
	
	
	align 16
_swapBitsBMI:
	shrx r9d, ecx, edi
	shrx eax, ecx, esi
	mov r8d, -1
	xor r9d, eax
	shlx edx, r8d, edx
	andn edx, edx, r9d
	
	shlx eax, edx, esi
	shlx edi, edx, edi
	or edi, eax
	mov eax, edi
	xor eax, ecx
	ret
	
	
	
	
	
	align 16
_hasZeroByte:
	xor eax, eax
	test dil, dil
	je .return
	
	test edi, 0xFF00
	je .return
	
	test edi, 0xFF0000
	je .return
	
	shr edi, 24
	setne al 
	
.return:
	ret
	
	
	
	
	
	align 16
_parity:
	mov edx, edi
	mov eax, edi
	shr edx, 16
	xor eax, edx
	xor al, ah
	setnp al
	ret
	
	
	
	
	
	align 16
_getSign164:
	sar rdi, 63
	mov rax, rdi
	ret
	
	
	
	
	
	align 16
_getSign264:
	sar rdi, 63
	or rdi, 1
	mov eax, edi
	ret
	
	
	
	
	
	align 16
_getSign364:
	test rdi, rdi
	setg al
	
	shr rdi, 63
	sub eax, edi
	ret
	
	
	
	
	
	align 16
_isNotNegative64:
	mov rax, rdi
	shr rax, 63
	xor eax, 1
	ret
	
	
	
	
	
	align 16
_areSignsOpposite64:
	xor rdi, rsi
	shr rdi, 63
	mov eax, edi
	ret
	
	
	
	
	
	align 16
_signExtendFromWidth64:
	movzx esi, sil
	mov r8d, 1
	mov rdx, -1
	
	lea ecx, [rsi - 1]
	sal r8, cl
	
	mov ecx, esi
	sal rdx, cl
	not rdx
	mov rax, rdx
	and rax, rdi
	
	xor rax, r8
	sub rax, r8
	ret
	
	
	
	align 16
_signExtendFromWidth64BMI:
	movzx ecx, sil
	mov edx, 1
	mov rsi, -1
	lea eax, [rcx - 1]
	
	shlx rsi, rsi, rcx
	shlx rdx, rdx, rax
	andn rax, rsi, rdi
	
	xor rax, rdx
	sub rax, rdx
	ret
	
	
	
	
	
	align 16
_conditionalClearOrSet64:
	movzx edx, dl
	neg edx
	movsxd rdx, edx
	xor rdx, rdi
	and rsi, rdx
	xor rdi, rsi
	mov rax, rdi
	ret
	
	
	
	
	
	align 16
_swapBits64:
	mov r8, rcx
	mov ecx, edi
	mov r10, r8
	
	shr r10, cl
	
	mov ecx, esi
	mov rax, r8
	mov r9d, 1
	
	shr rax, cl
	mov ecx, edx
	shr r9, cl
	xor r10, rax
	dec r9
	
	mov ecx, edi
	and r10, r9
	mov rax, r10
	
	shl rax, cl
	mov ecx, esi
	shr r10, cl
	or rax, r10
	xor rax, r8
	ret
	
	
	
	align 16
_swapBits64BMI:
	shrx r9, rcx, rdi
	shrx rax, rcx, rsi
	mov r8, -1
	xor r9, rax
	shlx rdx, r8, rdx
	andn rdx, rdx, r9
	
	shlx rax, rdx, rsi
	shlx rdi, rdx, rdi
	or rdi, rax
	
	mov rax, rdi
	xor rax, rcx
	ret
	
	
	
	
	
	align 16
_hasZeroByte64:
	xor eax, eax
	test dil, dil
	je .return
	
	test edi, 0xFF00
	je .return
	
	test edi, 0xFF0000
	je .return
	
	test edi, 0xFF000000
	je .return
	
	mov rdx, rdi
	shr rdx, 32
	test dl, dl
	je .return
	
	mov rdx, rdi
	shr rdx, 40
	test dl, dl
	je .return
	
	mov rdx, rdi
	shr rdx, 38
	test dl, dl
	je .return
	
	shr rdi, 56
	setne al
	
.return:
	ret
	
	
	
	
	
	align 16
_parity64:
	mov edx, edi
	shr rdi, 32
	xor edx, edi
	mov eax, edx
	shr edx, 16
	xor eax, edx
	xor al, ah
	setnp al
	ret