__m128i makeM128FromM64(__m64 a, __m64 b)
{
    return _mm_set_epi64(a, b);
}

__m128i makeM128FromI32(int32_t i3, int32_t i2, int32_t i1, int32_t i0)
{
    return _mm_set_epi32(i3, i2, i1, i0);
}

__m128i makeM128FromI16(int16_t w7, int16_t w6, int16_t w5, int16_t w4, int16_t w3, int16_t w2, int16_t w1, int16_t w0)
{
    return _mm_set_epi16(w7, w6, w5, w4, w3, w2, w1, w0);
}

__m128i makeM128FromI8(int8_t w15,int8_t w14, int8_t w13, int8_t w12, int8_t w11, int8_t w10, int8_t w9, int8_t w8, int8_t w7,int8_t w6, int8_t w5, int8_t w4, int8_t w3, int8_t w2,int8_t w1, int8_t w0)
{
	return _mm_set_epi8(w15, w14, w13, w12, w11, w10, w9, w8, w7, w6, w5, w4, w3, w2, w1, w0);
}