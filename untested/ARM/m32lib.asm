
	include 'macros.inc'

    code32

    format  ELF
	public _a2dw
	public _arr2mem
	public _arr2text
	public _arr_add
	public _arrcnt
	public _arrget
	public _arrlen
	public _arr_mul
	public _arr_sub
	public _arrtotal
	public _atodw
	public _atol
	public _byt2bin_ex
	public _BMBinSearch
	public _BinSearch
	public _Cmpi
	public _CombSortA
	public _CombSortD
	public _decomment
	public _dissort
	public _dw2ah
	public _dw2bin_ex
	public _dw2hex_ex
	public _dwtoa
	public _get_line_count
	public _get_ml
	public _GetPercent
	public _GetPathOnly
	public _htodw
	public _InString
;	public _IntDiv
;	public _IntMul
;	public _IntSqrt
	public _isalpha
	public _isalphanum
	public _islower
	public _isnumber
	public _isupper
	public _lfcnt
	public _MemCopy
	public _memfill
	public _NameFromPath
	public _nrandom
	public _nseed
	public _parse_line
	public _partial
	public _RolData
	public _RorData
	public _SBMBinSearch
	public _StripRangeI
	public _StripLF
	public _StripRangeX
	public _szappend
	public _szCmp
	public _szCmpi
	public _szCopy
	public _szLeft
	public _szLen
	public _szLower
	public _szLtrim
	public _szMid
	public _szMonoSpace
;	public _szMultiCat
	public _szRemove
	public _szRep
	public _szRev
	public _szRight
	public _szRtrim
	public _szTrim
	public _szUpper
	public _tstline
	public _ucappend
	public _ucCatStr
	public _ucCmp
	public _ucCopy
	public _ucLeft
	public _ucLen
;	public _ucMultiCat

	extrn _memcpy
	extrn _memset
	extrn _stpcpy
	extrn _strcat
	extrn _strcpy
	extrn _strlen
	extrn _tolower
	extrn _toupper
	extrn _wcscat
	extrn _wcscpy
	extrn _wcslen
	extrn _wmemcpy
	
section '.rodata' align 16

	align 16
	bintable dw '0000', '0000', '0000', '1000', '0000', '0100', '0000', '1100', '0000', '0010', '0000', '1010', '0000', '0110', '0000', '1110', '0000', '0001', '0000', '1001', '0000', '0101', '0000', '1101', '0000', '0011', '0000', '1011', '0000', '0111', '0000', '1111', '1000', '0000', '1000', '1000', '1000', '0100', '1000', '1100', '1000', '0010', '1000', '1010', '1000', '0110', '1000', '1110', '1000', '0001', '1000', '1001', '1000', '0101', '1000', '1101', '1000', '0011', '1000', '1011', '1000', '0111', '1000', '1111', '0100', '0000', '0100', '1000', '0100', '0100', '0100', '1100', '0100', '0010', '0100', '1010', '0100', '0110', '0100', '1110', '0100', '0001', '0100', '1001', '0100', '0101', '0100', '1101', '0100', '0011', '0100', '1011', '0100', '0111', '0100', '1111', '1100', '0000', '1100', '1000', '1100', '0100', '1100', '1100', '1100', '0010', '1100', '1010', '1100', '0110', '1100', '1110', '1100', '0001', '1100', '1001', '1100', '0101', '1100', '1101', '1100', '0011', '1100', '1011', '1100', '0111', '1100', '1111', '0010', '0000', '0010', '1000', '0010', '0100', '0010', '1100', '0010', '0010', '0010', '1010', '0010', '0110', '0010', '1110', '0010', '0001', '0010', '1001', '0010', '0101', '0010', '1101', '0010', '0011', '0010', '1011', '0010', '0111', '0010', '1111', '1010', '0000', '1010', '1000', '1010', '0100', '1010', '1100', '1010', '0010', '1010', '1010', '1010', '0110', '1010', '1110', '1010', '0001', '1010', '1001', '1010', '0101', '1010', '1101', '1010', '0011', '1010', '1011', '1010', '0111', '1010', '1111', '0110', '0000', '0110', '1000', '0110', '0100', '0110', '1100', '0110', '0010', '0110', '1010', '0110', '0110', '0110', '1110', '0110', '0001', '0110', '1001', '0110', '0101', '0110', '1101', '0110', '0011', '0110', '1011', '0110', '0111', '0110', '1111', '1110', '0000', '1110', '1000', '1110', '0100', '1110', '1100', '1110', '0010', '1110', '1010', '1110', '0110', '1110', '1110', '1110', '0001', '1110', '1001', '1110', '0101', '1110', '1101', '1110', '0011', '1110', '1011', '1110', '0111', '1110', '1111', '0001', '0000', '0001', '1000', '0001', '0100', '0001', '1100', '0001', '0010', '0001', '1010', '0001', '0110', '0001', '1110', '0001', '0001', '0001', '1001', '0001', '0101', '0001', '1101', '0001', '0011', '0001', '1011', '0001', '0111', '0001', '1111', '1001', '0000', '1001', '1000', '1001', '0100', '1001', '1100', '1001', '0010', '1001', '1010', '1001', '0110', '1001', '1110', '1001', '0001', '1001', '1001', '1001', '0101', '1001', '1101', '1001', '0011', '1001', '1011', '1001', '0111', '1001', '1111', '0101', '0000', '0101', '1000', '0101', '0100', '0101', '1100', '0101', '0010', '0101', '1010', '0101', '0110', '0101', '1110', '0101', '0001', '0101', '1001', '0101', '0101', '0101', '1101', '0101', '0011', '0101', '1011', '0101', '0111', '0101', '1111', '1101', '0000', '1101', '1000', '1101', '0100', '1101', '1100', '1101', '0010', '1101', '1010', '1101', '0110', '1101', '1110', '1101', '0001', '1101', '1001', '1101', '0101', '1101', '1101', '1101', '0011', '1101', '1011', '1101', '0111', '1101', '1111', '0011', '0000', '0011', '1000', '0011', '0100', '0011', '1100', '0011', '0010', '0011', '1010', '0011', '0110', '0011', '1110', '0011', '0001', '0011', '1001', '0011', '0101', '0011', '1101', '0011', '0011', '0011', '1011', '0011', '0111', '0011', '1111', '1011', '0000', '1011', '1000', '1011', '0100', '1011', '1100', '1011', '0010', '1011', '1010', '1011', '0110', '1011', '1110', '1011', '0001', '1011', '1001', '1011', '0101', '1011', '1101', '1011', '0011', '1011', '1011', '1011', '0111', '1011', '1111', '0111', '0000', '0111', '1000', '0111', '0100', '0111', '1100', '0111', '0010', '0111', '1010', '0111', '0110', '0111', '1110', '0111', '0001', '0111', '1001', '0111', '0101', '0111', '1101', '0111', '0011', '0111', '1011', '0111', '0111', '0111', '1111', '1111', '0000', '1111', '1000', '1111', '0100', '1111', '1100', '1111', '0010', '1111', '1010', '1111', '0110', '1111', '1110', '1111', '0001', '1111', '1001', '1111', '0101', '1111', '1101', '1111', '0011', '1111', '1011', '1111', '0111', '1111', '1111'
	
	align 16
	Cmpi_tbl db 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 97, 98, 99,100,101,102,103,104,105,106,107,108,109,110,111, 112,113,114,115,116,117,118,119,120,121,122, 91, 92, 93, 94, 95, 96, 97, 98, 99,100,101,102,103,104,105,106,107,108,109,110,111, 112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127, 128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143, 144,145,146,147,148,149,150,151,152,153,154,155,156,156,158,159, 160,161,162,163,164,165,166,167,168,169,170,171,172,173,173,175, 176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191, 192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207, 208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223, 224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239, 240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255
	
	align 16
	hex_table dw '00', '10', '20', '30', '40', '50', '60', '70', '80', '90', 'A0', 'B0', 'C0', 'D0', 'E0', 'F0', '01', '11', '21', '31', '41', '51', '61', '71', '81', '91', 'A1', 'B1', 'C1', 'D1', 'E1', 'F1', '02', '12', '22', '32', '42', '52', '62', '72', '82', '92', 'A2', 'B2', 'C2', 'D2', 'E2', 'F2', '03', '13', '23', '33', '43', '53', '63', '73', '83', '93', 'A3', 'B3', 'C3', 'D3', 'E3', 'F3', '04', '14', '24', '34', '44', '54', '64', '74', '84', '94', 'A4', 'B4', 'C4', 'D4', 'E4', 'F4', '05', '15', '25', '35', '45', '55', '65', '75', '85', '95', 'A5', 'B5', 'C5', 'D5', 'E5', 'F5', '06', '16', '26', '36', '46', '56', '66', '76', '86', '96', 'A6', 'B6', 'C6', 'D6', 'E6', 'F6', '07', '17', '27', '37', '47', '57', '67', '77', '87', '97', 'A7', 'B7', 'C7', 'D7', 'E7', 'F7', '08', '18', '28', '38', '48', '58', '68', '78', '88', '98', 'A8', 'B8', 'C8', 'D8', 'E8', 'F8', '09', '19', '29', '39', '49', '59', '69', '79', '89', '99', 'A9', 'B9', 'C9', 'D9', 'E9', 'F9', '0A', '1A', '2A', '3A', '4A', '5A', '6A', '7A', '8A', '9A', 'AA', 'BA', 'CA', 'DA', 'EA', 'FA', '0B', '1B', '2B', '3B', '4B', '5B', '6B', '7B', '8B', '9B', 'AB', 'BB', 'CB', 'DB', 'EB', 'FB', '0C', '1C', '2C', '3C', '4C', '5C', '6C', '7C', '8C', '9C', 'AC', 'BC', 'CC', 'DC', 'EC', 'FC', '0D', '1D', '2D', '3D', '4D', '5D', '6D', '7D', '8D', '9D', 'AD', 'BD', 'CD', 'DD', 'ED', 'FD', '0E', '1E', '2E', '3E', '4E', '5E', '6E', '7E', '8E', '9E', 'AE', 'BE', 'CE', 'DE', 'EE', 'FE', '0F', '1F', '2F', '3F', '4F', '5F', '6F', '7F', '8F', '9F', 'AF', 'BF', 'CF', 'DF', 'EF', 'FF'
	
	align 16
	ctbl db true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, true, true, false, true, false, false, true, true, true, true, true, true, true, true, true, true, true, false, false, false, false, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false, true, false, true, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false
	
	align 16
	szCmpi_tbl db 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 46, 45, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, -128, -127, -126, -125, -124, -123, -122, -121, -120, -119, -118, -117, -116, -115, -114, -113, -112, -111, -110, -109, -108, -107, -106, -105, -104, -103, -102, -101, -100, -100, -98, -97, -96, -95, -94, -93, -92, -91, -90, -89, -88, -87, -86, -85, -84, -83, -83, -81, -80, -79, -78, -77, -76, -75, -74, -73, -72, -71, -70, -69, -68, -67, -66, -65, -64, -63, -62, -61, -60, -59, -58, -57, -56, -55, -54, -53, -52, -51, -50, -49, -48, -47, -46, -45, -44, -43, -42, -41, -40, -39, -38, -37, -36, -35, -34, -33, -32, -31, -30, -29, -28, -27, -26, -25, -24, -23, -22, -21, -20, -19, -18, -17, -16, -15, -14, -13, -12, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1
	
