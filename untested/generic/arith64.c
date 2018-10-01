void add64(int64_t *a1, int64_t *a2)
{
	*a1 += *a2;
}

void sub64(int64_t *a1, int64_t *a2)
{
	*a1 -= *a2;
}

void mul64(int64_t *a1, int64_t *a2)
{
	*a1 *= *a2;
}

bool isEqual64(int64_t *a1, int64_t *a2)
{
	return *a1 == *a2;
}

bool isGreater64(int64_t *a1, int64_t *a2)
{
	return *a1 > *a2;
}

int64_t divide64(int64_t a1, int64_t a2)
{
	return a1 / a2;
}

int64_t divide64ForLibCallers(int64_t dividend, int64_t divisor)
{
	int64_t sign = ((dividend < 0) ^ (divisor < 0));
	
	dividend = abs(dividend);
	divisor = abs(divisor);
	
	int64_t quotient = 0;
	while (dividend > divisor)
	{
		dividend -= divisor;
		quotient++;
	}
	
	return sign * quotient;
		
}

int64_t modulo64(int64_t a1, int64_t a2)
{
	return a1 % a2;
}

int64_t modulo64ForLibCallers(int64_t a1, int64_t a2)
{
	return a1 - (a2 * (a1/a2));
}

int64_t getVal64(int64_t a1)
{
	return a1;
}

int64_t getOpposite64(int64_t a1)
{
	return -a1;
}

int64_t getComplement64(int64_t a1)
{
	return ~a1;
}