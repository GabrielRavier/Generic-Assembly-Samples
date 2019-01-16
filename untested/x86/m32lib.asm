global _a2dw
global _arr2mem
global _arr2text
global _arr_add
global _arrcnt
global _arrget
global _arrlen
global _arr_mul
global _arr_sub
global _arrtotal
global _atodw
global _atol
global _byt2bin_ex
global _BMBinSearch
global _BinSearch
global _Cmpi
global _cmpmem
global _CombSortA

extern _strlen

segment .rodata align=16

	bintable dd '0000', '0000', '0000', '1000', '0000', '0100', '0000', '1100', '0000', '0010', '0000', '1010', '0000', '0110', '0000', '1110', '0000', '0001', '0000', '1001', '0000', '0101', '0000', '1101', '0000', '0011', '0000', '1011', '0000', '0111', '0000', '1111', '1000', '0000', '1000', '1000', '1000', '0100', '1000', '1100', '1000', '0010', '1000', '1010', '1000', '0110', '1000', '1110', '1000', '0001', '1000', '1001', '1000', '0101', '1000', '1101', '1000', '0011', '1000', '1011', '1000', '0111', '1000', '1111', '0100', '0000', '0100', '1000', '0100', '0100', '0100', '1100', '0100', '0010', '0100', '1010', '0100', '0110', '0100', '1110', '0100', '0001', '0100', '1001', '0100', '0101', '0100', '1101', '0100', '0011', '0100', '1011', '0100', '0111', '0100', '1111', '1100', '0000', '1100', '1000', '1100', '0100', '1100', '1100', '1100', '0010', '1100', '1010', '1100', '0110', '1100', '1110', '1100', '0001', '1100', '1001', '1100', '0101', '1100', '1101', '1100', '0011', '1100', '1011', '1100', '0111', '1100', '1111', '0010', '0000', '0010', '1000', '0010', '0100', '0010', '1100', '0010', '0010', '0010', '1010', '0010', '0110', '0010', '1110', '0010', '0001', '0010', '1001', '0010', '0101', '0010', '1101', '0010', '0011', '0010', '1011', '0010', '0111', '0010', '1111', '1010', '0000', '1010', '1000', '1010', '0100', '1010', '1100', '1010', '0010', '1010', '1010', '1010', '0110', '1010', '1110', '1010', '0001', '1010', '1001', '1010', '0101', '1010', '1101', '1010', '0011', '1010', '1011', '1010', '0111', '1010', '1111', '0110', '0000', '0110', '1000', '0110', '0100', '0110', '1100', '0110', '0010', '0110', '1010', '0110', '0110', '0110', '1110', '0110', '0001', '0110', '1001', '0110', '0101', '0110', '1101', '0110', '0011', '0110', '1011', '0110', '0111', '0110', '1111', '1110', '0000', '1110', '1000', '1110', '0100', '1110', '1100', '1110', '0010', '1110', '1010', '1110', '0110', '1110', '1110', '1110', '0001', '1110', '1001', '1110', '0101', '1110', '1101', '1110', '0011', '1110', '1011', '1110', '0111', '1110', '1111', '0001', '0000', '0001', '1000', '0001', '0100', '0001', '1100', '0001', '0010', '0001', '1010', '0001', '0110', '0001', '1110', '0001', '0001', '0001', '1001', '0001', '0101', '0001', '1101', '0001', '0011', '0001', '1011', '0001', '0111', '0001', '1111', '1001', '0000', '1001', '1000', '1001', '0100', '1001', '1100', '1001', '0010', '1001', '1010', '1001', '0110', '1001', '1110', '1001', '0001', '1001', '1001', '1001', '0101', '1001', '1101', '1001', '0011', '1001', '1011', '1001', '0111', '1001', '1111', '0101', '0000', '0101', '1000', '0101', '0100', '0101', '1100', '0101', '0010', '0101', '1010', '0101', '0110', '0101', '1110', '0101', '0001', '0101', '1001', '0101', '0101', '0101', '1101', '0101', '0011', '0101', '1011', '0101', '0111', '0101', '1111', '1101', '0000', '1101', '1000', '1101', '0100', '1101', '1100', '1101', '0010', '1101', '1010', '1101', '0110', '1101', '1110', '1101', '0001', '1101', '1001', '1101', '0101', '1101', '1101', '1101', '0011', '1101', '1011', '1101', '0111', '1101', '1111', '0011', '0000', '0011', '1000', '0011', '0100', '0011', '1100', '0011', '0010', '0011', '1010', '0011', '0110', '0011', '1110', '0011', '0001', '0011', '1001', '0011', '0101', '0011', '1101', '0011', '0011', '0011', '1011', '0011', '0111', '0011', '1111', '1011', '0000', '1011', '1000', '1011', '0100', '1011', '1100', '1011', '0010', '1011', '1010', '1011', '0110', '1011', '1110', '1011', '0001', '1011', '1001', '1011', '0101', '1011', '1101', '1011', '0011', '1011', '1011', '1011', '0111', '1011', '1111', '0111', '0000', '0111', '1000', '0111', '0100', '0111', '1100', '0111', '0010', '0111', '1010', '0111', '0110', '0111', '1110', '0111', '0001', '0111', '1001', '0111', '0101', '0111', '1101', '0111', '0011', '0111', '1011', '0111', '0111', '0111', '1111', '1111', '0000', '1111', '1000', '1111', '0100', '1111', '1100', '1111', '0010', '1111', '1010', '1111', '0110', '1111', '1110', '1111', '0001', '1111', '1001', '1111', '0101', '1111', '1101', '1111', '0011', '1111', '1011', '1111', '0111', '1111', '1111'
	
	Cmpi_tbl db 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 97, 98, 99,100,101,102,103,104,105,106,107,108,109,110,111, 112,113,114,115,116,117,118,119,120,121,122, 91, 92, 93, 94, 95, 96, 97, 98, 99,100,101,102,103,104,105,106,107,108,109,110,111, 112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127, 128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143, 144,145,146,147,148,149,150,151,152,153,154,155,156,156,158,159, 160,161,162,163,164,165,166,167,168,169,170,171,172,173,173,175, 176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191, 192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207, 208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223, 224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239, 240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255
	
	oneDiv1Dot3 dq 0.76923076923076916
	
