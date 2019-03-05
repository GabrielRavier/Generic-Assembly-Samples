void my_m_prefetchw(void *p)
{
	__builtin_prefetch(p, 1, 3 /* _MM_HINT_T0 */);
}