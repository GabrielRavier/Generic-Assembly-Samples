struct uint128_t
{
    uint64_t upper, lower;
};

void uint128_t_makeEmpty(uint128_t *x)
{
    x->upper = 0;
    x->lower = 0;
}