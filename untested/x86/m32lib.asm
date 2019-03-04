%include "macros.inc"

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
global _CombSortD
global _decomment
global _dissort
global _dw2ah
global _dw2bin_ex
global _dw2hex_ex
global _dwtoa
global _get_line_count
global _get_ml
global _GetPercent
global _GetPathOnly
global _htodw
global _InString
global _IntDiv
global _IntMul
global _isalpha
global _isalphanum
global _islower
global _isnumber
global _isupper
global _lfcnt
global _MemCopy
global _NameFromPath
global _nrandom
global _nseed
global _parse_line
global _partial
global _RolData
global _RorData
global _SBMBinSearch
global _StripRangeI
global _StripLF
global _StripRangeX
global _szappend
global _szCmp
global _szCmpi
global _szCopy
global _szLeft
global _szLen
global _szLower
global _szLtrim
global _szMid
global _szMonoSpace
global _szMultiCat
global _szRemove
global _szRep
global _szRev
global _szRight
global _szRtrim
global _szTrim
global _szUpper
global _tstline
global _ucappend
global _ucCatStr
global _ucCmp
global _ucCopy
global _ucLeft
global _ucLen
global _ucMultiCat

extern _strlen
extern _strcat
extern _strcpy
extern _toupper
extern _memcpy
extern _memset
extern _wcscat
extern _wcscpy
extern _wmemcpy
extern _wcslen

segment .rodata align=16

	align 16
	bintable dd '0000', '0000', '0000', '1000', '0000', '0100', '0000', '1100', '0000', '0010', '0000', '1010', '0000', '0110', '0000', '1110', '0000', '0001', '0000', '1001', '0000', '0101', '0000', '1101', '0000', '0011', '0000', '1011', '0000', '0111', '0000', '1111', '1000', '0000', '1000', '1000', '1000', '0100', '1000', '1100', '1000', '0010', '1000', '1010', '1000', '0110', '1000', '1110', '1000', '0001', '1000', '1001', '1000', '0101', '1000', '1101', '1000', '0011', '1000', '1011', '1000', '0111', '1000', '1111', '0100', '0000', '0100', '1000', '0100', '0100', '0100', '1100', '0100', '0010', '0100', '1010', '0100', '0110', '0100', '1110', '0100', '0001', '0100', '1001', '0100', '0101', '0100', '1101', '0100', '0011', '0100', '1011', '0100', '0111', '0100', '1111', '1100', '0000', '1100', '1000', '1100', '0100', '1100', '1100', '1100', '0010', '1100', '1010', '1100', '0110', '1100', '1110', '1100', '0001', '1100', '1001', '1100', '0101', '1100', '1101', '1100', '0011', '1100', '1011', '1100', '0111', '1100', '1111', '0010', '0000', '0010', '1000', '0010', '0100', '0010', '1100', '0010', '0010', '0010', '1010', '0010', '0110', '0010', '1110', '0010', '0001', '0010', '1001', '0010', '0101', '0010', '1101', '0010', '0011', '0010', '1011', '0010', '0111', '0010', '1111', '1010', '0000', '1010', '1000', '1010', '0100', '1010', '1100', '1010', '0010', '1010', '1010', '1010', '0110', '1010', '1110', '1010', '0001', '1010', '1001', '1010', '0101', '1010', '1101', '1010', '0011', '1010', '1011', '1010', '0111', '1010', '1111', '0110', '0000', '0110', '1000', '0110', '0100', '0110', '1100', '0110', '0010', '0110', '1010', '0110', '0110', '0110', '1110', '0110', '0001', '0110', '1001', '0110', '0101', '0110', '1101', '0110', '0011', '0110', '1011', '0110', '0111', '0110', '1111', '1110', '0000', '1110', '1000', '1110', '0100', '1110', '1100', '1110', '0010', '1110', '1010', '1110', '0110', '1110', '1110', '1110', '0001', '1110', '1001', '1110', '0101', '1110', '1101', '1110', '0011', '1110', '1011', '1110', '0111', '1110', '1111', '0001', '0000', '0001', '1000', '0001', '0100', '0001', '1100', '0001', '0010', '0001', '1010', '0001', '0110', '0001', '1110', '0001', '0001', '0001', '1001', '0001', '0101', '0001', '1101', '0001', '0011', '0001', '1011', '0001', '0111', '0001', '1111', '1001', '0000', '1001', '1000', '1001', '0100', '1001', '1100', '1001', '0010', '1001', '1010', '1001', '0110', '1001', '1110', '1001', '0001', '1001', '1001', '1001', '0101', '1001', '1101', '1001', '0011', '1001', '1011', '1001', '0111', '1001', '1111', '0101', '0000', '0101', '1000', '0101', '0100', '0101', '1100', '0101', '0010', '0101', '1010', '0101', '0110', '0101', '1110', '0101', '0001', '0101', '1001', '0101', '0101', '0101', '1101', '0101', '0011', '0101', '1011', '0101', '0111', '0101', '1111', '1101', '0000', '1101', '1000', '1101', '0100', '1101', '1100', '1101', '0010', '1101', '1010', '1101', '0110', '1101', '1110', '1101', '0001', '1101', '1001', '1101', '0101', '1101', '1101', '1101', '0011', '1101', '1011', '1101', '0111', '1101', '1111', '0011', '0000', '0011', '1000', '0011', '0100', '0011', '1100', '0011', '0010', '0011', '1010', '0011', '0110', '0011', '1110', '0011', '0001', '0011', '1001', '0011', '0101', '0011', '1101', '0011', '0011', '0011', '1011', '0011', '0111', '0011', '1111', '1011', '0000', '1011', '1000', '1011', '0100', '1011', '1100', '1011', '0010', '1011', '1010', '1011', '0110', '1011', '1110', '1011', '0001', '1011', '1001', '1011', '0101', '1011', '1101', '1011', '0011', '1011', '1011', '1011', '0111', '1011', '1111', '0111', '0000', '0111', '1000', '0111', '0100', '0111', '1100', '0111', '0010', '0111', '1010', '0111', '0110', '0111', '1110', '0111', '0001', '0111', '1001', '0111', '0101', '0111', '1101', '0111', '0011', '0111', '1011', '0111', '0111', '0111', '1111', '1111', '0000', '1111', '1000', '1111', '0100', '1111', '1100', '1111', '0010', '1111', '1010', '1111', '0110', '1111', '1110', '1111', '0001', '1111', '1001', '1111', '0101', '1111', '1101', '1111', '0011', '1111', '1011', '1111', '0111', '1111', '1111'
	
	align 16
	Cmpi_tbl db 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 97, 98, 99,100,101,102,103,104,105,106,107,108,109,110,111, 112,113,114,115,116,117,118,119,120,121,122, 91, 92, 93, 94, 95, 96, 97, 98, 99,100,101,102,103,104,105,106,107,108,109,110,111, 112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127, 128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143, 144,145,146,147,148,149,150,151,152,153,154,155,156,156,158,159, 160,161,162,163,164,165,166,167,168,169,170,171,172,173,173,175, 176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191, 192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207, 208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223, 224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239, 240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255
	
	align 16
	oneDiv1Dot3 dq 0.76923076923076916
	
	align 16
	hex_table dw '00', '10', '20', '30', '40', '50', '60', '70', '80', '90', 'A0', 'B0', 'C0', 'D0', 'E0', 'F0', '01', '11', '21', '31', '41', '51', '61', '71', '81', '91', 'A1', 'B1', 'C1', 'D1', 'E1', 'F1', '02', '12', '22', '32', '42', '52', '62', '72', '82', '92', 'A2', 'B2', 'C2', 'D2', 'E2', 'F2', '03', '13', '23', '33', '43', '53', '63', '73', '83', '93', 'A3', 'B3', 'C3', 'D3', 'E3', 'F3', '04', '14', '24', '34', '44', '54', '64', '74', '84', '94', 'A4', 'B4', 'C4', 'D4', 'E4', 'F4', '05', '15', '25', '35', '45', '55', '65', '75', '85', '95', 'A5', 'B5', 'C5', 'D5', 'E5', 'F5', '06', '16', '26', '36', '46', '56', '66', '76', '86', '96', 'A6', 'B6', 'C6', 'D6', 'E6', 'F6', '07', '17', '27', '37', '47', '57', '67', '77', '87', '97', 'A7', 'B7', 'C7', 'D7', 'E7', 'F7', '08', '18', '28', '38', '48', '58', '68', '78', '88', '98', 'A8', 'B8', 'C8', 'D8', 'E8', 'F8', '09', '19', '29', '39', '49', '59', '69', '79', '89', '99', 'A9', 'B9', 'C9', 'D9', 'E9', 'F9', '0A', '1A', '2A', '3A', '4A', '5A', '6A', '7A', '8A', '9A', 'AA', 'BA', 'CA', 'DA', 'EA', 'FA', '0B', '1B', '2B', '3B', '4B', '5B', '6B', '7B', '8B', '9B', 'AB', 'BB', 'CB', 'DB', 'EB', 'FB', '0C', '1C', '2C', '3C', '4C', '5C', '6C', '7C', '8C', '9C', 'AC', 'BC', 'CC', 'DC', 'EC', 'FC', '0D', '1D', '2D', '3D', '4D', '5D', '6D', '7D', '8D', '9D', 'AD', 'BD', 'CD', 'DD', 'ED', 'FD', '0E', '1E', '2E', '3E', '4E', '5E', '6E', '7E', '8E', '9E', 'AE', 'BE', 'CE', 'DE', 'EE', 'FE', '0F', '1F', '2F', '3F', '4F', '5F', '6F', '7F', '8F', '9F', 'AF', 'BF', 'CF', 'DF', 'EF', 'FF'
	
	align 16
	zeroDot01 dq 0.01
	
	align 16
	ctbl db true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, true, true, false, true, false, false, true, true, true, true, true, true, true, true, true, true, true, false, false, false, false, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false, true, false, true, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false
	
	align 16
	szCmpi_tbl db 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 46, 45, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, -128, -127, -126, -125, -124, -123, -122, -121, -120, -119, -118, -117, -116, -115, -114, -113, -112, -111, -110, -109, -108, -107, -106, -105, -104, -103, -102, -101, -100, -100, -98, -97, -96, -95, -94, -93, -92, -91, -90, -89, -88, -87, -86, -85, -84, -83, -83, -81, -80, -79, -78, -77, -76, -75, -74, -73, -72, -71, -70, -69, -68, -67, -66, -65, -64, -63, -62, -61, -60, -59, -58, -57, -56, -55, -54, -53, -52, -51, -50, -49, -48, -47, -46, -45, -44, -43, -42, -41, -40, -39, -38, -37, -36, -35, -34, -33, -32, -31, -30, -29, -28, -27, -26, -25, -24, -23, -22, -21, -20, -19, -18, -17, -16, -15, -14, -13, -12, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1
	
