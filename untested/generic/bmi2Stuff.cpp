#include <cstdint>

uint32_t mulx(uint32_t x, uint32_t y, int32_t *up)
{
	uint64_t tmp;
	
	tmp = y * (uint64_t)x;
	*up = tmp >> 32;
	return tmp;
}