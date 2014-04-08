lib_NAME := libxtscreengrab.dylib
lib_C_SRCS := $(wildcard *.c)
lib_CXX_SRCS := $(wildcard *.cpp)
lib_C_OBJS := ${lib_C_SRCS:.c=.o}
lib_CXX_OBJS := ${lib_CXX_SRCS:.cpp=.o}
lib_OBJS := $(lib_C_OBJS) $(lib_CXX_OBJS)
lib_INCLUDE_DIRS :=
lib_LIBRARY_DIRS :=
lib_LIBRARIES :=
lib_FRAMEWORKS := Foundation

CPPFLAGS += $(foreach includedir,$(lib_INCLUDE_DIRS),-I$(includedir))
CPPFLAGS += $(foreach library,$(lib_FRAMEWORKS),-framework $(library))
LDFLAGS += -dynamiclib
LDFLAGS += $(foreach librarydir,$(lib_LIBRARY_DIRS),-L$(librarydir))
LDFLAGS += $(foreach library,$(lib_LIBRARIES),-l$(library))

.PHONY: all clean distclean

all: $(lib_NAME)

$(lib_NAME): $(lib_OBJS)
	$(LINK.cc) $(lib_OBJS) -o $(lib_NAME)

clean:
	@- $(RM) $(lib_NAME)
	@- $(RM) $(lib_OBJS)

distclean: clean

