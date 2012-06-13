#
CXX=g++
WINDLLMAIN=
# -m32 export ARCHFLAGS ="-arch i386"

HOSTOS=$(shell uname | tr A-Z a-z)
ifeq ($(HOSTOS),darwin)
 HIDAPIPATH=./hidapi/mac
 LIBS=-framework IOKit -framework CoreFoundation
 LNFLAGS=-arch i386 -flat_namespace -undefined warning -L.
 CFLAGS=-arch i386 -Wall -O3 -DAPL=1 -DIBM=0 -DLIN=0
else
 ifeq ($(HOSTOS),linux)
  HIDAPIPATH=./hidapi/linux
  LIBS=
  LNFLAGS=-rdynamic -nodefaultlibs -L.
  CFLAGS=-march=i386 -Wall -O3 -DAPL=0 -DIBM=0 -DLIN=1 -fvisibility=hidden
 else # windows
  HOSTOS=windows
  HIDAPIPATH=./hidapi/windows
  LIBS=-lXPLM -lSetupAPI
  LNFLAGS=-m32 -Wl,-O1 -L. -L./SDK/Libraries/Win/
  CFLAGS=-m32 -DAPL=0 -DIBM=1 -DLIN=0 -Wall -fpermissive
  WINDLLMAIN=SaitekProPanelsWin.o
 endif
endif

INCLUDE=-I./include
INCLUDE+=-I./include
INCLUDE+=-I./include/ptypes

all:
ifeq ($(HOSTOS),windows)
	$(CXX) -c $(INCLUDE) $(DEFS) $(CFLAGS) SaitekProPanelsWin.cpp
endif
	$(CXX) -c $(INCLUDE) $(DEFS) $(CFLAGS) $(HIDAPIPATH)/hid.c
	$(CXX) -c $(INCLUDE) $(DEFS) $(CFLAGS) cpdemo.cpp

	$(CXX) -o cpdemo hid.o cpdemo.o $(WINDLLMAIN) $(LNFLAGS) $(LIBS)

clean:
	$(RM) *.o cpdemo
