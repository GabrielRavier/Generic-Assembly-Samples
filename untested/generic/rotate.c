uint32_t rotateLeft(uint32_t value, uint32_t count) 
{
    const unsigned int mask = CHAR_BIT*sizeof(value) - 1;
    count &= mask;
    return (value << count) | (value >> (-count & mask));
}

uint32_t rotateRight(uint32_t value, uint32_t count) 
{
    const unsigned int mask = CHAR_BIT*sizeof(value) - 1;
    count &= mask;
    return (value >> count) | (value << (-count & mask));
}

uint64_t rotateLeft64(uint64_t value, uint32_t count) 
{
    const unsigned int mask = CHAR_BIT*sizeof(value) - 1;
    count &= mask;
    return (value << count) | (value >> (-count & mask));
}

uint64_t rotateRight64(uint64_t value, uint32_t count) 
{
    const unsigned int mask = CHAR_BIT*sizeof(value) - 1;
    count &= mask;
    return (value >> count) | (value << (-count & mask));
}