segment .data align=16

	align 16
	nrandomSeed dd 12345678
	
segment .text align=16

_a2dw:
	multipush ebx, edi, esi
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
	multipop ebx, edi, esi
	ret
	
	
	
	
	
	align 16
_arr2mem:
	multipush ebp, edi, esi, ebx
	mov ebp, 1
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
	multipop ebp, edi, esi, ebx
	ret
	
	
	
	
	
_arr2text:
	multipush ebp, edi, esi, ebx
	xor ebp, ebp
	mov edi, 1
	sub esp, 24
	mov ebx, [esp + 48]
	
	push dword [esp + 44]
	call _arrcnt
	add esp, 16
	mov esi, eax
	
.loop:
	sub esp, 8
	multipush edi, dword [esp + 44]
	inc edi
	call _arrget
	
	add esp, 12
	multipush ebp, eax, ebx
	call _szappend
	
	mov edx, 0x0A0D
	add esp, 16
	mov [ebx + eax], dx
	lea ebp, [eax + 2]
	cmp esi, edi
	jge .loop
	
	add esp, 12
	mov eax, esi
	multipop ebp, edi, esi, ebx
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
	multipush esi, edi
	
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
	
	multipop esi, edi
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
	multipush ebp, edi, esi, ebx
	mov eax, -2
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
	multipop ebp, edi, esi, ebx
	ret
	
	
	
	
	
_BinSearch:
	multipush ebp, ebx, edi, esi
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
	multipop ebp, ebx, edi, esi
	ret
	
	
	
	
	
	align 16
_Cmpi:
	multipush ebx, edi, esi
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
	multipop ebx, edi, esi
	ret
	
	
	
	
	
	align 16
_cmpmem:
	multipush ebp, ebx, edi, esi
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
	multipop ebp, ebx, edi, esi
	ret
	
	
	
	
	
_CombSortA:
	multipush ebp, edi, esi, ebx
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
	multipop ebp, edi, esi, ebx
	ret
	
	
	
	
	
_CombSortD:
	multipush ebp, edi, esi, ebx
	sub esp, 20
	fnstsw [esp + 14]
	mov eax, [esp + 44]
	mov ebp, [esp + 40]
	dec eax
	mov [esp + 8], eax
	movzx eax, word [esp + 14]
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
	
.loop2:
	mov ecx, [ebp + eax * 4]
	mov edx, [ebx + eax * 4]
	
	cmp ecx, edx
	jge .greaterEqual
	
	mov [ebx + eax * 4], ecx
	inc esi
	mov [ebp + eax * 4], edx
	
.greaterEqual:
	inc eax
	
	cmp eax, edi
	jle .loop2
	
	test esi, esi
	jg .loop
	
	cmp byte [esp + 7], 0
	je .loop
	
	add esp, 20
	multipop ebp, edi, esi, ebx
	ret
	
	
	
	
	
_decomment:
	push ebx
	mov ecx, [esp + 8]
	xor ebx, ebx
	mov edx, -1
	
.loop:
	inc edx
	movzx eax, byte [ecx + edx]
	
	cmp al, 9
	je .loop
	
	cmp al, 32
	je .loop
	
	test al, al
	je .return
	
	cmp al, 34
	je .equal34
	
	cmp al, 39
	je .equal39
	
	cmp al, 59
	je .equal59
	
.continue:
	mov ebx, edx
	jmp .loop
	
	align 16
.thingo:
	cmp al, 34
	je .continue
	
.equal34:
	inc edx
	movzx eax, byte [ecx + edx]
	test al, al
	jne .return
	
	mov eax, -1
	
.return:
	pop ebx
	ret
	
	align 16
.thingo2:
	cmp al, 39
	je .continue
	
.equal39:
	inc edx
	movzx eax, byte [ecx + edx]
	test al, al
	jne .thingo2
	
	mov eax, -1
	jmp .return
	
	align 16
.equal59:
	movzx edx, byte [ecx + ebx]
	mov byte [ecx + ebx + 1], 0
	mov eax, 1
	
	cmp dl, 44
	je .return
	
	cmp dl, 92
	pop ebx
	sete al
	ret
	
	
	
	
	
_dissort:
	multipush esi, edi, ebx, ebp
	
	cmp dword [esp + 24], 1
	jle .return
	
	mov edi, [esp + 20]
	xor esi, esi
	inc esi
	
.loop:
	mov ebp, [edi + esi * 4]
	mov ebx, esi
	
.loop2:
	xor edx, edx
	dec edx
	mov ecx, [edi + ebx * 4 - 4]
	
.loop3:
	inc edx
	mov al, [edx + ecx]
	cmp al, [edx + ebp]
	jg .greater
	jge .greaterEqual
	
	mov [edi + ebx * 4], ecx
	dec ebx
	
	jne .loop2
	jmp .greater
	
	align 16
.greaterEqual:
	test al, al
	jne .loop3
	
.greater:
	inc esi
	mov [edi + ebx * 4], ebp
	cmp esi, [esp + 24]
	jl .loop
	
