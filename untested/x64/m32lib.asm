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
global _IntSqrt
global _isalpha
global _isalphanum
global _islower
global _isnumber
global _isupper
global _lfcnt
global _MemCopy
global _memfill
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

extern _memcpy
extern _memset
extern _stpcpy
extern _strcat
extern _strcpy
extern _strlen
extern _toupper
extern _wcscat
extern _wcscpy
extern _wcslen
extern _wmemcpy

segment .rodata align=16

	align 16
	bintable dd '0000', '0000', '0000', '1000', '0000', '0100', '0000', '1100', '0000', '0010', '0000', '1010', '0000', '0110', '0000', '1110', '0000', '0001', '0000', '1001', '0000', '0101', '0000', '1101', '0000', '0011', '0000', '1011', '0000', '0111', '0000', '1111', '1000', '0000', '1000', '1000', '1000', '0100', '1000', '1100', '1000', '0010', '1000', '1010', '1000', '0110', '1000', '1110', '1000', '0001', '1000', '1001', '1000', '0101', '1000', '1101', '1000', '0011', '1000', '1011', '1000', '0111', '1000', '1111', '0100', '0000', '0100', '1000', '0100', '0100', '0100', '1100', '0100', '0010', '0100', '1010', '0100', '0110', '0100', '1110', '0100', '0001', '0100', '1001', '0100', '0101', '0100', '1101', '0100', '0011', '0100', '1011', '0100', '0111', '0100', '1111', '1100', '0000', '1100', '1000', '1100', '0100', '1100', '1100', '1100', '0010', '1100', '1010', '1100', '0110', '1100', '1110', '1100', '0001', '1100', '1001', '1100', '0101', '1100', '1101', '1100', '0011', '1100', '1011', '1100', '0111', '1100', '1111', '0010', '0000', '0010', '1000', '0010', '0100', '0010', '1100', '0010', '0010', '0010', '1010', '0010', '0110', '0010', '1110', '0010', '0001', '0010', '1001', '0010', '0101', '0010', '1101', '0010', '0011', '0010', '1011', '0010', '0111', '0010', '1111', '1010', '0000', '1010', '1000', '1010', '0100', '1010', '1100', '1010', '0010', '1010', '1010', '1010', '0110', '1010', '1110', '1010', '0001', '1010', '1001', '1010', '0101', '1010', '1101', '1010', '0011', '1010', '1011', '1010', '0111', '1010', '1111', '0110', '0000', '0110', '1000', '0110', '0100', '0110', '1100', '0110', '0010', '0110', '1010', '0110', '0110', '0110', '1110', '0110', '0001', '0110', '1001', '0110', '0101', '0110', '1101', '0110', '0011', '0110', '1011', '0110', '0111', '0110', '1111', '1110', '0000', '1110', '1000', '1110', '0100', '1110', '1100', '1110', '0010', '1110', '1010', '1110', '0110', '1110', '1110', '1110', '0001', '1110', '1001', '1110', '0101', '1110', '1101', '1110', '0011', '1110', '1011', '1110', '0111', '1110', '1111', '0001', '0000', '0001', '1000', '0001', '0100', '0001', '1100', '0001', '0010', '0001', '1010', '0001', '0110', '0001', '1110', '0001', '0001', '0001', '1001', '0001', '0101', '0001', '1101', '0001', '0011', '0001', '1011', '0001', '0111', '0001', '1111', '1001', '0000', '1001', '1000', '1001', '0100', '1001', '1100', '1001', '0010', '1001', '1010', '1001', '0110', '1001', '1110', '1001', '0001', '1001', '1001', '1001', '0101', '1001', '1101', '1001', '0011', '1001', '1011', '1001', '0111', '1001', '1111', '0101', '0000', '0101', '1000', '0101', '0100', '0101', '1100', '0101', '0010', '0101', '1010', '0101', '0110', '0101', '1110', '0101', '0001', '0101', '1001', '0101', '0101', '0101', '1101', '0101', '0011', '0101', '1011', '0101', '0111', '0101', '1111', '1101', '0000', '1101', '1000', '1101', '0100', '1101', '1100', '1101', '0010', '1101', '1010', '1101', '0110', '1101', '1110', '1101', '0001', '1101', '1001', '1101', '0101', '1101', '1101', '1101', '0011', '1101', '1011', '1101', '0111', '1101', '1111', '0011', '0000', '0011', '1000', '0011', '0100', '0011', '1100', '0011', '0010', '0011', '1010', '0011', '0110', '0011', '1110', '0011', '0001', '0011', '1001', '0011', '0101', '0011', '1101', '0011', '0011', '0011', '1011', '0011', '0111', '0011', '1111', '1011', '0000', '1011', '1000', '1011', '0100', '1011', '1100', '1011', '0010', '1011', '1010', '1011', '0110', '1011', '1110', '1011', '0001', '1011', '1001', '1011', '0101', '1011', '1101', '1011', '0011', '1011', '1011', '1011', '0111', '1011', '1111', '0111', '0000', '0111', '1000', '0111', '0100', '0111', '1100', '0111', '0010', '0111', '1010', '0111', '0110', '0111', '1110', '0111', '0001', '0111', '1001', '0111', '0101', '0111', '1101', '0111', '0011', '0111', '1011', '0111', '0111', '0111', '1111', '1111', '0000', '1111', '1000', '1111', '0100', '1111', '1100', '1111', '0010', '1111', '1010', '1111', '0110', '1111', '1110', '1111', '0001', '1111', '1001', '1111', '0101', '1111', '1101', '1111', '0011', '1111', '1011', '1111', '0111', '1111', '1111'
	
	align 16
	Cmpi_tbl db 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 97, 98, 99,100,101,102,103,104,105,106,107,108,109,110,111, 112,113,114,115,116,117,118,119,120,121,122, 91, 92, 93, 94, 95, 96, 97, 98, 99,100,101,102,103,104,105,106,107,108,109,110,111, 112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127, 128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143, 144,145,146,147,148,149,150,151,152,153,154,155,156,156,158,159, 160,161,162,163,164,165,166,167,168,169,170,171,172,173,173,175, 176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191, 192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207, 208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223, 224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239, 240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255
	
	align 16
	CombSortAMultiplier dq 0.76923076923076916
	
	align 16
	hex_table dw '00', '10', '20', '30', '40', '50', '60', '70', '80', '90', 'A0', 'B0', 'C0', 'D0', 'E0', 'F0', '01', '11', '21', '31', '41', '51', '61', '71', '81', '91', 'A1', 'B1', 'C1', 'D1', 'E1', 'F1', '02', '12', '22', '32', '42', '52', '62', '72', '82', '92', 'A2', 'B2', 'C2', 'D2', 'E2', 'F2', '03', '13', '23', '33', '43', '53', '63', '73', '83', '93', 'A3', 'B3', 'C3', 'D3', 'E3', 'F3', '04', '14', '24', '34', '44', '54', '64', '74', '84', '94', 'A4', 'B4', 'C4', 'D4', 'E4', 'F4', '05', '15', '25', '35', '45', '55', '65', '75', '85', '95', 'A5', 'B5', 'C5', 'D5', 'E5', 'F5', '06', '16', '26', '36', '46', '56', '66', '76', '86', '96', 'A6', 'B6', 'C6', 'D6', 'E6', 'F6', '07', '17', '27', '37', '47', '57', '67', '77', '87', '97', 'A7', 'B7', 'C7', 'D7', 'E7', 'F7', '08', '18', '28', '38', '48', '58', '68', '78', '88', '98', 'A8', 'B8', 'C8', 'D8', 'E8', 'F8', '09', '19', '29', '39', '49', '59', '69', '79', '89', '99', 'A9', 'B9', 'C9', 'D9', 'E9', 'F9', '0A', '1A', '2A', '3A', '4A', '5A', '6A', '7A', '8A', '9A', 'AA', 'BA', 'CA', 'DA', 'EA', 'FA', '0B', '1B', '2B', '3B', '4B', '5B', '6B', '7B', '8B', '9B', 'AB', 'BB', 'CB', 'DB', 'EB', 'FB', '0C', '1C', '2C', '3C', '4C', '5C', '6C', '7C', '8C', '9C', 'AC', 'BC', 'CC', 'DC', 'EC', 'FC', '0D', '1D', '2D', '3D', '4D', '5D', '6D', '7D', '8D', '9D', 'AD', 'BD', 'CD', 'DD', 'ED', 'FD', '0E', '1E', '2E', '3E', '4E', '5E', '6E', '7E', '8E', '9E', 'AE', 'BE', 'CE', 'DE', 'EE', 'FE', '0F', '1F', '2F', '3F', '4F', '5F', '6F', '7F', '8F', '9F', 'AF', 'BF', 'CF', 'DF', 'EF', 'FF'
	
	align 16
	GetPercentMultiplier dq 0.01
	
	align 16
	ctbl db true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, true, true, false, true, false, false, true, true, true, true, true, true, true, true, true, true, true, false, false, false, false, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false, true, false, true, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false
	
	align 16
	szCmpi_tbl db 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 46, 45, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, -128, -127, -126, -125, -124, -123, -122, -121, -120, -119, -118, -117, -116, -115, -114, -113, -112, -111, -110, -109, -108, -107, -106, -105, -104, -103, -102, -101, -100, -100, -98, -97, -96, -95, -94, -93, -92, -91, -90, -89, -88, -87, -86, -85, -84, -83, -83, -81, -80, -79, -78, -77, -76, -75, -74, -73, -72, -71, -70, -69, -68, -67, -66, -65, -64, -63, -62, -61, -60, -59, -58, -57, -56, -55, -54, -53, -52, -51, -50, -49, -48, -47, -46, -45, -44, -43, -42, -41, -40, -39, -38, -37, -36, -35, -34, -33, -32, -31, -30, -29, -28, -27, -26, -25, -24, -23, -22, -21, -20, -19, -18, -17, -16, -15, -14, -13, -12, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1
	
