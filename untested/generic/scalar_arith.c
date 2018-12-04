// parity

bool parityByte(uint8_t val8)
{
	return (0x9669 >> ((val8 ^ (val8 >> 4)) & 0xF)) & 1;
}

// tzcnt

uint8_t tzcntw(uint16_t val16)
{
	uint16_t mask = 0x1;
	uint8_t count = 0;
	
	while ((val16 & mask) == 0 && mask) 
	{
		mask <<= 1;
		count++;
	}
	
	return count;
}

uint8_t tzcntd(uint32_t val32)
{
	uint32_t mask = 0x1;
	uint8_t count = 0;
	
	while ((val32 & mask) == 0 && mask) 
	{
		mask <<= 1;
		count++;
	}
	
	return count;
}

uint8_t tzcntq(uint64_t val64)
{
	uint64_t mask = 0x1;
	uint8_t count = 0;
	
	while ((val64 & mask) == 0 && mask) 
	{
		mask <<= 1;
		count++;
	}
	
	return count;
}

// lzcnt

uint8_t lzcntw(uint16_t val16)
{
	uint16_t mask = 0x8000;
	uint8_t count = 0;
	
	while ((val16 & mask) == 0 && mask) 
	{
		mask >>= 1;
		count++;
	}
	
	return count;
}

uint8_t lzcntd(uint32_t val32)
{
	uint32_t mask = 0x80000000;
	uint8_t count = 0;
	
	while ((val32 & mask) == 0 && mask) 
	{
		mask >>= 1;
		count++;
	}
	
	return count;
}

uint8_t lzcntq(uint64_t val64)
{
	uint64_t mask = 0x8000000000000000ULL;
	uint8_t count = 0;
	
	while ((val64 & mask) == 0 && mask) 
	{
		mask >>= 1;
		count++;
	}
	
	return count;
}

// popcnt

uint8_t popcntb(uint8_t val8)
{
	val8 = ((val8>>1) & 0x55) + (val8 & 0x55);
	val8 = ((val8>>2) & 0x33) + (val8 & 0x33);
	val8 = ((val8>>4) & 0x0F) + (val8 & 0x0F);
	
	return val8;
}

uint8_t popcntw(uint16_t val16)
{
	val16 = ((val16>>1) & 0x5555) + (val16 & 0x5555);
	val16 = ((val16>>2) & 0x3333) + (val16 & 0x3333);
	val16 = ((val16>>4) & 0x0F0F) + (val16 & 0x0F0F);
	val16 = ((val16>>8) & 0x00FF) + (val16 & 0x00FF);
	
	return val16;
}

uint8_t popcntd(uint32_t val32)
{
	val32 = ((val32 >>  1) & 0x55555555) + (val32 & 0x55555555);
	val32 = ((val32 >>  2) & 0x33333333) + (val32 & 0x33333333);
	val32 = ((val32 >>  4) & 0x0F0F0F0F) + (val32 & 0x0F0F0F0F);
	val32 = ((val32 >>  8) & 0x00FF00FF) + (val32 & 0x00FF00FF);
	val32 = ((val32 >> 16) & 0x0000FFFF) + (val32 & 0x0000FFFF);
	
	return val32;
}

uint8_t popcntq(uint64_t val64)
{
	val64 = ((val64 >>  1) & BX_CONST64(0x5555555555555555)) + (val64 & BX_CONST64(0x5555555555555555));
	val64 = ((val64 >>  2) & BX_CONST64(0x3333333333333333)) + (val64 & BX_CONST64(0x3333333333333333));
	val64 = ((val64 >>  4) & BX_CONST64(0x0F0F0F0F0F0F0F0F)) + (val64 & BX_CONST64(0x0F0F0F0F0F0F0F0F));
	val64 = ((val64 >>  8) & BX_CONST64(0x00FF00FF00FF00FF)) + (val64 & BX_CONST64(0x00FF00FF00FF00FF));
	val64 = ((val64 >> 16) & BX_CONST64(0x0000FFFF0000FFFF)) + (val64 & BX_CONST64(0x0000FFFF0000FFFF));
	val64 = ((val64 >> 32) & BX_CONST64(0x00000000FFFFFFFF)) + (val64 & BX_CONST64(0x00000000FFFFFFFF));
	
	return val64;
}

// bit extract

uint32_t bextrd(uint32_t val32, uint32_t start, uint32_t len)
{
	uint32_t result = 0;
	
	if (start < 32 && len > 0) 
	{
		result = val32 >> start;
	
		if (len < 32)
		{
			uint32_t extract_mask = (1 << len) - 1;
			result &= extract_mask;
		}
	}
	
	return result;
}

uint64_t bextrq(uint64_t val64, uint32_t start, uint32_t len)
{
	uint64_t result = 0;
	
	if (start < 64 && len > 0) 
	{
		result = val64 >> start;
	
		if (len < 64) 
		{
			uint64_t extract_mask = (1ULL << len) - 1;
			result &= extract_mask;
		}
	}
	
	return result;
}