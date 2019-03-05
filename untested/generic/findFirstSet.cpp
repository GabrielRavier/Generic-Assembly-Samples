#include <cstdint>

int32_t findFirstSet(int32_t n)
{
    return __builtin_ffs(n);
}

int64_t findFirstSet64(int64_t n)
{
    return __builtin_ffsll(n);
}