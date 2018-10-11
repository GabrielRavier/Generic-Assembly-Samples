// if less than 0 then returns -1 else 0
int32_t getSign(int32_t x)
{
	return -(x < 0);
}

int32_t getSign2(int32_t x)
{
	return -(int32_t)((uint32_t)((int32_t)x) >> (sizeof(int32_t) * CHAR_BIT - 1));
}

int32_t getSign3(int32_t x)
{
	return x >> (sizeof(int32_t) * CHAR_BIT - 1);	// not portable
}

// returns either -1 or 1
int32_t getSign4(int32_t x)
{
	return 1 | (x >> (sizeof(int32_t) * CHAR_BIT - 1));
}

// returns either -1, 0 or -1
int32_t getSign5(int32_t x)
{
	return (x != 0) | -(int32_t)((uint32_t)((int32_t)v) >> sizeof(int32_t) * CHAR_BIT - 1));
}

int32_t getSign6(int32_t x)
{
	return (x != 0) | (v >> (sizeof(int32_t) * CHAR_BIT - 1)); // less portable
}

int32_t getSign7(int32_t x)
{
	return (x > 0) - (v < 0);
}

bool isNotNegative(int32_t x)
{
	return 1 ^ ((uint32_t)x >> (sizeof(int32_t) * CHAR_BIT - 1));
}

bool areSignOpposite(int32_t x, int32_t y)
{
	return ((x ^ y) < 0);
}

uint32_t myabs(int32_t x)
{
	const int32_t mask = x >> sizeof(int32_t) * CHAR_BIT - 1;
	return (x + mask) ^ mask;
}

uint32_t myabs2(int32_t x)
{
	return (x < 0) ? -(uint32_t)x : x;
}

uint32_t myabs3(int32_t x)
{
	const int32_t mask = x >> sizeof(int32_t) * CHAR_BIT - 1;
	return (x ^ mask) - mask;
}

uint32_t myabs4(int32_t x)
{
	return (1 | (x >> (sizeof(int32_t) * CHAR_BIT - 1))) * x;
}

uint32_t myabs5(int32_t x)
{
	return (x < 0) ? (1 + ((uint32_t)(-1-x))) : (uint32_t)x;
}

int32_t min(int32_t x, int32_t y)
{
	return y ^ ((x ^ y) & -(x < y));
}

int32_t max(int32_t x, int32_t y)
{
	return x ^ ((x ^ y) & -(x < y));
}

bool isPowerOf2(uint32_t x)
{
	return x && !(x & (x - 1));
}

int32_t signExtendFromWidth(int32_t x, uint8_t bitWidth)
{
	const int mask = 1u << (b - 1);
	x &= ((1U << bitWidth) - 1);
	return (x ^ m) - m;
}

int32_t signExtendFromWidth2(int32_t x, uint8_t bitWidth)
{
	#define M(B) (1U << ((sizeof(x) * CHAR_BIT) - B)) // CHAR_BIT=bits/byte
	constexpr static int multipliers[] = 
	{
	0,     M(1),  M(2),  M(3),  M(4),  M(5),  M(6),  M(7),
	M(8),  M(9),  M(10), M(11), M(12), M(13), M(14), M(15),
	M(16), M(17), M(18), M(19), M(20), M(21), M(22), M(23),
	M(24), M(25), M(26), M(27), M(28), M(29), M(30), M(31),
	M(32)
	}; // (add more if using more than 64 bits)
	constexpr static int divisors[] = 
	{
	1,    ~M(1),  M(2),  M(3),  M(4),  M(5),  M(6),  M(7),
	M(8),  M(9),  M(10), M(11), M(12), M(13), M(14), M(15),
	M(16), M(17), M(18), M(19), M(20), M(21), M(22), M(23),
	M(24), M(25), M(26), M(27), M(28), M(29), M(30), M(31),
	M(32)
	}; // (add more for 64 bits)
	#undef M
	return (x * multipliers[bitWidth]) / divisors[bitWidth];
}

uint32_t conditionalClearOrSet(uint32_t wordToModify, uint32_t bitMask, bool doIt)
{
	wordToModify ^= (-doIt ^ wordToModify) & bitMask;
	return wordToModify;
}

uint32_t conditionalClearOrSetSuperScalar(uint32_t wordToModify, uint32_t bitMask, bool doIt)
{
	return (wordToModify & ~bitMask) | (-doIt & bitMask);
}

int32_t conditionalNegate(bool dontNegate, int32_t x)
{
	return (dontNegate ^ (dontNegate - 1)) * x;
}

int32_t conditionalNegate2(bool negate, int32_t x)
{
	return (x ^ -negate) + negate;
}