segment .data align=16

	align 16
	nrandom_seed dd 12345678

segment .text align=16

	align 16
_a2dw:
	test rdi, rdi
	je .ret0
	
	multipush rbp, rbx
	
	mov rbx, rdi
	sub rsp, 8
	
	call _strlen
	
	test rax, rax
	je .len0
	
	movzx esi, byte [rbx]
	dec rax
	mov rcx, rax
	lea edx, [rsi - 48]
	movzx edx, dl
	je .returnRes
	
.loop:
	mov rax, rcx
	
.loop2:
	lea edx, [rdx + rdx * 4]
	add edx, edx
	
	dec rax
	jne .loop2
	
	movzx eax, byte [rbx + 1]
	add ebp, edx
	inc rbx
	lea edx, [rax - 48]
	movzx edx, dl
	
	dec rcx
	jne .loop
	
.returnRes:
	lea eax, [rbp + rbx]
	
.return:
	add rsp, 8
	multipop rbp, rbx
	ret
	
	align 16
.ret0:
	xor eax, eax
	ret
	
	align 16
.len0:
	xor eax, eax
	jmp .return
	
	
	
	
	
	align 16
_arr2mem:
	multipush r14, r13, r12, rbp, rbx
	mov r13, rdi
	mov r12, rsi
	
	mov ebx, 1
	
	call _arrcnt
	mov r14, rax
	
.loop:
	mov rsi, rbx
	mov rdi, r13
	call _arrlen
	
	mov rsi, rbx
	mov rdi, r13
	inc rbx
	mov rbp, rax
	call _arrget
	
	mov rsi, r12
	mov rdx, rbp
	add r12, rbp
	mov rdi, rax
	call _MemCopy
	
	cmp r14, rbx
	jge .loop
	
	mov rax, r12
	multipop r14, r13, r12, rbp, rbx
	ret
	
	
	
	
	
	align 16
_arr2text:
	multipush r14, r13, r12, rbp, rbx
	mov r14d, 1
	xor r12d, r12d
	mov rbp, rdi
	mov rbx, rdi
	
	call _arrcnt
	mov r13, rax
	
.loop:
	mov rsi, r14
	mov rdi, rbp
	inc r14
	call _arrget
	
	mov rdx, r12
	mov rdi, rbx
	mov rsi, rax
	call _szappend
	
	mov edx, 0x0A0D
	mov [rbx + rax], dx
	
	lea r12, [rax + 2]
	cmp r13, r14
	jge .loop
	
	mov rax, r13
	multipop r14, r13, r12, rbp, rbx
	ret
	
	
	
	
	
%define arrAddCurrentElement rdi + rcx * 8
	align 16
_arr_add:
	lea rax, [rdi + rsi * 8]
	
	mov r11, rsi
	neg r11
	
	lea rcx, [r11 * 4]
	test rcx, rcx
	je .return
	
	mov r8, 0x3FFFFFFFFFFFFFFF
	
	lea r9, [rsi + r8]
	and r9, r8
	inc r9
	cmp r9, 3
	jbe .startSmall
	
	push rbx
	mov r11, r9
	and r11, -4
	
	lea rbx, [r11 - 4]
	mov rcx, rbx
	shr rcx, 2
	inc rcx
	
	mov r10d, ecx
	and r10d, 3
	cmp rbx, 12
	jae .doSSE
	
	xor ecx, ecx
	test r10, r10
	pop rbx
	jne .startSmallSSE
	jmp .doSmall
	
	align 16
.doSSE:
	mov ebx, 1
	sub rdx, rcx
	add rbx, r10
	dec rbx
	xor ecx, ecx
	movq xmm0, rdx
	pshufd xmm0, xmm0, 0x44	; xmm0 = xmm0[0, 1, 0, 1]
	
.sseLoop:
	movdqu xmm1, [arrAddCurrentElement]
	movdqu xmm2, [arrAddCurrentElement + 16]
	movdqu xmm3, [arrAddCurrentElement + 32]
	movdqu xmm4, [arrAddCurrentElement + 48]
	paddq xmm1, xmm0
	paddq xmm2, xmm0
	movdqu [arrAddCurrentElement], xmm1
	movdqu [arrAddCurrentElement + 16], xmm2
	paddq xmm3, xmm0
	paddq xmm4, xmm0
	movdqu [arrAddCurrentElement + 32], xmm3
	movdqu [arrAddCurrentElement + 48], xmm4
	
	movdqu xmm1, [arrAddCurrentElement + 64]
	movdqu xmm2, [arrAddCurrentElement + 80]
	paddq xmm1, xmm0
	paddq xmm2, xmm0
	movdqu [arrAddCurrentElement + 64], xmm1
	movdqu [arrAddCurrentElement + 80], xmm2
	
	movdqu xmm1, [arrAddCurrentElement + 96]
	movdqu xmm2, [arrAddCurrentElement + 112]
	paddq xmm1, xmm0
	paddq xmm2, xmm0
	movdqu [arrAddCurrentElement + 96], xmm1
	movdqu [arrAddCurrentElement + 112], xmm2
	
	add rcx, 16
	add rbx, 4
	jne .sseLoop
	
	test r10, r10
	pop rbx
	je .doSmall
	
.startSmallSSE:
	lea rcx, [arrAddCurrentElement]
	add rcx, 16
	neg r10
	movq xmm0, rdx
	pshufd xmm0, xmm0, 0x44	; xmm0 = xmm0[0, 1, 0, 1]

.smallSSELoop:
	movdqu xmm1, [rcx - 16]
	movdqu xmm2, [rcx]
	paddq xmm1, xmm0
	paddq xmm2, xmm0
	movdqu [rcx - 16], xmm1
	movdqu [rcx], xmm2
	add rcx, 32
	inc r10
	jne .smallSSELoop
	
.doSmall:
	cmp r9, r11
	je .return
	
	sub r11, rsi
	
.startSmall:
	inc r11
	
.smallLoop:
	add [rax + r11 * 8 - 8], rdx
	test r11, r8
	lea r11, [r11 + 1]
	jne .smallLoop
	
.return:
	ret
	
	
	
	
	
	align 16
_arrcnt:
	mov rax, [rdi]
	ret
	
	
	
	
	
	align 16
_arrget:
	mov rax, -1
	test rsi, rsi
	jle .return
	
	mov rax, -2
	cmp [rdi], rsi
	jge .retArrIdx
	
.return:
	ret
	
	align 16
.retArrIdx:
	mov rax, [rdi + rsi * 8]
	ret
	
	
	
	
	
	align 16
_arrlen:
	mov rax, [rdi + rsi * 8]
	mov rax, [rax - 8]
	ret
	
	
	
	
	
	align 16
_arr_mul:
	lea rax, [rdi + rsi * 8]
	
	neg rsi
	movsx rdx, edx
	sal rsi, 2
	je .return
	
.loop:
	mov rcx, [rax + rsi * 2]
	imul rcx, rdx
	mov [rax + rsi * 2], rcx
	
	add rsi, 4
	jne .loop
	
.return:
	ret
	
	
	
	
	
	align 16
