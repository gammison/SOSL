/*
 *  A function illustrating how to link C code to code generated from LLVM 
 */

#include <stdio.h>

void print_string( char *c)
{
    printf("%s",c);
}

#ifdef BUILD_TEST
int main()
{
  char s[] = "HELLO WORLD09AZ";
  char *c;
  for ( c = s ; *c ; c++) printbig(*c);
}
#endif
