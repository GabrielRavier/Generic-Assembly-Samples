int64_t sumArray(int *arr, size_t size)
{
	int64_t result = 0;
	for (size_t i = 0; i < size; ++i)
		result += arr[i];
	return result;
}