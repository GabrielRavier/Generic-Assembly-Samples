inline int gcd(int a, int b) 
{ 
    if (b == 0) 
        return a; 
    return gcd(b, a % b); 
}
  
// Returns LCM of array elements
int lcmArray(int arr[], int n) 
{ 
    int ans = arr[0];
    for (int i = 1; i < n; i++) 
        ans = (((arr[i] * ans)) / 
                (gcd(arr[i], ans))); 
    return ans; 
} 