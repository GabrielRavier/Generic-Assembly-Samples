inline int8_t SaturateWordSToByteS(int16_t value)
{
	if (value < -128) 
		return -128;
	if (value >  127) 
		return  127;
	return (int8_t)value;
}

#define BYTE0(n) BYTEn((n), 0)
#define WORD0(n) WORDn((n), 0)
#define SWORD0(n) SWORDn((n), 0)
#define SBYTE0(n) SBYTEn((n), 0)

uint64_t my_mm_packs_pi16(uint64_t m1, uint64_t m2)
{
	SBYTE0(m1) = SaturateWordSToByteS(SWORD0(m1));
	SBYTE1(m1) = SaturateWordSToByteS(SWORD1(m1));
	SBYTE2(m1) = SaturateWordSToByteS(SWORD2(m1));
	SBYTE3(m1) = SaturateWordSToByteS(SWORD3(m1));
	
	SBYTE4(m1) = SaturateWordSToByteS(SWORD0(m2));
	SBYTE5(m1) = SaturateWordSToByteS(SWORD1(m2));
	SBYTE6(m1) = SaturateWordSToByteS(SWORD2(m2));
	SBYTE7(m1) = SaturateWordSToByteS(SWORD3(m2));
	
	return m1;
}

inline int16_t SaturateDwordSToWordS(int32_t value)
{
	if(value < -32768) 
		return -32768;
	if(value >  32767) 
		return  32767;
	return (int16_t) value;
}

uint64_t my_mm_packs_pi32(uint64_t m1, uint64_t m2)
{
	SWORD0(m1) = SaturateDwordSToWordS(SLODWORD(m1));
	SWORD1(m1) = SaturateDwordSToWordS(SHIDWORD(m1));
	SWORD2(m1) = SaturateDwordSToWordS(SLODWORD(m2));
	SWORD3(m1) = SaturateDwordSToWordS(SHIDWORD(m2));
	
	return m1;
}

inline uint8_t SaturateWordSToByteU(int16_t value)
{
	if (value < 0) 
		return 0;
	if (value > 255) 
		return 255;
	return (uint8_t)value;
}

uint64_t my_mm_packs_pu16(uint64_t m1, uint64_t m2)
{
	BYTE0(m1) = SaturateWordSToByteU(SWORD0(m1));
	BYTE1(m1) = SaturateWordSToByteU(SWORD1(m1));
	BYTE2(m1) = SaturateWordSToByteU(SWORD2(m1));
	BYTE3(m1) = SaturateWordSToByteU(SWORD3(m1));
	BYTE4(m1) = SaturateWordSToByteU(SWORD0(m2));
	BYTE5(m1) = SaturateWordSToByteU(SWORD1(m2));
	BYTE6(m1) = SaturateWordSToByteU(SWORD2(m2));
	BYTE7(m1) = SaturateWordSToByteU(SWORD3(m2));
	
	return m1;
}

uint64_t my_mm_unpackhi_pi8(uint64_t m1, uint64_t m2)
{	
	BYTE0(m1) = BYTE4(m1);
	BYTE1(m1) = BYTE4(m2);
	BYTE2(m1) = BYTE5(m1);
	BYTE3(m1) = BYTE5(m2);
	BYTE4(m1) = BYTE6(m1);
	BYTE5(m1) = BYTE6(m2);
	BYTE6(m1) = BYTE7(m1);
	BYTE7(m1) = BYTE7(m2);
	
	return m1;
}

uint64_t my_mm_unpackhi_pi16(uint64_t m1, uint64_t m2)
{	
	WORD0(m1) = WORD2(m1);
	WORD1(m1) = WORD2(m2);
	WORD2(m1) = WORD3(m1);
	WORD3(m1) = WORD3(m2);
	
	return m1;
}

uint64_t my_mm_unpackhi_pi32(uint64_t m1, uint64_t m2)
{	
	LODWORD(m1) = HIDWORD(m1);
	HIDWORD(m1) = HIDWORD(m2);
	
	return m1;
}

