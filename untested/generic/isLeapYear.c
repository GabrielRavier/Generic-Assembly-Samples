bool isLeapYear(uint32_t x)
{
	return !(a1 % 400) || a1 % 100 && !(a1 % 4);
}