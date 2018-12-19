/*
 *  A function illustrating how to link C code to code generated from LLVM 
 */

#include <stdio.h>

void print_string( char *c)
{
    printf("%s",c);
}

void print_char( char c)
{
    printf("%c",c);
}
