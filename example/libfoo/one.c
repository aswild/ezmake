#include <stdio.h>
#include "libfoo.h"

#ifndef FOO_ONE
#define FOO_ONE 1
#endif

void libfoo_one()
{
    printf("%s: FOO_ONE = %d\n", __func__, FOO_ONE);
}