.return:
	multipop esi, edi, ebx, ebp
	ret
	
	
	
	
	
	align 16
_dw2ah:
	push ebx
	mov eax, [esp + 12]
	mov ecx, [esp + 8]
	
	lea edx, [eax + 7]
	mov word [eax + 8], 72
	
.loop:
	mov ebx, ecx
	and ebx, 0xF
	
	cmp ebx, 9
	ja .above
	
	or bl, 48
	jmp .skip
	
	align 16
.above:
	add bl, 55
	
.skip:
	mov [edx], bl
	dec edx
	
	ror ecx, 4
	
	cmp edx, eax
	jae .loop
	
	pop ebx
	ret
	
	
	
	
	
	align 16
_dw2bin_ex:
	movzx edx, byte [esp + 7]
	mov eax, [esp + 8]
	movq xmm0, [bintable + edx * 8]
	movzx edx, byte [esp + 6]
	movq [eax], xmm0
	
	mov byte [eax + 32], 0
	
	mov ecx, [bintable + edx * 8]
	mov [eax + 8], ecx
	
	mov ecx, [bintable + edx * 8 + 4]
	mov [eax + 12], ecx
	
	movzx ecx, byte [esp + 5]
	mov edx, [bintable + ecx * 8]
	mov [eax + 16], edx
	
	mov edx, [bintable + ecx * 8 + 4]
	mov [eax + 20], edx
	
	movzx edx, byte [esp + 4]
	mov ecx, [bintable + edx * 8]
	mov [eax + 24], ecx
	
	mov ecx, [bintable + edx * 8 + 4]
	mov [eax + 28], ecx
	
	ret
	
	
	
	
	
	align 16
_dw2hex_ex:
	sub esp, 12
	
	movzx edx, byte [esp + 16]
	mov eax, [esp + 20]
	mov ecx, [hex_table + edx * 2]
	
	movzx edx, byte [esp + 17]
	shl ecx, 16
	mov [esp], ecx
	
	movzx ecx, word [hex_table + edx * 2]
	mov [esp], cx
	
	movzx ecx, byte [esp + 18]
	mov edx, [esp]
	mov [esp + 4], edx
	
	mov edx, [hex_table + ecx * 2]
	movzx ecx, byte [esp + 19]
	shl edx, 16
	mov [esp], edx
	
	movzx edx, word [hex_table + ecx * 2]
	mov [esp], dx
	
	mov ecx, [esp]
	mov [eax], ecx
	
	mov byte [eax + 8], 0
	
	add esp, 12
	ret
	
	
	
	
	
_dwtoa:
	multipush ebp, ebx, edi, esi
	mov ebp, [esp + 20]
	mov esi, [esp + 24]
	
	test ebp, ebp
	je .val0
	jns .valNotNeg
	
	mov byte [esi], 45
	neg ebp
	inc esi
	
.valNotNeg:
	mov ebx, 0x66666667
	mov edi, esi
	
.loop:
	mov eax, ebp
	mov ebx, ebp
	add ebp, 9
	
	imul ebx

	mov eax, edx
	sar edx, 2
	shr eax, 31
	add edx, eax
	
	lea eax, [edx + edx]
	lea eax, [eax + eax * 4]
	sub ecx, eax
	add cl, 48
	mov [edi], cl
	inc edi
	
	cmp ebp, 18
	mov ebp, edx
	ja .loop
	
	cmp esi, edi
	mov byte [edi], 0
	jae .return
	
.reverseLoop:
	movzx eax, byte [edi]
	movzx ecx, byte [esi]
	mov [edi], cl
	mov [esi], al
	inc esi
	
	cmp esi, edi
	lea edi, [edi - 1]
	jb .reverseLoop
	jmp .return
	
	align 16
.val0:
	mov word [esi], 48
	
.return:
	multipop ebp, ebx, edi, esi
	ret
	
	
	
	
	
	align 16
_get_line_count:
	push ebx
	mov eax, [esp + 12]
	mov ecx, [esp + 16]
	movzx edx, byte [ecx + eax - 2]
	cmp edx, 0xA0D
	je .notEnd
	
	mov word [ecx + eax], 0xA0D
	mov byte [ecx + eax + 2], 0
	
.notEnd:
	xor eax, eax
	mov edx, -1
	jmp .startLoop
	
	align 16
.loop:
	inc edx
	cmp bl, 10
	jne .notEOL
	
	inc eax
	
.notEOL:
.startLoop:
	movzx ebx, byte [ecx + edx + 1]
	test bl, bl
	jne .loop
	
	pop ebx
	ret
	
	
	
	
	
	align 16
_get_ml:
	multipush ebp, ebx, edi, esi
	sub esp, 12
	mov eax, [esp + 40]
	mov ebx, [esp + 32]
	mov esi, [esp + 36]
	multizero edx, ebp
	
	lea edi, [ebx + eax]
	jmp .checkEnd
	
	align 16
.leadTrim:
	mov eax, ebp
	inc ebp
	
	cmp cl, 32
	jne .checkEnd
	
	cmp cl, 59
	jne .notEq59
	
.loop:
	movzx eax, byte [edi + ebp]
	
	test al, al
	je .ret0
	
	inc ebp
	cmp al, 10
	jne .loop
	
.checkEnd:
	mov cl, [edi + ebp]
	test cl, cl
	jne .leadTrim
	
.ret0:
	xor eax, eax
	
.return:
	mov byte [esi + edx], 0
	add esp, 12
	multipop ebp, ebx, edi, esi
	ret
	
	align 16
.notEq59:
	mov ecx, [esp + 40]
	xor edx, edx
	
	mov dword [esp], 0
	mov dword [esp + 4], 0
	
	lea ecx, [ebx + ecx + 1]
	mov [esp + 8], ecx
	jmp .startMainLoop
	
	align 16
.mainLoop:
	mov ecx, [esp + 4]
	mov ebp, [esp]
	
	cmp bl, 32
	mov [esi + edx], bl
	cmovg ecx, eax
	cmovg ebp, edx
	inc edx
	
	mov [esp + 4], ecx
	mov [esp], ebp
	
.startMainLoop:
	mov bl, [edi + eax]
	mov ebp, eax
	
.mainText:
	lea eax, [ebp + 1]
	movzx ecx, bl
	cmp bl, 59
	ja .mainLoop
	jmp dword [.jumpTable + ecx * 4]
	
	align 16
%macro getMlMakeCharLoop 3
.%1:
	mov byte [esi + edx], %3
	inc edx
	
.%2:
	movzx ebx, byte [edi + eax]
	mov [esi + edx], bl
	inc edx
	
	test bl, bl
	je .retMin1
	
	cmp bl, 10
	je .retMin1
	
	inc eax
	cmp bl, %3
	jne .%2
	jmp .afterCharLoop

%endmacro
	
	getMlMakeCharLoop startQuoteLoop, quoteLoop, 34
	getMlMakeCharLoop startApostropheLoop, apostropheLoop, 39
	
.startLoop2:
	mov ecx, [esp + 8]
	
.loop2:
	movzx eax, byte [ecx + ebp]
	inc ebp
	cmp al, 10
	je .gotEndLine
	
	test al, al
	jne .loop2
	jmp .ret0
	
	align 16
.gotEndLine:
	mov eax, ebp
	
.newLine:
	mov ecx, [esp + 4]
	mov cl, [edi + ecx - 1]
	
	cmp cl, 44
	je .afterCharLoop
	
	cmp cl, 92
	jne .not92
	
	mov ecx, [esp]
	mov dword [esp], 0
	mov byte [esi + ecx], 32
	
.afterCharLoop:
	dec eax
	mov ebp, eax
	
.loop3:
	movzx ebx, byte [edi + ebp + 1]

	test bl, bl
	je .ret0
	
	inc ebp
	cmp bl, 32
	jle .loop3
	jmp .mainText
	
	align 16
.retMin1:
	mov eax, -1
	jmp .return
	
	align 16
.not92:
	add eax, [esp + 40]
	jmp .return
	
	align 16
