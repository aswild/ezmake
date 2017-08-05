# Example Makefile using ezmake.mk

# Set the compilers, can be overridden by the command line
CC  = gcc
CXX = g++

# Default first target. ezmake.mk defines 'ez-build' as a phony target
# for all the programs/alibs/solibs, but if you define a dependency before
# including ezmake.mk, make will treat that as the first/default target, therefore
# it's good practice to define your default target early in the main Makefile
all: ez-build
.PHONY: all

# Common flags, used if not overridden by target-specific flags
# (use CFLAGS/LDFLAGS/LIBS to set custom flags from the command line)
AM_CPPFLAGS = -DAM_CPPFLAGS
AM_CFLAGS   = -Wall

# libfoo - a static library
CC_ALIBS = libfoo/libfoo.a
libfoo_libfoo_a_SOURCES = libfoo/one.c libfoo/two.c

# foo - a program which uses code from libfoo.a
CC_PROGRAMS = foo
foo_SOURCES = foo.c
foo_CPPFLAGS = -Ilibfoo
foo_LDFLAGS = -Llibfoo
foo_LDADD = -lfoo
# foo depends on libfoo.a, so add a normal dependency
foo: libfoo/libfoo.a

# libbar - a shared library
CC_SOLIBS = libbar/libbar.so
libbar_libbar_so_SOURCES = libbar/bar_main.c

# bar - a program which links to libbar.so
CC_PROGRAMS += bar
bar_SOURCES = bar.c
bar_CPPFLAGS = -Ilibbar
bar_LDFLAGS = -Llibbar
bar_LDADD = -lbar
bar: libbar/libbar.so

# baz - a C++ program
CXX_PROGRAMS = baz
baz_SOURCES = baz.cpp
baz_CXXFLAGS = -DBAZ_CXXFLAGS

# Including ezmake.mk creates targets from all the rules above
include ../ezmake.mk
