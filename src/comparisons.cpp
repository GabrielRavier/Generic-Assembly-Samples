#include "comparisons.h"
#include "assemblyFunctions.h"

#include <iostream>
#include <cstring>

using std::cout;

constexpr int sizeForArrays = 10000;
constexpr int compareIterationsDefault = 10000;
constexpr int compareIterationsMemcpy = compareIterationsDefault;
constexpr int compareIterationsMemmove = compareIterationsDefault;
constexpr int compareIterationsMemset = compareIterationsDefault;

volatile char array1[sizeForArrays] = {0};
volatile char array2[sizeForArrays] = {0};

void compareMemcpy()
{
    int lol, lol2 = 0;
    ASM_memcpy(&lol, &lol2, sizeof(int)); // Initialise dispatcher
    memcpy(&lol, &lol2, sizeof(int)); // Maybe std's has one too idk
    auto tempTime = ASM_readTSC();
    for (int i = 0; i < compareIterationsMemcpy; i++)
        ASM_memcpy((void *)array2, (void *)array1, sizeForArrays);
    auto timeForASM = (ASM_readTSC() - tempTime) / compareIterationsMemcpy;
    cout << "Clocks for ASM (per iteration) : " << timeForASM << '\n';
    tempTime = ASM_readTSC();
    for (int i = 0; i < compareIterationsMemcpy; i++)
        memcpy((void *)array2, (void *)array1, sizeForArrays);
    auto timeForStd = (ASM_readTSC() - tempTime) / compareIterationsMemcpy;
    cout << "Clocks for std (per iteration) : " << timeForStd << '\n';
}

void compareMemmove()
{
    int lol, lol2 = 0;
    ASM_memmove(&lol, &lol2, sizeof(int)); // Initialise dispatcher
    memmove(&lol, &lol2, sizeof(int)); // Maybe std's has one too idk
    auto tempTime = ASM_readTSC();
    for (int i = 0; i < compareIterationsMemmove; i++)
        ASM_memmove((void *)array2, (void *)array1, sizeForArrays);
    auto timeForASM = (ASM_readTSC() - tempTime) / compareIterationsMemmove;
    cout << "Clocks for ASM (per iteration) : " << timeForASM << '\n';
    tempTime = ASM_readTSC();
    for (int i = 0; i < compareIterationsMemmove; i++)
        memmove((void *)array2, (void *)array1, sizeForArrays);
    auto timeForStd = (ASM_readTSC() - tempTime) / compareIterationsMemmove;
    cout << "Clocks for std (per iteration) : " << timeForStd << '\n';
}

void compareMemset()
{
    int lol;
    ASM_memset(&lol, 0, sizeof(int)); // Initialise dispatcher
    memset(&lol, 0, sizeof(int)); // Maybe std's has one too idk
    auto tempTime = ASM_readTSC();
    for (int i = 0; i < compareIterationsMemset; i++)
        ASM_memset((void *)array1, 0, sizeForArrays);
    auto timeForASM = (ASM_readTSC() - tempTime) / compareIterationsMemset;
    cout << "Clocks for ASM (per iteration) : " << timeForASM << '\n';
    tempTime = ASM_readTSC();
    for (int i = 0; i < compareIterationsMemset; i++)
        memset((void *)array1, 0, sizeForArrays);
    auto timeForStd = (ASM_readTSC() - tempTime) / compareIterationsMemset;
    cout << "Clocks for std (per iteration) : " << timeForStd << '\n';
}