uint64_t my_mm_unpacklo_pi8(uint64_t m1, uint64_t m2)
{
	BYTE7(m1) = BYTE3(m2);
	BYTE6(m1) = BYTE3(m1);
	BYTE5(m1) = BYTE2(m2);
	BYTE4(m1) = BYTE2(m1);
	BYTE3(m1) = BYTE1(m2);
	BYTE2(m1) = BYTE1(m1);
	BYTE1(m1) = BYTE0(m2);
 // BYTE0(m1) = BYTE0(m1);
	
	return m1;
}

uint64_t my_mm_unpacklo_pi16(uint64_t m1, uint64_t m2)
{
	WORD3(m1) = WORD1(m2);
	WORD2(m1) = WORD1(m1);
	WORD1(m1) = WORD0(m2);
 // WORD0(m1) = WORD0(m1);
 
	return m1;
}

uint64_t my_mm_unpacklo_pi32(uint64_t m1, uint64_t m2)
{
	HIDWORD(m1) = LODWORD(m2);
	return m1;
}

uint64_t my_mm_add_pi8(uint64_t m1, uint64_t m2)
{
	BYTE0(m1) += BYTE0(m2);
	BYTE1(m1) += BYTE1(m2);
	BYTE2(m1) += BYTE2(m2);
	BYTE3(m1) += BYTE3(m2);
	BYTE4(m1) += BYTE4(m2);
	BYTE5(m1) += BYTE5(m2);
	BYTE6(m1) += BYTE6(m2);
	BYTE7(m1) += BYTE7(m2);
	
	return m1;
}

uint64_t my_mm_add_pi16(uint64_t m1, uint64_t m2)
{
	WORD0(m1) += WORD0(m2);
	WORD1(m1) += WORD1(m2);
	WORD2(m1) += WORD2(m2);
	WORD3(m1) += WORD3(m2);
	
	return m1;
}

uint64_t my_mm_add_pi32(uint64_t m1, uint64_t m2)
{
	LODWORD(m1) += LODWORD(m2);
	HIDWORD(m1) += HIDWORD(m2);
	
	return m1;
}

uint64_t my_mm_add_si64(uint64_t m1, uint64_t m2)
{
	return m1 + m2;
}

uint64_t my_mm_adds_pi8(uint64_t m1, uint64_t m2)
{
	SBYTE0(m1) = SaturateWordSToByteS(int16_t(SBYTE0(m1)) + int16_t(MMXSB0(m2)));
	SBYTE1(m1) = SaturateWordSToByteS(int16_t(SBYTE1(m1)) + int16_t(MMXSB1(m2)));
	SBYTE2(m1) = SaturateWordSToByteS(int16_t(SBYTE2(m1)) + int16_t(MMXSB2(m2)));
	SBYTE3(m1) = SaturateWordSToByteS(int16_t(SBYTE3(m1)) + int16_t(MMXSB3(m2)));
	SBYTE4(m1) = SaturateWordSToByteS(int16_t(SBYTE4(m1)) + int16_t(MMXSB4(m2)));
	SBYTE5(m1) = SaturateWordSToByteS(int16_t(SBYTE5(m1)) + int16_t(MMXSB5(m2)));
	SBYTE6(m1) = SaturateWordSToByteS(int16_t(SBYTE6(m1)) + int16_t(MMXSB6(m2)));
	SBYTE7(m1) = SaturateWordSToByteS(int16_t(SBYTE7(m1)) + int16_t(MMXSB7(m2)));
	
	return m1;
}

uint64_t my_mm_adds_pi16(uint64_t m1, uint64_t m2)
{
	SWORD0(m1) = SaturateDwordSToWordS(int32_t(SWORD0(m1)) + int32_t(SWORD0(m2)));
	SWORD1(m1) = SaturateDwordSToWordS(int32_t(SWORD1(m1)) + int32_t(SWORD1(m2)));
	SWORD2(m1) = SaturateDwordSToWordS(int32_t(SWORD2(m1)) + int32_t(SWORD2(m2)));
	SWORD3(m1) = SaturateDwordSToWordS(int32_t(SWORD3(m1)) + int32_t(SWORD3(m2)));
	
	return m1;
}