%define arrSubCurrentElement rax + r10 * 8
_arr_sub:
	lea rax, [rdi + rsi * 8]
	
	mov r10, rsi
	neg r10
	lea rcx, [r10 * 4]
	test rcx, rcx
	je .return
	
	mov r8, 0x3FFFFFFFFFFFFFFF
	movsxd rdx, edx
	
	lea r9, [rsi + r8]
	and rsi, 3
	je .startBig
	
.smallLoop:
	sub [rdi], rdx
	inc r10
	add rsi, r8
	lea rcx, [rsi * 4]
	add rdi, 8
	test rcx, rcx
	jne .smallLoop
	
.startBig:
	and r9, r8
	cmp r9, 3
	jb .return
	
	add r10, 4
	
.bigLoop:
	sub [arrSubCurrentElement - 32], rdx
	sub [arrSubCurrentElement - 24], rdx
	sub [arrSubCurrentElement - 16], rdx
	sub [arrSubCurrentElement - 8], rdx
	
	test r10, r8
	lea r10, [r10 + 4]
	jne .bigLoop
	
.return:
	ret
	




	align 16
_arrtotal:
	mov r8, [rdi]
	mov edx, 1
	xor eax, eax

.loop:
	inc rdx
	mov rdx, [rdi + rdx * 8 - 8]
	mov ecx, [rdx - 4]
	add rax, rcx

	cmp rdx, r8
	jle .loop

	lea rdx, [rax + r8 * 2]
	test sil, sil
	cmovne rax, rdx
	ret
	
	
	
	
	
	align 16
_atodw:
	mov dl, [rdi]
	xor eax, eax

	cmp dl, 2
	jne .not2
	
	mov dl, [rdi + 1]
	add rdi, 2
	mov ecx, -1
	
	test dl, dl
	jne .startLoop
	jmp .return
	
	align 16
.not2:
	inc rdi
	xor ecx, ecx
	
	test dl, dl
	je .return
	
.startLoop:
	xor eax, eax
	
.loop:
	add dl, -48
	movzx edx, dl
	lea eax, [rax + rax * 4]
	lea eax, [rax + rax * 2]
	movzx edx, byte [rdi]
	inc rdi
	
	test dl, dl
	jne .loop
	
.return:
	add eax, ecx
	xor eax, ecx
	ret
	
	
	
	
	
	align 16
_atol:
	mov al, [rdi]
	cmp al, 45
	jne .notNegative
	
	mov al, [rdi + 1]
	add rdi, 2
	mov cl, 1
	xor edx, edx
	cmp al, 48
	jae .loop
	jmp .return
	
	align 16
.notNegative:
	inc rdi
	multizero ecx, edx
	cmp al, 48
	jb .return
	
.loop:
	movsx rax, al
	lea rdx, [rdx + rdx * 4]
	lea rdx, [rax + rdx * 2]
	add rdx, -48
	
	movzx eax, byte [rdi]
	inc rdi
	
	cmp al, 47
	ja .loop
	
.return:
	mov rax, rdx
	neg rax
	test cl, cl
	cmove rax, rdx
	ret
	
	
	
	
	
	align 16
_byt2bin_ex:
	mov eax, edi
	
	lea ecx, [rax + rax]
	mov ecx, [bintable + rcx * 4]
	mov [rsi], ecx
	
	lea ecx, [rax + rax + 1]
	mov ecx, [bintable + rcx * 4]
	mov [rsi + 4], ecx
	
	mov byte [rsi + 8], 0
	ret
	
	
	
	
	
	align 16
_BMBinSearch:
	cmp r8, 1
	jle .retMin2
	
	multipush rbp, rbx
	movq xmm0, r8
	punpcklqdq xmm0, xmm0
	sub rsp, 1936
	lea r9, [rsp - 120]
	lea rax, [rsp + 1928]
	
.memsetLoop:
	movaps [r9], xmm0
	add r9, 16
	cmp r9, rax
	jne .memsetLoop
	
	lea rbx, [r8 - 1]
	mov r10, rcx
	mov r9, rbx
	
.makeShift:
	movzx r11d, byte [r10]
	inc r10
	mov [rsp - 120 + r11 * 8], r9
	dec r9
	jne .makeShift
	
	sub rdx, r8
	lea rax, [rsi + rdi]
	mov rdi, rbx
	
	mov r9, [rsp - 120]
	mov r10d, 1
	
	lea r11, [rsi + rdx]
	jmp .startLoop
	
	align 16
.loop:
	lea rax, [rax + rdi + 1]
	cmp rax, r11
	jg .return
	
.startLoop:
	movzx edx, byte [rax + rdi]
	cmp [rcx + rdi], dl
	je .remove1
	
	mov rdx, [rsp - 120 + rdx * 8]
	cmp r8, rdx
	je .loop
	
	add rax, rdx
	mov rdi, rbx
	
.checkWhile:
	cmp rax, r11
	jle .startLoop
	
.return:
	add rsp, 1936
	mov rax, -1
	multipop rbp, rbx
	ret
	
	align 16
.remove1:
	dec rdi
	jmp .startLoop2
	
	align 16
.loop2:
	dec rdi
	js .returnSub
	
.startLoop2:
	movzx edx, byte [rax + rdi]
	cmp [rcx + rdi], dl
	je .loop2
	
	cmp r8, r9
	je .loop
	
	add rdi, r9
	
	sub rdi, rbx
	cmovs rdi, r10
	
	mov rdx, rdi
	mov rdi, rbx
	add rax, rdx
	jmp .checkWhile
	
	align 16
.returnSub:
	add rsp, 1936
	sub rax, rsi
	multipop rbp, rbx
	ret
	
	align 16
.retMin2:
	mov rax, -2
	ret
	
	
	
	
	
	align 16
_BinSearch:
	mov rax, -2
	
	sub rdx, r8
	js .return
	
	movsx rdi, edi
	mov rax, -3
	cmp rdi, rdx
	jg .return
	
	lea rax, [rsi + rdi]
	lea rdi, [rsi + rdx]
	dec r8
	
	cmp rax, rdi
	jg .retMin1
	
	movzx r10d, byte [rcx]
	mov r9, rax
	jmp .startLoop
	
	align 16
.loop:
	inc rax
	inc r9
	
	cmp rax, rdi
	jg .retMin1
	
.startLoop:
	cmp [r9], r10b
	jne .loop
	
	mov rdx, -1
	
.loop2:
	inc rdx
	movzx r11d, byte [rcx + rdx]
	cmp [rax + rdx], r11b
	jne .loop
	
	cmp r8, rdx
	jne .loop2
	
	sub rax, rsi
	ret
	
	align 16
.retMin1:
	mov rax, -1
	
.return:
	ret
	
	
	
	
	
	align 16
_Cmpi:
	mov edx, 1
	jmp .startLoop
	
	align 16
.loop:
	inc rdx
	test cl, cl
	je .ret0
	
.startLoop:
	movzx ecx, byte [rdi + rdx - 1]
	movzx r8d, byte [rsi + rdx - 1]
	movsx rax, edx
	
	movzx ecx, byte [Cmpi_tbl + rcx]
	cmp byte [Cmpi_tbl + r8], cl
	je .loop
	
	ret
	
	align 16
.ret0:
	xor eax, eax
	ret
	
	
	
	
	
	align 16
_cmpmem:
	cmp rax, 3
	ja .large
	
	xor eax, eax
	
.startSmall:
	add rdx, rax
	jmp .startSmallLoop
	
	align 16
.smallLoop:
	inc rax
	cmp rdx, rax
	je .ret1
	
.startSmallLoop:
	movzx ecx, byte [rsi + rax]
	cmp [rdi + rax], cl
	je .smallLoop
	
.ret0:
	xor eax, eax
	ret
	
	align 16
.large:
	mov rax, rdx
	mov ecx, 4
	shr rax, 2
	lea r8, [rax * 4 + 4]
	jmp .startBigLoop
	
	align 16
.bigLoop:
	movsx rax, ecx
	add rcx, 4
	cmp r8, rcx
	je .and3
	
.startBigLoop:
	mov eax, [rsi + rcx - 4]
	cmp [rdi + rcx - 4], eax
	je .bigLoop
	jmp .ret0
	
	align 16
.and3:
	and edx, 3
	jne .startSmall
	
.ret1:
	mov eax, 1
	ret
	
	
	
	
	
	align 16
_CombSortA:
	push rbx
	movsd xmm0, [rel CombSortAMultiplier]
	
.loop:
	xorps xmm1, xmm1
	cvtsi2sd xmm1, r8
	mulsd xmm1, xmm0
	
	cvtsd2si eax, xmm1
	lea r9d, [rax - 1]
	
	cmp eax, 1
	cmove r9d, eax
	movsxd r8, r9d
	
	mov r11, r8
	not r11
	add r11, rsi
	
	lea rcx, [rdi + r8 * 4]
	mov rax, -1
	
	xor r10d, r10d
	