segment .text align=16

_a2dw:
	push ebx
	push edi
	push esi
	sub esp, 16
	mov esi, [esp + 32]
	
	test esi, esi
	je .return
	
	mov [esp], esi
	call _strlen
	
	test eax, eax
	je .return
	
	mov edx, 1
	mov ecx, eax
	sub edx, eax
	
.loop:
	mov bl, [esi]
	add bl, -48
	dec ecx
	movzx edi, bl
	je .addRet
	
	mov ebx, edx
	
.inLoop:
	add edi, edi
	inc ebx
	lea edi, [edi + edi * 4]
	jne .inLoop
	
	add eax, edi
	inc esi
	inc edx
	test ecx, ecx
	jne .loop
	jmp .return
	
	align 16
.addRet:
	add eax, edi
	
.return:
	add esp, 16
	pop esi
	pop edi
	pop ebx
	ret
	
	
	
	
	
	align 16
_arr2mem:
	push ebp
	mov ebp, 1
	push edi
	push esi
	push ebx
	sub esp, 40
	mov edi, [esp + 60]
	mov esi, [esp + 64]
	
	push edi
	call _arrcnt
	mov [esp + 28], eax
	add esp, 16
	
.loop:
	sub esp, 8
	push ebp
	push edi
	call _arrlen
	mov ebx, eax
	
	pop eax
	pop edx
	push ebp
	push edi
	inc ebp
	call _arrget
	
	add esp, 12
	push ebx
	push esi
	add esi, ebx
	push eax
	call _MemCopy
	
	add esp, 16
	cmp [esp + 12], ebp
	jge .loop
	
	add esp, 28
	mov eax, esi
	pop ebx
	pop esi
	pop edi
	pop ebp
	ret
	
	
	
	
	