uint64_t my_mm_adds_pu8(uint64_t m1, uint64_t m2)
{
	BYTE0(m1) = SaturateWordSToByteU(int16_t(BYTE0(op1)) + int16_t(BYTE0(op2)));
	BYTE1(m1) = SaturateWordSToByteU(int16_t(BYTE1(op1)) + int16_t(BYTE1(op2)));
	BYTE2(m1) = SaturateWordSToByteU(int16_t(BYTE2(op1)) + int16_t(BYTE2(op2)));
	BYTE3(m1) = SaturateWordSToByteU(int16_t(BYTE3(op1)) + int16_t(BYTE3(op2)));
	BYTE4(m1) = SaturateWordSToByteU(int16_t(BYTE4(op1)) + int16_t(BYTE4(op2)));
	BYTE5(m1) = SaturateWordSToByteU(int16_t(BYTE5(op1)) + int16_t(BYTE5(op2)));
	BYTE6(m1) = SaturateWordSToByteU(int16_t(BYTE6(op1)) + int16_t(BYTE6(op2)));
	BYTE7(m1) = SaturateWordSToByteU(int16_t(BYTE7(op1)) + int16_t(BYTE7(op2)));
	
	return m1;
}

inline uint16_t SaturateDwordSToWordU(int32_t value)
{
	if(value < 0) 
		return 0;
	if(value > 65535) 
		return 65535;
	return (uint16_t) value;
}

uint64_t my_mm_adds_pu16(uint64_t m1, uint64_t m2)
{
	WORD0(m1) = SaturateDwordSToWordU(int32_t(WORD0(m1)) + int32_t(WORD0(m2)));
	WORD1(m1) = SaturateDwordSToWordU(int32_t(WORD1(m1)) + int32_t(WORD1(m2)));
	WORD2(m1) = SaturateDwordSToWordU(int32_t(WORD2(m1)) + int32_t(WORD2(m2)));
	WORD3(m1) = SaturateDwordSToWordU(int32_t(WORD3(m1)) + int32_t(WORD3(m2)));
	
	return m1;
}

uint64_t my_mm_sub_pi8(uint64_t m1, uint64_t m2)
{
	BYTE0(m1) -= BYTE0(m2);
	BYTE1(m1) -= BYTE1(m2);
	BYTE2(m1) -= BYTE2(m2);
	BYTE3(m1) -= BYTE3(m2);
	BYTE4(m1) -= BYTE4(m2);
	BYTE5(m1) -= BYTE5(m2);
	BYTE6(m1) -= BYTE6(m2);
	BYTE7(m1) -= BYTE7(m2);
	
	return m1;
}

uint64_t my_mm_sub_pi16(uint64_t m1, uint64_t m2)
{
	WORD0(m1) -= WORD0(m2);
	WORD1(m1) -= WORD1(m2);
	WORD2(m1) -= WORD2(m2);
	WORD3(m1) -= WORD3(m2);
	
	return m1;
}

uint64_t my_mm_sub_pi32(uint64_t m1, uint64_t m2)
{
	LODWORD(m1) -= LODWORD(m2);
	HIDWORD(m1) -= HIDWORD(m2);
	
	return m1;
}

uint64_t my_mm_sub_si64(uint64_t m1, uint64_t m2)
{
	return m1 - m2;
}

