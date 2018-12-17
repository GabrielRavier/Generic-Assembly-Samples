// From bochs lol

uint8_t my_bsfd(uint32_t x)
{
	return __builtin_ctz(x);
}

uint8_t my_bsrd(uint32_t x)
{
	return __builtin_clz(x);
}

uint32_t my_bswapd(uint32_t x)
{
	return __builtin_bswap32(x);
}

inline uint8_t BitReflect8(uint8_t val8)
{
	return ((val8 & 0x80) >> 7) |
			((val8 & 0x40) >> 5) |
			((val8 & 0x20) >> 3) |
			((val8 & 0x10) >> 1) |
			((val8 & 0x08) << 1) |
			((val8 & 0x04) << 3) |
			((val8 & 0x02) << 5) |
			((val8 & 0x01) << 7);
}

inline uint16_t BitReflect16(uint16_t val16)
{
	return ((uint16_t)(BitReflect8(val16 & 0xff)) << 8) | BitReflect8(val16 >> 8);
}

inline uint32_t BitReflect32(uint32_t val32)
{
	return ((uint32_t)(BitReflect16(val32 & 0xffff)) << 16) | BitReflect16(val32 >> 16);
}

inline uint32_t mod2_64bit(uint64_t divisor, uint64_t dividend)
{
	uint64_t remainder = dividend >> 32;
	
	for (int bitpos=31; bitpos>=0; bitpos--) 
	{
		// copy one more bit from the dividend
		remainder = (remainder << 1) | ((dividend >> bitpos) & 1);
		
		// if MSB is set, then XOR divisor and get new remainder
		if (((remainder >> 32) & 1) == 1)
			remainder ^= divisor;
	}
	
	return (uint32_t)remainder;
}

constexpr uint64_t crc32Polymonial = 0x11EDC6F41ULL;

uint32_t my_crc32b(uint32_t c, uint8_t v)
{
	c = BitReflect32(c);
	
	uint64_t tmp1 = ((uint64_t) BitReflect8 (v)) << 32;
	uint64_t tmp2 = ((uint64_t) c) <<  8;
	uint64_t tmp3 = tmp1 ^ tmp2;
	c = mod2_64bit(crc32Polymonial, tmp3);
	
	return BitReflect32(c);
}

uint32_t my_crc32w(uint32_t c, uint16_t v)
{
	c = BitReflect32(c);
	
	uint64_t tmp1 = ((uint64_t) BitReflect16(v)) << 32;
	uint64_t tmp2 = ((uint64_t) c) << 16;
	uint64_t tmp3 = tmp1 ^ tmp2;
	c = mod2_64bit(crc32Polymonial, tmp3);
	
	return BitReflect32(c);
}

uint32_t my_crc32d(uint32_t c, uint32_t v)
{
	c = BitReflect32(c);
	
	uint64_t tmp1 = ((uint64_t) BitReflect32(v)) << 32;
	uint64_t tmp2 = ((uint64_t) c) << 32;
	uint64_t tmp3 = tmp1 ^ tmp2;
	c = mod2_64bit(crc32Polymonial, tmp3);
	
	return BitReflect32(c);
}

int32_t my_popcntd(uint32_t x)
{
	return __builtin_popcount(x);
}

uint8_t my_rolb(uint8_t x, int32_t c)
{
	uint32_t count = c;
	
	if ((count & 7) == 0)
		return x;
	
	count &= 7; // use only lowest 3 bits
	
	uint8_t result = (x << count) | (x >> (8 - count));
	
	return result;
}

uint16_t my_rolw(uint16_t x, int32_t c)
{
	uint32_t count = c;
	
	if ((count & 0xF) == 0)
		return x;
	
	count &= 0xF; // only use bottom 4 bits
	
	uint16_t result = (x << count) | (x >> (16 - count));
	
	return result;
}

uint32_t my_rold(uint32_t x, int32_t c)
{
	return (x << c) | (x >> (32 - c));
}

uint8_t my_rorb(uint8_t x, int32_t c)
{
	uint32_t count = c;
	
	if ((count & 7) == 0)
		return x;
	
	count &= 7; // use only lowest 3 bits
	
	uint8_t result = (x >> count) | (x << (8 - count));
	
	return result;
}

uint16_t my_rorw(uint16_t x, int32_t c)
{
	uint32_t count = c;
	
	if ((count & 0xF) == 0)
		return x;
	
	count &= 0xF; // only use bottom 4 bits
	
	uint16_t result = (x >> count) | (x << (16 - count));
	
	return result;
}

uint32_t my_rord(uint32_t x, int32_t c)
{
	return (x >> c) | (x << (32 - c));
}

int32_t my_bsfq(uint64_t x)
{
	return __builtin_ctzll(x);
}

int32_t my_bsrq(uint64_t x)
{	
	return __builtin_clzll(x)
}

int64_t my_bswapq(int64_t x)
{
	return __builtin_bswap64(x);
}

uint64_t my_crc32q(uint64_t c, uint64_t v)
{
	uint32_t c32 = c;
	c32 = BitReflect32(c32);
	
	uint64_t tmp1 = ((uint64_t)BitReflect32(v & 0xffffffff)) << 32;
	uint64_t tmp2 = ((uint64_t)c32) << 32;
	uint64_t tmp3 = tmp1 ^ tmp2;
	
	c32  = mod2_64bit(crc32Polymonial, tmp3);
	tmp1 = ((uint64_t)BitReflect32(v >> 32)) << 32;
	tmp2 = ((uint64_t)c32) << 32;
	tmp3 = tmp1 ^ tmp2;
	c32  = mod2_64bit(crc32Polymonial, tmp3);
	
	return BitReflect32(c32);
}

int64_t my_popcntq(uint64_t x)
{
	return __builtin_popcountll(x);
}

uint64_t my_rolq(uint64_t x, int32_t c)
{
	return (x << c) | (x >> (64 - c));
}

uint64_t my_rorq(uint64_t x, int32_t c)
{
	return (x >> c) | (x << (64 - c));
}