.jumpTable:
	dd .ret0, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .newLine, .mainLoop, .mainLoop, .startMainLoop, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .startQuoteLoop, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .startApostropheLoop, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .mainLoop, .startLoop2
	
	
	
	
	
	align 16
_GetPercent:
	cvtsi2sd xmm1, [esp + 4]
	cvtsi2sd xmm0, [esp + 8]
	mulsd xmm1, [zeroDot01]
	mulsd xmm1, xmm0
	cvttsd2si eax, xmm1
	ret
	
	
	
	
	
	align 16
_GetPathOnly:
	multipush ebx, esi
	mov ecx, [esp + 16]
	mov esi, [esp + 12]
	xor eax, eax
	mov edx, 1
	
	mov bl, [esi + edx - 1]
	cmp bl, 92
	jne .test0
	jmp .startLoop
	
	align 16
.loop:
	mov [ecx + edx - 1], bl
	inc edx
	
	mov bl, [esi + edx - 1]
	cmp bl, 92
	je .startLoop
	
.test0:
	test bl, bl
	jne .loop
	jmp .return
	
	align 16
.startLoop:
	mov eax, edx
	jmp .loop
	
	align 16
.return:
	mov byte [ecx + eax], 0
	multipop ebx, esi
	ret
	
	
	
	
	
	align 16
_htodw:
	multipush ebp, edi, esi, ebx
	mov ebx, [esp + 20]
	mov eax, ebx
	
.findEnd:
	inc eax
	cmp byte [eax - 1], 0
	jne .findEnd
	
	mov edi, ebx
	sub edi, eax
	mov eax, edi
	
	xor eax, -1
	mov ebp, eax
	je .return
	lea ecx, [eax * 4 - 4]
	
	multizero esi, ebp
	
.loop:
	movzx edx, byte [ebx]
	
	cmp dl, 64
	jle .skip
	
	xor eax, eax
	cmp dl, 86
	setle al
	
	mov edi, eax
	mov eax, esi
	movsx esi, al
	add esi, edi
	sal esi, 5
	
	lea edx, [esi + edx - 87]
	
.skip:
	and edx, 0xF
	inc ebx
	sal edx, cl
	sub ecx, 4
	add ebp, edx
	
	cmp ecx, -4
	jne .loop
	
.return:
	mov eax, ebp
	multipop ebp, edi, esi, ebx
	ret
	
	
	
	
	
	align 16
_InString:
	multipush ebp, ebx, edi, esi
	sub esp, 12
	mov edi, [esp + 40]
	mov eax, [esp + 36]
	mov ebp, [esp + 32]
	mov ebx, eax
	
	mov [esp], eax
	call _strlen
	mov esi, eax
	
	mov [esp], edi
	call _strlen
	
	mov ecx, -2
	
	test ebp, ebp
	jle .return
	
	mov ecx, -1
	
	sub esi, eax
	jle .return
	
	lea edx, [esi + 1]
	mov ecx, -2
	
	cmp edx, ebp
	jl .return
	
	lea edi, [ebp - 2]
	sub edi, esi
	
	mov ecx, [esp + 40]
	mov cl, [ecx]
	mov [esp + 7], cl
	
	lea esi, [ebx + ebp]
	add esi, -2
	
	add ebx, edx
	
	mov [esp + 8], ebx
	jmp .startLoop
	
	align 16
.loop:
	inc edi
	inc esi
	
.startLoop:
	mov ebp, eax
	mov ebx, [esp + 8]
	mov cl, [esp + 7]
	
	cmp cl, [ebx + edi]
	mov ecx, [esp + 40]
	jne .checkEnd
	
.loop2:
	mov ebx, edx
	movzx edx, byte [esi + ebp]
	cmp dl, [ecx + ebp - 1]
	mov edx, ebx
	jne .loop
	
	add ebp, -1
	jne .loop2
	jmp .finish
	
	align 16
.checkEnd:
	cmp edi, -2
	jle .loop
	
	xor ecx, ecx
	jmp .return
	
	align 16
.finish:
	lea ecx, [edi + edx]
	inc ecx
	
.return:
	mov eax, ecx
	add esp, 12
	multipop ebp, ebx, edi, esi
	ret
	
	
	
	
	
	align 16
_IntDiv:
	sub esp, 12
	
	fild dword [esp + 16]
	fnstcw word [esp + 6]
	fild dword [esp + 20]
	fdivp st1, st0
	
	movzx eax, word [esp + 6]
	or ah, 0xC
	
	mov [esp + 4], ax
	fldcw word [esp + 4]
	fistp dword [esp]
	fldcw word [esp + 6]
	mov eax, [esp]
	
	add esp, 12
	ret
	
	
	
	
	
	align 16
_IntDivSSE2:
	cvtsi2sd xmm0, [esp + 4]
	cvtsi2sd xmm1, [esp + 8]
	divsd xmm0, xmm1
	cvttsd2si eax, xmm0
	ret
	
	
	
	
	
	align 16
_IntMul:
	sub esp, 12
	
	fnstcw word [esp + 6]
	fild dword [esp + 16]
	fild dword [esp + 20]
	fmulp st1, st0
	
	movzx eax, word [esp + 6]
	or ah, 0xC
	
	mov [esp + 4], ax
	fldcw word [esp + 4]
	fistp dword [esp]
	fldcw word [esp + 6]
	mov eax, [esp]
	
	add esp, 12
	ret
	
	
	
	
	
	align 16
_IntMulSSE2:
	cvtsi2sd xmm0, [esp + 4]
	cvtsi2sd xmm1, [esp + 8]
	mulsd xmm1, xmm0
	cvttsd2si eax, xmm1
	ret
	
	
	
	
	
	align 16
_IntSqrt:
	sub esp, 12
	
	fild dword [esp + 16]
	fnstcw word [esp + 6]
	fsqrt
	
	movzx eax, word [esp + 6]
	or ah, 0xC
	
	mov [esp + 4], ax
	fldcw word [esp + 4]
	fistp dword [esp]
	fldcw word [esp + 6]
	mov eax, [esp]
	
	add esp, 12
	ret
	
	
	
	
	
	align 16
_IntSqrtSSE2:
	cvtsi2sd xmm0, [esp + 4]
	sqrtsd xmm0, xmm0
	cvttsd2si eax, xmm0
	ret
	
	
	
	
	
	align 16
_isalpha:
	mov edx, [esp + 4]
	xor eax, eax
	lea ecx, [edx - 65]
	cmp cl, 57
	ja .return
	
	mov eax, 1
	cmp dl, 90
	jle .return
	
	xor eax, eax
	cmp dl, 96
	setg al
	
	add eax, eax
	
.return:
	ret
	
	
	
	
	
	align 16
_isalphanum:
	mov edx, [esp + 4]
	xor eax, eax
	
	cmp dl, 47
	jle .return
	
	mov eax, 1
	cmp dl, 57
	jle .return
	
	xor eax, eax
	cmp dl, 64
	jle .return
	
	mov eax, 2
	cmp dl, 90
	jle .return
	
	sub edx, 97
	cmp dl, 26
	sbb eax, eax
	and eax, 3
	
.return:
	ret
	
	
	
	
	
	align 16
_islower:
	mov al, [esp + 4]
	add al, -97
	cmp al, 26
	setb al
	ret
	
	
	
	
	
	align 16
_isnumber:
	mov al, [esp + 4]
	add al, -48
	cmp al, 10
	setb al
	ret
	
	
	
	
	
	align 16
_isupper:
	mov al, [esp + 4]
	add al, -65
	cmp al, 26
	setb al
	ret
	
	
	
	
	
	align 16
_lfcnt:
	mov ecx, [esp + 4]
	dec ecx
	xor eax, eax
	jmp .startLoop
	
	align 16
.loop:
	inc ecx
	cmp dl, 10
	jne .startLoop
	
	inc eax
	
.startLoop:
	movzx edx, byte [ecx + 1]
	test dl, dl
	jne .loop
	
	ret
	
	
	
	
	
	align 16