uint64_t my_mm_subs_pi8(uint64_t m1, uint64_t m2)
{
	SBYTE0(m1) = SaturateWordSToByteS(int16_t(SBYTE0(m1)) - int16_t(MMXSB0(m2)));
	SBYTE1(m1) = SaturateWordSToByteS(int16_t(SBYTE1(m1)) - int16_t(MMXSB1(m2)));
	SBYTE2(m1) = SaturateWordSToByteS(int16_t(SBYTE2(m1)) - int16_t(MMXSB2(m2)));
	SBYTE3(m1) = SaturateWordSToByteS(int16_t(SBYTE3(m1)) - int16_t(MMXSB3(m2)));
	SBYTE4(m1) = SaturateWordSToByteS(int16_t(SBYTE4(m1)) - int16_t(MMXSB4(m2)));
	SBYTE5(m1) = SaturateWordSToByteS(int16_t(SBYTE5(m1)) - int16_t(MMXSB5(m2)));
	SBYTE6(m1) = SaturateWordSToByteS(int16_t(SBYTE6(m1)) - int16_t(MMXSB6(m2)));
	SBYTE7(m1) = SaturateWordSToByteS(int16_t(SBYTE7(m1)) - int16_t(MMXSB7(m2)));
	
	return m1;
}

uint64_t my_mm_subs_pi16(uint64_t m1, uint64_t m2)
{
	SWORD0(m1) = SaturateDwordSToWordS(int32_t(SWORD0(m1)) - int32_t(SWORD0(m2)));
	SWORD1(m1) = SaturateDwordSToWordS(int32_t(SWORD1(m1)) - int32_t(SWORD1(m2)));
	SWORD2(m1) = SaturateDwordSToWordS(int32_t(SWORD2(m1)) - int32_t(SWORD2(m2)));
	SWORD3(m1) = SaturateDwordSToWordS(int32_t(SWORD3(m1)) - int32_t(SWORD3(m2)));
	
	return m1;
}

uint64_t my_mm_subs_pu8(uint64_t m1, uint64_t m2)
{
	BYTE0(m1) = SaturateWordSToByteU(int16_t(BYTE0(op1)) - int16_t(BYTE0(op2)));
	BYTE1(m1) = SaturateWordSToByteU(int16_t(BYTE1(op1)) - int16_t(BYTE1(op2)));
	BYTE2(m1) = SaturateWordSToByteU(int16_t(BYTE2(op1)) - int16_t(BYTE2(op2)));
	BYTE3(m1) = SaturateWordSToByteU(int16_t(BYTE3(op1)) - int16_t(BYTE3(op2)));
	BYTE4(m1) = SaturateWordSToByteU(int16_t(BYTE4(op1)) - int16_t(BYTE4(op2)));
	BYTE5(m1) = SaturateWordSToByteU(int16_t(BYTE5(op1)) - int16_t(BYTE5(op2)));
	BYTE6(m1) = SaturateWordSToByteU(int16_t(BYTE6(op1)) - int16_t(BYTE6(op2)));
	BYTE7(m1) = SaturateWordSToByteU(int16_t(BYTE7(op1)) - int16_t(BYTE7(op2)));
	
	return m1;
}

uint64_t my_mm_subs_pu16(uint64_t m1, uint64_t m2)
{
	WORD0(m1) = SaturateDwordSToWordU(int32_t(WORD0(m1)) - int32_t(WORD0(m2)));
	WORD1(m1) = SaturateDwordSToWordU(int32_t(WORD1(m1)) - int32_t(WORD1(m2)));
	WORD2(m1) = SaturateDwordSToWordU(int32_t(WORD2(m1)) - int32_t(WORD2(m2)));
	WORD3(m1) = SaturateDwordSToWordU(int32_t(WORD3(m1)) - int32_t(WORD3(m2)));
	
	return m1;
}

uint64_t my_mm_madd_pi16(uint64_t m1, uint64_t m2)
{
	if(LODWORD(m1) == 0x80008000 && LODWORD(m2) == 0x80008000)
		LODWORD(m1) = 0x80000000;
	else
		LODWORD(m1) = int32_t(SWORD0(m1)) * int32_t(SWORD0(m2)) + int32_t(SWORD1(m1)) * int32_t(SWORD1(m2));
	
	if (MMXUD1(m1) == 0x80008000 && MMXUD1(m2) == 0x80008000)
		MMXUD1(m1) = 0x80000000;
	else
		MMXUD1(m1) = int32_t(SWORD2(m1)) * int32_t(SWORD2(m2)) + int32_t(SWORD3(m1)) * int32_t(SWORD3(m2));
	
	return m1;
}

