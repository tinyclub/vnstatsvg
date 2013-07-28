#include "vnstatxml.h"
#include "dumpxml.h"

void dumpXML(int qmode)
{
	int i, j;
	int hour, week;
	int tmax=0;
	int r_unit, t_unit, s_unit, m_unit;
	double r, t, s, m;
        const struct tm *d;
	char f1[16], f2[16], f3[32], x[16];
	time_t current;

	/* XML header */
	if (qmode == 4 || qmode == 5 || qmode == 6) {
		printf("Current vnStatXML only support \"  -i IFACE [no option]|-d|-h|-m|-t \n");
		exit(-1);
	}
	printf(cfg.xml.header);

	/* XML data header */
	printf(cfg.xml.dataheader, cfg.xml.page[qmode], cfg.xml.colnum[qmode]);
	
	
	/* XML data text */
	printf(cfg.xml.units);

	if (data.totalrx+data.totaltx==0 && data.totalrxk+data.totaltxk==0) {
		printf(" %s: Not enough data available yet.\n", data.interface);
	} else {
		
		/* sumary */
		if (qmode==0) {
		
			/* totoal traffic */
			r = data.totalrx*1024 + data.totalrxk;
			t = data.totaltx*1024 + data.totaltxk;
			s = r + t;
			transformunit(&r, &r_unit);
			transformunit(&t, &t_unit);
			transformunit(&s, &s_unit);
			memset(f1, '\0', 16);
			memset(f2, '\0', 16);
			memset(f3, '\0', 32);
			d=localtime(&data.created);
			strftime(f1, 16, cfg.xml.ttfdformat, d);
			d=localtime(&data.lastupdated);
			strftime(f2, 16, cfg.xml.tttdformat, d);
			sprintf(f3, "%s%s", f1, f2);
			printf(cfg.xml.field, f3, "", r, r_unit, t, t_unit, s, s_unit);
			
			/* this month */
			r = data.month[0].rx*1024 + data.month[0].rxk;
			t = data.month[0].tx*1024 + data.month[0].txk;
			s = r + t;
			transformunit(&r, &r_unit);
			transformunit(&t, &t_unit);
			transformunit(&s, &s_unit);
			memset(f3, '\0', 32);
			d=localtime(&data.month[0].month);
			strftime(f3, 32, cfg.xml.mdformat, d);
			printf(cfg.xml.field, f3, "", r, r_unit, t, t_unit, s, s_unit);
			
			/* this week */
			strftime(f1, 16, "%V", d);
			week=atoi(f1);
			r=t=s=0;
			for(i = 0; i < 30; i++ ) {
				if(data.day[i].used) {
					d=localtime(&data.day[i].date);
					memset(f1, '\0', 16);
					strftime(f1, 16, "%V", d);
					if (atoi(f1) == week) {
						r += data.day[i].rx*1024+data.day[i].rxk;
						t += data.day[i].tx*1024+data.day[i].txk;
						s += r+t;
					}
				}
			}
			transformunit(&r, &r_unit);
			transformunit(&t, &t_unit);
			transformunit(&s, &s_unit);
			current=time(NULL);
			d=localtime(&current);
			strftime(f3, 32, cfg.xml.wdformat, d);
			printf(cfg.xml.field, f3, "", r, r_unit, t, t_unit, s, s_unit);
			
			/* today */
			r = data.day[0].rx*1024 + data.day[0].rxk;
			t = data.day[0].tx*1024 + data.day[0].txk;
			s = r + t;
			transformunit(&r, &r_unit);
			transformunit(&t, &t_unit);
			transformunit(&s, &s_unit);
			memset(f3, '\0', 32);
			d=localtime(&data.day[0].date);
			strftime(f3, 32, cfg.xml.tddformat, d);
			printf(cfg.xml.field, f3, "", r, r_unit, t, t_unit, s, s_unit);
			
			/* current hour */
			current=time(NULL);
			d=localtime(&current);
			hour = d->tm_hour;

			r = data.hour[hour].rx;
			t = data.hour[hour].tx;
			s = r + t;
			transformunit(&r, &r_unit);
			transformunit(&t, &t_unit);
			transformunit(&s, &s_unit);
			memset(f3, '\0', 32);
			d=localtime(&data.hour[hour].date);
			strftime(f3, 32, cfg.xml.hdformat, d);
			printf(cfg.xml.field, f3, "", r, r_unit, t, t_unit, s, s_unit);

		/* days */
		} else if (qmode==1) {
			/* search maximum */
			m=0;
			for (i=29;i>=0;i--) {
				if (data.day[i].used) {
					r=data.day[i].rx*1024+data.day[i].rxk;
					t=data.day[i].tx*1024+data.day[i].txk;
					if (r>m) m = r;
					if (t>m) m = t;
				}
			}
			
			for (i=29;i>=0;i--) {
				if (data.day[i].used) {
					r = data.day[i].rx*1024 + data.day[i].rxk;
					t = data.day[i].tx*1024 + data.day[i].txk;
					s = r + t;
					transformunit(&r, &r_unit);
					transformunit(&t, &t_unit);
					transformunit(&s, &s_unit);
					memset(f1, '\0', 16);
					d=localtime(&data.day[i].date);
					strftime(f1, 16, cfg.xml.dformat[qmode], d);
					strftime(x, 16, cfg.xml.xdformat[qmode], d);
					printf(cfg.xml.field, f1, x, r, r_unit, t, t_unit, s, s_unit);
				}
			}
			transformunit(&m, &m_unit);
			printf(cfg.xml.max, m, m_unit);

		/* months */
		} else if (qmode==2) {
			/* search maximum */
			m=0;
			for (i=11;i>=0;i--) {
				if (data.month[i].used) {
					r=data.month[i].rx*1024+data.month[i].rxk;
					t=data.month[i].tx*1024+data.month[i].txk;
					if (r>m) m = r;
					if (t>m) m = t;

				}
			}
			
			for (i=11;i>=0;i--) {
				if (data.month[i].used) {
					r = data.month[i].rx*1024 + data.month[i].rxk;
					t = data.month[i].tx*1024 + data.month[i].txk;
					s = r + t;
					transformunit(&r, &r_unit);
					transformunit(&t, &t_unit);
					transformunit(&s, &s_unit);
					memset(f1, '\0', 16);
					d=localtime(&data.month[i].month);
					strftime(f1, 16, cfg.xml.dformat[qmode], d);
					strftime(x, 16, cfg.xml.xdformat[qmode], d);
					printf(cfg.xml.field, f1, x, r, r_unit, t, t_unit, s, s_unit);
				}
			}
			transformunit(&m, &m_unit);
			printf(cfg.xml.max, m, m_unit);
	
		/* top10 */
		} else if (qmode==3) {
			/* search maximum */
			m=0;
			for (i=0;i<=9;i++) {
				if (data.top10[i].used) {
					r=data.top10[i].rx*1024+data.top10[i].rxk;
					t=data.top10[i].tx*1024+data.top10[i].txk;
					if (r>m) m = r;
					if (t>m) m = t;
				}
			}
			
			for (i=0;i<=9;i++) {
				if (data.top10[i].used) {
					r = data.top10[i].rx*1024 + data.top10[i].rxk;
					t = data.top10[i].tx*1024 + data.top10[i].txk;
					s = r + t;
					transformunit(&r, &r_unit);
					transformunit(&t, &t_unit);
					transformunit(&s, &s_unit);
					memset(f1, '\0', 16);
					d=localtime(&data.top10[i].date);
					strftime(f1, 16, cfg.xml.dformat[qmode], d);
					strftime(x, 16, cfg.xml.xdformat[qmode], d);
					printf(cfg.xml.field, f1, x, r, r_unit, t, t_unit, s, s_unit);
				}
			}
			transformunit(&m, &m_unit);
			printf(cfg.xml.max, m, m_unit);
		
		/* dumpdb */
		} else if (qmode==4) {
			;	/* not support currently */
		/* last 7 */
		} else if (qmode==6) {
			;	/* not support currently */
		/* hours */
		} else if (qmode==7) {
			/* receive(r), transimit(t), sum(s), max(m) */
			for (i=0;i<=23;i++) {
				if (data.hour[i].date>=data.hour[tmax].date) {
					tmax=i;
				}
				if (data.hour[i].rx>=m) {
					m=data.hour[i].rx;
				}
				if (data.hour[i].tx>=m) {
					m=data.hour[i].tx;
				}
			}
			
			/* hours and traffic */
			for (i=0;i<=23;i++) {
				j=tmax+i+1;
				r=data.hour[j%24].rx;
				t=data.hour[j%24].tx;
				s=r+t;
				if ( r != 0 && t != 0) {
					transformunit(&r, &r_unit);
					transformunit(&t, &t_unit);
					transformunit(&s, &s_unit);
					memset(f1, '\0', 16);
					d=localtime(&data.hour[j%24].date);
					strftime(f1, 16, cfg.xml.dformat[qmode], d);
					sprintf(x, "%d", j%24);
					printf(cfg.xml.field, f1, x,r,r_unit,t,t_unit,s,s_unit);
				}
			}
			transformunit(&m, &m_unit);
			printf(cfg.xml.max, m, m_unit);

		} else {
			/* users shouldn't see this text... */
			printf("Not such query mode: %d\n", qmode);
		}

	}

	/* XML data footer */
	printf(cfg.xml.datafooter);
}
void transformunit(double *size, int *unit)
{
                *unit = 0;
                if (*size > 1024) { 
			(*size)/=1024; 
			(*unit)++; 
		} 
		if(*size > 1024) { 
			(*size)/=1024; 
			(*unit)++; 
		}
}

