bool isPowerOf2(int32_t a1)
{
  bool result;

  if ( a1 )
    result = ((a1 - 1) & a1) == 0;
  else
    result = 0;
  return result;
}

bool isPowerOf264(int64_t a1)
{
  bool result;

  if ( a1 )
    result = ((a1 - 1) & a1) == 0;
  else
    result = 0;
  return result;
}