uint64_t my_mm_mullo_pi16(uint64_t m1, uint64_t m2)
{
	uint32_t product1 = uint32_t(WORD0(m1)) * uint32_t(WORD0(m2));
	uint32_t product2 = uint32_t(WORD1(m1)) * uint32_t(WORD1(m2));
	uint32_t product3 = uint32_t(WORD2(m1)) * uint32_t(WORD2(m2));
	uint32_t product4 = uint32_t(WORD3(m1)) * uint32_t(WORD3(m2));
	
	WORD0(m1) = product1 & 0xFFFF;
	WORD1(m1) = product2 & 0xFFFF;
	WORD2(m1) = product3 & 0xFFFF;
	WORD3(m1) = product4 & 0xFFFF;
	
	return m1;
}

uint64_t my_mm_sll_pi16(uint64_t m, uint64_t count)
{
	if (count > 15) 
		return 0;

	uint8_t shift = BYTE0(count);
	
	WORD0(m) <<= shift;
	WORD1(m) <<= shift;
	WORD2(m) <<= shift;
	WORD3(m) <<= shift;
		
	return m;
}

uint64_t my_mm_slli_pi16(uint64_t m, int count)
{
	return my_mm_sll_pi16(m, count);
}

uint64_t my_mm_sll_pi32(uint64_t m, uint64_t count)
{
	if (count > 31)
		return 0;
	
	uint8_t shift = BYTE0(count);
	
	LODWORD(m) <<= shift;
	HIDWORD(m) <<= shift;
	
	return m;
}

uint64_t my_mm_slli_pi32(uint64_t m, int count)
{
	return my_mm_sll_pi32(m, count);
}

uint64_t my_mm_sll_si64(uint64_t m, uint64_t count)
{
	if (count > 63)
		return 0;
	return m << count;
}

uint64_t my_mm_slli_si64(uint64_t m, int count)
{
	return my_mm_sll_si64(m, count);
}

uint64_t my_mm_sra_pi16(uint64_t m, uint64_t count)
{

	if (count == 0)
		return m;
	
	if (count > 15) 
	{
		WORD0(m) = (SWORD0(m) < 0) ? 0xFFFF : 0;
		WORD1(m) = (SWORD1(m) < 0) ? 0xFFFF : 0;
		WORD2(m) = (SWORD2(m) < 0) ? 0xFFFF : 0;
		WORD3(m) = (SWORD3(m) < 0) ? 0xFFFF : 0;
	}
	else 
	{
		uint8_t shift = BYTE0(count);
		
		WORD0(m) = (uint16_t)(SWORD0(m) >> shift);
		WORD1(m) = (uint16_t)(SWORD1(m) >> shift);
		WORD2(m) = (uint16_t)(SWORD2(m) >> shift);
		WORD3(m) = (uint16_t)(SWORD3(m) >> shift);
	}
	
	return m;
}

uint64_t my_mm_srai_pi16(uint64_t m, int count)
{
	return my_mm_sra_pi16(m, count);
}

uint64_t my_mm_sra_pi32(uint64_t m, uint64_t count)
{
	if (!count)
		return m;
	
	if (count > 31) 
	{
		LODWORD(m) = (SLODWORD(m) < 0) ? 0xFFFFFFFF : 0;
		HIDWORD(m) = (SHIDWORD(m) < 0) ? 0xFFFFFFFF : 0;
	}
	else 
	{
		uint8_t shift = BYTE0(count);
	
		LODWORD(m) = (uint32_t)(SLODWORD(m) >> shift);
		HIDWORD(m) = (uint32_t)(SHIDWORD(m) >> shift);
	}
	
	return m;
}

