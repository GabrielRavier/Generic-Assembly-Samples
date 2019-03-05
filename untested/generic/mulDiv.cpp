#include <cstdint>
#include <cstdlib>

inline int64_t divide(int64_t dividend, int64_t divisor) 
{   
  // Calculate sign of divisor i.e., 
  // sign will be negative only iff 
  // either one of them is negative 
  // otherwise it will be positive 
  int sign = ((dividend < 0) ^ (divisor < 0)) ? -1 : 1; 
  
  // Update both divisor and 
  // dividend positive 
  dividend = abs(dividend); 
  divisor = abs(divisor); 
  
  // Initialize the quotient 
  int64_t quotient = 0; 
  while (dividend >= divisor) { 
    dividend -= divisor; 
    ++quotient; 
  } 
  
  return sign * quotient; 
} 

int32_t MulDiv(int32_t a, int32_t b, int32_t c)
{
  return divide(((uint64_t)a * (uint64_t)b), c);
}