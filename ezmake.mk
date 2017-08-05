# ezmake.mk
# Allen Wild
# Simple C/C++ Makefile framework with automake-like syntax
# <MIT License>

CLEANFILES =

# First target is to build, unless user specified something else
ez-build: $(CC_PROGRAMS) $(CXX_PROGRAMS) $(CC_ALIBS) $(CXX_ALIBS) $(CC_SOLIBS) $(CXX_SOLIBS)
.PHONY: ez-build

# Macro to get per-target XX_YYFLAGS (also applies for LDADD)
#  $1 = the target name
#  $2 = variable name, e.g. CFLAGS, CXXFLAGS
define target_flags
ifeq ($$($(1)_$(2)),)
$(1)_$(2) = $$(AM_$(2))
endif
endef

# In these macros:
#  $(1) = name of the target
#  $(2) = source file extension
#  $(3) = FLAGS prefix: C or CXX
#  $(4) = compiler variable name: CC or CXX

# Common object/compilation rules
define target_common
#$(1)_OBJECTS = $$(foreach suffix,$(2),$$(patsubst %.$$(suffix),%.o,$$(filter %.$$(suffix),$$($(1)_SOURCES))))
$(1)_OBJECTS = $$(patsubst %.$(2),%.o,$$($(1)_SOURCES))
$(1)_DEPS    = $$(patsubst %.o,%.d,$$($(1)_OBJECTS))
CLEANFILES  += $(1) $$($(1)_OBJECTS) $$($(1)_DEPS)

# Define target-specific flags variables
$$(foreach flag,CFLAGS LDFLAGS LDADD,$$(eval $$(call target_flags,$(1),$$(flag))))

# file compilation rule
$$($(1)_OBJECTS) : %.o : %.$(2)
	$$($(4)) -MD -MP $$(strip $$($(1)_CPPFLAGS) $$(CPPFLAGS) $$($(1)_$(3)FLAGS) $$($(3)FLAGS)) -c -o $$@ $$<

# include dependency files
-include $$($(1)_DEPS)
endef # target_common

# C program
define cc_program
$$(eval $$(call target_common,$(1),c,C,CC))
$(1) : $$($(1)_OBJECTS)
	$$(CC) $$(strip $$($(1)_CFLAGS) $$(CFLAGS) $$($(1)_LDFLAGS) $$(LDFLAGS)) -o $$@ $$^ $$($(1)_LDADD) $$(LIBS)
endef # cc_program

# C++ program
define cxx_program
$$(eval $$(call target_common,$(1),cpp,CXX,CXX))
$(1) : $$($(1)_OBJECTS)
	$$(CXX) $$(strip $$($(1)_CXXFLAGS) $$(CXXFLAGS) $$($(1)_LDFLAGS) $$(LDFLAGS)) -o $$@ $$^ $$($(1)_LDADD) $$(LIBS)
endef # cxx_program

# C static library
define cc_alib
$$(eval $$(call target_common,$(1),c,C,CC))
$(1) : $$($(1)_OBJECTS)
	$$(AR) rcs $$@ $$^
endef

# C++ static library
define cxx_alib
$$(eval $$(call target_common,$(1),cpp,CXX,CXX))
$(1) : $$($(1)_OBJECTS)
	$$(AR) rcs $$@ $$^
endef

# C shared library
define cc_solib
$$(eval $$(call target_common,$(1),c,C,CC))

# Shared libraries need to have -fPIC somewhere in CFLAGS
ifeq ($$(findstring -fPIC,$$($(1)_CFLAGS)),)
ifeq ($$(findstring -fPIC,$$(CFLAGS)),)
$(1)_CFLAGS += -fPIC
endif
else
ifeq ($$(findstring -fPIC,$$($(1)_CFLAGS)),)
ifeq ($$(findstring -fPIC,$$(CFLAGS)),)
$(1)_CFLAGS += -fPIC
endif
endif
endif
endef # cc_solib

# C++ shared library
define cxx_solib
$$(eval $$(call target_common,$(1),cpp,CXX,CXX))

# Shared libraries need to have -fPIC somewhere in CXXFLAGS
ifeq ($$(findstring -fPIC,$$($(1)_CXXFLAGS)),)
ifeq ($$(findstring -fPIC,$$(CXXFLAGS)),)
$(1)_CXXFLAGS += -fPIC
endif
else
ifeq ($$(findstring -fPIC,$$($(1)_CXXFLAGS)),)
ifeq ($$(findstring -fPIC,$$(CXXFLAGS)),)
$(1)_CXXFLAGS += -fPIC
endif
endif
endif
endef # cxx_solib

$(foreach prog,$(CC_PROGRAMS),$(eval $(call cc_program,$(prog))))
$(foreach prog,$(CXX_PROGRAMS),$(eval $(call cxx_program,$(prog))))
$(foreach prog,$(CC_ALIBS),$(eval $(call cc_alib,$(prog))))
$(foreach prog,$(CXX_ALIBS),$(eval $(call cxx_alib,$(prog))))
$(foreach prog,$(CC_SOLIBS),$(eval $(call cc_solib,$(prog))))
$(foreach prog,$(CXX_SOLIBS),$(eval $(call cxx_solib,$(prog))))

# General targets

clean:
	rm -f $(CLEANFILES)
.PHONY: clean
