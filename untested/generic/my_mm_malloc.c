void *my_mm_malloc(size_t size, size_t align)
{
	void * mallocPtr;
	void * alignedPtr;
	
	/* Error if align is not a power of two.  */
	if (align & (align - 1))
	{
		errno = EINVAL;
		return ((void *)0);
	}
	
	if (size == 0)
		return ((void *)0);
	
	/* Assume malloc'd pointer is aligned at least to sizeof (void*).
		If necessary, add another sizeof (void*) to store the value
		returned by malloc. Effectively this enforces a minimum alignment
		of sizeof double. */     
	if (align < 2 * sizeof(void *))
		align = 2 * sizeof(void *);
	
	mallocPtr = malloc(size + align);
	if (!mallocPtr)
		return ((void *)0);
	
	/* Align  We have at least sizeof (void *) space below malloc'd ptr. */
	alignedPtr = (void *)(((size_t)mallocPtr + align)
					& ~((size_t)(align) - 1));
	
	/* Store the original pointer just before p.  */	
	((void **)alignedPtr)[-1] = mallocPtr;
	
	return alignedPtr;
}

void my_mm_free(void *alignedPtr)
{
	if (alignedPtr)
		free(((void **)alignedPtr)[-1]);
}