uint64_t my_mm_srai_pi32(uint64_t m, int count)
{
	return my_mm_sra_pi32(m, count);
}

uint64_t my_mm_srl_pi16(uint64_t m, uint64_t count)
{
	if (count > 15)
		return 0;
	
	uint8_t shift = BYTE0(count);
	
	WORD0(m) >>= shift;
	WORD1(m) >>= shift;
	WORD2(m) >>= shift;
	WORD3(m) >>= shift;
	
	return m;
}

uint64_t my_mm_srli_pi16(uint64_t m, int count)
{
	return my_mm_srl_pi16(m, count);
}

uint64_t my_mm_srl_pi32(uint64_t m, uint64_t count)
{
	if (count > 31)
		return 0;

	uint8_t shift = BYTE0(count);
	
	LODWORD(m) >>= shift;
	HIDWORD(m) >>= shift;
	
	return m;
}

uint64_t my_mm_srli_pi32(uint64_t m, int count)
{
	return my_mm_srl_pi32(m, count);
}

uint64_t my_mm_srl_si64(uint64_t m, uint64_t count)
{
	if (count > 63)
		return 0;
	return m >> BYTE0(count);
}

uint64_t my_mm_srli_si64(uint64_t m, int count)
{
	return my_mm_srl_si64(m, count);
}

uint64_t my_mm_and_si64(uint64_t m1, uint64_t m2)
{
	return m1 & m2;
}

uint64_t my_mm_andnot_si64(uint64_t m1, uint64_t m2)
{
	return ~m1 & m2;
}

uint64_t my_mm_or_si64(uint64_t m1, uint64_t m2)
{
	return m1 | m2;
}

uint64_t my_mm_xor_si64(uint64_t m1, uint64_t m2)
{
	return m1 ^ m2;
}

uint64_t my_mm_cmpeq_pi8(uint64_t m1, uint64_t m2)
{
	BYTE0(m1) = (BYTE0(m1) == BYTE0(m2)) ? 0xFF : 0;
	BYTE1(m1) = (BYTE1(m1) == BYTE1(m2)) ? 0xFF : 0;
	BYTE2(m1) = (BYTE2(m1) == BYTE2(m2)) ? 0xFF : 0;
	BYTE3(m1) = (BYTE3(m1) == BYTE3(m2)) ? 0xFF : 0;
	BYTE4(m1) = (BYTE4(m1) == BYTE4(m2)) ? 0xFF : 0;
	BYTE5(m1) = (BYTE5(m1) == BYTE5(m2)) ? 0xFF : 0;
	BYTE6(m1) = (BYTE6(m1) == BYTE6(m2)) ? 0xFF : 0;
	BYTE7(m1) = (BYTE7(m1) == BYTE7(m2)) ? 0xFF : 0;
	
	return m1;
}

uint64_t my_mm_cmpgt_pi8(uint64_t m1, uint64_t m2)
{
	BYTE0(m1) = (SBYTE0(m1) > SBYTE0(m2)) ? 0xFF : 0;
	BYTE1(m1) = (SBYTE1(m1) > SBYTE1(m2)) ? 0xFF : 0;
	BYTE2(m1) = (SBYTE2(m1) > SBYTE2(m2)) ? 0xFF : 0;
	BYTE3(m1) = (SBYTE3(m1) > SBYTE3(m2)) ? 0xFF : 0;
	BYTE4(m1) = (SBYTE4(m1) > SBYTE4(m2)) ? 0xFF : 0;
	BYTE5(m1) = (SBYTE5(m1) > SBYTE5(m2)) ? 0xFF : 0;
	BYTE6(m1) = (SBYTE6(m1) > SBYTE6(m2)) ? 0xFF : 0;
	BYTE7(m1) = (SBYTE7(m1) > SBYTE7(m2)) ? 0xFF : 0;
	
	return m1;
}

