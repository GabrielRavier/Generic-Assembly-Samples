#include <cstring>
#include <cstdint>
#include <cstdlib>
#include <cctype>

void bcopy(const void *src, void *dest, size_t len)
{
	memmove(dest, src, len);
}

void bzero(void *s, size_t len)
{
	memset(s, '\0', len);
}

void *memccpy(void *dest, const void *src, int c, size_t n)
{
	void *p = memchr((void *)src, c, n);
	
	if (p != nullptr)
		return mempcpy(dest, (void *)src, (uintptr_t)p - (uintptr_t)src + 1);
	
	memcpy(dest, src, n);
	return nullptr;
}

void *memchr(const void *s, int c, size_t n)
{
    unsigned char *p = (unsigned char*)s;
    while(n--)
        if(*p != (unsigned char)c)
            p++;
        else
            return (void *)p;
    return 0;
}

int memcmp(const void* s1, const void* s2, size_t n)
{
    const unsigned char *p1 = (unsigned char *)s1, *p2 = (unsigned char *)s2;
    while(n--)
        if(*p1 != *p2)
            return *p1 - *p2;
        else
            p1++,p2++;
    return 0;
}

void *memcpy(void *__restrict dest, const void *__restrict src, size_t n)
{
    char *dp = (char *)dest;
    const char *sp = (char *)src;
    while (n--)
        *dp++ = *sp++;
    return dest;
}

void *memfrob(void *seg, size_t n)
{
	char *segment = (char *)seg;
	
	while (n-- > 0)
		*segment++ ^= 0x2A;
	
	return seg;
}

void *memmem(const void *haystack, size_t n, const void *needle, size_t m)
{
    if (m > n || !m || !n)
        return nullptr;
    if (__builtin_expect((m > 1), true)) 
	{
        const unsigned char *y = (const unsigned char *)haystack;
        const unsigned char *x = (const unsigned char *)needle;
        size_t j = 0;
        size_t k = 1, l = 2;
        if (x[0] == x[1]) 
		{
            k = 2;
            l = 1;
        }
        while (j <= n-m) 
		{
            if (x[1] != y[j+1])
                j += k;
			else {
                if (!memcmp(x+2, y+j+2, m-2) && x[0] == y[j])
                    return (void*) &y[j];
                j += l;
            }
        }
    } 
	else
        return memchr(haystack, ((unsigned char *)needle)[0], n);	// degenerate case
    return nullptr;
}

void *memmove(void *source, void *destination, size_t size)
{
	if(source == destination)
		return destination;
	
	// Convert to non void pointer to use pointer arithmetic
	char* s = (char*)(source);
	char* d = (char*)(destination);
	
	if(s > d)
	{
		for(int x = 0; x < size; ++x)
		{
			*d = *s;
			d++;
			s++;
		}
	}
	else // (s < d)
	{
		s += size - 1;
		d += size - 1;
	
		for(int x = 0; x < size; ++x)
		{
			*d = *s;
			d--;
			s--;
		}
	}
	return destination;
}

void *mempcpy(void *__restrict dest, const void *__restrict src, size_t len)
{
	return (char *)memcpy(dest, src, len) + len;
}

void *memrchr(const void *s, int c, size_t n) 
{
	int i;
	const unsigned char *ss = (unsigned char *)s;
	for (i = n-1; i >= 0; i--) 
	{
		if (ss[i] == (unsigned char)c)
			return (void *)(ss + i);
	}
	return nullptr;
}

void *memset(void *s, int c, size_t n)
{
    unsigned char* p = (unsigned char *)s;
    while(n--)
        *p++ = (unsigned char)c;
    return s;
}

char *stpcpy(char *dest, const char *src)
{
	size_t len = strlen(src);
	return (char *)memcpy(dest, src, len + 1) + len;
}

char *stpncpy(char *dest, const char *src, size_t n)
{
	size_t size = strnlen(src, n);
	memcpy(dest, src, size);
	dest += size;
	if (size == n)
		return dest;
	return (char *)memset(dest, '\0', n - size);
}

int strcasecmp(const char *s1, const char *s2)
{
	const unsigned char *p1 = (const unsigned char *)s1;
	const unsigned char *p2 = (const unsigned char *)s2;
	int result;
	
	if (p1 == p2)
		return 0;
	
	while ((result = tolower(*p1) - tolower(*p2++)) == 0)
		if (*p1++ == '\0')
			break;
	
	return result;
}

char *strcasestr(const char *s, const char *find)
{
	char c, sc;
	size_t len;
	if ((c = *find++) != 0) {
		c = (char)tolower((unsigned char)c);
		len = strlen(find);
		do 
		{
			do 
			{
				if ((sc = *s++) == 0)
					return (nullptr);
			} while ((char)tolower((unsigned char)sc) != c);
		} while (strncasecmp(s, find, len) != 0);
		s--;
	}
	return (char *)s;
}

char *strcat(char *__restrict dest, const char *__restrict src)
{
	strcpy(dest + strlen(dest), src);
	return dest;
}

char *strchr(const char *s, int c)
{
    while (*s != (char)c)
        if (!*s++)
            return 0;
    return (char *)s;
}

