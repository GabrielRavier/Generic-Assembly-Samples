%include "macros.inc"

global _getSurrenderIndex

segment .rodata align=16

	align 16
	zeroDot001 dq 0.001

	align 16
	zeroDot2 dq 0.2
	zeroDot4 dq 0.4

	align 16
	zeroDot6 dq 0.6

	align 16
	zeroDot8 dq 0.8

	align 16
	one dq 1.0

	align 16
	oneDot1 dq 1.1

	align 16
	oneDot2 dq 1.2

	align 16
	twoDot59 dq 2.59

segment .text align=16

%macro makeGetSurrenderIndex 1

%if %1 == 0
%define stackOffset 8
_getSurrenderIndex:
%elif %1 == 1
%define stackOffset 12
_getSurrenderIndexSSE2:
%endif
	sub esp, stackOffset
	mov eax, [esp + stackOffset + 4]
	
%if %1 == 0
	fld1
	fld st0
%elif %1 == 1
	movsd xmm0, [one]
	movapd xmm1, xmm0
%endif
	mov ecx, [eax]

	test ecx, ecx
	js .endGetYardMult

%if %1 == 0
	fstp st0
%endif
	mov edx, 60
	cmp ecx, 110
	jg .greater110

	cmp ecx, 41
%if %1 == 0
	fld st0
%endif
	jl .endGetYardMult

%if %1 == 0
	fstp st0
%endif

	cmp ecx, 50

	jg .greater50

%if %1 == 0
	fld1
%elif %1 == 1
	movsd xmm1, [one]
	movsd xmm2, [oneDot1]
%endif
	sub ecx, 40

	align 16
.mulLoop:
%if %1 == 0
	fmul qword [oneDot1]
%elif %1 == 1
	mulsd xmm1, xmm2
%endif
	dec ecx
	jne .mulLoop
	jmp .endGetYardMult

	align 16
.greater50:
	sub ecx, 50
	mov edx, ecx

.greater110:
%if %1 == 0
	fld qword [twoDot59]
%elif %1 == 1
	movsd xmm1, [twoDot59]
	movsd xmm2, [oneDot2]
%endif
	xor ecx, ecx

.mulLoop2:
%if %1 == 0
	fmul qword [oneDot2]
%elif %1 == 1
	mulsd xmm1, xmm2
%endif
	inc ecx
	cmp ecx, edx
	jl .mulLoop2

.endGetYardMult:
	mov ecx, [eax + 4]
%if %1 == 0
	fld st1
%elif %1 == 1
	movapd xmm2, xmm0
%endif
	test ecx, ecx
	js .endGetFirstDownMult

%if %1 == 0
	fstp st0
	fld qword [zeroDot2]
%endif
	
	cmp ecx, 110
%if %1 == 0
	jg .endGetFirstDownMult
%elif %1 == 1
	jle .skip

	movsd xmm2, [zeroDot2]
	mov ecx, [eax + 8]
	mulsd xmm2, xmm1
	test ecx, ecx
	jg .return
	jmp .doGetClockMultiplier

	align 16
.skip:
%endif

%if %1 == 0
	fstp st0
	fld st1
%elif %1 == 1
	movapd xmm2, xmm0
%endif
	cmp ecx, 2
	jl .endGetFirstDownMult

%if %1 == 0
	fstp st0
	fld qword [zeroDot8]
%endif

	cmp ecx, 4
%if %1 == 0
	jl .endGetFirstDownMult
%elif %1 == 1
	jge .continue

	movsd xmm2, [zeroDot8]

.endGetFirstDownMult:
	mov ecx, [eax + 8]
	mulsd xmm2, xmm1

	test ecx, ecx
	jg .return

.doGetClockMultiplier:
%endif

%if %1 == 0
	fstp st0
	fld qword [zeroDot6]

	cmp ecx, 7
	jl .endGetFirstDownMult

	fstp st0
	xor edx, edx
	cmp ecx, 10
	setl dl

	fld qword [zeroDot2 + edx * 8]

.endGetFirstDownMult:
	fmulp st1, st0
	mov ecx, [eax + 8]
	test ecx, ecx
	jg .return

%endif
	xor edx, edx
	cmp ecx, -9
	setg dl

	add edx, 3
	test ecx, ecx
	mov ecx, 2
	cmovne ecx, edx

%if %1 == 0
	mov [esp + 4], ecx
	fimul dword [esp + 4]
%elif %1 == 1
	xorps xmm1, xmm1
	cvtsi2sd xmm1, ecx
	mulsd xmm2, xmm1
%endif
	
	mov eax, [eax + 12]
	test eax, eax
	js .return

%if %1 == 0
	fstp st1
	mov [esp], eax
	fild dword [esp]
	fmul qword [zeroDot001]
	fld st0
	fmul st0, st1
	fmulp st1, st0
	fld1
	faddp st1, st0
	fxch st1
%elif %1 == 1
	xorps xmm1, xmm1
	cvtsi2sd xmm1, eax

	mulsd xmm1, [zeroDot001]
	movapd xmm0, xmm1
	mulsd xmm0, xmm1
	mulsd xmm0, xmm1
	addsd xmm0, [one]
%endif

.return:
%if %1 == 0
	fmulp st1, st0
%elif %1 == 1
	mulsd xmm2, xmm0
	retDouble esp, xmm2
%endif
	add esp, stackOffset
	ret

%if %1 == 1
	align 16
.continue:
	cmp ecx, 7
	jge .skip2

	movsd xmm2, [zeroDot6]
	mov ecx, [eax + 8]
	mulsd xmm2, xmm1
	
	test ecx, ecx
	jg .return
	jmp .doGetClockMultiplier

.skip2:
	xor edx, edx
	cmp ecx, 10
	setl dl

	movsd xmm2, [zeroDot2 + edx * 8]
	mov ecx, [eax + 8]
	mulsd xmm2, xmm1

	test ecx, ecx
	jg .return
	jmp .doGetClockMultiplier
%endif

%endmacro

	makeGetSurrenderIndex 0
	makeGetSurrenderIndex 1