global _intSqrt

segment .text align=16

_intSqrt:
	sub esp, 12
	
	fild dword [esp + 16]
	fsqrt
	fnstcw [esp + 6]
	
	mov ax, [esp + 6]
	mov ah, 12
	mov [esp + 4], ax
	
	fldcw [esp + 4]
	fistp dword [esp]
	fldcw [esp + 6]
	
	mov eax, [esp]
	add esp, 12
	ret
	


	align 16
_intSqrtSSE2:
	pxor xmm0, xmm0
	cvtsi2sd xmm0, [esp + 4]
	sqrtsd xmm1, xmm0
	cvttsd2si eax, xmm1
	ret
	
	
	
	align 16
_intSqrtAVX:
	vxorpd xmm0, xmm0
	vcvtsi2sd xmm0, [esp + 4]
	vsqrtsd xmm0, xmm0
	vcvttsd2si eax, xmm0
	ret