global _my_m_prefetchw

segment .text align=16

_my_m_prefetchw:
	mov eax, [esp + 4]
	prefetchw [eax]
	ret