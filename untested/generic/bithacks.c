// if less than 0 then returns -1 else 0
int8_t getSign1(int32_t x)
{
	return -(x < 0);
}

// returns either -1 or 1
int8_t getSign2(int32_t x)
{
	return 1 | (x >> (sizeof(int32_t) * CHAR_BIT - 1));
}

// returns either -1, 0 or -1
int8_t getSign3(int32_t x)
{
	return (x > 0) - (x < 0);
}

bool isNotNegative(int32_t x)
{
	return 1 ^ ((uint32_t)x >> (sizeof(int32_t) * CHAR_BIT - 1));
}

bool areSignsOpposite(int32_t x, int32_t y)
{
	return ((x ^ y) < 0);
}

int32_t signExtendFromWidth(int32_t x, uint8_t bitWidth)
{
	const int32_t mask = 1u << (bitWidth - 1);
	x &= ((1U << bitWidth) - 1);
	return (x ^ mask) - mask;
}

uint32_t conditionalClearOrSet(uint32_t wordToModify, uint32_t bitMask, bool doIt)
{
	return wordToModify ^ bitMask & (wordToModify ^ -doIt);
}

uint32_t swapBits(uint8_t swapPos1, uint8_t swapPos2, uint8_t sizeSequenceBits, uint32_t bitsToSwap)
{
	uint32_t temp = ((bitsToSwap >> swapPos1) ^ (bitsToSwap >> swapPos2)) & ((1U << sizeSequenceBits) - 1);
	return bitsToSwap ^ ((temp << swapPos1) | (temp << swapPos2));
}

bool hasZeroByte(uint32_t x)
{
	uint8_t *p = (uint8_t *)&x;
	return *p && *(p + 1) && *(p + 2) && *(p + 3);
}

bool parity(uint32_t x)
{
    return __builtin_parity(x);
}

// if less than 0 then returns -1 else 0
int8_t getSign164(int64_t x)
{
	return -(x < 0);
}

// returns either -1 or 1
int8_t getSign264(int64_t x)
{
	return 1 | (x >> (sizeof(int64_t) * CHAR_BIT - 1));
}

// returns either -1, 0 or -1
int8_t getSign364(int64_t x)
{
	return (x > 0) - (x < 0);
}

bool isNotNegative64(int64_t x)
{
	return 1 ^ ((uint64_t)x >> (sizeof(int64_t) * CHAR_BIT - 1));
}

bool areSignsOpposite64(int64_t x, int64_t y)
{
	return ((x ^ y) < 0);
}

int64_t signExtendFromWidth64(int64_t x, uint8_t bitWidth)
{
	const int64_t mask = 1ULL << (bitWidth - 1);
	x &= ((1ULL << bitWidth) - 1);
	return (x ^ mask) - mask;
}

uint64_t conditionalClearOrSet64(uint64_t wordToModify, uint64_t bitMask, bool doIt)
{
	return wordToModify ^ bitMask & (wordToModify ^ -doIt);
}

uint64_t swapBits64(uint8_t swapPos1, uint8_t swapPos2, uint8_t sizeSequenceBits, uint64_t bitsToSwap)
{
	uint64_t temp = ((bitsToSwap >> swapPos1) ^ (bitsToSwap >> swapPos2)) & ((1ULL << sizeSequenceBits) - 1);
	return bitsToSwap ^ ((temp << swapPos1) | (temp << swapPos2));
}

bool hasZeroByte64(uint64_t x)
{
	uint8_t *p = (uint8_t *)&x;
	return *p && *(p + 1) && *(p + 2) && *(p + 3) && *(p + 4) && *(p + 5) && *(p + 6) && *(p + 7);
}

bool parity64(uint64_t x)
{
    return __builtin_parityll(x);
}