void defaultcfg4vnstatxml(void)
{
	cfg.xml.dumpxml = DEFDUMPXML;
	strncpy(cfg.xml.header, XMLHEADER, 128);
	strncpy(cfg.xml.dataheader, XMLDATAHEADER, 128);
	strncpy(cfg.xml.units, XMLUNITS, 256);
	strncpy(cfg.xml.field, XMLFIELD, 512);
	strncpy(cfg.xml.max, XMLMAX, 64);
	strncpy(cfg.xml.datafooter, XMLDATAFOOTER, 16);
	strncpy(cfg.xml.page[0], XMLPAGE1, 8);
	strncpy(cfg.xml.page[1], XMLPAGE2, 8);
	strncpy(cfg.xml.page[2], XMLPAGE3, 8);
	strncpy(cfg.xml.page[3], XMLPAGE4, 8);
	strncpy(cfg.xml.page[4], XMLPAGE5, 8);
	strncpy(cfg.xml.page[5], XMLPAGE6, 8);
	strncpy(cfg.xml.page[6], XMLPAGE7, 8);
	strncpy(cfg.xml.page[7], XMLPAGE8, 8);
	strncpy(cfg.xml.dformat[0], XMLDFORMAT1, 16);
	strncpy(cfg.xml.dformat[1], XMLDFORMAT2, 16);
	strncpy(cfg.xml.dformat[2], XMLDFORMAT3, 16);
	strncpy(cfg.xml.dformat[3], XMLDFORMAT4, 16);
	strncpy(cfg.xml.dformat[4], XMLDFORMAT5, 16);
	strncpy(cfg.xml.dformat[5], XMLDFORMAT6, 16);
	strncpy(cfg.xml.dformat[6], XMLDFORMAT7, 16);
	strncpy(cfg.xml.dformat[7], XMLDFORMAT8, 16);
	strncpy(cfg.xml.xdformat[0], XMLXDFORMAT1, 16);
	strncpy(cfg.xml.xdformat[1], XMLXDFORMAT2, 16);
	strncpy(cfg.xml.xdformat[2], XMLXDFORMAT3, 16);
	strncpy(cfg.xml.xdformat[3], XMLXDFORMAT4, 16);
	strncpy(cfg.xml.xdformat[4], XMLXDFORMAT5, 16);
	strncpy(cfg.xml.xdformat[5], XMLXDFORMAT6, 16);
	strncpy(cfg.xml.xdformat[6], XMLXDFORMAT7, 16);
	strncpy(cfg.xml.xdformat[7], XMLXDFORMAT8, 16);
	cfg.xml.colnum[0] = XMLCOLNUM1;
	cfg.xml.colnum[1] = XMLCOLNUM2;
	cfg.xml.colnum[2] = XMLCOLNUM3;
	cfg.xml.colnum[3] = XMLCOLNUM4;
	cfg.xml.colnum[4] = XMLCOLNUM5;
	cfg.xml.colnum[5] = XMLCOLNUM6;
	cfg.xml.colnum[6] = XMLCOLNUM7;
	cfg.xml.colnum[7] = XMLCOLNUM8;
	strncpy(cfg.xml.ttfdformat, XMLTOTALFROMDFORMAT, 32);
	strncpy(cfg.xml.tttdformat, XMLTOTALTODFORMAT, 32);
	strncpy(cfg.xml.mdformat, XMLMONTHDFORMAT, 32);
	strncpy(cfg.xml.wdformat, XMLWEEKDFORMAT, 32);
	strncpy(cfg.xml.tddformat, XMLTODAYDFORMAT, 32);
	strncpy(cfg.xml.hdformat, XMLHOURDFORMAT, 32);
}
