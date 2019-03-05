// See also "The search for the saddest punt in the world | Chart Party" at https	youtu.be/F9H9LwGmc-0

#include <algorithm>
#include <cmath>

static double getYardMultiplier(int yardsFromOrigin)
{
	yardsFromOrigin = std::clamp(yardsFromOrigin, 0, 110);
	if (yardsFromOrigin <= 40)
		return 1;
	if (yardsFromOrigin <= 50)
	{
		yardsFromOrigin -= 40;
		double result = 1;
		for (int i = 0; i < yardsFromOrigin; ++i)
			result *= 1.1;
		return result;
	}
	
	yardsFromOrigin -= 50;
	double result = 2.59;
	for (int i = 0; i < yardsFromOrigin; ++i)
		result *= 1.2;
	return result;
}

static double getFirstDownMultiplier(int firstDownDistance)
{
	firstDownDistance = std::clamp(firstDownDistance, 0, 110);
	if (firstDownDistance <= 1)
		return 1;
	if (firstDownDistance <= 3)
		return 0.8;
	if (firstDownDistance <= 6)
		return 0.6;
	if (firstDownDistance <= 9)
		return 0.4;
	return 0.2;
}

static unsigned int getScoreDiffMultiplier(int scoreDifference)
{
	if (scoreDifference > 0)
		return 1;
	if (!scoreDifference)
		return 2;
	if (scoreDifference > -9)
		return 4;
	return 3;
}

static double getClockMultiplier(int scoreDifference, int secondsElapsedSinceHalftime)
{
	if (secondsElapsedSinceHalftime < 0 || scoreDifference > 0)
		return 1;
	
	return 1 + pow(static_cast<double>(secondsElapsedSinceHalftime) / 1000, 3);
}

struct MatchInfo
{
	int fieldPosition;
	int firstDownDistance;
	int scoreDifference;
	int secondsElapsedSinceHalftime;
};

// Field position is in yards
double getSurrenderIndex(MatchInfo *matchInfo)
{
	double result = getYardMultiplier(matchInfo->fieldPosition);
	result *= getFirstDownMultiplier(matchInfo->firstDownDistance);
	result *= getScoreDiffMultiplier(matchInfo->scoreDifference);
	result *= getClockMultiplier(matchInfo->scoreDifference, matchInfo->secondsElapsedSinceHalftime);
	
	return result;
}