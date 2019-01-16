#include <cstdint>

bool isLeapYear(uint32_t x)
{
	return !(x % 400) || x % 100 && !(x % 4);
}