CC = $(CROSS_COMPILE)gcc
CFLAGS += -O2 #-fprofile-arcs -ftest-coverage 
OBJS = ifinfo.o db.o dbaccess.o misc.o cfg.o dumpxml.o
STRIP= $(CROSS_COMPILE)strip
OBJCOPY = $(CROSS_COMPILE)objcopy

default: vnstat

vnstat: $(OBJS) vnstat.c vnstat.h
	$(CC) $(CFLAGS) -o vnstat vnstat.c $(OBJS) -lm
	$(STRIP) -s $@
	$(OBJCOPY) -R .note -R .comment -R .note.ABI-tag -R .gnu.version $@

ifinfo.o: ifinfo.c ifinfo.h vnstat.h db.h misc.h cfg.h
	$(CC) $(CFLAGS) -c ifinfo.c

db.o: db.c db.h dbaccess.h ifinfo.h misc.h vnstat.h
	$(CC) $(CFLAGS) -c db.c

dbaccess.o: dbaccess.c dbaccess.h vnstat.h
	$(CC) $(CFLAGS) -c dbaccess.c

misc.o: misc.c misc.h vnstat.h
	$(CC) $(CFLAGS) -c misc.c

cfg.o: cfg.c cfg.h
	$(CC) $(CFLAGS) -c cfg.c

dumpxml.o: dumpxml.c dumpxml.h vnstatxml.h vnstat.h
	$(CC) $(CFLAGS) -c dumpxml.c
 
clean:
	rm -f *.o *~ core *.i vnstat *.gcda *.gcno cscope*out *.gcov *.gch