_MemCopy:
	mov eax, [esp + 8]
	mov edx, [esp + 4]
	
	mov [esp + 4], eax
	mov [esp + 8], edx
	jmp _memcpy
	
	
	
	
	
	align 16
_memfill:
	mov eax, [esp + 12]
	mov edx, [esp + 8]
	mov [esp + 8], eax
	mov [esp + 12], edx
	jmp _memset
	
	
	
	
	
	align 16
_NameFromPath:
	push ebx
	sub esp, 8
	mov ebx, [esp + 16]
	
	movzx edx, byte [ebx]
	test dl, dl
	je .retMin1
	
	mov ecx, ebx
	xor eax, eax
	
.loop:
	cmp dl, 92
	cmove ecx, eax
	
	inc eax
	movzx edx, byte [ebx + eax]
	test dl, dl
	jne .loop
	
	cmp ebx, ecx
	je .retMin1
	
	sub esp, 8
	lea eax, [ebx + ecx + 1]
	multipush eax, dword [esp + 32]
	call _strcpy
	add esp, 16
	
	xor eax, eax
	
	add esp, 8
	pop ebx
	ret
	
	align 16
.retMin1:
	add esp, 8
	mov eax, -1
	pop ebx
	ret
	
	
	
	
	
	align 16
_nrandom:
	mov eax, [nrandomSeed]
	mov edx, 0x69C16BD
	lea ecx, [eax + 0x7FFFFFFF]
	test eax, eax
	cmovns ecx, eax
	
	mov eax, ecx
	mul edx
	
	mov eax, ecx
	sub eax, edx
	shr eax, 1
	add eax, edx
	shr eax, 16
	imul edx, eax, 127773
	imul eax, eax, -2836
	sub ecx, edx
	imul ecx, ecx, 16807
	add eax, ecx
	mov [nrandomSeed], eax
	
	xor edx, edx
	div dword [esp + 4]
	mov eax, edx
	ret
	
	
	
	
	
	align 16
_nseed:
	mov eax, [esp + 4]
	mov [nrandomSeed], eax
	ret
	
	
	
	
	
	align 16
_parse_line:
	multipush ebx, esi
	xor eax, eax
	mov ecx, [esp + 16]
	mov edx, [esp + 12]
	
.badChar:
	mov esi, [ecx]
	
.loop:
	movsx ebx, byte [edx]
	test ebx, ebx
	je .gaOut
	
	inc edx
	cmp byte [ctbl + ebx], true
	jne .loop
	
	inc eax
	
.loop2:
	cmp bl, 34
	je .gotQuote
	
	cmp bl, 91
	je .wsqb
	
	mov [esi], bl
	movsx ebx, byte [edx]
	inc esi
	test ebx, ebx
	je .gaOut
	
	inc edx
	cmp byte [ctbl + ebx], false
	jne .loop2
	
.reIndex:
	mov byte [esi], 0
	add ecx, 4
	jmp .badChar
	
	align 16
.wsqb:
	mov [esi], bl
	inc esi
	
	cmp bl, 93
	je .reIndex
	
.loop4:
	mov bl, [edx]
	inc edx
	
	cmp bl, 32
	je .loop4
	
	test bl, bl
	jne .wsqb
	jmp .return
	
	align 16
.gotQuote:
	mov byte [esi], 34
	inc esi
	
.loop5:
	mov bl, [edx]
	test bl, bl
	je .return
	
	inc edx
	
	mov [esi], bl
	inc esi
	
	cmp bl, 34
	jne .loop5
	jmp .reIndex
	
	align 16
.gaOut:
	xor edx, edx
	mov [esi], dl
	mov ecx, [ecx + 4]
	mov [ecx], dl
	
.return:
	multipop ebx, esi
	ret
	
	
	
	
	
	align 16
_partial:
	multipush esi, edi, ebx, ebp
	sub esp, 28
	
	mov edx, [esp + 48]
	mov eax, [esp + 52]
	mov ebp, [esp + 56]
	
	add esp, 4
	push ebp
	lea edi, [eax + edx]
	call _strlen
	
	add esp, 4
	mov ebx, eax
	push edi
	call _strlen
	
	movsx ecx, byte [ebp]
	xor edx, edx
	mov [esp + 20], edx
	
	cmp ecx, 42
	jne .skipLoop
	
.loop:
	inc ebp
	inc edx
	movsx ecx, byte [ebp]
	cmp ecx, 42
	je .loop
	
	mov [esp + 28], edx
	
.skipLoop:
	sub eax, ebx
	sub ebx, edx
	mov [esp + 16], edi
	dec ebx
	lea esi, [edi + edx - 1]
	add edx, esi
	add eax, edx
	
.mainLoop:
	inc esi
	cmp cl, [esi]
	je .skipLoop2
	
.loop2:
	cmp esi, eax
	jg .retMin1
	
	inc esi
	cmp cl, [esi]
	jne .loop2
	
.skipLoop2:
	test ebx, ebx
	js .return
	
	xor edi, edi
	
.loop3:
	movsx edx, byte [edi + ebp]
	
	cmp edx, 42
	je .skip
	
	cmp dl, [edi + esi]
	jne .mainLoop
	
.skip:
	inc edi
	cmp edi, ebx
	jle .loop3
	
.return:
	mov edi, [esp + 16]
	mov eax, [esp + 48]
	sub eax, edi
	sub eax, [esp + 20]
	add eax, esi
	
	add esp, 28
	multipop esi, edi, ebx, ebp
	ret
	
.retMin1:
	mov eax, -1
	add esp, 28
	multipop esi, edi, ebx, ebp
	ret
	
	
	
	
	
	align 16
_RolData:
	multipush ebp, edi, esi, ebx
	
	mov esi, [esp + 28]
	mov edi, [esp + 32]
	mov eax, [esp + 20]
	movzx ecx, byte [esi]
	add edi, esi
	mov esi, [esp + 24]
	mov ebx, [esp + 28]
	add esi, eax
	
.loop:
	movzx edx, byte [eax]
	and cl, 7
	lea ebp, [ebx + 1]
	rol dl, cl
	movzx ecx, byte [ebx + 1]
	
	cmp ebp, edi
	je .pcntEqKeyPlusKeyLen
	
	inc eax
	mov [eax - 1], dl
	
	cmp eax, esi
	je .return
	
	mov ebx, ebp
	jmp .loop
	
	align 16
.return:
	multipop ebp, edi, esi, ebx
	ret
	
	align 16
	
.pcntEqKeyPlusKeyLen:
	mov ebx, [esp + 28]
	inc eax
	movzx ecx, byte [ebx]
	mov [eax - 1], dl
	
	cmp eax, esi
	je .return
	
	mov ebp, ebx
	mov ebx, ebp
	jmp .loop
	
	
	
	
	
	align 16
_RorData:
	multipush ebp, edi, esi, ebx
	
	mov esi, [esp + 28]
	mov edi, [esp + 32]
	mov eax, [esp + 20]
	movzx ecx, byte [esi]
	add edi, esi
	mov esi, [esp + 24]
	mov ebx, [esp + 28]
	add esi, eax
	
.loop:
	movzx edx, byte [eax]
	and cl, 7
	lea ebp, [ebx + 1]
	ror dl, cl
	movzx ecx, byte [ebx + 1]
	
	cmp ebp, edi
	je .pcntEqKeyPlusKeyLen
	
	inc eax
	mov [eax - 1], dl
	
	cmp eax, esi
	je .return
	
	mov ebx, ebp
	jmp .loop
	
	align 16
.return:
	multipop ebp, edi, esi, ebx
	ret
	
	align 16
	
.pcntEqKeyPlusKeyLen:
	mov ebx, [esp + 28]
	inc eax
	movzx ecx, byte [ebx]
	mov [eax - 1], dl
	
	cmp eax, esi
	je .return
	
	mov ebp, ebx
	mov ebx, ebp
	jmp .loop
	
	
	
	
	
	align 16
