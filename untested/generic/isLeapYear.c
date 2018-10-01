bool isLeapYear(uint32_t a1)
{
  return !(a1 % 0x190) || a1 % 0x64 && !(a1 & 3);
}