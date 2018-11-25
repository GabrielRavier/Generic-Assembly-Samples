uint8_t countSetBits(uint32_t x)
{
	uint8_t count = 0;
	while (x)
	{
		x &= (x - 1);
		count++;
	}
	return count;
}

uint8_t countSetBits64(uint64_t x)
{
	uint8_t count = 0;
	while (x)
	{
		x &= (x - 1);
		count++;
	}
	return count;
}