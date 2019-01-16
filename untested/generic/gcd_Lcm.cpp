#include <cstdint>

int32_t gcd(int32_t a, int32_t b)
{
	while (a && b)
	{
		if (a == b)
			return a;
		if (a <= b)
			b -= a;
		else
			a = -(b - a);
	}
	return 0;
}

int32_t lcm(int32_t a, int32_t b)
{
	return b * a / gcd(a, b);
}

int64_t gcd(int64_t a, int64_t b)
{
	while (a && b)
	{
		if (a == b)
			return a;
		if (a <= b)
			b -= a;
		else
			a = -(b - a);
	}
	return 0;
}

int64_t lcm(int64_t a, int64_t b)
{
	return b * a / gcd(a, b);
}

