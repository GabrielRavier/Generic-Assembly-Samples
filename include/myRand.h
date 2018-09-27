#include <ctime>
#include <random>
#include <cstdlib>

template<class T = std::mt19937, size_t N = T::state_size>
auto seededRandomEngine() -> typename std::enable_if<!!N, T>::type
{
    srand(time(0));
    std::seed_seq seeds
    {
        rand(),
        rand(),
        rand(),
        rand(),
        rand(),
        rand(),
        rand(),
        rand(),
    };
    T seededEngine(seeds);
    return seededEngine;
}

thread_local std::mt19937 engine(seededRandomEngine());

inline int random(int low, int high)
{
    static std::uniform_int_distribution<int> distrInt;
    return (low + (distrInt(engine) % (high - low + 1)));
}

inline long long int random(long long low, long long high)
{
    static std::uniform_int_distribution<unsigned long long> distrInt64;
    return (low + (distrInt64(engine) % (high - low + 1)));
}

inline double random(double low, double high)
{
    std::uniform_real_distribution<double> distDbl(low, high);
    return distDbl(engine);
}

inline long double random(long double low, long double high)
{
    std::uniform_real_distribution<long double> distLDbl(low, high);
    return distLDbl(engine);
}

inline float random(float low, float high)
{
    std::uniform_real_distribution<float> distFlt(low, high);
    return distFlt(engine);
}