section '.data' writeable align 16

	align 16
	nrandom_seed dw 12345678
	
section '.text' executable align 16

getSpacesEnd:
	sub r0, #1

.loop:
	ldrb r3, [r0, #1]!
	cmp r3, #9
	cmpne r3, #32
	beq .loop
	
	bx lr

	
	
	
	
_a2dw:
	push {r4, r5, r6, lr}
	
	subs r5, r0, #0
	beq .ret0
	
	bl _strlen
	
	subs r1, r0, #0
	beq .ret0
	
	ldrb r3, [r5]
	sub r0, r3, #48
	and r0, #0xFF
	
	subs r1, #1
	
	beq .finish
	
.loop:
	mov r2, r1
	
.loop2:
	add ip, r0, r0, lsl #2
	lsl r0, ip, #2
	
	subs r2, #1
	bne .loop2
	
	add r4, r0
	
	ldrb lr, [r5, #1]!
	sub r3, lr, #48
	and r0, r3, #0xFF
	
	subs r1, #1
	bne .loop
	
.finish:
	add r0, r4, r0
	pop {r4, r5, r6, pc}
	
.ret0:
	mov r0, #0
	pop {r4, r5, r6, pc}
	
	
	
	
	
_arr2mem:
	push {r4, r5, r6, r7, r8, lr}
	mov r7, r0
	mov r5, r1
	
	bl _arrcnt
	mov r8, r0
	
	mov r4, #1
	
.loop:
	mov r1, r4
	mov r0, r7
	bl _arrlen
	mov r6, r0
	
	mov r1, r4
	mov r0, r7
	bl _arrget
	
	mov r2, r6
	mov r1, r5
	bl _MemCopy
	
	add r4, #1
	
	add r5, r6
	cmp r8, r4
	bge .loop
	
	mov r0, r5
	pop {r4, r5, r6, r7, r8, pc}
	
	
	
	
	
_arr2text:
	push {r4, r5, r6, r7, r8, r9, r10, lr}
	mov r10, r0
	mov r6, r1
	
	bl _arrcnt
	mov r7, r0
	
	mov r5, #1
	mov r4, #0
	mov r9, #13
	mov r8, #10
	
.loop:
	mov r1, r5
	mov r0, r10
	bl _arrget
	
	mov r2, r4
	mov r1, r0
	mov r0, r6
	bl _szappend
	
	add r3, r6, r0
	strb r9, [r6, r0]
	strb r8, [r3, #1]
	
	add r4, r0, #2
	add r5, #1
	
	cmp r7, r5
	bge .loop
	
	mov r0, r7
	pop {r4, r5, r6, r7, r8, r9, r10, pc}
	
	
	
	
	
_arr_add:
	mov r3, r0
	add r0, r1, lsl #2
	rsb r1, r1, lsl #30
	lsls r1, #2
	bxeq lr
	
.loop:
	ldr ip, [r3]
	add r1, ip, r2
	str r1, [r3], #4
	
	cmp r0, r3
	bne .loop
	
	bx lr
	
	
	
	
	
_arrcnt:
	ldr r0, [r0]
	bx lr
	
	
	
	
	
_arr_mul:
	mov r3, r0
	add r0, r1, lsl #2
	rsb r1, r1, lsl #30
	lsls r1, #2
	bxeq lr
	
.loop:
	ldr ip, [r3]
	mul r1, r2, ip
	str r1, [r3], #4
	
	cmp r0, r3
	bne .loop
	
	bx lr
	
	
	
	
	
_arr_sub:
	mov r3, r0
	add r0, r1, lsl #2
	rsb r1, r1, lsl #30
	lsls r1, #2
	bxeq lr
	
.loop:
	ldr ip, [r3]
	sub r1, ip, r2
	str r1, [r3], #4
	
	cmp r0, r3
	bne .loop
	
	bx lr
	
	
	
	
	
_arrget:
	cmp r1, #0
	ble .retMin1
	
	ldr r3, [r0]
	cmp r3, r1
	bge .retArrIndx
	
	mvn r0, #1
	bx lr
	
.retArrIndx:
	ldr r0, [r0, r1, lsl #2]
	bx lr
	
.retMin1:
	mvn r0, #0
	bx lr
	
	
	
	
	
_arrlen:
	ldr r3, [r0, r1, lsl #2]
	ldr r0, [r3, #-4]
	bx lr
	
	
	
	
	
_arrtotal:
	str lr, [sp, #-4]!
	ldr lr, [r0]
	
	mov r2, r0
	mov r3, #1
	mov r0, #0
	
.loop:
	add r3, #1
	ldr ip, [r2, #4]!
	ldr ip, [ip, #-4]
	add r0, ip
	
	cmp r3, lr
	ble .loop
	
	cmp r1, #0
	addne r0, lr, lsl #1
	ldr pc, [sp], #4
	
	
	
	
	
_atodw:
	ldrb r3, [r0]
	cmp r3, #2
	
	addne r2, r0, #1
	movne r1, #0
	
	ldrbeq r3, [r0, #1]
	addeq r2, r0, #2
	mvneq r1, #0
	
	cmp r3, #0
	beq .retR3
	
	mov r0, #0
	
.loop:
	add r0, r0, lsl #2
	sub r3, #48
	and ip, r3, #0xFF
	add r0, ip, r0, lsl #1
	
	ldrb r3, [r2], #1
	
	cmp r3, #0
	bne .loop
	
	add r2, r0, r1
	eor r0, r2, r1
	bx lr
	
.retR3:
	mov r0, r3
	bx lr
	
	
	
	
	
_atol:
	ldrb r3, [r0]
	cmp r3, #45
	beq .itsNeg
	
	sub r1, r3, #48
	cmp r3, #47
	bls .ret0
	
	add r2, r0, #1
	mov ip, #0
	
.start:
	mov r0, #0
	
.loop:
	add r0, r0, lsl #2
	add r0, r1, r0, lsl #1
	
	ldrb r3, [r2], #1
	
	sub r1, r3, #48
	
	cmp r3, #47
	bhi .loop
	
	cmp ip, #0
	rsbne r0, #0
	bx lr
	
.itsNeg:
	ldrb r3, [r0, #1]
	add r2, r0, #2
	sub r1, r3, #48
	cmp r3, #47
	movhi ip, #1
	bhi .start
	
.ret0:
	mov r0, #0
	bx lr
	
	
	
	
	
_byt2bin_ex:
	lsl r3, r0, #1
	ldr r2, [.ptrBintable]
	ldr ip, [r2, r3, lsl #2]
	str ip, [r1]
	
	add r3, #1
	ldr r2, [r2, r3, lsl #2]
	str r2, [r1, #4]
	
	mov ip, #0
	strb ip, [r1, #8]
	bx lr
	
.ptrBintable:
	dw bintable
	
	
	
	
	
_BMBinSearch:
	push {r4, r5, r6, r7, r8, r9, lr}
	sub sp, #1024
	sub sp, #4
	ldr r4, [sp, #1056]
	
	cmp r4, #1
	ble .retMin2
	
	mov ip, sp
	
.memsetLoop:
	str r4, [ip]
	str r4, [ip, #4]
	add lr, sp, #1024
	add ip, #8
	
	cmp ip, lr
	bne .memsetLoop
	
	sub r5, r4, #1
	mov ip, r5
	mov r6, r3
	
.makeShiftTblLoop:
	ldrb lr, [r6], #1
	add r7, sp, #1024
	add lr, r7, lr, lsl #2
	str ip, [lr, #-1024]
	
	subs ip, #1
	bne .makeShiftTblLoop
	
	sub r2, r4
	mov ip, r5
	ldr r8, [sp]
	add r7, r1, r2
	add r0, r1, r0
	b .startLoop
	
.loop:
	add r2, ip, #1
	add r0, r2
	
	cmp r0, r7
	bgt .retMin1
	
.startLoop:
	ldrb lr, [r3, ip]
	ldrb r2, [r0, ip]
	add r6, r0, ip
	
	cmp lr, r2
	add lr, r3, ip
	beq .equal
	
	add lr, sp, #0x400
	add r2, lr, r2, lsl #2
	ldr r2, [r2, #-0x400]
	
	cmp r4, r2
	beq .loop
	
	mov ip, r5
	add r0, r2

.check:
	cmp r0, r7
	ble .startLoop
	
.retMin1:
	mvn r0, #0
	add sp, #1024
	add sp, #4
	pop {r4, r5, r6, r7, r8, r9, pc}
	
.equal:
	mov r2, lr
	sub ip, #1
	b .skip
	
.loop2:
	subs ip, #1
	bmi .subAndRet
	
.skip:
	ldrb r9, [r2, #-1]!
	ldrb lr, [r6, #-1]!
	cmp r9, lr
	beq .loop2
	
	cmp r4, r8
	beq .loop
	
	add ip, r8
	
	subs r2, ip, r5
	movmi r2, #1
	mov ip, r5
	add r0, r2
	b .check
	
.subAndRet:
	sub r0, r1
	
.return:
	add sp, #1024
	add sp, #4
	pop {r4, r5, r6, r7, r8, r9, pc}
	
.retMin2:
	mvn r0, #1
	b .return
	
	
	
	
	
_BinSearch:
	push {r4, r5, r6, r7, r8, r9, lr}
	ldr r5, [sp, #28]
	
	subs r2, r5
	bmi .retMin2
	
	cmp r2, r0
	blt .retMin3
	
	sub r5, #1
	add r2, r1, r2
	add r0, r1, r0
	b .startLoop
	
.loop:
	mov r0, lr
	
.startLoop:
	cmp r0, r2
	bgt .retMin1
	
	mov lr, r0
	ldrb ip, [r3]
	ldrb r4, [lr], #1
	cmp r4, ip
	bne .loop
	
	sub r9, r0, #1
	mov ip, r9
	sub r4, r3, #1
	
.loop2:
	ldrb r7, [ip, #1]
	ldrb r6, [r4, #1]!
	sub r8, ip, r9
	cmp r7, r6
	add ip, #1
	bne .loop
	
	cmp r5, r8
	bne .loop2
	
	sub r0, r1
	pop {r4, r5, r6, r7, r8, r9, pc}
	
.retMin3:
	mvn r0, #2
	pop {r4, r5, r6, r7, r8, r9, pc}
	
.retMin2:
	mvn r0, #1
	pop {r4, r5, r6, r7, r8, r9, pc}
	
.retMin1:
	mvn r0, #0
	pop {r4, r5, r6, r7, r8, r9, pc}
	
	
	
	
	
_Cmpi:
	ldr ip, [.cmpiTblPtr]
	
	push {r4, lr}
	sub r1, #1
	sub r3, r0, #1
	rsb r4, r0, #2
	
.loop:
	add r0, r4, r3
	
	ldrb r2, [r1, #1]!
	ldrb lr, [r3, #1]!
	ldrb r2, [ip, r2]
	ldrb lr, [ip, lr]
	
	cmp r2, lr
	popne {r4, pc}
	
	cmp r2, #0
	bne .loop
	
	mov r0, r2
	pop {r4, pc}

.cmpiTblPtr:
	dw Cmpi_tbl
	
	
	
	
	
CombSortCore:
	push {r4, r5, r6, r7, r8, r9, r10, fp, lr}
	sub sp, #12
	str r1, [sp]
	mov r8, r1
	sub r9, r0, #4
	sub r3, r1, #2
	str r3, [sp, #4]
	
.loop:
	asr r7, r8, #31
	lsl ip, r7, #2
	lsl r3, r8, #2
	orr r1, ip, r8, lsr #30
	
	adds r3, r8
	adc r1, r7
	
	adds r4, r3, r3
	adc r5, r1, r1
	
	cmp r5, #0
	cmpeq r4, #12
	bls .less
	
	mov r3, #0
	
.quotLoop:
	subs r4, #13
	sbc r5, #0
	
	adds r3, #1
	
	cmp r5, #0
	cmpeq r4, #12
	bhi .quotLoop
	
	mov r8, r3
	cmp r3, #1
	bne .notEq
	
	ldr r7, [sp, #4]
	
.skipDiv:
	mov lr, r9
	sub ip, r8, #-0x3FFFFFFF
	add ip, r0, ip, lsl #2
	cmp r2, #0
	bne .zeroAndStuff
	
	mov r1, r2
	mov r6, r2
	
.loop2:
	ldr fp, [lr, #4]!
	ldr r10, [ip, #4]!
	cmp r10, fp
	strgt fp, [ip]
	strgt r10, [lr]
	addgt r6, #1
	
	cmp r1, r7
	ble .loop2
	
	cmp r6, #0
	movne r3, #0
	cmp r3, #0
	beq .loop
	
.return:
	add sp, #12
	pop {r4, r5, r6, r7, r8, r9, r10, fp, pc}
	
.zeroAndStuff:
	mov r1, #0
	mov r6, r1
	
.differentLoop2:
	ldr fp, [lr, #4]!
	ldr r10, [ip, #4]!
	cmp fp, r10
	strgt fp, [ip]
	strgt r10, [lr]
	addgt r6, #1
	add r1, #1
	cmp r1, r7
	ble .differentLoop2
	
	cmp r6, #0
	movne r3, #0
	cmp r3, #0
	beq .loop
	b .return
	
.less:
	ldr r7, [sp]
	mov r3, #1
	
	mvn r8, #0
	b .skipDiv
	
.notEq:
	sub r8, r3, #1
	ldr r1, [sp]
	sub r7, r1, r3
	cmp r8, #1
	movgt r3, #0
	movle r3, #1
	b .skipDiv
	
	
	
	
	
_CombSortA:
	mov r2, #0
	b CombSortCore
	
	
	
	
	
_CombSortD:
	mov r2, #1
	b CombSortCore
	
	
	
	
	
_decomment:
	mvn r3, #0
	mov r1, #0
	rsb ip, r0, #1
	
.spaceLoop:
	add r3, #1
	ldrb r2, [r0, r3]
	cmp r2, #9
	cmpne r2, #32
	beq .spaceLoop
	
	cmp r2, #0
	beq .retR2
	
	cmp r2, #34
	beq .gotQuotes
	
	cmp r2, #39
	beq .gotBackslash
	
	cmp r2, #59
	beq .gotSemicolon
	
	mov r1, r3
	b .spaceLoop
	
.gotQuotes:
	add r3, r0, r3
	b .startLoop
	
.loop:
	cmp r2, #34
	beq .movR3R1Loop
	
.startLoop:
	add r1, ip, r3
	ldrb r2, [r3, #1]!
	cmp r2, #0
	bne .loop
	
	mvn r0, #0
	bx lr
	
.movR3R1Loop:
	mov r3, r1
	b .spaceLoop
	
.gotBackslash:
	add r3, r0, r3
	beq .skipFirst
	
.loop2:
	cmp r2, #39
	beq .movR3R1Loop
	
.skipFirst:
	add r1, ip, r3
	ldrb r2, [r3, #1]!
	cmp r2, #0
	bne .loop2
	
	mvn r0, #0
	bx lr
	
.retR2:
	mov r0, r2
	bx lr
	
.gotSemicolon:
	add r3, r0, r1
	mov r2, #0
	strb r2, [r3, #1]
	
	ldrb r2, [r0, r1]
	cmp r2, #44
	beq .ret1
	
	sub r3, r2, #92
	rsbs r0, r3, #0
	adc r0, r3
	bx lr
	
.ret1:
	mov r0, #1
	bx lr
	
	
	
	
	
_dissort:
	cmp r1, #1
	bxle lr
	
	push {r4, r5, r6, r7, r8, r9, r10, lr}
	mov r4, r0
	sub r10, r0, #4
	add r10, r1, lsl #2
	
	mov r7, #1
	
.loop:
	ldr r8, [r4, #4]!
	mov r5, r4
	mov lr, r7
	sub r9, r8, #1
	
.inner:
	ldr r6, [r5, #-4]
	sub r1, r6, #1
	mov r2, r9
	b .startLoop2
	
.loop2:
	bhi .higher
	
	cmp r3, #0
	beq .equal
	
.startLoop2:
	ldrb r3, [r1, #1]!
	ldrb ip, [r2, #1]!
	
	cmp ip, r3
	bcs .loop2
	
.equal:
	add lr, r0, lr, lsl #2
	
.return:
	str r8, [lr]
	add r7, #1
	
	cmp r10, r4
	bne .loop
	
	pop {r4, r5, r6, r7, r8, r9, r10, pc}
	
.higher:
	str r6, [r5], #-4
	subs lr, #1
	bne .inner
	
	mov lr, r0
	b .return
	
	
	
	
	
_dw2ah:
	mov r3, #72
	strb r3, [r1, #8]
	mov r3, #0
	strb r3, [r1, #9]
	
	and r3, r0, #0xF
	cmp r3, #9
	addhi r3, #55
	addls r3, #48
	strb r3, [r1, #7]
	ror r3, r0, #4
	
	and r3, #0xF
	cmp r3, #9
	addhi r3, #55
	addls r3, #48
	strb r3, [r1, #6]
	ror r3, r0, #8
	
	and r3, #0xF
	cmp r3, #9
	addhi r3, #55
	addls r3, #48
	strb r3, [r1, #5]
	ror r3, r0, #12
	
	and r3, #0xF
	cmp r3, #9
	addhi r3, #55
	addls r3, #48
	strb r3, [r1, #4]
	ror r3, r0, #16
	
	and r3, #0xF
	cmp r3, #9
	addhi r3, #55
	addls r3, #48
	strb r3, [r1, #3]
	ror r3, r0, #20
	
	and r3, #0xF
	cmp r3, #9
	addhi r3, #55
	addls r3, #48
	strb r3, [r1, #2]
	ror r3, r0, #24
	
	and r3, #0xF
	cmp r3, #9
	addhi r3, #55
	addls r3, #48
	strb r3, [r1, #1]
	
	lsr r0, #28
	cmp r0, #9
	addhi r0, #55
	addls r0, #48
	strb r0, [r1]
	bx lr
	
	
	
	
	
_dw2bin_ex:
	lsr r3, r0, #24
	ldr ip, [.bintablePtr]
	
	add r3, ip, r3, lsl #3
	ldmia r3, {r2-r3}
	stm r1, {r2-r3}
	
	lsr r3, r0, #16
	and r3, 0xFF
	lsl r3, #1
	ldr r2, [ip, r3, lsl #2]
	str r2, [r1, #8]
	
	add r3, #1
	ldr r3, [ip, r3, lsl #2]
	str r3, [r1, #12]
	
	lsr r3, r0, #8
	
	and r3, #0xFF
	lsl r3, #1
	ldr r2, [ip, r3, lsl #2]
	str r2, [r1, #16]
	
	add r3, #1
	ldr r3, [ip, r3, lsl #2]
	str r3, [r1, #20]
	
	and r0, #0xFF
	lsl r0, #1
	ldr r3, [ip, r0, lsl #2]
	str r3, [r1, #24]
	
	add r0, #1
	ldr r3, [ip, r0, lsl #2]
	str r3, [r1, #28]
	
	mov r3, #0
	strb r3, [r1, #32]
	
	bx lr

.bintablePtr:
	dw bintable
	
	
	
	
	
_dw2hex_ex:
	sub sp, #8
	
	and r2, r0, #0xFF
	ldr r3, [.hexTablePtr]
	ldr r2, [r3, r2, lsl #1]
	lsl r2, #16
	str r2, [sp, #4]
	
	lsr r2, r0, #8
	and r2, #255
	add ip, r3, r2, lsl #1
	ldrb r2, [r3, r2, lsl #1]
	ldrb ip, [ip, #1]
	orr r2, ip, lsl #8
	strb r2, [sp, #4]
	asr r2, #8
	strb r2, [sp, #5]
	
	ldr r2, [sp, #4]
	str r2, [r1, #4]
	
	lsr r2, r0, #16
	and r2, #255
	ldr r2, [r3, r2, lsl #1]
	lsl r2, #16
	str r2, [sp, #4]
	
	lsr r0, #24
	add r2, r3, r0, lsl #1
	ldrb r3, [r3, r0, lsl #1]
	ldrb r2, [r2, #1]
	orr r3, r2, lsl #8
	strb r3, [sp, #4]
	asr r3, #8
	strb r3, [sp, #5]
	
	ldr r3, [sp, #4]
	str r3, [r1]
	mov r3, #0
	strb r3, [r1, #8]
	
	add sp, #8
	bx lr
	
.hexTablePtr:
	dw hex_table
	
	
	
	
	
_dwtoa:
	cmp r0, #0
	bne .notZero
	
	mov r3, #48
	strb r3, [r1]
	strb r0, [r1, #1]
	bx lr
	
.notZero:
	push {r4, r5, r6, lr}
	sub sp, #8
	blt .negative
	
.afterNeg:
	mov ip, r1
	
.loop:
	asr r5, r0, #31
	
	adds r3, r0, r0
	adc r2, r5, r5
	
	adds r3, r0
	adc r2, r5
	
	lsr lr, r2, #4
	orr lr, r3, lsr #28
	lsr r6, r3, #4
	
	adds r3, r6
	adc r2, lr
	
	lsr lr, r2, #8
	orr lr, r3, lsr #24
	
	lsl r6, r3, #8
	adds r3, r6
	adc r2, lr
	
	lsl lr, r2, #16
	orr lr, r3, lsr #16
	lsl r6, r3, #16
	
	adds r3, r6
	adc r2, lr
	
	adds r3, r3
	adc r2, r2
	
	adds r3, r0
	adc r3, r2, r5
	
	asr r3, #2
	
	rsb r2, r3, r3, lsl #5
	rsb r2, r3, r2, lsl #2
	add r0, #48
	add r0, r2, lsl #1
	strb r0, [ip], #1
	
	subs r0, r3, #0
	bne .loop
	
	str r0, [sp, #4]
	strb r0, [ip]
	
	cmp ip, r1
	bls .return
	
.loop2:
	ldrb r2, [r1]
	ldrb r3, [ip, #-1]!
	strb r2, [ip]
	strb r3, [ip], #1
	
	cmp ip, r1
	bhi .loop2
	
.return:
	add sp, #8
	pop {r4, r5, r6, pc}
	
.negative:
	mov r3, #45
	strb r3, [r1], #1
	rsb r0, #0
	b .afterNeg
	
	
	
	
	
_get_line_count:
	add r3, r0, r1
	ldrb ip, [r3, #-2]
	ldrb r2, [r3, #-1]
	orr ip, r2, lsl #8
	mov r2, 0x0A00
	add r2, #13
	
	cmp ip, r2
	beq .notEndline
	
	mov r2, #13
	strb r2, [r0, r1]
	mov r2, #10
	strb r2, [r3, #1]
	
	mov r2, #0
	strb r2, [r3, #2]
	
.notEndline:
	ldrb r3, [r0]
	cmp r3, #0
	beq .retR3
	
	mov r2, r0
	mov r0, #0
	
.loop:
	cmp r3, #10
	addeq r0, #1
	
	ldrb r3, [r2, #1]!
	cmp r3, #0
	bne .loop
	
	bx lr

.retR3:
	mov r0, r3
	bx lr
	
	
	
	
	
_get_ml:
	push {r4, r5, r6, r7, r8, r9, r10, fp, lr}
	add r4, r0, r2
	mov r3, #0
	rsb lr, r4, #2
	
.i0:
	sub r3, #1
	add r3, r4, r3
	
	b .startLoop
	
.loop:
	cmp r0, #32
	bhi .checkSemicolon
	
.startLoop:
	add ip, lr, r3
	ldrb r0, [r3, #1]!
	
	cmp r0, #0
	bne .loop
	
.return:
	mov r3, #0
	strb r3, [r1]
	pop {r4, r5, r6, r7, r8, r9, r10, fp, pc}

.checkSemicolon:
	cmp r0, #59
	bne .l0
	
	sub ip, #1
	add ip, r4, ip
	b .startLoop2
	
.loop2:
	cmp r0, #10
	beq .i0
	
.startLoop2:
	add r3, lr, ip
	ldrb r0, [ip, #1]!
	
	cmp r0, #0
	bne .loop2
	
	b .return
	
.l0:
	mov r8, #0
	mov r3, r8
	mov r9, r8
	rsb r7, r1, #1
	rsb lr, r4, #1
	mov r10, #32
	
.loop3:
	add r6, r1, r3
	add r5, r3, #1
	
	cmp r0, #34
	beq .gotQuotes
	
	cmp r0, #39
	beq .gotBackslash
	
	cmp r0, #33
	movcs r8, ip
	movcs r9, r3
	
	strb r0, [r6]
	add r6, r1, r5
	
.continue:
	sub r3, ip, #1
	add r3, r4, r3
	
.loop4:
	add fp, ip, #1
	ldrb r0, [r3, #1]!
	
	cmp r0, #0
	beq .got0
	
	cmp r0, #13
	beq .gotLinefeed
	
	cmp r0, #10
	bne .noEndline
	
.gotEndline:
	add r3, r4, r8
	ldrb r3, [r3, #-1]
	cmp r3, #44
	beq .gotComma
	
	cmp r3, #92
	bne .noBackslash
	
	strb r10, [r1, r9]
	mov r9, #0
	
.gotComma:
	sub r0, fp, #1
	add r0, r4, r0
	b .startLoop5
	
.loop5:
	cmp r3, #32
	bhi .continue
	
.startLoop5:
	add ip, lr, r0
	ldrb r3, [r0, #1]!
	cmp r3, #0
	bne .loop5
	
.afterLoop5:
	mov r1, r6
	mov r0, r3
	b .return
	
.gotLinefeed:
	mov ip, fp
	b .loop4
	
.noEndline:
	cmp r0, #59
	movne ip, fp
	movne r3, r5
	bne .loop3
	
	add ip, r4, ip
	b .startLoop6
	
.loop6:
	cmp r3, #10
	beq .gotEndline
	
.startLoop6:
	add fp, lr, ip
	ldrb r3, [ip, #1]!
	cmp r3, #0
	bne .loop6
	b .afterLoop5
	
.gotQuotes:
	strb r0, [r1, r3]
	sub r6, ip, #1
	add r6, r4, r6
	add r0, r1, r5
	sub ip, r1
	sub ip, r3
	b .startLoop7
	
.loop7:
	cmp r3, #34
	beq .fTrim
	
.startLoop7:
	add fp, ip, r0
	ldrb r3, [r6, #1]!
	
	add r5, r7, r0
	strb r3, [r0], #1
	
	cmp r3, #10
	cmpne r3, #0
	bne .loop7
	
.afterLoop7:
	add r1, r5
	mvn r0, #0
	b .return
	
.fTrim:
	add r6, r1, r5
	b .gotComma
	
.gotBackslash:
	strb r0, [r6]
	sub r6, ip, #1
	add r6, r4, r6
	add r0, r1, r5
	sub ip, r1
	sub ip, r3
	b .startLoop8
	
.loop8:
	cmp r3, #39
	beq .fTrim
	
.startLoop8:
	add fp, ip, r0
	ldrb r3, [r6, #1]!
	
	add r5, r7, r0
	strb r3, [r0], #1
	
	cmp r3, #10
	cmpne r3, #0
	bne .loop8
	
	b .afterLoop7
	
.got0:
	mov r1, r6
	b .return
	
.noBackslash:
	add r0, fp, r2
	mov r1, r6
	b .return
	
	
	
	
	
_GetPercent:
	push {r4, r5, r6, r7, lr}
	
	rsb r1, r1, lsl #31
	mov r4, r1
	asr r5, r1, #31
	
	asr ip, r5, #31
	eor r2, ip, r1
	eor r3, ip, r5
	
	subs r2, ip
	sbc r3, ip
	
	cmp r2, #101
	sbcs r1, r3, #0
	mov r1, #0
	mov ip, r1
	blt .noQuotLoop
	
.quotLoop:
	subs r2, #100
	sbc r3, #0
	
	adds r1, #1
	adc ip, #0
	
	cmp r2, #101
	sbcs lr, r3, #0
	bge .quotLoop
	
.noQuotLoop:
	cmp r4, #0
	sbcs r3, r5, #0
	movge r1, #0
	movge ip, r1
	
	mov r5, #0x10000
	sub r5, #1
	and r3, r5, r1
	and r4, r0, r5
	mul lr, r4, r3
	
	lsr r7, r1, #16
	mul r2, r7, r4
	add r2, lr, asr #16
	
	and lr, r5
	
	mul r3, r6, r7
	add r3, r2, lsr #16
	add r3, r4, lsr #16
	
	asr r7, r0, #31
	
	mul r2, r7, r1
	mla r1, r0, ip, r2
	
	add r6, lr, r4, lsl #16
	add r7, r1, r3
	
	asr r1, r7, #31
	eor r2, r1, r6
	eor r3, r1, r7
	subs r2, r1
	sbc r3, r1
	
	mvn r4, #-0x80000000
	mov r5, #0
	cmp r4, r2
	sbcs r1, r5, r3
	mov r0, #0
	
	bge .noQuotLoop2
	
.quotLoop2:
	adds r2, #-0x7FFFFFFF
	sbc r3, #0
	
	adds r0, #1
	cmp r4, r2
	sbcs r1, r5, r3
	blt .quotLoop2
	
.noQuotLoop2:
	cmp r6, #0
	sbcs r3, r7, #0
	
	movge r0, #0
	pop {r4, r5, r6, r7, pc}
	
	
	
	
	
_GetPathOnly:
	ldrb r3, [r0], #1
	
	cmp r3, #0
	beq .earlyReturn
	
	push {r4, lr}
	mov r2, r1
	mov r4, #0
	rsb lr, r1, #1
	
.loop:
	add ip, r2, lr
	strb r3, [r2], #1
	
	cmp r3, #92
	ldrb r3, [r0], #1
	beq .gotBackslash
	
	cmp r3, #0
	bne .loop
	
.return:
	mov r3, #0
	add r1, r4
	strb r3, [r1]
	pop {r4, pc}
	
.gotBackslash:
	cmp r3, #0
	mov r4, ip
	bne .loop
	b .return
	
.earlyReturn:
	mov r3, #0
	strb r3, [r1]
	bx lr
	
	
	
	
	
_htodw:
	mov r3, r0
	
.strlenLp:
	ldrb ip, [r3], #1
	cmp ip, #0
	bne .strlenLp
	
	sub r3, r0, r3
	
	mvns r2, r3
	beq .retR2
	
	sub r1, r0, #1
	sub r2, #1
	lsl r0, r2, #2
	
	mov r2, ip
	
.loop:
	ldrb r3, [r1, #1]!
	cmp r3, #64
	subhi r3, #87
	
	and r3, #15
	add r2, r3, lsl r0
	
	sub r0, #4
	
	cmn r0, #4
	bne .loop
	
.retR2:
	mov r0, r2
	bx lr
	
	
	
	
	
_InString:
	push {r4, r5, r6, r7, r8, r9, r10, lr}
	mov r4, r0
	mov r8, r1
	mov r5, r2
	
	mov r0, r1
	bl _strlen
	mov r6, r0
	
	mov r0, r5
	bl _strlen
	
	cmp r4, #0
	ble .retMin2
	
	sub r4, #1
	cmp r6, r0
	ble .retMin1
	
	sub r6, r0
	add r6, #1
	
	cmp r4, r6
	bge .retMin2
	
	add r8, r6
	ldrb r7, [r5]
	
	sub r4, r6
	sub r3, r4, #1
	add r3, r8, r3
	rsb r8, #1
	
	b .startLoop
	
.loop:
	cmn r2, r8
	bpl .ret0
	
.loopFromLoop2:
	mov r3, r2

.startLoop:
	add r9, r3, r8
	add r2, r3, #1
	ldrb r1, [r3, #1]
	cmp r1, r7
	bne .loop
	
	add r1, r0, r2
	add ip, r5, r0
	mvn r3, r3
	
.loop2:
	ldrb r4, [r1, #-1]!
	ldrb lr, [r1, #-1]!
	cmp r4, lr
	bne .loopFromLoop2
	
	cmn r3, r1
	bne .loop2
	
	add r6, r9
	add r0, r6, #1
	pop {r4, r5, r6, r7, r8, r9, r10, pc}
	
.ret0:
	mov r0, #0
	pop {r4, r5, r6, r7, r8, r9, r10, pc}

.retMin1:
	mvn r0, #0
	pop {r4, r5, r6, r7, r8, r9, r10, pc}
	
.retMin2:
	mvn r0, #1
	pop {r4, r5, r6, r7, r8, r9, r10, pc}
	
	
	
	
	
_isalpha:
	sub r3, r0, #65
	cmp r3, #57
	bhi .ret0
	
	cmp r0, #90
	bls .ret1
	
	cmp r0, #97
	movcc r0, #0
	movcs r0, #2
	bx lr

.ret0:
	mov r0, #0
	bx lr
	
.ret1:
	mov r0, #1
	bx lr
	
	
	
	
	
_isalphanum:
	cmp r0, #47
	bls .ret0
	
	cmp r0, #57
	bls .ret1
	
	cmp r0, #64
	bls .ret0
	
	cmp r0, #90
	bls .ret2
	
	sub r0, #97
	cmp r0, #25
	
	movhi r0, #0
	movls r0, #3
	bx lr
	
.ret0:
	mov r0, #0
	bx lr
	
.ret1:
	mov r0, #1
	bx lr
	
.ret2:
	mov r0, #2
	bx lr
	
	
	
	
	
_islower:
	sub r0, #97
	cmp r0, #25
	movhi r0, #0
	movls r0, #1
	bx lr
	
	
	
	
	
_isnumber:
	sub r0, #48
	cmp r0, #9
	movhi r0, #0
	movls r0, #1
	bx lr
	
	
	
	
	
_isupper:
	sub r0, #65
	cmp r0, #25
	movhi r0, #0
	movls r0, #1
	bx lr
	
	
	
	
	
_lfcnt:
	mov r2, r0
	
	ldrb r3, [r0]
	cmp r3, #0
	beq .retR3
	
	mov r0, #0
	
.loop:
	cmp r3, #10
	addeq r0, #1
	ldrb r3, [r2, #1]!
	cmp r3, #0
	bne .loop
	
	bx lr
	
.retR3:
	mov r0, r3
	bx lr
	
	
	
	
	
_MemCopy:
	mov r3, r1
	mov r1, r0
	mov r0, r3
	b _memcpy
	
	
	
	
	
_memfill:
	mov r3, r2
	mov r2, r1
	mov r1, r3
	b _memset
	
	
	
	
	
_NameFromPath:
	push {r4, lr}
	ldrb r4, [r0]
	
	cmp r4, #0
	beq .retMin1
	
	mov lr, r0
	add r3, r0, #1
	
	mov r2, r0
	mvn ip, r0
	
.loop:
	cmp r4, #92
	addeq r2, ip, r3
	
	ldrb r4, [r3], #1
	cmp r4, #0
	bne .loop
	
	cmp lr, r2
	beq .retMin1
	
	mov r0, r1
	add r2, #1
	add r1, lr, r2
	bl _strcpy
	
	mov r0, r4
	pop {r4, pc}
	
.retMin1:
	mvn r0, #0
	pop {r4, pc}
	
	
	
	
	
_nrandom:
	push {r4, r5, r6, r7, lr}
	ldr r5, [.nrandomSeedPtr]
	ldr r4, [r5]
	
	cmp r4, #0
	sublt r4, #-0x7FFFFFFF
	mov r7, r4
	
	cmp r0, #0
	beq .simple
	
	cmp r4, #0
	streq r4, [r5]
	beq .return
	
	lsr r2, r0, #16
	lsl r2, #16
	cmp r2, #0
	lsrne r1, r0, #16
	movne r2, #8
	movne ip, #0
	moveq r1, r0
	moveq r2, #24
	moveq ip, #16
	
	tst r1, #0xFF00
	lsrne r1, #8
	movne r2, ip
	
	tst r1, #0xF0
	lsreq r1, #4
	addeq r2, #4
	
	tst r1, #0xC
	lsrne r1, #2
	addeq r2, #2
	
	lsr lr, r1, #1
	eor lr, #1
	ands lr, #1
	mvnne lr, #0
	
	rsb r1, #2
	and r1, lr
	add lr, r1, r2
	
	lsr r2, r4, #16
	lsl r2, #16
	
	cmp r2, #0
	lsrne r2, r4, #16
	movne r1, lr
	subeq r1, lr, #16
	moveq r2, r4
	
	tst r2, #0xFF00
	lsrne r2, #8
	subeq r1, #8
	
	tst r2, #0xF0
	lsreq r2, #4
	subeq r1, #4
	
	tst r2, #0xC
	lsrne r2, #2
	subeq r1, #2
	
	lsr ip, r2, #1
	eor ip, #1
	ands ip, #1
	mvnne ip, #0
	rsb r2, #2
	and r2, ip
	
	sub r2, r1, r2
	
	cmp r2, #31
	movhi r6, #0
	bhi .afterQuotLoop
	
	beq .divN
	
	add ip, r2, #1
	rsb r6, ip, #32
	lsl r6, r4, r6
	lsr r3, r4, ip
	sub r7, r0, #1
	mov r1, #0
	
.quotLoop:
	lsr r2, r6, #31
	orr r2, r3, lsl #1
	orr r6, r1, r6, lsl #1
	
	sub r1, r7, r2
	asr r3, r1, #31
	
	and r1, r3, #1
	and r3, r0
	sub r3, r2, r3
	
	subs ip, #1
	bne .quotLoop
	
.afterQuotLoop:
	add r2, r7, r7, lsl #2
	rsb r2, r2, lsl #4
	add r3, r7, r2, lsl #5
	rsb r3, r3, lsl #3
	sub r7, r3, r6
	str r7, [r5]
	
	cmp r7, #0
	beq .return
	
	lsr r2, r7, #16
	lsl r2, #16
	cmp r2, #0
	lsrne r1, r7, #16
	subeq lr, #16
	moveq r1, r7
	
	tst r1, #65280
	lsrne r1, #8
	subeq lr, #8
	
	tst r1, #240
	lsreq r1, #4
	subeq lr, #4
	
	tst r1, #12
	lsrne r1, #2
	subeq lr, #2
	
	lsr r2, r1, #1
	eor r2, #1
	ands r2, #1
	mvnne r2, #0
	
	rsb r1, #2
	and r2, r1
	sub r2, lr, r2
	
	cmp r2, #31
	bhi .return
	
	beq .divN2
	
	add r2, #1
	rsb r4, r2, #32
	lsl r4, r7, r4
	lsr r1, r7, r2
	sub r5, r0, #1
	mov ip, #0
	
.quotLoop2:
	lsr lr, r4, #31
	orr lr, r1, lsl #1
	orr r4, ip, r4, lsl #1
	sub ip, r5, lr
	asr r1, ip, #31
	
	and ip, r1, #1
	and r1, r0
	sub r1, lr, r1
	
	subs r2, #1
	bne .quotLoop2
	
	orr r3, ip, r4, lsl #1
	mul r4, r0, r3
	sub r7, r4

.return:
	mov r0, r7
	pop {r4, r5, r6, r7, pc}
	
.simple:
	add r0, r4, r4, lsl #2
	rsb r0, r0, lsl #4
	add r3, r4, r0, lsl #5
	rsb r7, r3, r3, lsl #3
	str r7, [r5]
	
	mov r0, r7
	pop {r4, r5, r6, r7, pc}
	
.divN:
	rsb r3, r0, #1
	add r6, r4, r4, lsl #1
	rsb r6, r6, lsl #4
	rsb r6, r6, lsl #6
	add r6, r4
	mul r7, r4, r3
	b .afterQuotLoop
	
.divN2:
	rsb r0, #1
	mul r7, r0, r7
	b .return
	
.nrandomSeedPtr:
	dw nrandom_seed





_nseed:
	ldr r3, [.nrandomSeedPtr]
	str r0, [r3]
	bx lr

.nrandomSeedPtr:
	dw nrandom_seed
	
	
	
	
	
_parse_line:
	push {r4, r5, r6, r7, r8, r9, lr}
	mov r2, r0
	
	ldr r4, [r1]
	mov r0, #0
	ldr r5, [.ctblPtr]
	
	mov r8, #91
	mov r7, #34
	mov r6, r0
	b .startLoop
	
.loop:
	ldrb lr, [r5, ip]
	cmp lr, #0
	moveq r2, r3
	bne .continue
	
.startLoop:
	mov r3, r2
	ldrb ip, [r3], #1
	
	cmp ip, #0
	bne .loop
	
.gaOut:
	mov r3, #0
	strb r3, [r4]
	
	ldr r2, [r1, #4]
	strb r3, [r2]
	pop {r4, r5, r6, r7, r8, r9, pc}
	
.continue:
	add r0, #1
	add lr, r4, #1
	cmp ip, #91
	beq .gotLeftBracket
	
	cmp ip, #34
	beq .gotQuotes
	
	strb ip, [r4]
	
	add r9, r2, #2
	ldrb ip, [r3]
	
	cmp ip, #0
	beq .gotoGaOut
	
	ldrb r3, [r5, ip]
	cmp r3, #0
	moveq r4, lr
	moveq r2, r9
	bne .continue2
	b .reIndex
	
.loop2:
	cmp ip, #34
	beq .gotQuotes2
	
	strb ip, [r4, #-1]
	ldrb ip, [r2, #-1]
	cmp ip, #0
	beq .gaOut
	
	mov lr, r4
	mov r9, r2
	ldrb r3, [r5, ip]
	cmp r3, #0
	beq .reIndex
	
.continue2:
	add r4, lr, #1
	add r2, r9, #1
	mov r3, r2
	
	cmp ip, #91
	bne .loop2
	
.wsqb:
	strb r8, [lr]
	b .startLoop3
	
.loop3:
	add r3, #1
	
.startLoop3:
	ldrb r2, [r3, #-1]
	cmp r2, #0
	popeq {r4, r5, r6, r7, r8, r9, pc}
	
	cmp r2, #32
	beq .loop3
	
	strb r2, [r4], #1
	
	cmp r2, #93
	bne .loop3
	
.gotoReIndex:
	mov r2, r3
	
.reIndex:
	strb r6, [r0]
	ldr r4, [r1, #4]!
	b .startLoop
	
.gotQuotes:
	mov r2, lr
	mov lr, r4
	mov r4, r2
	add r3, #1
	
.gotQuotes2:
	strb r7, [lr]
	b .startLoop4
	
.loop4:
	add r3, #1
	
.startLoop4:
	ldrb r2, [r3, #-1]
	
	cmp r2, #0
	popeq {r4, r5, r6, r7, r8, r9, pc}
	
	strb r2, [r4], #1
	
	cmp r2, #34
	bne .loop4
	b .gotoReIndex
	
.gotLeftBracket:
	mov r2, lr
	mov lr, r4
	mov r4, r2
	add r3, #1
	b .wsqb
	
.gotoGaOut:
	mov r4, lr
	b .gaOut

.ctblPtr:
	dw ctbl
	
	
	
	
	
_partial:
	push {r4, r5, r6, r7, r8, r9, r10, lr}
	mov r6, r0
	mov r7, r2
	
	add r4, r1, r0
	
	mov r0, r2
	bl _strlen
	mov r9, r0
	
	mov r0, r4
	bl _strlen
	
	ldrb r5, [r7]
	cmp r5, #42
	bne .noFiller
	
	mov r3, #0
	b .startLoop
	
.loop:
	mov r3, r8
	
.startLoop:
	add r8, r3, #1
	ldrb r5, [r7, #1]!
	cmp r5, #42
	beq .loop
	
.afterLoop:
	add r3, r4, r3
	sub r0, r9
	add r0, r8
	add r0, r3, r0
	sub r2, r9, #1
	sub r2, r8
	
.mainLoop:
	ldrb r1, [r3, #1]!
	cmp r1, r5
	subeq lr, r7, #1
	mvneq r1, #0
	beq .gotPatMin1
	
	cmp r0, r3
	bge .mainLoop
	
	mvn r0, #0
	pop {r4, r5, r6, r7, r8, r9, r10, pc}
	
.gotPatMin1:
	add r1, #1
	cmp r1, r2
	bgt .end
	
.loop2:
	ldrb ip, [lr, #1]!
	cmp ip, #42
	beq .gotPatMin1
	
	ldrb r9, [r3, r1]
	cmp r9, ip
	bne .mainLoop
	
	add r1, #1
	cmp r1, r2
	ble .loop2
	
.end:
	add r0, r3, r6
	sub r0, r4
	sub r0, r8
	pop {r4, r5, r6, r7, r8, r9, r10, pc}
	
.noFiller:
	mvn r3, #0
	mov r8, #0
	b .afterLoop
	
	
	
	
	
_RolData:
	push {r4, r5, r6, lr}
	
	mov r6, r2
	ldrb ip, [r6], r3
	sub lr, r0, #1
	sub r1, #1
	add r0, r1
	mov r5, r2
	b .startLoop
	
.loop:
	strb r3, [lr]
	cmp r0, lr
	popeq {r4, r5, r6, pc}
	
.loop2:
	mov r5, r4
	
.startLoop:
	and ip, #7
	ldrb r4, [lr, #1]!
	rsb r3, ip, #0
	and r3, #7
	lsr r3, r4, r3
	orr r3, r4, lsl ip
	and r3, #0xFF
	
	add r4, r5, #1
	ldrb ip, [r5, #1]
	
	cmp r4, r6
	bne .loop
	
	ldrb ip, [r2]
	strb r3, [lr]
	
	cmp r0, lr
	popeq {r4, r5, r6, pc}
	
	mov r4, r2
	b .loop2
	
	
	
	
	
_RorData:
	push {r4, r5, r6, lr}
	
	mov r6, r2
	ldrb ip, [r6], r3
	sub lr, r0, #1
	sub r1, #1
	add r0, r1
	mov r5, r2
	b .startLoop
	
.loop:
	strb r3, [lr]
	cmp r0, lr
	popeq {r4, r5, r6, pc}
	
.loop2:
	mov r5, r4
	
.startLoop:
	and ip, #7
	ldrb r4, [lr, #1]!
	rsb r3, ip, #0
	and r3, #7
	lsl r3, r4, r3
	orr r3, r4, lsr ip
	and r3, #0xFF
	
	add r4, r5, #1
	ldrb ip, [r5, #1]
	
	cmp r4, r6
	bne .loop
	
	ldrb ip, [r2]
	strb r3, [lr]
	
	cmp r0, lr
	popeq {r4, r5, r6, pc}
	
	mov r4, r2
	b .loop2
	
	
	
	
	
_SBMBinSearch:
	push {r4, r5, r6, r7, lr}
	sub sp, #1024
	sub sp, #4 
	ldr r4, [sp, #1048]
	
	cmp r4, #1
	ble .retMin2
	
	mov ip, sp
	
.memsetLoop:
	str r4, [ip]
	str r4, [ip, #4]
	add ip, #8
	add lr, sp, #1024
	cmp ip, lr
	bne .memsetLoop
	
	sub r5, r4, #1
	mov r6, r3
	mov ip, r5
	
.makeShiftTblLoop:
	ldrb lr, [r6], #1
	add r7, sp, #1024
	add lr, r7, lr, lsl #2
	str ip, [lr, #-1024]
	
	subs ip, #1
	bne .makeShiftTblLoop
	
	add r0, r1, r0
	sub r2, r4
	add lr, r1, r2
	
.loop:
	ldrb r2, [r0, ip]
	ldrb r6, [r3, ip]
	cmp r6, r2
	bne .notSame
	
	subs ip, #1
	bcs .loop
	
	sub r0, r1
	add sp, #1024
	add sp, #4
	pop {r4, r5, r6, r7, pc}
	
.notSame:
	add r6, sp, #1024
	add r2, r6, r2, lsl #2
	ldr r2, [r2, #-1024]
	add ip, r2
	
	subs ip, r5
	movmi ip, #1
	
	add r0, ip
	cmp r0, lr
	bgt .retMin1
	
	ldrb r2, [r0, r5]
	ldrb ip, [r3, r5]
	
	cmp ip, r2
	bne .currentChar2NotEqSubStrSubStrLenMin1v2
	b .currentChar2EqSubStrSubStrLenMin1v2
	
.loop2:
	ldrb r2, [r0, r5]
	cmp r2, ip
	beq .currentChar2EqSubStrSubStrLenMin1v2
	
.currentChar2NotEqSubStrSubStrLenMin1v2:
	add r6, sp, #1024
	add r2, r6, r2, lsl #2
	ldr r2, [r2, #-1024]
	
	add r0, r2
	cmp r0, lr
	ble .loop2
	
.retMin1:
	mvn r0, #0
	
.return:
	add sp, #1024
	add sp, #4
	pop {r4, r5, r6, r7, pc}
	
.currentChar2EqSubStrSubStrLenMin1v2:
	sub ip, r4, #2
	b .loop
	
.retMin2:
	mvn r0, #1
	b .return
	
	
	
	
	
_StripLF:
	sub r0, #1
	
.loop:
	ldrb r3, [r0, #1]!
	cmp r3, #0
	bxeq lr
	
	cmp r3, #13
	bne .loop
	
	mov r3, #0
	strb r3, [r0]
	
	bx lr
	
	
	
	
	
_StripRangeI:
	ldrb ip, [r0], #1
	cmp ip, #0
	beq .retNoSet
	
	cmp ip, r2
	strbne ip, [r1], #1
	bne _StripRangeI
	
	ldrb ip, [r0], #1
	cmp ip, #0
	beq .return
	
.loop:
	cmp ip, r3
	beq _StripRangeI
	
	ldrb ip, [r0], #1
	cmp ip, #0
	bne .loop
	
.return:
	mov ip, #0
	
.retNoSet:
	strb ip, [r1]
	bx lr
	
	
	
	
	
_StripRangeX:
	ldrb ip, [r0], #1
	cmp ip, #0
	bxeq lr
	
	cmp ip, r2
	strbne ip, [r1], #1
	bne _StripRangeX
	
	strb r2, [r1]
	
.loop:
	ldrb ip, [r0], #1
	
	cmp ip, #0
	bxeq lr
	
	cmp ip, r3
	bne .loop
	
	strb r3, [r1, #1]
	add r1, #2
	b _StripRangeX
	
	
	
	
	
_szappend:
	str lr, [sp, #-4]!
	
	sub r3, r1, #1
	sub lr, r2, #1
	add lr, r0, lr
	
.loop:
	add r3, #1
	mov r0, r3
	ldrb ip, [r0], r2
	
	sub r0, r1
	strb ip, [lr, #1]!
	
	cmp ip, #0
	bne .loop
	
	ldr pc, [sp], #4
	
	
	
	
	
_szCmp:
	str lr, [sp, #-4]!
	
	sub r3, r0, #1
	sub r1, #1
	rsb lr, r0, #1	
	b .startLoop
	
.loop:
	cmp r2, #0
	ldreq pc, [sp], #4
	
.startLoop:
	add r0, lr, r3
	ldrb ip, [r3, #1]!
	ldrb r2, [r1, #1]!
	
	cmp r2, ip
	beq .loop
	
	mov r0, #0
	ldr pc, [sp], #4
	
	
	
	
	
_szCmpi:
	push {r4, lr}
	
	sub ip, r0, #1
	sub r1, #1
	mov r0, #0
	ldr r3, [.szCmpiTblPtr]
	
.loop:
	add r0, #1
	
	ldrb r4, [ip, #1]!
	ldrb lr, [r1, #1]!
	ldrb r4, [r3, r4]
	ldrb lr, [r3, lr]
	
	cmp r4, lr
	popne {r4, pc}
	
	cmp r0, r2
	bcc .loop
	
	mov r0, #0
	pop {r4, pc}
	
.szCmpiTblPtr:
	dw szCmpi_tbl
	
	
	
	
	
_szCopy:
	push {r4, lr}
	mov r4, r0
	mov r0, r1
	
	mov r1, r4
	bl _strcpy
	
	mov r0, r4
	pop {r4, lr}
	b _strlen
	
	
	
	
	
_szLeft:
	push {r4, r5, lr}
	
	add r5, r1, r2
	add r3, r1, #4
	cmp r1, ip
	cmpcc r0, r3
	movcs ip, #1
	movcc ip, #0
	
	rsb r3, r2, #0
	cmn r3, #10
	movhi r3, #0
	movls r3, #1
	orr lr, r0, r1
	
	tst lr, #3
	andeq r3, ip
	movne r3, #0
	cmp r3, #0
	beq .startSmallLoop
	
	sub ip, r0, #4
	bic r4, r2, #3
	add r4, r1, r4
	mov r3, r1
	
.bigLoop:
	ldr lr, [ip, #4]!
	str lr, [r3], #4
	
	cmp r3, r4
	bne .bigLoop
	
	bic ip, r2, #3
	sub r3, ip, r2
	cmp r2, ip
	beq .return
	
	ldrb lr, [r0, ip]
	strb lr, [r1, ip]
	
	adds ip, r3, #1
	beq .return
	
	add lr, r0, ip
	ldrb lr, [lr, r2]
	strb lr, [r5, ip]
	adds r3, #2
	addne r0, r3
	ldrbne r0, [r0, r2]
	strbne r0, [r5, r3]
	
.return:
	mov r0, #0
	strb r3, [r1, r2]
	mov r0, r1
	pop {r4, r5, pc}
	
.startSmallLoop:
	mov r3, r0
	sub r0, r1, #1
	add lr, r3, r2
	
.smallLoop:
	ldrb ip, [r3], #1
	strb ip, [r0, #1]!
	
	cmp r3, lr
	bne .smallLoop
	b .return
	
	
	
	
	
_szLen:
	b _strlen
	
	
	
	
	
_szLower:
	push {r4, r5, r6, lr}
	mov r6, r0
	
	ldrb r4, [r0]
	cmp r4, #0
	movne r5, r0
	beq .retR6
	
.loop:
	mov r0, r4
	bl _isupper
	cmp r0, #0
	beq .notUpper
	
	mov r0, r4
	bl _tolower
	strb r0, [r5]
	
.notUpper:
	ldrb r4, [r5, #1]!
	cmp r4, #0
	bne .loop
	
.retR6:
	mov r0, r6
	pop {r4, r5, r6, pc}
	
	
	
	
	
_szLtrim:
	push {r4, r5, r6, lr}
	mov r5, r1
	
	bl getSpacesEnd
	mov r4, r0
	
	ldrb r0, [r0]
	cmp r0, #0
	bne .srcNot0
	
	strb r0, [r5]
	pop {r4, r5, r6, pc}
	
.srcNot0:
	mov r1, r4
	mov r0, r5
	bl _strcpy
	
	mov r0, r4
	bl _strlen
	
	sub r0, #1
	pop {r4, r5, r6, pc}
	
	
	
	
	
_szMid:
	push {r4, lr}
	mov r4, r0
	
	add r0, r1, r3
	add ip, r4, r3
	sub lr, r1, #1
	add r2, r3, r2
	add r4, r2
	
.loop:
	ldrb r2, [ip], #1
	strb r2, [lr, #1]!
	
	cmp ip, r4
	bne .loop
	
	mov r2, #0
	strb r2, [r1, r3]
	pop {r4, pc}
	
	
	
	
	
_szMonoSpace:
	push {r4, r5, r6, lr}
	mov r5, r0
	mov r4, r0
	mov r6, #32
	
.ftrim:
	mov r0, r5
	bl getSpacesEnd
	
	sub r0, #1
	b .startLoop
	
.loop:
	strb r3, [r2, #-1]
	mov r4, r2
	
	cmp r3, #0
	beq .return
	
.startLoop:
	ldrb r3, [r0, #1]!
	add r2, r4, #1
	cmp r3, #9
	cmpne r3, #32
	bne .loop
	
	strb r6, [r4]
	mov r4, r2
	b .ftrim
	
.return:
	ldrb r2, [r2, #-2]
	cmp r2, #32
	
	strbeq r3, [r4, #-2]
	
	mov r0, r5
	pop {r4, r5, r6, pc}
	
	
	
	
	
_szRemove:
	push {r4, r5, r6, r7, r8, r9, lr}
	ldrb r7, [r2]
	sub r0, #1
	sub r9, r1, #1
	
.loop:
	add r3, r0, #1
	ldrb r6, [r0, #1]
	cmp r7, r6
	bne .srcNotFirstRemChar
	
	ldrb r8, [r2]
	mov r0, r3
	b .startLoop2
	
.loop2:
	ldrb r3, [r4, #1]!
	mov r5, ip
	ldrb lr, [ip], #1
	cmp r3, #0
	bne .skip
	
	mov r0, r5
	cmp r7, lr
	bne .after
	
	mov r6, r7
	
.startLoop2:
	mov r4, r2
	add ip, r0, #1
	mov r3, r8
	mov lr, r6
	
.skip:
	cmp lr, r3
	beq .loop2
	
	strb r6, [r9, #1]!
	cmp r6, #0
	bne .loop2
	
.retR1:
	mov r0, r1
	pop {r4, r5, r6, r7, r8, r9, pc}
	
.after:
	mov r6, lr
	strb r6, [r9, #1]!
	cmp r6, #0
	bne .loop
	b .retR1
	
.srcNotFirstRemChar:
	mov r0, r3
	strb r6, [r9, #1]!
	cmp r6, #0
	bne .loop
	b .retR1
	
	
	
	
	
_szRep:
	push {r4, r5, r6, r7, r8, r9, r10, lr}
	mov r9, r0
	mov r6, r1
	mov r5, r2
	mov r7, r3
	
	bl _strlen
	mov r8, r0
	
	sub r4, r9, #1
	mov r0, r5
	bl _strlen
	add r8, #1
	sub r0, r8, r0
	add r0, r9, r0
	
.loop:
	add r1, r4, #1
	cmp r1, r0
	bge .return
	
.thingo:
	ldrb lr, [r4, #1]
	ldrb ip, [r5]
	cmp lr, ip
	strbne lr, [r6], #1
	movne r4, r1
	bne .loop
	
	mov r2, r5
	mvn r3, r5
	b .startLoop2
	
.loop2:
	add r2, #1
	ldrb r5, [r4, #1]!
	cmp r5, ip
	bne .srcNotCurrentChar
	
	ldrb ip, [r2]
	
.startLoop2:
	add r5, r2, r3
	cmp ip, #0
	bne .loop2
	
	ldrb r3, [r7]
	cmp r3, #0
	beq .break
	
	add ip, r7, #1
	
.loop3:
	mov r7, ip
	strb r3, [r6], #1
	ldrb r3, [ip], #1
	
	cmp r3, #0
	bne .loop3
	
.break:
	add r4, r1, r5
	mov r5, r2
	
	add r1, r4, #1
	cmp r1, r0
	blt .thingo
	
.return:
	mov r0, r6
	pop {r4, r5, r6, r7, r8, r9, r10, lr}
	b _strcpy
	
.srcNotCurrentChar:
	strb lr, [r6], #1
	mov r5, r2
	mov r4, r1
	b .loop
	
	
	
	
	
_szRev:
	push {r4, lr}
	mov r4, r1
	
	mov r1, r0
	mov r0, r4
	bl _stpcpy
	
	sub ip, r0, r4
	sub r0, #2
	mov r3, r4
	sub ip, #1
	sub ip, r0, ip, lsr #1
	
.loop:
	ldrb r2, [r3]
	ldrb r1, [r0]
	strb r1, [r3], #1
	strb r2, [r0], #-1
	
	cmp r0, ip
	bne .loop
	
	mov r0, r4
	pop {r4, pc}
	
	
	
	
	
_szRight:
	push {r4, r5, r6, lr}
	mov r6, r0
	mov r5, r1
	mov r4, r2
	
	bl _strlen
	sub r1, r0, r4
	add r1, r6, r1
	mov r0, r5
	bl _strcpy
	
	mov r0, r5
	pop {r4, r5, r6, pc}
	
	
	
	
	
_szRtrim:
	push {r4, r5, r6, lr}
	mov r4, r0
	mov r5, r1
	
	bl getSpacesEnd
	
	ldrb r0, [r0]
	cmp r0, #0
	beq .end0Ret0
	
	sub r3, r4, #1
	sub ip, r5, #1
	
	mov r0, #0
	b .startLoop
	
.loop:
	cmp r2, #32
	movhi r0, r3
	mov r3, lr
	
.startLoop:
	add lr, r3, #1
	ldrb r2, [r3, #1]
	
	add r3, #2
	sub r3, r4
	strb r2, [ip, #1]!
	
	cmp r2, #0
	bne .loop
	
	strb r2, [r5, r0]
	pop {r4, r5, r6, pc}
	
.end0Ret0:
	strb r0, [r5]
	pop {r4, r5, r6, pc}
	
	
	
	
	
_szTrim:
	push {r4, lr}
	mov r4, r0
	
	bl getSpacesEnd
	
	ldrb r3, [r0]
	cmp r3, #0
	strbeq r3, [r4]
	bne .startLoop
	
	mov r0, #0
	pop {r4, pc}
	
.loop:
	ldrb r3, [r0]
	
.startLoop:
	strb r3, [r4]
	cmp r3, #0
	bne .loop
	
	mov r0, #0
	pop {r4, pc}
	
	
	
	
	
_szUpper:
	push {r4, r5, r6, lr}
	mov r6, r0
	
	sub r5, r0, #1
	
.loop:
	ldrb r4, [r5, #1]!
	cmp r4, #0
	beq .return
	
.loop2:
	mov r0, r4
	bl _islower
	cmp r0, #0
	beq .loop
	
	mov r0, r4
	bl _toupper
	strb r0, [r5]
	
	ldrb r4, [r5, #1]!
	cmp r4, #0
	bne .loop2
	
.return:
	mov r0, r6
	pop {r4, r5, r6, pc}
	
	
	
	
	
_tstline:
	push {r4, lr}
	
	bl getSpacesEnd
	
	ldrb r3, [r0]
	cmp r3, #31
	
	movls r0, #0
	pop {r4, pc}
	
	
	
	
	
_ucappend:
	sub r1, #4
	sub r2, #4
	add ip, r0, r2
	mov r0, #0
	
.loop:
	ldr r3, [r1, #4]!
	str r3, [ip, #4]!
	add r0, #1
	cmp r3, #0
	bne .loop
	
	add r0, r2, r0, lsl #2
	bx lr
	
	
	
	
	
_ucCatStr:
	push {r4, lr}
	bl _wcscat
	mov r0, #0
	pop {r4, pc}
	
	
	
	
	
_ucCmp:
	str lr, [sp, #-4]!
	sub ip, r0, #4
	sub r1, #4
	mvn r3, #0
	b .startLoop
	
.loop:
	cmp r2, #0
	ldreq pc, [sp], #4
	
.startLoop:
	add r3, #1
	mov r0, r3
	ldr lr, [ip, #4]!
	
	ldr r2, [r1, #4]!
	cmp r2, lr
	beq .loop
	
	mov r0, #0
	ldr pc, [sp], #4
	
	
	
	
	
_ucCopy:
	mov r3, r1
	mov r1, r0
	mov r0, r3
	b _wcscpy
	
	
	
	
	
_ucLeft:
	push {r4, r5, r6, lr}
	mov r4, r1
	mov r5, r2
	
	mov r1, r0
	mov r0, r4
	bl _wmemcpy
	
	mov r3, #0
	str r3, [r4, r5, lsl #2]
	pop {r4, r5, r6, pc}
	
	
	
	
	
_ucLen:
	b _wcslen
	