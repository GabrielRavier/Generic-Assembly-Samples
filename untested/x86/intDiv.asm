global _intDiv	; int IntSqrt(int a1, int a2)

segment .text align=16

_intDivi386:
	sub esp, 28
	
	fild dword [esp + 28 + 4]
	fild dword [esp + 28 + 8]
	
	fdivp st1, st0
	fnstcw [esp]
	
	movzx eax, word [esp]
	or eax, 0xC00
	mov dword [esp + 8], eax
	
	fldcw [esp + 8]
	fistp dword [esp + 16]
	fldcw [esp]
	
	mov eax, dword [esp + 16]
	add esp, 28
	ret
	
	
	
_intDivSSE2:
	pxor xmm1, xmm1
	pxor xmm0, xmm0
	
	cvtsi2sd xmm1, [esp + 4]
	cvtsi2sd xmm0, [esp + 8]
	
	divsd xmm1, xmm0
	
	cvttsd2si eax, xmm1
	ret
	
	

_intDivAVX:
	vxorpd xmm0, xmm0, xmm0
	vxorpd xmm1, xmm1, xmm1
	
	vcvtsi2sd xmm0, xmm0, [esp + 4]
	vcvtsi2sd xmm1, xmm1, [esp + 8]
	
	vdivsd xmm2, xmm0, xmm1
	
	vcvttsd2si eax, xmm2
	ret