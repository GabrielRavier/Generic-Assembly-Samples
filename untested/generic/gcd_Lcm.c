int32_t gcd(int32_t a1, int32_t a2)
{
  int32_t result;

  result = a1;
  while ( result && a2 )
  {
    if ( result == a2 )
      return result;
    if ( result <= a2 )
      a2 -= result;
    else
      result = -(a2 - result);
  }
  return 0;
}

int32_t lcm(int32_t a1, int32_t a2)
{
  return a2 * a1 / gcd(a1, a2);
}

int64_t gcd64(int64_t a1, int64_t a2)
{
  int64_t result;

  result = a1;
  while ( result && a2 )
  {
    if ( result == a2 )
      return result;
    if ( result <= a2 )
      a2 -= result;
    else
      result = -(a2 - result);
  }
  return 0;
}

int64_t lcm64(int64_t a1, int64_t a2)
{
  return a2 * a1 / gcd64(a1, a2);
}