.loop2:
	mov edx, [rdi + rax * 4 + 4]
	mov ebx, [rcx + rax * 4 + 4]
	cmp edx, ebx
	jle .noSwap
	
	mov [rcx + rax * 4 + 4], edx
	mov [rdi + rax * 4 + 4], ebx
	inc r10
	
.noSwap:
	inc rax
	cmp rax, r11
	jl .loop2
	
	cmp r9d, 1
	jg .loop
	
	test r10, r10
	jne .loop
	
	pop rbx
	ret
	
	
	
	
	
	align 16
_CombSortD:
	push rbx
	movsd xmm0, [rel CombSortAMultiplier]
	mov r8, rsi
	
.loop:
	xorps xmm1, xmm1
	cvtsi2sd xmm1, r8
	mulsd xmm1, xmm0
	
	cvtsd2si eax, xmm1
	lea r9d, [rax - 1]
	
	cmp eax, 1
	cmove r9d, eax
	movsxd r8, r9d
	
	mov r11, r8
	not r11
	add r11, rsi
	
	lea rcx, [rdi + r8 * 4]
	mov rax, -1
	
	xor r10d, r10d
	
.loop2:
	mov edx, [rdi + rax * 4 + 4]
	mov ebx, [rcx + rax * 4 + 4]
	cmp edx, ebx
	jge .noSwap
	
	mov [rcx + rax * 4 + 4], edx
	mov [rdi + rax * 4 + 4], ebx
	inc r10
	
.noSwap:
	inc rax
	cmp rax, r11
	jl .loop2
	
	cmp r9d, 1
	jg .loop
	
	test r10, r10
	jg .loop
	
	pop rbx
	ret
	
	
	
	
	
	align 16
_decomment:
	mov rdx, -1
	xor ecx, ecx
	
.arrIterLoop:
	inc rdx
	movzx eax, byte [rdi + rdx]
	cmp al, 9
	je .arrIterLoop
	
.checkTab:
	cmp al, 32
	je .arrIterLoop
	
	test al, al
	je .return
	
	cmp al, 34
	je .gotQuotes
	
	cmp al, 39
	je .gotBackSlash
	
	cmp al, 59
	je .break
	
.checkIter:
	mov rcx, rdx
	inc rdx
	movzx eax, byte [rdi + rdx]
	
	cmp al, 9
	jne .checkTab
	jmp .arrIterLoop
	
	align 16
.checkOtherQuote:
	cmp al, 34
	je .checkIter
	
.gotQuotes:
	inc rdx
	movzx eax, byte [rdi + rdx]
	test al, al
	jne .checkOtherQuote
	
	mov eax, -1
	
.return:
	ret
	
	align 16
.checkOtherQuote2:
	cmp al, 39
	je .checkIter
	
.gotBackSlash:
	inc rdx
	movzx eax, byte [rdi + rdx]
	test al, al
	jne .checkOtherQuote2
	
	mov eax, -1
	ret
	
	align 16
.break:
	movzx edx, byte [rdi + rcx]
	mov byte [rdi + rcx + 1], 0
	
	mov eax, 1
	cmp dl, 44
	je .return
	
	cmp dl, 92
	sete al
	ret
	
	
	
	
	
	align 16
_dissort:
	cmp rsi, 2
	jl .return
	
	mov r9d, 1
	
.loop:
	mov r11, [rdi + r9 * 8]
	mov r10, r9
	
.loop2:
	lea r8, [r10 - 1]
	mov rax, [rdi + r10 * 8 - 8]
	xor edx, edx
	
.loop3:
	movzx ecx, byte [rax + rdx]
	cmp cl, [r11 + rdx]
	jg .greater
	jl .larger
	
	inc rdx
	test cl, cl
	jne .loop3
	jmp .greater
	
	align 16
.larger:
	mov [rdi + r10 * 8], rax
	mov r10, r8
	test r8, r8
	jne .loop2
	
	xor r10d, r10d
	
.greater:
	mov [rdi + r10 * 8], r11
	inc r9
	cmp r9, rsi
	jne .loop
	
.return:
	ret
	
	
	
	
	
	align 16
_dw2ah:
	mov word [rsi + 8], 72
	lea rax, [rsi + 7]
	
.loop:
	mov ecx, edi
	and ecx, 0xF
	
	cmp ecx, 9
	ja .above
	
	or cl, 48
	jmp .skip
	
	align 16
.above:
	lea ecx, [rcx + 55]
	
.skip:
	mov [rax], cl
	dec rax
	
	ror edi, 4
	
	cmp rax, rsi
	jae .loop
	
	ret
	
	
	
	
	
	align 16
_dw2bin_ex:
	mov [rsp - 8], edi
	
	movzx eax, byte [rsp - 5]
	movzx r8d, byte [rsp - 6]
	movzx r11d, byte [rsp - 7]
	
	mov rdx, [bintable + rax * 8]
	mov [rsi], rdx
	
	mov ecx, [bintable + r8 * 8]
	mov [rsi + 8], ecx
	
	mov r9d, [bintable + r8 * 8 + 4]
	mov [rsi + 12], r9d
	
	mov r10d, [bintable + r11 * 8]
	mov [rsi + 16], r10d
	
	movzx ecx, byte [rsp - 8]
	mov eax, [bintable + r11 * 8 + 4]
	mov [rsi + 20], eax
	
	mov edx, [bintable + rcx * 8]
	mov [rsi + 24], edx
	
	mov edi, [bintable + rcx * 8 + 4]
	mov [rsi + 28], edi
	
	mov byte [rsi + 32], 0
	
	ret
	
	
	
	
	
	align 16
_dw2hex_ex:
	mov eax, edi
	mov ecx, edi
	movzx edx, al
	movzx edi, ah
	
	shr eax, 16
	shr ecx, 24
	
	mov edx, [hex_table + rdx + rdx]
	movzx edi, word [hex_table + rdi + rdi]
	
	shr edx, 16
	or edx, edi
	mov [rsi + 4], edx
	
	movzx eax, al
	mov eax, [hex_table + rax + rax]
	movzx ecx, word [hex_table + rcx + rcx]
	
	shr eax, 16
	or eax, ecx
	mov [rsi], eax
	mov byte [rsi + 8], 0
	ret
	
	
	
	
	
	align 16
_dwtoa:
	test edi, edi
	je .zero
	jns .notNegative
	
	mov byte [rsi], 45
	
	neg edi
	inc rsi
	
.notNegative:
	mov rax, rsi
	
.loop:
	movsxd rcx, edi
	imul rdi, rcx, 0x66666667
	mov rdx, rdi
	shr rdx, 63
	sar rdi, 34
	add edi, edx
	
	lea edx, [rdi + rdi]
	lea r8d, [rdx + rdx * 4]
	mov edx, ecx
	sub edx, r8d
	add dl, 48
	mov [rax], dl
	inc rax
	
	add ecx, 9
	cmp ecx, 18
	ja .loop
	
	mov byte [rax], 0
	
	cmp rsi, rax
	jae .return
	
	dec rax
	
.loop2:
	movzx ecx, byte [rax]
	movzx edx, byte [rsi]
	mov [rax], dl
	mov [rsi], cl
	inc rsi
	
	cmp rsi, rax
	lea rax, [rax - 1]
	jb .loop2
	
.return:
	ret
	
	align 16
.zero:
	mov word [rsi], 48
	ret
	
	
	
	
	
	align 16
_get_line_count:
	movzx eax, word [rdi + rsi - 2]
	cmp eax, 0x0A0D
	je .notEndl
	
	mov word [rdi + rsi], 0x0A0D
	mov byte [rdi + rsi + 2], 0
	
.notEndl:
	mov rcx, -1
	xor eax, eax
	jmp .startLoop
	
	align 16
.loop:
	inc rcx
	cmp dl, 10
	jne .startLoop
	
	inc rax
	
.startLoop:
	movzx edx, byte [rdi + rcx + 1]
	test dl, dl
	jne .loop
	
	ret
	
	
	
	
	
	align 16
_get_ml:
	push rbx
	lea rcx, [rdi + rdx]
	multizero r8d, eax
	jmp .start
	
	align 16
.doTheChecks:
	mov r11, rax
	inc rax
	
	cmp bl, 32
	jle .start
	
	cmp bl, 59
	jne .notSemicolon
	
.loop:
	mov bl, [rcx + rax]
	test bl, bl
	je .ret0AndClearFirst
	
	inc rax
	cmp bl, 10
	jne .loop
	
