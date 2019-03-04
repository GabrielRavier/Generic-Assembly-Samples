global _my_m_prefetchw

segment .text align=16

_my_m_prefetchw:
	prefetchw [rdi]
	ret