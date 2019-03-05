#include <cstdint>

int32_t andn(int32_t a1, int32_t a2)
{
  return a2 & ~a1;
}

int32_t blsi(int32_t a1)
{
  return -a1 & a1;
}

int32_t blsr(int32_t a1)
{
  return (a1 - 1) & a1;
}

int64_t andn64(int64_t a1, int64_t a2)
{
  return a2 & ~a1;
}

int64_t blsi64(int64_t a1)
{
  return -a1 & a1;
}

int64_t blsr64(int64_t a1)
{
  return (a1 - 1) & a1;
}