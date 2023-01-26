#include <stdio.h>
extern int squareroot(int abc);

int main()
{
    for (int i = 1; i <= 10; ++i)
        printf("squareroot(%d) == %d\n", i * i, squareroot(i * i));
    fputc('\n', stdout);
    for (int i = 0; i < 30; ++i)
        printf("squareroot(%d) == %d\n", i, squareroot(i));
}
