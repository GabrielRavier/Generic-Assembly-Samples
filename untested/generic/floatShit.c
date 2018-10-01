float fmin(float a1, float a2)
{
  float result;

  result = a1;
  if ( a2 <= a1 )
    result = a2;
  return result;
}

float fmax(float a1, float a2)
{
  float result;

  result = a1;
  if ( a2 >= a1 )
    result = a2;
  return result;
}

float ftrunc(float a1)
{
	return trunc(a1);
}

float fround(float a1)
{
	return round(a1);
}

float fabs(float x)
{
	return abs(x);
}

float fadd(float a1, float a2)
{
	return a1 + a2;
}

float fchs(float a1)
{
	return -a1;
}

float fdiv(float a1, float a2)
{
	if (a2 == 0)
		return 0;
	return a1 / a2;
}

float fatan(float a1)
{
	return atan(a1);
}

float fpatan(float a1, float a2)
{
	if (!a1)
		return 0;
	return atan2(1, a2 / a1);
}