_arr2text:
	push ebp
	xor ebp, ebp
	push edi
	mov edi, 1
	push esi
	push ebx
	sub esp, 24
	mov ebx, [esp + 48]
	
	push dword [esp + 44]
	call _arrcnt
	add esp, 16
	mov esi, eax
	
.loop:
	sub esp, 8
	push edi
	inc edi
	push dword [esp + 44]
	call _arrget
	
	add esp, 12
	push ebp
	push eax
	push ebx
	call _szappend
	
	mov edx, 0x0A0D
	add esp, 16
	mov [ebx + eax], dx
	lea ebp, [eax + 2]
	cmp esi, edi
	jge .loop
	
	add esp, 12
	mov eax, esi
	pop ebx
	pop esi
	pop edi
	pop ebp
	ret
	
	
	
	
	
_arr_add:
	mov edx, [esp + 8]
	mov ecx, [esp + 12]

	lea eax, [edx * 4]
	neg edx
	add eax, [esp + 4]
	sal edx, 2
	
.loop:
	add [eax + edx], ecx
	add edx, 4
	jne .loop
	
	ret
	
	
	
	
	
_arrcnt:
	mov eax, [esp + 4]
	mov eax, [eax]
	ret
	
	
	
	
	
_arrget:
	mov ecx, [esp + 8]
	test ecx, ecx
	jle .retMin1
	
	mov edx, [esp + 4]
	mov eax, -2
	
	cmp [edx], ecx
	jl .return
	
	mov eax, [edx + ecx * 4]
	
.return:
	ret
	
	align 16
.retMin1:
	mov eax, -1
	ret
	
	
	
	
	
_arrlen:
	mov eax, [esp + 8]
	mov ecx, [esp + 4]
	mov eax, [ecx + eax * 4]
	mov eax, [eax - 4]
	ret
	
	
	
	
	
_arr_mul:
	push ebx
	mov edx, [esp + 12]
	mov ebx, [esp + 16]
	
	lea eax, [edx * 4]
	neg edx
	add eax, [esp + 8]
	
	sal edx, 2
	
.loop:
	mov ecx, [eax + edx]
	imul ecx, ebx
	mov [eax + edx], ecx
	
	add edx, 4
	jne .loop
	
	pop ebx
	ret
	
	
	
	
	
_arr_sub:
	mov edx, [esp + 8]
	mov ecx, [esp + 12]

	lea eax, [edx * 4]
	neg edx
	add eax, [esp + 4]
	
	neg ecx
	sal edx, 2
	
.loop:
	add [eax + edx], ecx
	add edx, 4
	jne .loop
	
	ret
	
	
	
	
	
_arrtotal:
	push esi
	push edi
	
	xor eax, eax
	mov esi, [esp + 12]
	mov edx, 1
	mov ecx, [esi]
	
.loop:
	mov edi, [esi + edx * 4]
	inc edx
	add eax, [edi - 4]
	
	cmp edx, ecx
	jle .loop
	
	cmp byte [esp + 16], 0
	lea edx, [eax + ecx * 2]
	cmovne eax, edx
	
	pop edi
	pop esi
	ret
	
	
	
	
	
_atodw:
	push esi
	mov ecx, [esp + 8]
	xor eax, eax
	
	mov dl, [ecx]
	cmp dl, 2
	jne .notEq
	
	mov dl, [ecx + 1]
	add ecx, 2
	mov esi, -1
	
	test dl, dl
	jne .startLoop
	jmp .return
	
	align 16
.notEq:
	inc ecx
	xor esi, esi
	
	test dl, dl
	je .return
	
.startLoop:
	xor eax, eax
	
.loop:
	add dl, -48

	lea eax, [eax + eax * 4]
	movzx edx, dl
	lea eax, [edx + eax * 2]
	
	movzx edx, byte [ecx]
	inc ecx
	
	test dl, dl
	jne .loop
	
