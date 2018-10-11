global _getSign1
global _getSign2
global _getSign3
global _isNotNegative
global _areSignsOpposite
global _min
global _max
global _signExtendFromWidth
global _conditionalClearOrSet
global _swapBits
global _hasZeroByte

segment .text align=16

_getSign1:
	mov eax, [esp + 4]
	sar eax, 31
	ret
	
	
	
	

_getSign2:
	mov eax, [esp + 4]
	sar eax, 31
	or eax, 1
	ret
	
	
	
	
	
_getSign3:
	mov edx, [esp + 4]
	
	test edx, edx
	setg al
	
	shr edx, 31
	or eax, edx
	ret
	
	
	
	
	
_isNotNegative:
	mov eax, [esp + 4]
	
	not eax
	shr eax, 31
	ret
	
	
	
	
	
_areSignsOpposite:
	mov eax, [esp + 8]
	xor eax, [esp + 4]
	shr eax, 31
	ret
	
	
	
	
	
_min:
	mov ecx, [esp + 8]
	mov edx, [esp + 4]
	
	xor eax, eax
	cmp edx, ecx
	setl al
	xor edx, ecx
	neg eax
	and eax, edx
	xor eax, ecx
	ret
	
	
	
	
	
_max:
	mov ecx, [esp + 4]
	mov edx, [esp + 8]
	
	xor eax, eax
	cmp ecx, edx
	setl al
	neg eax
	xor edx, ecx
	and eax, edx
	xor eax, ecx
	ret
	
	
	
	
	
_signExtendFromWidth:
	mov edx, 1
	movzx eax, byte [esp + 8]
	lea ecx, [eax + 31]
	shl edx, cl
	
	mov ecx, eax
	mov eax, 1
	shl eax, cl
	dec eax
	and eax, [esp + 4]
	
	xor eax, edx
	sub eax, edx
	ret
	
	
	
_signExtendFromWidthBMI:
	movzx ecx, byte [esp + 8]
	mov edx, 1
	lea eax, [ecx - 1]
	shlx edx, edx, eax
	
	mov eax, -1
	shlx eax, eax, ecx
	andn eax, eax, [esp + 4]
	
	xor eax, edx
	sub eax, edx
	ret
	
	
	
	
	
_conditionalClearOrSet:
	movzx eax, byte [esp + 12]
	mov edx, [esp + 4]
	
	neg eax
	xor eax, edx
	and eax, [esp + 8]
	xor eax, edx
	ret
	
	
	
	
	
_swapBits:
	push edi
	push esi
	push ebx
	
	mov eax, [esp + 28]
	movzx edi, byte [esp + 16]
	movzx esi, byte [esp + 20]
	
	mov ebx, eax
	mov edx, eax
	mov ecx, edi
	shr ebx, cl
	mov ecx, esi
	shr edx, cl
	
	movzx ecx, byte [esp + 24]
	
	xor edx, ebx
	mov ebx, -1
	sal ebx, cl
	mov ecx, edi
	not ebx
	and edx, ebx
	mov ebx, edx
	sal ebx, cl
	mov ecx, esi
	sal edx, cl
	or edx, ebx
	
	pop ebx
	pop esi
	xor eax, edx
	pop edi
	ret
	
	
	
_swapBitsBMI:
	push edi
	push esi
	push ebx
	
	mov ebx, [esp + 28]
	movzx edx, byte [esp + 16]
	movzx esi, byte [esp + 20]
	movzx edi, byte [esp + 24]
	
	shrx ecx, ebx, edx
	shrx eax, ebx, esi
	xor eax, ecx
	mov ecx, -1
	shlx ecx, ecx, edi
	andn ecx, ecx, eax
	shlx eax, ecx, edx
	shlx edx, ecx, esi
	or eax, edx
	xor eax, ebx
	
	pop ebx
	pop esi
	pop edi
	ret
	
	
	
	
	
_hasZeroByte:
	mov edx, [esp + 4]
	
	xor eax, eax
	test dl, dl
	je .return
	
	test dh, 0xFF
	je .return
	
	test edx, 0xFF0000
	je .return
	
	shr edx, 24
	setne al 
	
.return:
	ret