initShiftTable:
	multipush esi, edi
	xor eax, eax
	mov esi, [esp + 12]
	mov edx, [esp + 16]
	mov ecx, [esp + 20]
	
.memsetLp:
	mov [esi + eax * 4], edx
	inc eax
	cmp eax, 64
	jb .memsetLp
	
	mov edx, [esp + 24]
	mov eax, [edx]
	
.shiftTableInitLp:
	movsx edi, byte [ecx]
	inc ecx
	
	mov [esi + edi * 4], eax
	dec eax
	mov [edx], eax
	
	jne .shiftTableInitLp
	
	multipop esi, edi
	ret
	
	
	
	
	
initShiftTableSSE2:
	multipush ebx, edi, esi
	mov eax, [esp + 28]
	mov ecx, [esp + 16]
	
	movd xmm0, [esp + 20]
	pshufd xmm0, xmm0, 0
	movdqu [ecx], xmm0
	movdqu [ecx + 16], xmm0
	movdqu [ecx + 32], xmm0
	movdqu [ecx + 48], xmm0
	movdqu [ecx + 64], xmm0
	movdqu [ecx + 80], xmm0
	movdqu [ecx + 96], xmm0
	movdqu [ecx + 112], xmm0
	movdqu [ecx + 128], xmm0
	movdqu [ecx + 144], xmm0
	movdqu [ecx + 160], xmm0
	movdqu [ecx + 176], xmm0
	movdqu [ecx + 192], xmm0
	movdqu [ecx + 208], xmm0
	movdqu [ecx + 224], xmm0
	movdqu [ecx + 240], xmm0
	mov edx, [esp + 24]
	mov esi, [eax]
	
.loop:
	movsx edi, byte [edx]
	inc edx
	
	lea ebx, [esi - 1]
	mov [eax], ebx
	mov [ecx + edi * 4], esi
	
	mov esi, [eax]
	test esi, esi
	jne .loop
	
	multipop ebx, edi, esi
	ret
	
	
	
	
	
	align 16
initShiftTableAVX2:
	multipush ebx, edi, esi
	mov eax, [esp + 28]
	mov ecx, [esp + 16]
	
	vbroadcastss ymm0, [esp + 20]
	vmovups [ecx], ymm0
	vmovups [ecx + 32], ymm0
	vmovups [ecx + 64], ymm0
	vmovups [ecx + 96], ymm0
	vmovups [ecx + 128], ymm0
	vmovups [ecx + 160], ymm0
	vmovups [ecx + 192], ymm0
	vmovups [ecx + 224], ymm0
	mov edx, [esp + 24]
	mov esi, [eax]
	
.loop:
	movsx edi, byte [edx]
	inc edx
	
	lea ebx, [esi - 1]
	mov [eax], ebx
	mov [ecx + edi * 4], esi
	
	mov esi, [eax]
	test esi, esi
	jne .loop
	
	multipop ebx, edi, esi
	vzeroupper
	ret
	
	
	
	
	
	align 16
initShiftTableAVX512F:
	multipush ebx, edi, esi
	mov eax, [esp + 28]
	mov ecx, [esp + 16]
	
	vbroadcastss zmm0, [esp + 20]
	vmovups [ecx], zmm0
	vmovups [ecx + 64], zmm0
	vmovups [ecx + 128], zmm0
	vmovups [ecx + 192], zmm0
	mov edx, [esp + 24]
	mov esi, [eax]
	
.loop:
	movsx edi, byte [edx]
	inc edx
	
	lea ebx, [esi - 1]
	mov [eax], ebx
	mov [ecx + edi * 4], esi
	
	mov esi, [eax]
	test esi, esi
	jne .loop
	
	multipop ebx, edi, esi
	vzeroupper
	ret
	
	
	
	
	
	align 16
_SBMBinSearch:
	multipush ebp, edi, esi, ebx
	sub esp, 1052
	
	mov ebp, [esp + 1088]
	mov edi, [esp + 1084]
	
	cmp ebp, 1
	jle .retMin2
	
	lea eax, [esp + 12]
	lea ebx, [ebp - 1]
	mov [esp + 12], ebx
	
	multipush eax, edi, ebp
	lea eax, [esp + 28]
	push eax
	call initShiftTable
	
	mov eax, [esp + 1092]
	mov edx, [esp + 28]
	add eax, [esp + 1088]
	add esp, 16
	
	mov ecx, [esp + 1080]
	sub ecx, ebp
	add ecx, [esp + 1076]
	mov esi, ecx
	
.loop:
	movsx ecx, byte [eax + edx]
	cmp [edi + edx], cl
	jne .break
	
	dec edx
	jns .loop
	
	sub eax, [esp + 1076]
	add esp, 1052
	
	multipop ebp, edi, esi, ebx
	ret
	
	align 16
.break:
	add edx, [esp + 16 + ecx * 4]
	
	sub edx, ebx
	mov ecx, 1
	cmovs edx, ecx
	
	add eax, edx
	cmp eax, esi
	jg .retMin1
	
	movsx edx, byte [eax + ebx]
	movzx ecx, byte [edi + ebx]
	cmp dl, cl
	jne .startLoop2
	jmp .currentCharIsSubstrSubStrLenMin1v2
	
	align 16
.loop2:
	movsx edx, byte [edx + ebx]
	cmp dl, cl
	je .currentCharIsSubstrSubStrLenMin1v2
	
.startLoop2:
	add eax, [esp + 16 + edx * 4]
	mov edx, eax
	cmp eax, esi
	jle .loop2
	
.retMin1:
	mov eax, -1
	
.return:
	add esp, 1052
	multipop ebp, edi, esi, ebx
	ret
	
	align 16
.currentCharIsSubstrSubStrLenMin1v2:
	lea edx, [ebp - 2]
	jmp .loop
	
	align 16
.retMin2:
	mov eax, -2
	jmp .return
	
	
	
	
	
	align 16
_StripRangeI:
	push ebx
	mov eax, [esp + 12]
	mov ecx, [esp + 8]
	
	mov bl, [ecx]
	test bl, bl
	je .return
	
	mov dl, [esp + 20]
	mov dh, [esp + 16]

.loop:
	inc ecx
	cmp bl, dh
	jne .currentCharNotStartByte
	
.characterLoop:
	movzx ebx, byte [ecx]
	test bl, bl
	je .return
	
	inc ecx
	cmp bl, dl
	jne .characterLoop
	
	mov bl, [ecx]
	test bl, bl
	jne .loop
	jmp .return
	
	align 16
.currentCharNotStartByte:
	mov [eax], bl
	inc eax
	
	mov bl, [ecx]
	test bl, bl
	jne .loop
	
.return:
	mov byte [eax], 0
	pop ebx
	ret
	
	
	
	
	
	align 16
_StripLF:
	mov eax, [esp + 4]
	
.loop:
	movzx ecx, byte [eax]
	test cl, cl
	je .return
	
	inc eax
	cmp cl, 13
	jne .loop
	
	mov byte [eax - 1], 0
	
.return:
	ret
	
	
	
	
	
	align 16
_StripRangeX:
	push esi
	mov eax, [esp + 8]
	
	mov ch, [eax]
	
	test ch, ch
	je .return
	
	mov cl, [esp + 20]
	mov dl, [esp + 16]
	mov esi, [esp + 12]
	
.loop:
	inc eax
	cmp ch, dl
	jne .check
	
	mov [esi], dl
	
.loop2:
	mov ch, [eax]
	test ch, ch
	je .return
	
	inc eax
	cmp ch, cl
	jne .loop2
	
	mov [esi + 1], cl
	mov ch, [eax]
	
	add esi, 2
	
	test ch, ch
	jne .loop
	jmp .return
	
	align 16
.check:
	mov [esi], ch
	inc esi
	
	mov ch, [eax]
	test ch, ch
	jne .loop
	
.return:
	pop esi
	ret
	
	
	
	
	
	align 16
