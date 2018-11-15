global _makeM128FromM64
global _makeM128FromI32
global _makeM128FromI16
global _makeM128FromI8

segment .text align=16

_makeM128FromM64:
	movq2dq xmm0, mm1
	movq2dq xmm1, mm0
	punpcklqdq xmm0, xmm1
	ret
	
	
	
	
	
	align 16
_makeM128FromI32:
	movd xmm1, [esp + 8]
	movd xmm2, [esp + 4]
	movd xmm0, [esp + 16]
	movd xmm3, [esp + 12]
	punpckldq xmm1, xmm2
	punpckldq xmm0, xmm3
	punpcklqdq xmm0, xmm1
	ret
	
	
	
	
	
	align 16
_makeM128FromI16:
	movd xmm0, [esp + 4]
	movd xmm1, [esp + 8]
	movd xmm2, [esp + 16]
	movd xmm4, [esp + 24]
	movd xmm3, [esp + 28]
	punpcklwd xmm1, xmm0
	movd xmm0, [esp + 12]
	punpcklwd xmm2, xmm0
	movd xmm0, [esp + 20]
	punpckldq xmm2, xmm1
	punpcklwd xmm4, xmm0
	movd xmm0, [esp + 32]
	punpcklwd xmm0, xmm3
	punpckldq xmm0, xmm4
	punpcklqdq xmm0, xmm2
	ret
	
	
	
	
	
	align 16
_makeM128FromI8:
	movd xmm0, [esp + 4]
	movd xmm1, [esp + 8]
	movd xmm2, [esp + 16]
	movd xmm5, [esp + 24]
	movd xmm3, [esp + 32]
	movd xmm4, [esp + 40]
	punpcklbw xmm1, xmm0
	movd xmm0, [esp + 12]
	punpcklbw xmm2, xmm0
	movd xmm0, [esp + 20]
	punpcklwd xmm2, xmm1
	punpcklbw xmm5, xmm0
	movd xmm0, [esp + 28]
	punpcklbw xmm3, xmm0
	movd xmm0, [esp + 36]
	punpcklwd xmm3, xmm5
	movd xmm5, [esp + 56]
	punpckldq xmm3, xmm2
	movd xmm2, [esp + 48]
	punpcklbw xmm4, xmm0
	movd xmm0, [esp + 44]
	punpcklbw xmm2, xmm0
	movd xmm0, [esp + 52]
	punpcklwd xmm2, xmm4
	movd xmm4, [esp + 60]
	punpcklbw xmm5, xmm0
	movd xmm0, [esp + 64]
	punpcklbw xmm0, xmm4
	punpcklwd xmm0, xmm5
	punpckldq xmm0, xmm2
	punpcklqdq xmm0, xmm3
	ret