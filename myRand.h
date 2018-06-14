#include <thread>
#include <random>

template<class T = std::mt19937, size_t N = T::state_size>
auto SeededRandomEngine() -> typename std::enable_if<!!N, T>::type
{
    void *randMalloced = malloc(1);
    std::seed_seq seeds
    {
        static_cast<long long>(std::chrono::high_resolution_clock::now().time_since_epoch().count()),
        static_cast<long long>(std::hash<std::thread::id>()(std::this_thread::get_id())),
        static_cast<long long>(reinterpret_cast<intptr_t>(&seeds)),
        static_cast<long long>(reinterpret_cast<intptr_t>(randMalloced)),
        static_cast<long long>(time(0))
    };
    T seededEngine(seeds);
    free(randMalloced);
    return seededEngine;
}

thread_local std::mt19937 engine(SeededRandomEngine());

// Distribution goes from 0 to TYPE_MAX by default

std::uniform_int_distribution<unsigned long long> distrInt64;
std::uniform_int_distribution<int> distrInt;

inline int random(int low, int high)
{
    return (low + (distrInt(engine) % (high - low + 1)));
}

inline long long int random(long long int low, long long int high)
{
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
