#include <cstdint>

bool isMulOk(uint32_t a1, uint32_t a2)
{
  bool result;

  if ( a2 && a1 )
    result = a1 <= uint32_t(-1) / a2;
  else
    result = 1;
  return result;
}

uint32_t saturatedMul(uint32_t a1, uint32_t a2)
{
  uint32_t result;

  if ( a2 && a1 && uint32_t(-1) / a2 < a1 )
    result = uint32_t(-1);
  else
    result = a2 * a1;
  return result;
}