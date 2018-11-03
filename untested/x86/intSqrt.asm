global _intSqrt	; int IntSqrt(int a1)

segment .text align=16

_intSqrti386:
	sub esp, 12
	
	fild dword [esp + 12 + 4]
	fsqrt
	fnstcw [esp + 12 - 6]
	
	mov ax, [esp + 12 - 6]
	mov ah, 12
	mov [esp + 12 - 8], ax
	
	fldcw [esp + 12 - 8]
	fistp dword [esp + 12 - 12]
	fldcw [esp + 12 - 6]
	
	mov eax, [esp + 12 - 12]
	add esp, 12
	ret
	

	
_intSqrtSSE2:
	pxor xmm0, xmm0
	cvtsi2sd xmm0, [esp + 4]
	sqrtsd xmm1, xmm0
	cvttsd2si eax, xmm1
	ret
	
	
	
_intSqrtAVX:
	vxorpd xmm0, xmm0, xmm0
	vcvtsi2sd xmm0, xmm0, [esp + 4]
	vsqrtsd xmm0, xmm0, xmm0
	vcvttsd2si eax, xmm0
	ret