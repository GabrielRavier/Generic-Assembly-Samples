#include <cstdint>

bool oppositeSigns(int32_t a1, int32_t a2)
{
  return (a2 ^ a1) >> 31;
}

bool oppositeSigns64(int64_t a1, int64_t a2)
{
  return (a2 ^ a1) >> 31;
}