uint64_t my_mm_cmpeq_pi16(uint64_t m1, uint64_t m2)
{
	WORD0(m1) = (WORD0(m1) == WORD0(m2)) ? 0xFFFF : 0;
	WORD1(m1) = (WORD1(m1) == WORD1(m2)) ? 0xFFFF : 0;
	WORD2(m1) = (WORD2(m1) == WORD2(m2)) ? 0xFFFF : 0;
	WORD3(m1) = (WORD3(m1) == WORD3(m2)) ? 0xFFFF : 0;
	
	return m1;
}

uint64_t my_mm_cmpgt_pi16(uint64_t m1, uint64_t m2)
{
	WORD0(m1) = (SWORD0(m1) > SWORD0(m2)) ? 0xFFFF : 0;
	WORD1(m1) = (SWORD1(m1) > SWORD1(m2)) ? 0xFFFF : 0;
	WORD2(m1) = (SWORD2(m1) > SWORD2(m2)) ? 0xFFFF : 0;
	WORD3(m1) = (SWORD3(m1) > SWORD3(m2)) ? 0xFFFF : 0;
	
	return m1;
}

uint64_t my_mm_cmpeq_pi32(uint64_t m1, uint64_t m2)
{
	LODWORD(m1) = (LODWORD(m1) == LODWORD(m2)) ? 0xFFFFFFFF : 0;
	HIDWORD(m1) = (HIDWORD(m1) == HIDWORD(m2)) ? 0xFFFFFFFF : 0;
	
	return m1;
}

uint64_t my_mm_cmpgt_pi32(uint64_t m1, uint64_t m2)
{
	LODWORD(m1) = (SLODWORD(m1) > SLODWORD(m2)) ? 0xFFFFFFFF : 0;
	HIDWORD(m1) = (SHIDWORD(m1) > SHIDWORD(m2)) ? 0xFFFFFFFF : 0;
	
	return m1;
}

uint64_t my_mm_setzero_si64()
{
	return 0LL;
}

uint64_t my_mm_set_pi32(int32_t i1, int32_t i0)
{
	uint64_t result;
	
	LODWORD(result) = i0;
	HIDWORD(result) = i1;
	
	return result;
}

uint64_t my_mm_set_pi16(int16_t w3, int16_t w2, int16_t w1, int16_t w0)
{
	uint64_t result;
	
	WORD0(result) = w0;
	WORD1(result) = w1;
	WORD2(result) = w2;
	WORD3(result) = w3;
	
	return result;
}

uint64_t my_mm_set_pi8(int8_t b7, int8_t b6, int8_t b5, int8_t b4, int8_t b3, int8_t b2, int8_t b1, int8_t b0)
{
	uint64_t result;
	
	BYTE0(result) = b0;
	BYTE1(result) = b1;
	BYTE2(result) = b2;
	BYTE3(result) = b3;
	BYTE4(result) = b4;
	BYTE5(result) = b5;
	BYTE6(result) = b6;
	BYTE7(result) = b7;
	
	return result;
}

uint64_t my_mm_setr_pi32(int32_t i0, int32_t i1)
{
	return my_mm_set_pi32(i1, i0);
}

uint64_t my_mm_setr_pi16(int16_t w0, int16_t w1, int16_t w2, int16_t w3)
{
  return my_mm_set_pi16(w3, w2, w1, w0);
}

uint64_t my_mm_setr_pi8(int8_t b0, int8_t b1, int8_t b2, int8_t b3, int8_t b4, int8_t b5, int8_t b6, int8_t b7)
{
	return my_mm_set_pi8(b7, b6, b5, b4, b3, b2, b1, b0);
}

uint64_t my_mm_set1_pi32(int32_t i)
{
  return my_mm_set_pi32(i, i);
}

uint64_t my_mm_set1_pi16(int16_t w)
{
	return my_mm_set_pi16(w, w, w, w);
}

uint8_t my_mm_set1_pi8(int8_t b)
{
	return my_mm_set_pi8(b, b, b, b, b, b, b, b);
}