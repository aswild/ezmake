#include <stdio.h>
#include "libfoo.h"

#ifndef FOO_TWO
#define FOO_TWO 2
#endif

void libfoo_two()
{
    printf("%s: FOO_TWO = %d\n", __func__, FOO_TWO);
}
