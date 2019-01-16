#include <cstdint>

void setBit(uint8_t *buf, size_t pos)
{
    buf[pos / 8] |= 1 << (pos % 8);
}

void clearBit(uint8_t *buf, size_t pos)
{
    buf[pos / 8] &= ~(1 << (pos % 8));
}

bool getBit(uint8_t *buf, size_t pos)
{
    return ((buf[pos / 8] >> (pos % 8)) & 1) != 0;
}