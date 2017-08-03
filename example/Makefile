AM_CPPFLAGS = -DAM_CPPFLAGS
AM_CFLAGS   = -DAM_CFLAGS
AM_LDFLAGS  = -DAM_LDFLAGS
AM_LDADD    = -lm

CC_PROGRAMS = foo bar

foo_SOURCES = foo1.c foo2.c

bar_SOURCES = bar1.c bar2.c
bar_CFLAGS = -DBAR
bar_LDFLAGS = -DBAR_LDFLAGS
bar_LDADD = -ldl

CXX_PROGRAMS = baz
baz_SOURCES = baz.cpp
baz_CXXFLAGS = -DBAZ_CXXFLAGS

include ../ezmake.mk