.return:
	add eax, esi
	xor eax, esi
	pop esi
	ret
	
	
	
	
	
_atol:
	push ebx
	mov eax, [esp + 8]
	xor ecx, ecx
	
	mov dl, [eax]
	
	cmp dl, 45
	jne .notNegative
	
	mov dl, [eax + 1]
	add eax, 2
	mov bl, 1
	
	cmp dl, 48
	jae .startLoop
	jmp .return
	
	align 16
.notNegative:
	inc eax
	xor ebx, ebx
	cmp dl, 48
	jb .return
	
.startLoop:
	xor ecx, ecx
	
.loop:
	movsx edx, dl
	
	lea ecx, [ecx + ecx * 4]
	lea ecx, [edx + ecx * 2 - 48]
	
	movzx edx, byte [eax]
	inc eax
	
	cmp dl, 47
	ja .loop
	
.return:
	mov eax, ecx
	neg eax
	test bl, bl
	cmove eax, ecx
	
	pop ebx
	ret
	
	
	
	
	
_byt2bin_ex:
	movzx eax, byte [esp + 4]
	mov ecx, [esp + 8]
	
	mov edx, [bintable + eax * 8]
	mov [ecx], edx
	
	mov edx, [bintable + eax * 8 + 4]
	mov [ecx + 4], edx
	
	mov byte [ecx + 8], 0
	ret
	
	
	
	
	
_BMBinSearch:
	push ebp
	mov eax, -2
	push edi
	push esi
	push ebx
	sub esp, 1024
	mov ecx, [esp + 1060]
	mov edi, [esp + 1056]
	
	cmp ecx, 1
	jle .return
	
	xor eax, eax
	
.loop1:
	mov [esp + eax * 4], ecx
	inc eax
	cmp eax, 64
	jne .loop1
	
	lea esi, [ecx - 1]
	mov edx, edi
	mov eax, esi
	
.loop2:
	movzx ebx, byte [edx]
	inc edx
	mov [esp + ebx * 4], eax
	dec eax
	jne .loop2
	
	mov ebp, [esp + 1052]
	mov eax, [esp + 1048]
	mov edx, esi
	
	add eax, [esp + 1044]
	sub ebp, ecx
	add ebp, [esp + 1048]
	
.loop3:
	movzx ebx, byte [eax + edx]
	cmp [edi + edx], bl
	jne .nope
	
	dec edx
	
.loop4:
	movzx ebx, byte [eax + edx]
	cmp [edi + edx], bl
	jne .nope2
	
	dec edx
	jns .loop4
	
	sub eax, [esp + 1048]
	jmp .return
	
	align 16
.nope2:
	mov ebx, [esp + ebx * 4]
	cmp ecx, ebx
	je .yup
	
	add ebx, edx
	sub ebx, esi
	jns .nope3
	
	mov ebx, 1
	
.nope3:
	add eax, ebx
	mov edx, esi
	jmp .maybeFinished
	
	align 16
.nope:
	mov ebx, [esp + ebx * 4]
	cmp ecx, ebx
	jne .nope3
	
.yup:
	lea eax, [eax + edx + 1]
	
.maybeFinished:
	cmp eax, ebp
	jle .loop3
	
	or eax, -1
	
.return:
	add esp, 1024
	pop ebx
	pop esi
	pop edi
	pop ebp
	ret
	
	
	
	
	
_BinSearch:
	push ebp
	push ebx
	push edi
	push esi
	mov edi, [esp + 36]
	mov edx, [esp + 28]
	
	sub edx, edi
	js .retMin2
	
	mov esi, [esp + 20]
	mov eax, -3
	
	cmp edx, esi
	jl .return
	
	mov eax, [esp + 24]
	add edx, eax
	add esi, eax
	mov eax, -1
	cmp esi, edx
	jg .return
	
	mov ebx, [esp + 32]
	mov ch, [ebx]
	
.loop:
	cmp [esi], ch
	jne .skip
	
	xor ebp, ebp
	