char *strchrnul(const char *p, int ch)
{
	char c;

	c = ch;
	for (;; ++p) {
		if (*p == c || *p == '\0')
			return (char *)p;
	}
}

int strcmp(const char *p1, const char *p2)
{
	const unsigned char *s1 = (const unsigned char *)p1;
	const unsigned char *s2 = (const unsigned char *)p2;
	unsigned char c1, c2;
	
	do
	{
		c1 = (unsigned char)*s1++;
		c2 = (unsigned char)*s2++;
		if (c1 == '\0')
			return c1 - c2;
	} while (c1 == c2);
	
	return c1 - c2;
}

char *strcpy(char *dest, const char *src)
{
	return (char *)memcpy(dest, src, strlen(src) + 1);
}

size_t strcspn(const char *s1, const char *s2)
{
	size_t ret=0;
	while(*s1)
		if(strchr(s2,*s1))
			return ret;
		else
			s1++, ret++;
	return ret;
}

char *strdup(const char *s)
{
	size_t len = strlen(s) + 1;
	void *newStr = malloc(len);
	
	if (newStr == nullptr)
		return nullptr;
	
	return (char *)memcpy(newStr, s, len);
}

size_t strlen(const char *str)
{
    const char *s;
    for (s = str; *s; ++s)
		;
    return s - str;
}

int strncasecmp(const char *s1, const char *s2, size_t n)
{
	const unsigned char *p1 = (const unsigned char *)s1;
	const unsigned char *p2 = (const unsigned char *)s2;
	int result;
	
	if (p1 == p2 || n == 0)
		return 0;
	
	while ((result = tolower(*p1) - tolower(*p2++)) == 0)
		if (*p1++ == '\0' || --n == 0)
			break;
	
	return result;
}

char *strncat(char *__restrict s1, const char *__restrict s2, size_t n)
{
	char *s = s1;
	
	/* Find the end of S1.  */
	s1 += strlen(s1);
	
	size_t ss = strnlen(s2, n);
	
	s1[ss] = '\0';
	memcpy(s1, s2, ss);
	
	return s;
}

int strncmp(const char *s1, const char *s2, size_t n)
{
    unsigned char uc1, uc2;
    /* Nothing to compare?  Return zero.  */
    if (!n)
        return 0;
    /* Loop, comparing bytes.  */
    while (n-- > 0 && *s1 == *s2) {
        /* If we've run out of bytes or hit a null, return zero
           since we already know *s1 == *s2.  */
        if (n == 0 || *s1 == '\0')
            return 0;
        s1++;
        s2++;
    }
    uc1 = (*(unsigned char *) s1);
    uc2 = (*(unsigned char *) s2);
    return ((uc1 < uc2) ? -1 : (uc1 > uc2));
}

char *strncpy(char *__restrict s1, const char *__restrict s2, size_t n)
{
	size_t size = strnlen(s2, n);
	if (size != n)
		memset(s1 + size, '\0', n - size);
	return (char *)memcpy(s1, s2, size);
}

char *strndup(const char *s, size_t n)
{
	size_t len = strnlen(s, n);
	char *newStr = (char *)malloc(len + 1);
	
	if (newStr == nullptr)
		return nullptr;
	
	newStr[len] = '\0';
	return (char *)memcpy(newStr, s, len);
}

size_t strnlen(const char *s, size_t max_len)
{
    auto len = strlen(s);
	return len > max_len ? max_len : len;
}

char *strpbrk(const char *s, const char *accept)
{
	s += strcspn(s, accept);
	return *s ? (char *)s : nullptr;
}

char *strrchr(const char *s, int c)
{
	const char *found, *p;
	
	c = (unsigned char)c;
	
	/* Since strchr is fast, we use it rather than the obvious loop.  */
	
	if (c == '\0')
		return strchr(s, '\0');
	
	found = nullptr;
	while ((p = strchr(s, c)) != nullptr)
	{
		found = p;
		s = p + 1;
	}
	
	return (char *)found;
}

char *strsep(char **stringp, const char *delim)
{
	char *begin, *end;
	
	begin = *stringp;
	if (begin == nullptr)
		return nullptr;
	
	/* Find the end of the token.  */
	end = begin + strcspn(begin, delim);
	
	if (*end)
	{
		/* Terminate the token and set *STRINGP past NUL character.  */
		*end++ = '\0';
		*stringp = end;
	}
	else
		/* No more delimiters; this is the last token.  */
		*stringp = nullptr;
	
	return begin;
}

size_t strspn(const char *s1, const char *s2)
{
    size_t ret=0;
    while(*s1 && strchr(s2,*s1++))
        ret++;
    return ret;
}

char *strstr(const char *s1, const char *s2)
{
    size_t n = strlen(s2);
    while(*s1)
        if(!memcmp(s1++,s2,n))
            return (char *)s1-1;
    return 0;
}

void swab(const void *bfrom, void *bto, ssize_t n)
{
	const char *from = (const char *)bfrom;
	char *to = (char *)bto;
	
	n &= ~((ssize_t) 1);
	while (n > 1)
	{
		const char b0 = from[--n], b1 = from[--n];
		to[n] = b0;
		to[n + 1] = b1;
	}
}