#ifndef _VNSTATXML_H
#define _VNSTATXML_H

/* default dumpxml setting */

#define DEFDUMPXML 0

/* default XML header format */

#define XMLHEADER "<?xml version='1.0' encoding='UTF-8' standalone='yes'?>\n"

/* default units array format */

#define XMLUNITS "<us><u id='0' sym=' KB' val='1'/><u id='1' sym=' MB' val='1024'/><u id='2' sym=' GB' val='1048576'/></us>\n"

/* default XML data header format */

#define XMLDATAHEADER "<traffic id='content' p='%s' colnum='%d'>\n" 

/* default field info format */

#define XMLFIELD "<r f1='%s' x='%s'><f><s>%.4f</s><u>%d</u></f><f><s>%.2f</s><u>%d</u></f><f><s>%.2f</s><u>%d</u></f></r>\n"

/* default max info format */

#define XMLMAX "<mf><s>%.2f</s><u>%d</u></mf>\n"

/* default XML data footer format */

#define XMLDATAFOOTER "</traffic>\n"

/* the type of pages of the XML info, currently, only support summary,day,month,top10,hour with --dumpxml */

#define XMLPAGE1 "summary"
#define XMLPAGE2 "day"
#define XMLPAGE3 "month"
#define XMLPAGE4 "top10"
#define XMLPAGE5 "all"
#define XMLPAGE6 "short"
#define XMLPAGE7 "week"
#define XMLPAGE8 "hour"
 
/* the total of the columns for every page*/

#define XMLCOLNUM1 0		
#define XMLCOLNUM2 30		/* day */
#define XMLCOLNUM3 12		/* month */
#define XMLCOLNUM4 10		/* top10 */
#define XMLCOLNUM5 0
#define XMLCOLNUM6 0
#define XMLCOLNUM7 0
#define XMLCOLNUM8 24		/* hour */

/* date format for XML date */

#define XMLDFORMAT1 ""
#define XMLDFORMAT2 "%Y-%m-%d"	/* day */
#define XMLDFORMAT3 "%Y-%m"	/* month */
#define XMLDFORMAT4 "%Y-%m-%d"	/* top10 */
#define XMLDFORMAT5 ""
#define XMLDFORMAT6 ""
#define XMLDFORMAT7 ""
#define XMLDFORMAT8 "%Y-%m-%d %H:00"	/* hour */

#define XMLXDFORMAT1 ""
#define XMLXDFORMAT2 "%d"	/* day */
#define XMLXDFORMAT3 "%m"	/* month */
#define XMLXDFORMAT4 "%m-%d"	/* top10 */
#define XMLXDFORMAT5 ""
#define XMLXDFORMAT6 ""
#define XMLXDFORMAT7 ""
#define XMLXDFORMAT8 "%H"	/* hour */

/* date format for XML summary time format */

#define XMLTOTALFROMDFORMAT "%Y/%m/%d"	/* total(from ...) */
#define XMLTOTALTODFORMAT " -> %Y/%m/%d"	/* total(to ...) */
#define XMLMONTHDFORMAT "this month: %Y/%m"	/* month */
#define XMLWEEKDFORMAT "this week: The %Vth week"		/* week */
#define XMLTODAYDFORMAT "today: %Y/%m/%d"	/* today */
#define XMLHOURDFORMAT "current hour: %H:00"	/* hour */

/* XML structure for the --dumpxml of vnstat */
typedef struct {
	int dumpxml;		/* dump xml or not */
	char header[128];	/* the output format of XML header */
	char dataheader[128];	/* the XML data header format */
	char units[256];	/* the output format of units array */
	char field[512];	/* the output format of flows */
	char max[64];		/* the output format of max info */
	char datafooter[16];	/* the XML data footer format */
	char page[8][8];	/* the type of XML 'pages' */
	char dformat[8][16];	/* the output date format of every XML 'pages' */
	char xdformat[8][16];	/* the output date format of every XML 'pages' */
	int colnum[8]; 		/* the total of columns os the XML 'pages' */
	char ttfdformat[32];	/* the output date format for total info(from ... to ...) */
	char tttdformat[32];	/* the output date format for total info(from ... to ...) */
	char mdformat[32];	/* the output date format for month */
	char wdformat[32];	/* the output date format for week */
	char tddformat[32];	/* the output date format for today */
	char hdformat[32];	/* the output date format for hour */
} XML;

/* the following #include and macro are only used in  vnstatxml-only, so #ifndef DATABASEDIR is needed */

#ifndef DATABASEDIR

#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <time.h>
#include <string.h>
#include <errno.h>
#include <sys/file.h>

/* location of the database directory */
#define DATABASEDIR "/var/lib/vnstat"

/* default interface */
#define DEFIFACE "eth0"

/* default query mode */
/* 0 = normal(summary), 1 = days, 2 = months, 3 = top10 */
/* 4 = dumpdb, 5 = short, 6 = weeks, 7 = hours */
#define DEFQMODE 0

/* use file locking by default */
#define USEFLOCK 1

/* how many times try file locking before giving up */
/* each try takes about a second */
#define LOCKTRYLIMIT 5

/* database version */
/* 1 = 1.0, 2 = 1.1-1.2, 3 = 1.3- */
#define DBVERSION 3

/* integer limits */
#define FP32 4294967295ULL
#define FP64 18446744073709551615ULL

/* version string */
#define VNSTATXMLVERSION "0.1"

/* internal config structure */
typedef struct {
	int qmode;
	int flock;
	char iface[32];
	char dbdir[512];
	XML xml;	/* Added by Wu Zhangjin at Sat Jun 28 04:14:46 CST 2008 */
} CFG;

typedef struct {
	time_t date;
	uint64_t rx, tx;
} HOUR;

typedef struct {
	time_t date;
	uint64_t rx, tx;
	int rxk, txk;
	int used;
} DAY;

typedef struct {
	time_t month;
	uint64_t rx, tx;
	int rxk, txk;
	int used;
} MONTH;

/* db structure */
typedef struct {
	int version;
	char interface[32];
	char nick[32];
	int active;
	uint64_t totalrx, totaltx, currx, curtx;
	int totalrxk, totaltxk;
	time_t lastupdated, created;
	DAY day[30];
	MONTH month[12];
	DAY top10[10];
	HOUR hour[24];
	uint64_t btime;
} DATA;

/* global variables */
DATA data;
CFG cfg;

#endif

#endif
