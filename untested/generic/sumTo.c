uint32_t sumTo(uint32_t x)
{
    uint32_t result = 0;
    for (uint32_t i = 0; i < x; ++i)
        result += i;
    return result;
}

uint64_t sumTo64(uint64_t x)
{
    uint64_t result = 0;
    for (uint64_t i = 0; i < x; ++i)
        result += i;
    return result;
}