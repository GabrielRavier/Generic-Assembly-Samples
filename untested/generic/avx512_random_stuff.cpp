#include <cstdint>

uint32_t ternlogd_scalar(uint32_t op1, uint32_t op2, uint32_t op3, uint32_t imm8)
{
	uint32_t result = 0;
	
	for (uint8_t bit = 0; bit < 32; bit++) 
	{
		uint32_t tmp  = (op1 >> bit) & 0x1;
		tmp <<= 1;
		tmp |= (op2 >> bit) & 0x1;
		tmp <<= 1;
		tmp |= (op3 >> bit) & 0x1;
	
		result |= ((uint32_t)((imm8 >> tmp) & 0x1)) << bit;
	}
	
	return result;
}

uint64_t ternlogq_scalar(uint64_t op1, uint64_t op2, uint64_t op3, uint32_t imm8)
{
	uint64_t result = 0;
	
	for (uint8_t bit = 0; bit < 64; bit++) 
	{
		uint32_t tmp  = (op1 >> bit) & 0x1;
		tmp <<= 1;
		tmp |= (op2 >> bit) & 0x1;
		tmp <<= 1;
		tmp |= (op3 >> bit) & 0x1;
	
		result |= ((uint64_t)((imm8 >> tmp) & 0x1)) << bit;
	}
	
	return result;
}

uint64_t pmadd52luq_scalar(uint64_t dst, uint64_t op1, uint64_t op2)
{
	op1 &= 0x000FFFFFFFFFFFFFULL;
	op2 &= 0x000FFFFFFFFFFFFFULL;
	
	return dst + ((op1 * op2) & 0x000FFFFFFFFFFFFFULL);
}