.loop2:
	mov cl, [esi + ebp]
	cmp cl, [ebx + ebp]
	jne .skip
	
	inc ebp
	cmp edi, ebp
	jne .loop2
	jmp .retMined
	
	align 16
.skip:
	inc esi
	cmp esi, edx
	jle .loop
	jmp .return
	
	align 16
.retMin2:
	mov eax, -2
	jmp .return
	
	align 16
.retMined:
	sub esi, [esp + 24]
	mov eax, esi
	
.return:
	pop esi
	pop edi
	pop ebx
	pop ebp
	ret
	
	
	
	
	
	align 16
_Cmpi:
	push ebx
	push edi
	push esi
	mov edi, [esp + 20]
	mov edx, [esp + 16]
	mov eax, 1
	
.loop:
	movzx ebx, byte [edx + eax - 1]
	movzx esi, byte [edi + eax - 1]
	movzx ecx, byte [Cmpi_tbl + ebx]
	cmp cl, [Cmpi_tbl + esi]
	jne .return
	
	inc eax
	test bl, bl
	jne .loop
	
	xor eax, eax
	
.return:
	pop esi
	pop edi
	pop ebx
	ret
	
	
	
	
	
	align 16
_cmpmem:
	push ebp
	push ebx
	push edi
	push esi
	mov eax, [esp + 28]
	mov ecx, [esp + 24]
	mov edx, [esp + 20]
	xor esi, esi
	
	cmp eax, 3
	ja .szAbove3
	
	xor edi, edi
	jmp .under
	
	align 16
.szAbove3:
	mov ebx, eax
	xor edi, edi
	shr ebx, 2
	neg ebx
	
.loop:
	mov ebp, [edx + edi]
	cmp ebp, [ecx + edi]
	jne .ret0
	
	add edi, 4
	inc ebx
	jne .loop
	
	and eax, 3
	je .ret1
	
.under:
	add ecx, edi
	add edx, edi
	
.underLoop:
	movzx ebx, byte [edx + esi]
	cmp bl, [ecx + esi]
	jne .ret0
	
	inc esi
	cmp eax, esi
	jne .underLoop
	
.ret1:
	mov al, 1
	jmp .return
	
	align 16
.ret0:
	xor eax, eax
	
.return:
	pop esi
	pop edi
	pop ebx
	pop ebp
	ret
	
	
	
	
	
_CombSortA:
	push ebp
	push edi
	push esi
	push ebx
	sub esp, 20
	fnstcw [esp + 14]
	
	mov eax, [esp + 44]
	mov ebp, [esp + 40]
	dec eax
	mov [esp + 8], eax
	movzx eax, word [esp + 13]
	or ah, 0xC
	mov [esp + 12], ax

.loop:
	fild dword [esp + 44]
	fmul qword [oneDiv1Dot3]
	mov byte [esp + 7], 1
	
	fldcw [esp + 12]
	fistp dword [esp + 44]
	fldcw [esp + 14]
	
	cmp dword [esp + 44], 1
	je .equal
	
	dec dword [esp + 44]
	cmp dword [esp + 44], 1
	setle byte [esp + 7]
	
.equal:
	mov eax, [esp + 44]
	mov edi, [esp + 8]
	
	xor esi, esi
	sub edi, [esp + 44]
	lea ebx, [ebp + eax * 4]
	xor eax, eax
	
.smallLoop:
	mov ecx, [ebp + eax * 4]
	mov edx, [ebx + eax * 4]
	
	cmp ecx, edx
	jle .largerEqual
	
	mov [ebx + eax * 4], ecx
	inc esi
	mov [ebp + eax * 4], edx
	
.largerEqual:
	inc eax
	cmp eax, edi
	jle .smallLoop
	
	test esi, esi
	jne .loop
	
	cmp byte [esp + 7], 0
	je .loop
	
	add esp, 20
	pop ebx
	pop esi
	pop edi
	pop ebp
	ret
	