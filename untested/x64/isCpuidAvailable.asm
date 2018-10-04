global _isCpuidAvailable

segment .text align=16

_isCpuidAvailable:
	mov eax, 1	; cpuid always available on 64-bit CPUs
	ret