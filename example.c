#include <math.h>
#include <stdbool.h>
#include <stdio.h>

int is_prime(int v)
{
    if (v == 1)
        return false;
    if (v == 2)
        return true;
    int limit = (int)(sqrt((double)v) + 0.5);
    for (int i = 2; i <= limit; ++i)
        if (v % i == 0)
            return false;
    return true;
}

int find_prime(int n)
{
    int position = 0;
    int prime_value = 2;
    while (position < n) {
        ++prime_value;
        while (!is_prime(prime_value))
            ++prime_value;
        ++position;
    }
    return prime_value;
}

int main()
{
    for (int i = 1; i <= 10; ++i)
        printf("is_prime(%d) == %s\n", i, is_prime(i) ? "true" : "false");
    for (int i = 0; i < 10; ++i)
        printf("find_prime(%d) == %d\n", i, find_prime(i));
}