.start:
	mov bl, [rcx + rax]
	test bl, bl
	jne .doTheChecks
	jmp .ret0
	
.ret0AndClearFirst:
	xor r8d, r8d
	
.ret0:
	xor eax, eax
	
.return:
	mov byte [rsi + r8], 0
	pop rbx
	ret
	
	align 16
.notSemicolon:
	add rdi, rdx
	inc rdi
	
	multizero r9d, r10d, r8d
	jmp .mainText
	
	align 16
.anyChar:
	cmp bl, 13
	je .mainText
	
	cmp bl, 32
	cmovg r10, r8
	cmovg r9, r11
	
	mov [rsi + r8], bl
	inc r8
	
.mainText:
	mov bl, [rcx + r11]
	mov rax, r11
	jmp .checkAllTheChars
	
	align 16
.newlineLoop:
	mov bl, [rdi + rax]
	inc rax
	
	cmp bl, 10
	je .gotNewline
	
	test bl, bl
	jne .newlineLoop
	jmp .ret0
	
	align 16
.doNewline:
	mov rax, r11
	
.gotNewline:
	mov bl, [rcx + r9 - 1]
	cmp bl, 44
	je .decAndStuff
	
	cmp bl, 92
	jne .retRaxPlusRdx
	
	mov byte [rsi + r10], 32
	xor r10d, r10d
	jmp .decAndStuff
	
	align 16
.do34:
	mov byte [rsi + r8], 34
	inc r8
	
.newlineLoop2:
	mov al, [rcx + r11]
	mov [rsi + r8], al
	inc r8
	
	test al, al
	je .retMin1
	
	cmp al, 10
	je .retMin1
	
	inc r11
	cmp al, 34
	jne .newlineLoop2
	
	mov rax, r11
	jmp .decAndStuff
	
	align 16
.do39:
	mov byte [rsi + r8], 39
	inc r8
	mov rax, r11
	
.newlineLoop3:
	mov bl, [rcx + rax]
	mov [rsi + r8], bl
	inc r8
	
	test bl, bl
	je .retMin1
	
	cmp bl, 10
	je .retMin1
	
	inc rax
	cmp bl, 39
	jne .newlineLoop3
	
.decAndStuff:
	dec rax
	
.loop2:
	mov bl, [rcx + rax + 1]
	test bl, bl
	je .ret0
	
	inc rax
	cmp bl, 32
	jle .loop2
	
.checkAllTheChars:
	lea r11, [rax + 1]
	
	cmp bl, 10
	je .doNewline
	
	cmp bl, 34
	je .do34
	
	cmp bl, 39
	je .do39
	
	cmp bl, 59
	je .newlineLoop
	
	test bl, bl
	jne .anyChar
	jmp .ret0
	
	align 16
.retMin1:
	mov rax, -1
	jmp .return
	
	align 16
.retRaxPlusRdx:
	add rax, rdx
	jmp .return
	
	
	
	
	
	align 16
_GetPercent:
	cvtsi2sd xmm0, esi
	mulsd xmm0, [rel GetPercentMultiplier]
	cvtsi2sd xmm1, edi
	mulsd xmm1, xmm0
	cvttsd2si eax, xmm1
	ret
	
	
	
	
	
	align 16
_GetPathOnly:
	mov eax, 1
	xor ecx, ecx
	
	mov dl, [rdi + rax - 1]
	cmp dl, 92
	jne .startLoop
	jmp .doMov
	
	align 16
.loop:
	mov [rsi + rax - 1], dl
	inc rax
	
	mov dl, [rdi + rax - 1]
	cmp dl, 92
	je .doMov
	
.startLoop:
	test dl, dl
	jne .loop
	jmp .return
	
	align 16
.doMov:
	mov rcx, rax
	jmp .loop
	
	align 16
.return:
	mov byte [rsi + rcx], 0
	ret
	
	
	
	
	
	align 16
_htodw:
	mov rax, rdi
	
.strlenLoop:
	movzx esi, byte [rax]
	inc rax
	test sil, sil
	jne .strlenLoop
	
	mov rcx, rdi
	sub rcx, rax
	mov rax, rcx
	
	xor eax, -1
	je .return
	
	lea ecx, [rax * 4 - 4]
	xor eax, eax
	
.loop:
	movzx edx, byte [rdi]
	cmp dl, 64
	jg .hex
	
	and edx, 0xF
	inc rdi
	sal edx, cl
	sub ecx, 4
	add eax, edx
	
	cmp ecx, -4
	jne .loop
	
.return:
	ret
	
	align 16
.hex:
	xor r8d, r8d
	cmp dl, 86
	setle r8b
	
	inc rdi
	add esi, r8d
	sal esi, 5
	
	lea edx, [rsi + rdx - 87]
	
	and edx, 0xF
	sal edx, cl
	sub ecx, 4
	add eax, edx
	
	cmp ecx, -4
	jne .loop
	
	ret
	
	
	
	
	
	align 16
_InString:
	multipush r15, r14, r12, rbx
	push rax
	mov rbx, rdx
	mov r14, rdi
	
	mov rdi, rsi
	call _strlen
	mov r12, rax
	
	mov rdi, rbx
	call _strlen
	
	mov rsi, -2
	
	test r15, r15
	jle .return
	
	mov rsi, -1
	sub r12, rax
	jle .return
	
	lea r9, [r12 + 1]
	mov rsi, -2
	cmp r9, r15
	jl .return
	
	lea r10, [r15 - 2]
	sub r10, r12
	
	mov r8b, [rbx]
	
	lea rdi, [r14 + r15]
	sub rdi, 2
	
	add r14, r9
	
	xor esi, esi
	mov rdx, rax
	
	cmp r8b, [r14 + r10]
	je .loop
	jmp .checkMin2
	
	align 16
.loop2:
	inc r10
	inc rdi
	mov rdx, rax
	cmp r8b, [r14 + r10]
	jne .checkMin2
	
.loop:
	movzx ecx, byte [rdi + rdx]
	cmp cl, [rbx + rdx - 1]
	jne .loop2
	
	add rdx, -1
	jne .loop
	jmp .retR10PlusR9Inc
	
	align 16
.checkMin2:
	cmp r10, -2
	jle .loop2
	jmp .return
	
	align 16
.retR10PlusR9Inc:
	lea rsi, [r10 + r9]
	inc rsi
	
.return:
	mov rax, rsi
	add rsp, 8
	multipop r15, r14, r12, rbx
	ret
	
	
	
	
	
	align 16
_IntDiv:
	cvtsi2sd xmm0, edi
	cvtsi2sd xmm1, esi
	divsd xmm0, xmm1
	cvttsd2si eax, xmm0
	ret
	
	
	
	
	
	align 16
_IntMul:
	cvtsi2sd xmm0, edi
	cvtsi2sd xmm1, esi
	mulsd xmm0, xmm1
	cvttsd2si eax, xmm0
	ret
	
	
	
	
	
	align 16
_IntSqrt:
	cvtsi2sd xmm0, edi
	sqrtsd xmm0, xmm0
	cvttsd2si eax, xmm0
	ret
	
	
	
	
	
	align 16
_isalpha:
	lea edx, [rdi - 65]
	xor eax, eax
	cmp dl, 57
	ja .return
	
	mov eax, 1
	cmp dil, 90
	jle .return
	
	xor eax, eax
	cmp dil, 96
	setg al
	
	add al, al
	
.return:
	ret
	
	
	
	
	
	align 16
_isalphanum:
	xor eax, eax
	cmp dil, 47
	jle .return
	
	mov eax, 1
	cmp dil, 57
	jle .return
	
	xor eax, eax
	cmp dil, 64
	jle .return
	
	mov eax, 2
	cmp dil, 90
	jle .return
	
	sub edi, 97
	cmp dil, 26
	sbb eax, eax
	and eax, 3
	
.return:
	ret
	
	
	
	
	
%macro makeBetweenCheck 2
	sub edi, %1
	cmp dil, %2 - %1
	setbe al
	
	ret
%endmacro
	align 16
_islower:
	makeBetweenCheck 'a', 'z'
	
	
	
	
	
	align 16
_isnumber:
	makeBetweenCheck '0', '9'
	
	
	
	
	
	align 16
_isupper:
	makeBetweenCheck 'A', 'Z'
	
	
	
	
	
	align 16
_lfcnt:
	dec rdi
	
	xor eax, eax
	jmp .startLoop
	
	align 16
.loop:
	inc rdi
	cmp cl, 10
	jne .startLoop
	
	inc rax
	
