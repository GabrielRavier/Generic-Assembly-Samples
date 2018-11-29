global _debugBreak

segment .text align=16

_debugBreak:
	int 3
	nop
	ret