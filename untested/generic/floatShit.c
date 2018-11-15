float fmin(float a1, float a2)
{
  float result = a1;
  if ( a2 <= a1 )
    result = a2;
  return result;
}

float fmax(float a1, float a2)
{
  float result = a1;
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

float fclamp(float a, float lo, float hi) 
{ 
	return fmax(lo, fmin(a, hi)); 
}

float fsign(float a) 
{ 
	return a < 0 ? -1.0f : 1.0f; 
}

float fintersect(float da, float db) 
{ 
	return da / (da - db); 
}

int ftoi(float a)
{
	return a;
}

float facos(float x)
{
	return acos(x); 
}

float fasin(float x)
{
	return asin(x); 
}

float fatan(float x)
{
	return atan(x); 
}

float fceil(float x)
{
	return ceil(x); 
}

float fexp(float x)
{
	return exp(x);
}

float ffloor(float x)
{
	return floor(x);
}

float ffmod(float x, float y)
{
	return fmod(x, y);
}

float fldexp(float x, int exp)
{
	return ldexp(x, exp);
}

float flog(float x)
{
	return log(x);
}

float flog10(float x)
{
	return log10(x);
}

int ffpclassify(float x)
{
	return fpclassify(x);
}

bool fisfinite(float x)
{
	return isfinite(x);
}

float fpow(float a, float b)
{
	return exp(log(a) * b);
}

bool fisinf(float a)
{
	return isinf(a);
}