global _debugBreak	; void debugBreak()

segment .text align=16

_debugBreak:
	int 3
	ret