.startLoop:
	movzx ecx, byte [rdi + 1]
	test cl, cl
	jne .loop
	
	ret
	
	
	
	
	
	align 16
_MemCopy:
	mov rax, rdi
	mov rdi, rsi
	mov rsi, rax
	jmp _memcpy
	
	
	
	
	
	align 16
_memfill:
	mov rax, rsi
	mov esi, edx
	mov rdx, rax
	jmp _memset
	
	
	
	
	
	align 16
_NameFromPath:
	movzx edx, byte [rdi]
	mov r8, rdi
	
	test dl, dl
	je .retMin1
	
	mov rdi, rsi
	mov rcx, r8
	xor eax, eax
	
.loop:
	cmp dl, 92
	cmove rcx, rax
	
	inc rax
	movzx edx, byte [r8 + rax]
	test dl, dl
	jne .loop
	
	cmp r8, rcx
	je .retMin1
	
	sub rsp, 8
	lea rsi, [r8 + rcx + 1]
	call _strcpy
	
	xor eax, eax
	add rsp, 8
	ret
	
	align 16
.retMin1:
	mov eax, -1
	ret
	
	
	
	
	
	align 16
_nrandom:
	mov eax, [rel nrandom_seed]
	
	lea ecx, [rax + 0x7FFFFFFF]
	
	test eax, eax
	cmovns ecx, eax
	
	imul rax, rcx, 110892733
	shr rax, 32
	
	mov edx, ecx
	sub edx, eax
	shr edx, 1
	add edx, eax
	shr edx, 16
	imul eax, edx, 127773
	sub ecx, eax
	imul ecx, 16807
	imul eax, edx, -2836
	
	add eax, ecx
	mov [rel nrandom_seed], eax
	
	xor edx, edx
	div edi
	
	mov eax, edx
	ret
	
	
	
	
	
	align 16
_nseed:
	mov [rel nrandom_seed], edi
	ret
	
	
	
	
	
	align 16
_parse_line:
	xor eax, eax
	mov rcx, [rsi]
	xor edx, edx
	
.badChar:
	mov r8b, [rdi]
	inc rdi
	
	test r8b, r8b
	je .got0
	
	movsx r9, r8b
	cmp byte [ctbl + r9], true
	jne .badChar
	
	inc eax
	
	cmp r8b, 91
	je .itsLeftBracket
	
.whileLeftBracket:
	cmp r8b, 34
	je .gotQuote
	
	mov [rcx], r8b
	inc rcx
	
	mov r8b, [rdi]
	inc rdi
	
	test r8b, r8b
	je .got0
	
	movsx r9, r8b
	cmp byte [ctbl + r9], 0
	je .reIndex
	
	cmp r8b, 91
	jne .whileLeftBracket
	
.itsLeftBracket:
	mov [rcx], r8b
	inc rcx
	
	cmp r8b, 93
	je .reIndex
	
.endLoop:
	mov r8b, [rdi]
	inc rdi
	
	test r8b, r8b
	je .return
	
	cmp r8b, 32
	je .endLoop
	jmp .itsLeftBracket
	
	align 16
.reIndex:
	add rsi, 8
	mov byte [rcx], 0
	mov rcx, [rsi]
	jmp .badChar
	
	align 16
.got0:
	mov [rcx], dl
	mov rcx, [rsi + 8]
	mov [rcx], dl
	ret
	
	align 16
.gotQuote:
	mov byte [rcx], 34
	inc rcx
	
.quoteLoop:
	mov r8b, [rdi]
	inc rdi
	
	test r8b, r8b
	je .return
	
	mov [rcx], r8b
	inc rcx
	
	cmp r8b, 34
	jne .quoteLoop
	jmp .reIndex
	
	align 16
.return:
	ret
	
	
	
	
	
	align 16
_partial:
	multipush r13, r12, rbp, rbx
	mov r12, rdi
	lea rbp, [rsi + rdi]
	mov rdi, rdx
	mov rbx, rdx
	
	sub rsp, 8
	call _strlen
	
	mov rdi, rbp
	mov r13, rax
	call _strlen
	
	movzx esi, byte [rbx]
	mov rdi, rax
	
	cmp sil, 42
	jne .noStar
	
	xor r8d, r8d
	
.starLoop:
	movzx esi, byte [rbx + 1]
	mov rdx, r8
	inc rbx
	inc r8
	
	cmp sil, 42
	je .starLoop
	
	mov r10, r13
	sub r10, r8
	
.afterStarLoop:
	sub rdi, r13
	add rdx, rbp
	dec r10
	add rdi, r8
	add rdi, rdx
	jmp .startLoop
	
	align 16
.loop:
	cmp rdi, r9
	jl .retMin1
	
.movAndLoop:
	mov rdx, r9
	
.startLoop:
	lea r9, [rdx + 1]
	cmp byte [rdx + 1], sil
	jne .loop
	
	test r10, r10
	js .return
	
	xor eax, eax
	
.loop2:
	movzx ecx, byte [rbx + rax]
	
	cmp cl, 42
	je .skip
	
	cmp [rdx + rax + 1], cl
	jne .movAndLoop
	
.skip:
	inc rax
	cmp rax, r10
	jle .loop2
	
.return:
	lea rax, [r9 + r12]
	add rsp, 8
	sub rax, rbp
	sub rax, r8
	multipop r13, r12, rbp, rbx
	ret
	
	align 16
.retMin1:
	add rsp, 8
	mov rax, -1
	multipop r13, r12, rbp, rbx
	ret
	
	align 16
.noStar:
	mov r10, r13
	mov rdx, -1
	xor r8d, r8d
	jmp .afterStarLoop
	
	
	
	
	
	align 16
_RolData:
	mov r10, rcx
	add rsi, rdi
	
	movzx ecx, byte [rdx]
	mov r9, rdx
	add r10, rdx
	jmp .startLoop
	
	align 16
.pcntNotKeyKeyLen:
	inc rdi
	mov [rdi - 1], al
	
	cmp rdi, rsi
	je .return
	
.loop:
	mov r9, r8
	
.startLoop:
	movzx eax, byte [rdi]
	
	and ecx, 7
	lea r8, [r9 + 1]
	
	rol al, cl
	
	movzx ecx, byte [r9 + 1]
	
	cmp r8, r10
	jne .pcntNotKeyKeyLen
	
	inc rdi
	movzx ecx, byte [rdx]
	mov [rdi - 1], al
	
	cmp rdi, rsi
	je .return
	
	mov r8, rdx
	jmp .loop
	
	align 16
.return:
	ret
	
	
	
	
	
	align 16
_RorData:
	mov r10, rcx
	add rsi, rdi
	
	movzx ecx, byte [rdx]
	mov r9, rdx
	add r10, rdx
	jmp .startLoop
	
	align 16
.pcntNotKeyKeyLen:
	inc rdi
	mov [rdi - 1], al
	
	cmp rdi, rsi
	je .return
	
.loop:
	mov r9, r8
	
.startLoop:
	movzx eax, byte [rdi]
	
	and ecx, 7
	lea r8, [r9 + 1]
	
	ror al, cl
	
	movzx ecx, byte [r9 + 1]
	
	cmp r8, r10
	jne .pcntNotKeyKeyLen
	
	inc rdi
	movzx ecx, byte [rdx]
	mov [rdi - 1], al
	
	cmp rdi, rsi
	je .return
	
	mov r8, rdx
	jmp .loop
	
	align 16
.return:
	ret
	
	
	
	
	
	align 16
_SBMBinSearch:
	cmp r8, 1
	jle .retMin2
	
	multipush rbp, rbx
	sub rsp, 1936
	
	lea r9, [rsp - 120]
	lea rax, [rsp + 1928]
	
.memsetLoop:
	mov [r9], r8
	add r9, 8
	
	cmp rax, r9
	jne .memsetLoop
	
	lea r11, [r8 - 1]
	mov r10, rcx
	mov r9, r11
	
.makeShiftLoop:
	movsx rbx, byte [r10]
	inc r10
	mov [rsp - 120 + rbx * 8], r9
	
	dec r9
	jne .makeShiftLoop
	
	sub rdx, r8
	lea rax, [rsi + rdi]
	mov r10d, 1
	lea rdi, [rsi + rdx]
	
.loop:
	movsx rdx, byte [rax + r9]
	cmp [rcx + r9], dl
	jne .break
	
	dec r9
	cmp r9, -1
	jne .loop
	
	add rsp, 1936
	sub rax, rsi
	multipop rbp, rbx
	ret
	
	align 16
.break:
	add r9, [rsp - 120 + rdx * 8]
	sub r9, r11
	cmovs r9, r10
	
	add rax, r9
	cmp rax, rdi
	jg .retMin1
	
	movzx r9d, byte [rcx + r11]
	jmp .startLoop
	
	align 16