_szappend:
	push ebx
	mov ecx, [esp + 12]
	mov edx, [esp + 8]
	mov eax, [esp + 16]
	dec eax
	
.loop:
	movzx ebx, byte [ecx]
	mov [edx + eax + 1], bl
	
	inc eax
	inc ecx
	test bl, bl
	jne .loop
	
	pop ebx
	ret
	
	
	
	
	
	align 16
_szCmp:
	multipush ebx, esi
	mov ecx, -1
	mov edx, [esp + 16]
	mov esi, [esp + 12]
	
.loop:
	movzx ebx, byte [esi + ecx + 1]
	xor eax, eax
	cmp bl, [edx + ecx + 1]
	jne .return
	
	test bl, bl
	je .retEcxPlus1
	

%macro szCmpMakeIter 1-2
	movzx ebx, byte [esi + ecx + %1]
	cmp bl, [edx + ecx + %1]
	jne .return
	
%if %0 == 1
	add ecx, 4
	mov eax, ecx
%endif
	
	test bl, bl
%if %0 == 1
	jne .loop
%else
	je %2
%endif
%endmacro

	szCmpMakeIter 2, .recEcxPlus2
	szCmpMakeIter 3, .retEcxPlus3
	szCmpMakeIter 4
	
.return:
	multipop esi, ebx
	ret
	
	align 16
.retEcxPlus1:
	inc ecx
	mov eax, ecx
	multipop esi, ebx
	ret
	
	align 16
.recEcxPlus2:
	add ecx, 2
	mov eax, ecx
	multipop esi, ebx
	ret
	
	align 16
.retEcxPlus3:
	add ecx, 3
	mov eax, ecx
	multipop esi, ebx
	ret
	
	
	
	
	
	align 16
_szCmpi:
	multipush edi, esi, ebx
	xor eax, eax
	
	mov esi, [esp + 16]
	mov ebx, [esp + 20]
	mov edi, [esp + 24]
	
	jmp .startLoop
	
	align 16
.loop:
	cmp eax, edi
	jnb .ret0
	
.startLoop:
	movsx edx, byte [esi + eax]
	inc eax
	movsx ecx, byte [ebx + eax - 1]
	cmp [szCmpi_tbl + edx], cl
	je .loop
	
	multipop edi, esi, ebx
	ret
	
.ret0:
	xor eax, eax
	multipop edi, esi, ebx
	ret
	
	
	
	
	
	align 16
_szCopy:
	sub esp, 20
	multipush dword [esp + 24], dword [esp + 32]
	call _strcpy
	add esp, 28
	
	jmp _strlen
	
	
	
	
	
	align 16
_szLeft:
	multipush esi, ebx
	mov ebx, [esp + 20]
	mov eax, [esp + 16]
	
	mov edx, ebx
	lea esi, [eax + ebx]
	neg edx
	add ebx, [esp + 12]
	
.loop:
	movzx ecx, byte [ebx + edx]
	mov [esi + edx], cl
	
	inc edx
	jne .loop
	
	mov byte [esi], 0
	multipop esi, ebx
	ret
	
	
	
	
	
	align 16
_szLen:
	jmp _strlen
	
	
	
	
	
	align 16
_szLower:
	mov eax, [esp + 4]
	
	mov cl, [eax]
	test cl, cl
	je .return
	
	lea edx, [eax + 1]
	
.loop:
	mov ch, cl
	add ch, -65
	cmp ch, 25
	ja .skip
	
	add cl, 32
	mov [edx - 1], cl
	
.skip:
	movzx ecx, byte [edx]
	inc edx
	test cl, cl
	jne .loop
	
.return:
	ret
	
	
	
	
	
	align 16
_szLtrim:
	push ebx
	sub esp, 8
	mov eax, [esp + 16]
	mov edx, [esp + 20]
	lea ebx, [eax - 1]
	
.loop:
	inc ebx
	movzx eax, byte [ebx]
	
	cmp al, 9
	je .loop
	
	cmp al, 32
	je .loop
	
	test al, al
	jne .notEnd
	
	mov byte [edx], 0
	add esp, 8
	xor eax, eax
	pop ebx
	ret
	
	align 16
.notEnd:
	sub esp, 8
	multipush ebx, edx
	call _strcpy
	
	mov [esp], ebx
	call _strlen
	
	add esp, 24
	
	dec eax
	pop ebx
	ret
	
	
	
	
	
	align 16
_szMid:
	push ebx
	mov edx, [esp + 20]
	mov eax, [esp + 12]
	
	mov ecx, edx
	add eax, edx
	add edx, [esp + 16]
	neg ecx
	add edx, [esp + 8]
	
.loop:
	mov bl, [edx + ecx]
	mov [eax + ecx], bl
	
	inc ecx
	jne .loop
	
	mov byte [eax], 0
	
	pop ebx
	ret
	
	
	
	
	
	align 16
_szMonoSpace:
	push ebp
	mov eax, [esp + 8]
	
	mov ecx, eax
	mov ebp, eax
	
	lea edx, [eax - 1]
	
.loop:
	inc edx
	movsx eax, byte [edx]

	cmp eax, 32
	je .loop
	
	cmp eax, 9
	je .loop
	jmp .loop2
	
	align 16
.gotSpace:
	mov byte [ecx], ' '
	inc ecx
	jmp .loop
	
	align 16
.loop2:
	cmp eax, ' '
	je .gotSpace
	
	mov [ecx], al
	inc ecx
	
	test eax, eax
	je .end
	
	inc edx
	
	movsx eax, byte [edx]
	
	cmp eax, 9
	jne .loop2
	jmp .gotSpace
	
	align 16
.end:
	mov eax, ebp
	cmp byte [ecx - 2], 32
	jne .return
	
	mov byte [ecx - 2], 0
	
.return:
	pop ebp
	ret
	
	
	
	
	
	align 16
_szMultiCat:
	multipush edi, esi, ebx
	
	mov eax, [esp + 16]
	mov esi, [esp + 20]
	
	lea ebx, [esp + 24]
	lea edi, [ebx + eax * 4]
	
.loop:
	sub esp, 8
	push dword [ebx]
	add ebx, 4
	push esi
	call _strcat
	
	add esp, 16
	cmp edi, ebx
	jne .loop
	
	mov eax, esi
	multipop edi, esi, ebx
	ret
	
	
	
	
	
	align 16
_szRemove:
	multipush ebp, edi, esi, ebx
	push ecx
	
	mov ebp, [esp + 32]
	mov esi, [esp + 28]
	
	mov al, [ebp]
	mov [esp + 3], al
	
	mov eax, [esp + 24]
	lea edx, [eax - 1]
	
.loop:
	inc edx
	
.scanLoop:
	mov al, [edx]
	mov [esp + 2], al
	cmp al, [esp + 3]
	jne .endIfs
	
	xor eax, eax
	
.loop2:
	mov bl, [ebp + eax]
	cmp [edx + eax], bl
	jne .endIfs
	
%macro szRemoveDoCheck 1

	mov cl, [ebp + eax + %1]
	lea edi, [eax + %1]
	mov bl, [edx + eax + %1]
	test cl, cl
	je .endIfs2
	
	cmp cl, bl
	jne .endIfs

%endmacro

	szRemoveDoCheck 1
	szRemoveDoCheck 2
	szRemoveDoCheck 3
	
	cmp byte [ebp + eax + 4], 0
	lea edi, [eax + 4]
	je .endIfs2
	
	mov eax, edi
	jmp .loop2
	
	align 16
.endIfs2:
	add edx, edi
	jmp .scanLoop
	
	align 16
.endIfs:
	mov al, [esp + 2]
	mov [esi], al
	
	test al, al
	je .return
	
	inc esi
	jmp .loop
	
	align 16
.return:
	mov eax, [esp + 28]
	pop edx
	multipush ebp, edi, esi, ebx
	ret
	
	
	
	
	
	align 16
