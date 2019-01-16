#include <cstdint>

inline double calcSum(long i, double sum, double step)
{
	double x = (i + .5) * step;
	sum += 4.0 / (1. + x*x);
	return sum;
}

double calcPi(long numSteps)
{
	long i;
	double pi;
	double sum = 0.0;
	double step;

	step = 1. / numSteps;

	for (i=0; i < numSteps; i++)
		sum = calcSum(i, sum, step);
	
	pi = sum * step;

 	return pi;
}
