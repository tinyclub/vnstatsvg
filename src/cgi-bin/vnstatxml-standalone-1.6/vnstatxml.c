/*
vnStatXML - Copyright (c) 2008-09 Wu Zhangjin <wuzhangjin@gmail.com>

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; version 2 dated June, 1991.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program;  if not, write to the Free Software
   Foundation, Inc., 675 Mass Ave., Cambridge, MA 02139, USA.
*/

#include "misc.h"
#include "dumpxml.h"
#include "vnstatxml.h"

int main(int argc, char *argv[]) {
	char interface[32], dirname[512];
	int opt;

	/* init interface */
	strncpy(interface, DEFIFACE, 32);
		
	/* init dirname */
	strncpy(dirname, DATABASEDIR, 512);

	/* init configuration */
	defaultcfg();

	/* init the qmode */
	cfg.qmode = 0;

	/* parse parameters with the support of getopt */
	while ((opt = getopt(argc, argv, "dmtaswhi:c:")) != -1) {
        switch (opt) {
		case 'd':
			cfg.qmode=1;
			break;
		case 'm':
			cfg.qmode=2;
			break;
		case 't':
			cfg.qmode=3;
			break;
		case 'h':
			cfg.qmode=7;
			break;
		case 'i':
			strncpy(interface, optarg, 32);
			break;
		case 'c':
			strncpy(dirname, optarg, 512);
			break;
		case 'a':
		case 's':
		case 'w':
		default: /* '?' */
			usage();
			return 0;
		}	 
	}

	readdb(interface, dirname);
	dumpXML(cfg.qmode);
	
	return 0;
}