_szRep:
	multipush ebp, edi, esi, ebx
	sub esp, 40
	mov esi, [esp + 60]
	mov eax, [esp + 72]
	mov ebx, [esp + 68]
	mov edi, [esp + 64]
	mov [esp + 20], eax
	
	push esi
	call _strlen
	
	mov ebp, eax
	lea edx, [esi - 1]
	mov [esp], ebx
	mov [esp + 28], edx
	call _strlen
	
	inc ebp
	sub ebp, eax
	lea eax, [esi + ebp]
	add esp, 16
	
	mov [esp + 4], eax
	mov edx, [esp + 12]
	
	cmp esi, eax
	jl .loop
	jmp .return
	
	align 16
.srcINotCurrentChar:
	mov eax, ebp
	mov edx, esi
	lea esi, [edx + 1]
	mov [edi], cl
	inc edi
	
	cmp esi, [esp + 4]
	jge .return
	
.loop:
	movzx ecx, byte [edx + 1]
	mov eax, ebp
	cmp cl, [ebx]
	jne .srcINotCurrentChar
	
	mov eax, -1
	jmp .startLoop2
	
	align 16
.loop2:
	inc ebx
	cmp [esi + eax], dl
	jne .srcINotCurrentChar
	
.startLoop2:
	movzx ecx, byte [ebx]
	mov edx, eax
	inc eax
	
	test cl, cl
	jne .loop2
	
	mov ecx, [esp + 8]
	movzx eax, byte [ecx]
	
	test al, al
	je .break
	
.loop3:
	inc ecx
	
	mov [edi], al
	inc edi
	
	movzx eax, byte [ecx]
	
	test al, al
	jne .loop3
	
	mov [esp + 8], ecx
	
.break:
	add edx, esi
	lea esi, [edx + 1]
	cmp esi, [esp + 4]
	jl .loop
	
.return:
	mov [esp + 52], esi
	mov [esp + 48], edi
	add esp, 28
	multipop ebp, edi, esi, ebx
	jmp _strcpy
	
	
	
	
	
	align 16
_szRev:
	multipush edi, esi, ebx
	mov esi, [esp + 20]
	lea edi, [esi + 0x7FFFFFFF]
	
	sub esp, 8
	multipush dword [esp + 24], esi
	call _strcpy
	
	lea eax, [esi - 2]
	
	mov edx, esi
	add esp, 16
	
.loop:
	movzx ecx, byte [edx]
	movzx ebx, byte [eax]
	
	dec eax
	inc edx
	
	mov [edx - 1], bl
	mov [eax + 1], cl
	
	cmp eax, edi
	jne .loop
	
	mov eax, esi
	multipop edi, esi, ebx
	ret
	
	
	
	
	
	align 16
_szRight:
	multipush edi, esi
	sub esp, 20
	mov edi, [esp + 32]
	mov esi, [esp + 36]
	
	mov [esp], edi
	call _strlen
	sub eax, [esp + 40]
	mov [esp], edi
	add eax, edi
	mov [esp + 4], eax
	call _strcpy
	
	mov eax, esi
	add esp, 20
	multipop edi, esi
	ret
	
	
	
	
	
	align 16
_szRtrim:
	multipush ebx, edi, esi
	mov edx, [esp + 16]
	mov ecx, [esp + 20]
	mov eax, edx
	
	mov bl, [eax]
	cmp bl, 9
	jne .skipLoop
	
.loop:
	inc eax
	movzx ebx, byte [eax]
	cmp bl, 9 
	je .loop
	
.skipLoop:
	cmp bl, 32
	je .loop
	
	test bl, bl
	jne .startLoop2
	
	xor eax, eax
	jmp .return
	
	align 16
.startLoop2:
	xor esi, esi
	mov edi, 1
	
.loop2:
	movzx ebx, byte [edx + edi - 1]
	mov eax, esi
	
	cmp bl, 32
	mov [ecx + edi - 1], bl
	cmova esi, edi
	inc edi
	test bl, bl
	jne .loop2
	
.return:
	mov byte [ecx + eax], 0
	multipop ebx, edi, esi
	ret
	
	
	
	
	
	align 16
_szTrim:
	mov ecx, [esp + 4]
	lea eax, [ecx - 1]
	
.loop:
	movzx edx, byte [eax + 1]
	inc eax
	
	cmp dl, 9
	je .loop
	
	cmp dl, 32
	je .loop
	
	test dl, dl
	jne .loop2
	
	mov byte [ecx], 0
	
.ret0:
	xor eax, eax
	ret
	
	align 16
.loop2:
	movzx edx, byte [eax]
	mov [ecx], dl
	
	test dl, dl
	je .ret0
	
	movzx edx, byte [eax]
	mov [ecx], dl
	test dl, dl
	jne .loop2
	jmp .ret0
	
	
	
	
	
	align 16
_szUpper:
	multipush edi, esi
	push eax
	mov esi, [esp + 16]
	
	mov al, [esi]
	test al, al
	je .return
	
	mov edi, esi
	
.loop:
	movsx eax, al
	mov [esp], eax
	call _islower
	
	test al, al
	je .skip
	
	movsx eax, byte [edi]
	mov [esp], eax
	call _toupper
	mov [edi], al
	
.skip:
	movzx eax, byte [edi + 1]
	inc edi
	
	test al, al
	jne .loop
	
.return:
	mov eax, esi
	add esp, 4
	pop esi
	pop edi
	ret
	
	
	
	
	
	align 16
_tstline:
	mov eax, [esp + 4]
	dec eax
	
.loop:
	movzx edx, byte [eax + 1]
	inc eax
	
	cmp dl, 9
	je .loop
	
	cmp dl, 32
	je .loop
	
	cmp dl, 31
	mov edx, 0
	cmovle eax, edx
	
	ret
	
	
	
	
	
	align 16
_ucappend:
	push esi
	mov eax, [esp + 16]
	mov ecx, [esp + 12]
	mov edx, [esp + 8]
	add eax, -4
	
.loop:
	mov esi, [ecx]
	add ecx, 4
	mov [edx + eax + 4], esi
	add eax, 4
	test esi, esi
	jne .loop
	
	pop esi
	ret
	
	
	
	
	
	align 16
_ucCatStr:
	sub esp, 20
	multipush dword [esp + 28], dword [esp + 28]
	call _wcscat
	
	xor eax, eax
	add esp, 28
	ret
	
	
	
	
	
	align 16
_ucCmp:
	push esi
	mov ecx, [esp + 12]
	mov edx, [esp + 8]
	mov eax, -1
	
.loop:
	mov esi, [edx + eax * 4 + 4]
	cmp esi, [ecx + eax * 4 + 4]
	jne .ret0
	
	inc eax
	test esi, esi
	jne .loop
	
	and eax, 0x3FFFFFFF
	pop esi
	ret
	
	align 16
.ret0:
	xor eax, eax
	pop esi
	ret
	
	
	
	
	
	align 16
_ucCopy:
	mov eax, [esp + 4]
	mov edx, [esp + 8]
	mov [esp + 8], eax
	mov [esp + 4], edx
	jmp _wcscpy
	
	
	
	
	
	align 16
_ucLeft:
	multipush esi, ebx
	sub esp, 8
	mov ebx, [esp + 24]
	mov esi, [esp + 28]
	
	multipush esi, dword [esp + 24], ebx
	call _wmemcpy
	
	mov dword [ebx + esi * 4], 0
	
	add esp, 20
	pop ebx
	pop esi
	ret
	
	
	
	
	
	align 16
_ucLen:
	jmp _wcslen
	
	
	
	
	
	align 16
_ucMultiCat:
	multipush edi, esi, ebx
	
	mov eax, [esp + 16]
	mov esi, [esp + 20]
	
	lea ebx, [esp + 24]
	lea edi, [ebx + eax * 4]
	
.loop:
	sub esp, 8
	push dword [ebx]
	add ebx, 4
	push esi
	call _wcscat
	
	add esp, 16
	cmp edi, ebx
	jne .loop
	
	mov eax, esi
	pop ebx
	pop esi
	pop edi
	ret