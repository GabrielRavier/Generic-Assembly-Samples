#include <cstdint>

bool isPowerOf2(int32_t x)
{
	bool result;
	
	if (x)
		result = ((x - 1) & x) == 0;
	else
		result = 0;
	return result;
}

bool isPowerOf264(int64_t x)
{
	bool result;
	
	if (x)
		result = ((x - 1) & x) == 0;
	else
		result = 0;
	return result;
}