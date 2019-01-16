#include <cstdint>

unsigned gf_mul(unsigned a, unsigned b)
{
	unsigned res = 0, m = 0x11b;
	
	while (b) 
	{
		if (b & 1)
			res ^= a;
	
		a <<= 1;
		b >>= 1;
	
		if (a >= 256)
			a ^= m;
	}
	
	return res;
}

uint32_t AES_RotWord(uint32_t x)
{
	return (x >> 8) | (x << 24);
}