.loop2:
	add rax, [rsp - 120 + rbp * 8]
	cmp rax, rdi
	jg .retMin1
	
.startLoop:
	movsx rbp, byte [rax + r11]
	cmp r9b, bpl
	jne .loop2
	
	lea r9, [r8 - 2]
	jmp .loop
	
	align 16
.retMin1:
	add rsp, 1936
	mov rax, -1
	multipop rbp, rbx
	ret
	
	align 16
.retMin2:
	mov rax, -2
	ret
	
	
	
	
	
	align 16
_StripRangeI:
	jmp .startLoop
	
	align 16
.loop:
	mov [rsi], al
	inc rsi
	
.startLoop:
	mov al, [rdi]
	test al, al
	je .return
	
	inc rdi
	cmp al, dl
	jne .loop
	
.loop2:
	movzx eax, byte [rdi]
	test al, al
	je .return
	
	inc rdi
	cmp al, cl
	jne .loop2
	jmp .startLoop
	
	align 16
.return:
	mov byte [rsi], 0
	ret
	
	
	
	
	
	align 16
_StripLF:
.loop:
	movzx eax, byte [rdi]
	test al, al
	je .return
	
	inc rdi
	cmp al, 13
	jne .return
	
	mov byte [rdi - 1], 0
	
.return:
	ret
	
	
	
	
	
	align 16
_StripRangeX:
	mov al, [rdi]
	test al, al
	jne .startLoop
	jmp .return
	
	align 16
.loop:
	mov [rsi], al
	inc rsi
	
	mov al, [rdi]
	test al, al
	je .return
	
.startLoop:
	inc rdi
	cmp al, dl
	jne .loop
	
	mov [rsi], dl
	
.loop2:
	movzx eax, byte [rdi]
	test al, al
	je .return
	
	inc rdi
	cmp al, cl
	jne .loop2
	
	mov [rsi + 1], cl
	add rsi, 2
	
	mov al, [rdi]
	test al, al
	jne .startLoop
	
.return:
	ret
	
	
	
	
	
	align 16
_szappend:
	sub rsi, rdx
	
.loop:
	movzx ecx, byte [rsi + rdx]
	mov rax, rdx
	mov [rdi + rdx], cl
	inc rdx
	
	test cl, cl
	je .loop
	
	ret
	
	
	
	
	
	align 16
_szCmp:
	mov rax, -1
	
.loop:
	movzx ecx, byte [rdi + rax + 1]
	cmp cl, [rsi + rax + 1]
	jne .ret0
	
	inc rax
	test cl, cl
	jne .loop
	
	ret
	
	align 16
.ret0:
	xor eax, eax
	ret
	
	
	
	
	
	align 16
_szCmpi:
	xor eax, eax
	jmp .startLoop
	
	align 16
.loop:
	cmp rax, rdx
	jnb .ret0
	
.startLoop:
	movsx rcx, byte [rdi + rax]
	inc rax
	movsx r8, byte [rsi + rax - 1]
	movzx r9d, byte [rel szCmpi_tbl + r8]
	cmp [rel szCmpi_tbl + rcx], r9b
	je .loop
	
	ret
	
	align 16
.ret0:
	xor eax, eax
	ret
	
	
	
	
	
	align 16
_szCopy:
	push rbp
	mov rbp, rdi
	mov rdi, rsi
	mov rsi, rbp
	call _strcpy
	
	mov rdi, rbp
	pop rbp
	jmp _strlen
	
	
	
	
	
	align 16
_szLeft:
	mov rcx, rdx
	mov rax, rsi
	lea r8, [rsi + rdx]
	add rdi, rdx
	neg rcx
	
.loop:
	movzx edx, byte [rdi + rcx]
	mov [r8 + rcx], dl
	
	inc rcx
	jne .loop
	
	mov byte [r8], 0
	ret
	
	
	
	
	
	align 16
_szLen:
	jmp _strlen
	
	
	
	
	
	align 16
_szLower:
	mov rax, rdi
	
	mov cl, [rdi]
	test cl, cl
	je .return
	
	lea rdx, [rax + 1]
	
.loop:
	lea esi, [rcx - 65]
	cmp sil, 25
	ja .skip
	
	add cl, 32
	mov [rdx - 1], cl
	
.skip:
	movzx ecx, byte [rdx]
	inc rdx
	test cl, cl
	jne .loop
	
.return:
	ret
	
	
	
	
	
	align 16
_szLtrim:
	push rbp
	mov r8, rsi
	lea rbp, [rdi - 1]
	
.spaceLoop:
	movzx eax, byte [rbp + 1]
	inc rbp
	
	cmp al, 9
	je .spaceLoop
	
	cmp al, 32
	je .spaceLoop
	
	test al, al
	jne .notEnd
	
	xor eax, eax
	mov byte [r8], 0
	pop rbp
	ret
	
	align 16
.notEnd:
	mov rsi, rbp
	mov rdi, r8
	call _strcpy
	
	mov rdi, rbp
	call _strlen
	
	pop rbp
	dec rax
	ret
	
	
	
	
	
	align 16
_szMid:
	mov r8, rcx
	lea rax, [rsi + rcx]
	add rcx, rdx
	neg r8
	add rcx, rdi
	
.loop:
	movzx edx, byte [rcx + r8]
	mov [rax + r8], dl
	
	inc r8
	jne .loop
	
	mov byte [rax], 0
	ret
	
	
	
	
	
	align 16
_szMonoSpace:
	mov rax, rdi
	lea rdi, [rdi - 1]
	mov r9, rax
	
.spaceLoop:
	mov rsi, rdi
	movsx edx, byte [rdi + 1]
	inc rdi
	mov ecx, edx
	
	cmp dl, 32
	je .spaceLoop
	
	cmp edx, 9
	jne .startLoop
	jmp .spaceLoop
	
	align 16
.loop:
	movsx edx, byte [rsi + 1]
	mov r9, r8
	mov ecx, edx
	
.startLoop:
	inc rsi
	
	lea r8, [r9 + 1]
	cmp edx, 32
	je .gotAnotherSpace
	
	cmp edx, 9
	je .gotAnotherSpace
	
	mov [r8 - 1], cl
	
	test edx, edx
	jne .loop
	
	cmp byte [r8 - 2], 32
	je .terminate
	
	ret
	
	align 16
.gotAnotherSpace:
	mov byte [r9], 32
	mov rdi, rsi
	mov r9, r8
	jmp .spaceLoop
	
	align 16
.terminate:
	mov byte [r8 - 2], 0
	ret
	
	
	
	
	
	align 16
_szMultiCat:
	multipush rbp, rbx
	mov r10, rdi
	mov rdi, rsi
	sub rsp, 216
	
	mov [rsp + 48], rdx
	mov [rsp + 56], rcx
	mov [rsp + 64], r8
	mov [rsp + 72], r9
	
	test al, al
	je .noKeepXmm
	
	movaps [rsp + 80], xmm0
	movaps [rsp + 96], xmm1
	movaps [rsp + 112], xmm2
	movaps [rsp + 128], xmm3
	movaps [rsp + 144], xmm4
	movaps [rsp + 160], xmm5
	movaps [rsp + 176], xmm6
	movaps [rsp + 192], xmm7
	
.noKeepXmm:
	lea rax, [rsp + 240]
	lea rdx, [rsp + 32]
	mov dword [rsp + 8], 16
	mov dword [rsp + 12], 48
	lea rbx, [rsp + 8]
	mov [rsp + 16], rax
	lea rbp, [rbx + r10 * 8]
	mov [rsp + 24], rdx
	
.loop:
	mov rsi, [rbx]
	add rbx, 8
	call _strcat
	mov rdi, rax
	
	cmp rbx, rbp
	jne .loop
	
	add rsp, 216
	multipop rbp, rbx
	ret
	
	
	
	
	
	align 16
_szRemove:
	push rbp
	mov rax, rsi
	mov r9, rdx
	mov r8, rax
	
	dec rdi
	mov sil, [r9]
	jmp .startLoop
	
	align 16
.srcNotRemChar:
	inc r8
	
.startLoop:
	inc rdi
	
	mov cl, [rdi]
	cmp cl, sil
	jne .srcNotRemChar
	
	mov dl, [r9]
	
.loop:
	mov bpl, [rdi]
	cmp bpl, dl
	jne .continue
	
	xor ebp, ebp
	
.loop2:
	inc rbp
	
	mov r11b, [rbp + r9]
	test r11b, r11b
	je .continue2
	
	mov r10b, [rbp + rdi]
	cmp r10b, r11b
	je .loop2
	
