#include <cstdint>

uint32_t nextPowerOf2(uint32_t current)
{
	uint8_t shift;
	
	if (current)
	{
		if (!((current - 1) & current))
			return current;
		shift = 0;
		do
		{
			current >>= 1;
			++shift;
		} while (current);
	}
	else
		shift = 0;
	return 1 << shift;
}

uint64_t nextPowerOf2(uint64_t current)
{
	uint8_t shift;
	
	if (current)
	{
		if (!((current - 1) & current))
			return current;
		shift = 0;
		do
		{
			current >>= 1;
			++shift;
		} while (current);
	}
	else
		shift = 0;
	return 1 << shift;
}