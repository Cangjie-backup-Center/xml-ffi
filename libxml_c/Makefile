# Makefile for myxml2

CC=gcc

CFLAGS= -fPIC -Wall -Wextra -Wfloat-equal -std=c11 -std=gnu11 -fstack-protector-strong -O2 -fPIC -Wall -Wextra -Wfloat-equal -std=c11 -std=gnu11 -fstack-protector-strong -O2

SFLAGS=-O
LDFLAGS= -L../lib -lxml2 -Wl,-z,relro,-z,now,-z,noexecstack -L../lib -lxml2 -Wl,-z,relro,-z,now,-z,noexecstack
LDSHARED=gcc -shared
STRIP=strip

SHAREDLIB=../lib/libmyxml2.so
LDIR=../lib

SHELL=/bin/sh

SRCDIR=
INC=-Iinclude

SRCS=$(wildcard $(SRCDIR)*.c)
OBJS=$(notdir $(patsubst %.c, %.o, $(SRCS)))

%.o: $(SRCDIR)%.c
	$(CC) $(CFLAGS) $(INC) -c -o $@ $<

$(SHAREDLIB): $(OBJS)
	$(shell mkdir -p $(dir $(SHAREDLIB)))
	$(LDSHARED) $(CFLAGS) -o $@ $(OBJS) $(LDFLAGS)
	$(STRIP) -s $(SHAREDLIB)

all: ../lib/libmyxml2.so

clean:
	rm -f *.o $(SHAREDLIB)

distclean: clean
	rm -f Makefile configure.log
	@if [ -f Makefile.in ]; then \
	printf 'all:\n\t-@echo "Please use ./configure first.  Thank you."\n' > Makefile ; \
	printf '\ndistclean:\n\tmake -f Makefile.in distclean\n' >> Makefile ; \
	touch -r $(SRCDIR)Makefile.in Makefile ; fi
