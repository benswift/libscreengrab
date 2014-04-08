PREFIX=/usr/local

LIBNAME:= libscreengrab
HEADS:= screengrab.h
SRCS:= screengrab.m

FRAMEWORKS:= -framework Foundation -framework CoreVideo -framework CoreGraphics
LIBRARIES:= -lobjc

INSTALL_TOOL:= install
CFLAGS += -Wall -Werror -O3 $(SRCS)
LDFLAGS += -dynamiclib $(LIBRARIES) $(FRAMEWORKS)

.PHONY: all clean

all:
	$(CC) $(CFLAGS) $(LDFLAGS) -o $(LIBNAME).dylib

install: all
	$(INSTALL_TOOL) -p -g admin -d $(PREFIX)/include
	$(INSTALL_TOOL) -p -g admin -m 644 $(HFILES) $(PREFIX)/include
	$(INSTALL_TOOL) -p -g admin -d $(PREFIX)/bin
	$(INSTALL_TOOL) -p -g admin -m 755 $(LIBNAME).dylib $(PREFIX)/bin

clean: 
	@- $(RM) $(LIBNAME).dylib
