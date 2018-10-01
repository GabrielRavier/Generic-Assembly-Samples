uint32_t nextPowerOf2(uint32_t a1)
{
  uint32_t result;
  uint8_t v2;

  result = a1;
  if ( a1 )
  {
    if ( !((a1 - 1) & a1) )
      return result;
    v2 = 0;
    do
    {
      result >>= 1;
      ++v2;
    }
    while ( result );
  }
  else
  {
    v2 = 0;
  }
  return 1 << v2;
}

uint64_t nextPowerOf264(uint64_t a1)
{
  uint64_t result;
  uint8_t v2;

  result = a1;
  if ( a1 )
  {
    if ( !((a1 - 1) & a1) )
      return result;
    v2 = 0;
    do
    {
      result >>= 1;
      ++v2;
    }
    while ( result );
  }
  else
  {
    v2 = 0;
  }
  return 1 << v2;
}