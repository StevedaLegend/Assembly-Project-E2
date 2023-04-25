#include <stdio.h>

extern int add(int a, int b, int c);

int main(int argc, char **argv)
{
  printf("Addition = %d\n", add(4, 6, 2));
  return 0;
}
