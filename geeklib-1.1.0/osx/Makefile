# Unix makefile for Geeklib.		Ver. 1.1.0

# Definitions.
LIB = libgeek.a
SRCD = ../src
OBJD = obj
OBJS = $(OBJD)/chlit.o $(OBJD)/gexcep.o $(OBJD)/stplcpy.o $(OBJD)/strfit.o $(OBJD)/valobj.o

INCD = ../../include

# Options and arguments to the C compiler.
CC = cc
CFLAGS = -funsigned-char -W -Wall -Wunused\
 -Wno-comment -Wno-missing-field-initializers -Wno-missing-braces -Wno-pointer-sign -Wno-unused-parameter -O2 -I$(INCD)

$(LIB): $(OBJS)
	-[ -f $(LIB) ] && rm $(LIB)
	libtool -static -o $(LIB) $(OBJS)

$(OBJD)/chlit.o: $(SRCD)/chlit.c $(HDRS)
	$(CC) -c -o $(OBJD)/chlit.o $(CFLAGS) $(SRCD)/chlit.c

$(OBJD)/gexcep.o: $(SRCD)/gexcep.c $(INCD)/gl_def.h $(INCD)/os.h
	$(CC) -c -o $(OBJD)/gexcep.o $(CFLAGS) $(SRCD)/gexcep.c

$(OBJD)/stplcpy.o: $(SRCD)/stplcpy.c
	$(CC) -c -o $(OBJD)/stplcpy.o $(CFLAGS) $(SRCD)/stplcpy.c

$(OBJD)/strfit.o: $(SRCD)/strfit.c $(INCD)/gl_string.h
	$(CC) -c -o $(OBJD)/strfit.o $(CFLAGS) $(SRCD)/strfit.c

$(OBJD)/valobj.o: $(SRCD)/valobj.c $(INCD)/gl_valobj.h
	$(CC) -c -o $(OBJD)/valobj.o $(CFLAGS) $(SRCD)/valobj.c

clean:
	@rm -f $(LIB) $(OBJD)/*.o
