CC = gcc
CFLAGS = -O2 -g
OBJS = dbaccess.o misc.o dumpxml.o
STRIP= strip
OBJCOPY = objcopy

default: vnstatxml

vnstatxml: vnstatxml.c vnstatxml.h $(OBJS)
	$(CC) $(CFLAGS) -lm -o $@ vnstatxml.c $(OBJS)
	$(STRIP) -s $@
	$(OBJCOPY) -R .note -R .comment -R .note.ABI-tag -R .gnu.version $@

dbaccess.o: dbaccess.c dbaccess.h vnstatxml.h
	$(CC) $(CFLAGS) -c dbaccess.c

misc.o: misc.c misc.h vnstatxml.h
	$(CC) $(CFLAGS) -c misc.c

dumpxml.o: dumpxml.c dumpxml.h vnstatxml.h
	$(CC) $(CFLAGS) -c dumpxml.c

clean:
	rm -f *.o *~ core *.i vnstatxml *.gcda *.gcno cscope*out *.gcov *.gch
