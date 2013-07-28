#include "dumpxml.h"
#include "vnstatxml.h"

void usage()
{
	printf("::::::vnStatXML %s by Wu Zhangjin <wuzhangjin@gmail.com>::::::\n\n", VNSTATXMLVERSION);
	printf("         -h           show hours\n");
	printf("         -d           show days\n");
	printf("         -m           show months\n");
	printf("         -w           show weeks\n");
	printf("         -t           show top10\n");
	printf("         -s           use short output\n");
	printf("         -a           show database in parseable format\n");
	printf("         -i           set the interface\n");		
	printf("         -c           set the database directory of vnstat\n");		
	printf("         -?           short help\n");
	printf("         -v           show version\n\n");
	printf("NOTE: vnStatXML %s not support -a, -s and -w currently.\n\n", VNSTATXMLVERSION);

}

void defaultcfg(void) {
	cfg.qmode = DEFQMODE;
	strncpy(cfg.dbdir, DATABASEDIR, 512);
	strncpy(cfg.iface, DEFIFACE, 32);

	defaultcfg4vnstatxml();
}
