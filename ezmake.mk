# ezmake.mk
# Allen Wild
# Simple C/C++ Makefile framework with automake-like syntax
# <MIT License>

CLEANFILES =

all: all-build
.PHONY: all

define cc_target
$(1)_OBJECTS = $$(patsubst %.c,%.o,$$($(1)_SOURCES))
$(1)_DEPS    = $$(patsubst %.c,%.d,$$($(1)_SOURCES))
CLEANFILES  += $(1) $$($(1)_OBJECTS) $$($(1)_DEPS)

ifeq ($$($(1)_CFLAGS),)
$(1)_CFLAGS = $$(AM_CFLAGS)
endif

$$($(1)_OBJECTS) : %.o : %.c
	$$(CC) -MD -MP $$($(1)_CFLAGS) $$(CFLAGS) -c -o $$@ $$<

$(1) : $$($(1)_OBJECTS)
	$$(CC) $$(LDFLAGS) -o $$@ $$^

-include $$($(1)_DEPS)
endef

$(foreach target,$(CC_TARGETS),$(eval $(call cc_target,$(target))))

all-build: $(CC_TARGETS)

clean:
	rm -f $(CLEANFILES)