.continue:
	mov [r8], cl
	test cl, cl
	je .return
	jmp .loop
	
	align 16
.continue2:
	add rdi, rbp
	mov cl, [rdi]
	cmp cl, sil
	je .loop
	jmp .continue
	
	align 16
.return:
	pop rbp
	ret
	
	
	
	
	
	align 16
_szRep:
	multipush r15, r14, r13, r12, rbp, rbx
	mov r14, rcx
	mov r13, rsi
	mov r12, rdi
	mov rbp, rdx
	lea rbx, [r12 - 1]
	
	sub rsp, 8
	call _strlen
	
	mov rdi, rbp
	mov r15, rax
	call _strlen
	
	lea rcx, [r15 + 1]
	sub rcx, rax
	add rcx, r12
	
	cmp r12, rcx
	jl .startLoop
	jmp .return
	
	align 16
.loop:
	mov rbx, r12
	mov [r13], dl
	inc r13
	
	lea r12, [rbx + 1]
	cmp r12, rcx
	jge .return
	
.startLoop:
	movzx edx, byte [rbx + 1]
	movzx r8d, byte [rbp]
	cmp dl, r8b
	jne .loop
	
	mov rax, -1
	jmp .startLoop2
	
	align 16
.loop2:
	inc rbp
	cmp [r12 + rax + 1], r8b
	jne .loop
	
	movzx r8d, byte [rbp]
	mov rax, rsi
	
.startLoop2:
	lea rsi, [rax + 1]
	test r8b, r8b
	jne .loop2
	
	movzx edi, byte [r14]
	test dil, dil
	je .skip
	
.loop3:
	inc r14
	mov [r13], dil
	inc r13
	
	movzx edi, byte [r14]
	test dil, dil
	jne .loop3
	
.skip:
	lea rbx, [r12 + rax]
	lea r12, [rbx + 1]
	cmp r12, rcx
	jl .startLoop
	
.return:
	add rsp, 8
	mov rsi, r12
	mov rdi, r13
	multipop r15, r14, r13, r12, rbp, rbx
	jmp _strcpy
	
	
	
	
	
	align 16
_szRev:
	push r12
	mov r12, rdi
	
	mov rsi, rdi
	mov rdi, r12
	call _stpcpy
	
	mov rdx, r12
	mov rcx, rax
	sub rax, 2
	sub rcx, r12
	
	mov r9, rax
	dec rcx
	shr rcx, 1
	sub r9, rcx
	
.loop:
	movzx esi, byte [rdx]
	movzx edi, byte [rax]
	
	mov [rdx], dil
	mov [rax], sil
	
	dec rax
	inc rdx
	
	cmp rax, r9
	jne .loop
	
	mov rax, r12
	pop r12
	ret
	
	
	
	
	
	align 16
_szRight:
	multipush rbp, r14, rbx
	mov r15, rdx
	mov r14, rsi
	mov rbx, rdi
	
	call _strlen
	sub rax, r15
	lea rsi, [rax + rbx]
	mov rdi, r14
	
	multipop rbp, r14, rbx
	jmp _strcpy
	
	
	
	
	
	align 16
_szRtrim:
	mov rax, rdi
	
	mov cl, [rax]
	cmp cl, 9
	jne .checkSecond
	
.spaceLoop:
	inc rax
	movzx ecx, byte [rax]
	cmp cl, 9
	je .spaceLoop
	
.checkSecond:
	cmp cl, 32
	je .spaceLoop
	
	test cl, cl
	jne .notZero
	
	xor eax, eax
	mov byte [rsi + rax], 0
	ret
	
	align 16
.notZero:
	mov ecx, 1
	xor edx, edx
	
.loop:
	mov rax, rdx
	movzx r8d, byte [rdi + rcx - 1]
	
	cmp r8b, 32
	cmova rdx, rcx
	
	mov byte [rsi + rcx - 1], r8b
	inc rcx
	
	test r8b, r8b
	jne .loop
	
	mov byte [rsi + rax], 0
	ret
	
	
	
	
	
	align 16
_szTrim:
	lea rax, [rdi - 1]
	
.spaceLoop:
	movzx edx, byte [rax + 1]
	inc rax
	
	cmp dl, 9
	je .spaceLoop
	
	cmp dl, 32
	je .spaceLoop
	
	test dl, dl
	jne .notZero
	
	mov byte [rdi], 0
	
.ret0:
	xor eax, eax
	ret
	
	align 16
.notZero:
	movzx ecx, byte [rax]
	mov [rdi], cl
	test cl, cl
	jne .notZero
	jmp .ret0
	
	
	
	
	
	align 16
_szUpper:
	sub rsp, 24
	
	mov rax, rdi
	cmp byte [rdi], 0
	je .return
	
	mov [rsp], rbx
	mov rbx, rdi
	mov [rsp + 8], rbp
	mov rbp, rax
	
.loop:
	movsx edi, byte [rbp]
	call _islower
	
	test eax, eax
	je .skip
	
	movsx edi, byte [rbp]
	call _toupper
	
	mov [rbp], al
	
.skip:
	inc rbp
	cmp byte [rbp], 0
	jne .loop
	
	mov rbp, [rsp + 8]
	mov rdi, rbx
	mov rbx, [rsp]
	
.return:
	mov rax, rdi
	add rsp, 24
	ret
	
	
	
	
	
	align 16
_tstline:
	lea rax, [rdi - 1]
	
.spaceLoop:
	movzx edx, byte [rax + 1]
	inc rax
	
	cmp dl, 9
	je .spaceLoop
	
	cmp dl, 32
	je .spaceLoop
	
	cmp dl, 31
	mov ecx, nullptr
	cmovle rax, rcx
	ret
	
	
	
	
	
	align 16
_ucappend:
	xor eax, eax
	add rdi, rdx
	
.loop:
	mov ecx, [rsi + rax * 4]
	mov [rdi + rax * 4], ecx
	inc rax
	test ecx, ecx
	jne .loop
	
	lea rax, [rdx - 4 + rax * 4]
	ret
	
	
	
	
	
	align 16
_ucCatStr:
	push rax
	call _wcscat
	
	xor eax, eax
	pop rcx
	ret
	
	
	
	
	
	align 16
_ucCmp:
	mov rcx, -1
	xor eax, eax
	
.loop:
	mov edx, [rdi + rcx * 4 + 4]
	cmp edx, [rsi + rcx * 4 + 4]
	jne .return
	
	inc rcx
	test edx, edx
	jne .loop
	
	mov rax, 0x3FFFFFFFFFFFFFFF
	and rcx, rax
	mov rax, rcx
	
.return:
	ret
	
	
	
	
	
	align 16
_ucCopy:
	mov rax, rdi
	mov rdi, rsi
	mov rsi, rax
	jmp _wcscpy
	
	
	
	
	
	align 16
_ucLeft:
	multipush rbp, rbx
	mov rbp, rdx
	mov rbx, rsi
	mov rsi, rdi
	mov rdi, rbx
	sub rsp, 8
	call _wmemcpy
	
	mov dword [rbx + rbp * 4], 0
	
	add rsp, 8
	multipop rbp, rbx
	ret
	
	
	
	
	
	align 16
_ucLen:
	jmp _wcslen
	
	
	
	
	
	align 16
_ucMultiCat:
	multipush r12, rbp, rbx
	mov r12, rsi
	sub rsp, 208
	
	mov [rsp + 48], rdx
	mov [rsp + 56], rcx
	mov [rsp + 64], r8
	mov [rsp + 72], r9
	
	test al, al
	je .noKeepXmm
	
	movaps [rsp + 80], xmm0
	movaps [rsp + 96], xmm1
	movaps [rsp + 112], xmm2
	movaps [rsp + 128], xmm3
	movaps [rsp + 144], xmm4
	movaps [rsp + 160], xmm5
	movaps [rsp + 176], xmm6
	movaps [rsp + 192], xmm7
	
.noKeepXmm:
	lea rax, [rsp + 240]
	lea rdx, [rsp + 32]
	mov dword [rsp + 8], 16
	mov dword [rsp + 12], 48
	lea rbx, [rsp + 8]
	mov [rsp + 16], rax
	lea rbp, [rbx + rdi * 8]
	mov [rsp + 24], rdx
	
.loop:
	mov rsi, [rbx]
	mov rdi, r12
	add rbx, 8
	call _strcat
	mov rdi, rax
	
	cmp rbx, rbp
	jne .loop
	
	add rsp, 208
	mov rax, r12
	multipop r12, rbp, rbx
	ret
	