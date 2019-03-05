#include <cstdint>

bool isPowerOf4(int32_t n) 
{ 
	if(n == 0) 
		return 0; 
	while(n != 1) 
	{     
		if(n % 4 != 0) 
			return 0; 
		n = n / 4;       
	} 
	return 1; 
}

bool isPowerOf464(int64_t n) 
{ 
	if(n == 0) 
		return 0; 
	while(n != 1) 
	{     
		if(n % 4 != 0) 
			return 0; 
		n = n / 4;       
	} 
	return 1; 
}  