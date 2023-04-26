#include <stdio.h>


extern int add(int a, int b, int c);

extern int mul(int a, int b, int c);

int main(int argc, char **argv)
{
  printf("Addition = %d\n", add(4, 8, 12));

  printf("Multiply = %d\n", mul(4, 8, 12));
  return 0;
}
