uint32_t mulx(uint32_t a1, uint32_t a2, int32_t *a3)
{
  uint64_t v3;

  v3 = a2 * (uint64_t)a1;
  *a3 = HIDWORD(v3);
  return v3;
}