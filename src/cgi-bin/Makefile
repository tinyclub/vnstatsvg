CC=$(CROSS_COMPILE)gcc
CFLAGS+= -O2 -W
RM=rm -f
VNSTATXML_STANDALONE=vnstatxml-standalone-1.6
VNSTATXML=vnstatxml-1.6

all: httpclient vnstatxml vnstatxml_standalone

httpclient: httpclient.c
	$(CC) $(CFLAGS) -o $@ $<

vnstatxml_standalone:
	make -C $(VNSTATXML_STANDALONE)

vnstatxml:
	make -C $(VNSTATXML)

proxy:
	./proxy.sh http://www.google.com
	
clean:
	@$(RM) httpclient
