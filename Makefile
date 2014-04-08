LIBNAME:= libxtscreengrab
SRCS:= libxtscreengrab.m

FRAMEWORKS:= -framework Foundation -framework CoreVideo -framework CoreGraphics
LIBRARIES:= -lobjc

CFLAGS += -Wall -Werror -O3 $(SRCS)
LDFLAGS += -dynamiclib $(LIBRARIES) $(FRAMEWORKS)

.PHONY: all clean

all:
	$(CC) $(CFLAGS) $(LDFLAGS) -o $(LIBNAME).dylib

clean: 
	@- $(RM) $(LIBNAME).dylib
