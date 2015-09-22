
# INSTALL

    0. Introduction
	1. Download
	2. Preparation
	3. Installation
	3.1 Configure
	3.2 Compile & Cross compile
	3.3 Install
	4. Configuration
	4.1 Configure for one interface
	4.2 Configure for multi-interfaces on single host
	4.3 Configure for multi-hosts(just supported in Version 0.2.x or later):
	5. Access
	5.1 Access from web browser with web service
	5.2 vnstatgui: Access from web browser without web service
	6. More Configuration

----------------------------

## Introduction

vnStatSVG is a SVG-based web frontend to vnStat(a traffic monitor in linux), so
MUST install one of Linux distributions[1] and vnStat[2] at first.

Now, it's time to show the basic steps to install vnStatSVG.

## Download

vnStatSVG is published as git repo, clone it:

    $ git clone https://github.com/tinyclub/vnstatsvg.git && cd vnstatsvg/

Let's overview the source code

    $ tree src
    src
    ├── admin
    │   ├── index.xhtml
    │   ├── index.xsl
    │   ├── sidebar.xml
    │   ├── sidebar.xml-template-4-multihosts
    │   ├── sidebar.xml-template-4-singlehost
    │   ├── sidebar.xsl
    │   ├── vnstat.css
    │   ├── vnstat.js
    │   └── vnstat.xsl	# the XML interpreter file, with FULL comments
    ├── cgi-bin
    │   ├── httpclient.c
    │   ├── Makefile
    │   ├── proxy.sh
    │   ├── vnstat-c.sh
    │   ├── vnstat-p.sh
    │   ├── vnstat-shell.sh
    │   ├── vnstatxml-1.6		# vnstat-1.6 with --dumpxml feature support
    │   │   ├── README_vnStatXML
    │   │   ├── src
    │   │   │   ├── dumpxml.c
    │   │   │   ├── dumpxml.h
    │   │   │   └── vnstatxml.h
    │   │   ├── UNINSTALL
    │   │   └── UPGRADE
    │   └── vnstatxml-standalone-1.6  # the standalone vnStatXML
    │       ├── dbaccess.c
    │       ├── dbaccess.h
    │       ├── dumpxml.c
    │       ├── dumpxml.h
    │       ├── Makefile
    │       ├── misc.c
    │       ├── misc.h
    │       ├── README
    │       ├── vnstatxml.c
    │       └── vnstatxml.h
    └── vnstatgui			# SVG graphic output without web service
        ├── install.sh
        ├── README
        ├── uninstall.sh
        ├── vnstatgui.sh
        └── vnstat.xsl

## Preparation

Before installing vnStatSVG, the following tools are needed.

|Tools	 | Requirement
|:------:|:------------------------------------------------------------
|vnstat  | version >= 1.6
|httpd	 | support CGI, Apache, nginx+fastcgi and Busybox httpd
|sh		 | bash, dash, ash
|gawk/awk| only needed when using a shell script to dump xml data
|sort	 |
|cut	 |
|cron    |
|grep	 |

**Note**:

* The `index` keyword of the http server must include index.xhtml.
* the MIME types must include 'text/xml xml xsl'.

## Installation

### Configure

    $ ./configure

By default, the cgi-bin directory will be set as /usr/lib/cgi-bin or /var/www
in order. the installation root directory will be set as /var/www, and the XML
dumping method via a shell script with "--dumpdb" option provided by vnStat
will be used.

If want to do some special configuration, you can get help via the -h
option of configure.

### Compile & Cross compile

    $ make

To cross compile it for another architecture, use ARM as an example, please:

    $ make CROSS_COMPILE=arm-linux-gnueabi-

To link statically, please:

    $ make CFLAGS=" -static " CROSS_COMPILE=arm-linux-gnueabi-

Note: If don't want to compile vnstat separately, you can use the XML dumping
method patched vnstat. Although the latest vnstat itself provide the --xml
option, but our vnstatSVG doesn't work with the XML output for format issue.

### Install

    $ make install

## Configuration

After installing vnStatSVG, we should do some configuration on it via
the configuration file: `/path/to/vnstatsvg-installation-root/sidebar.xml`

### Configure for one interface

    <iface>
    	 <name>the name of interface, such as eth0, eth1...</name>
    	 <host>the ip address of domain of the host</host>
    	 <dump_tool>the address of the cgi program, e.g. /cgi-bin/vnstat.sh</dump_tool>
    	 <description>the description of this inteface, e.g. some description of iface</description>
    </iface>

### Configure for multi-interfaces on single host

Just configure a new node named `<iface> ... </iface>` in.

### Configure for multi-hosts

If want to monitor server hosts in a "window", just need to copy the
XML dumping reltated files to the relative servers. for example, if use the
shell script with the "--dumpdb" option provided by vnStat to dump XML data,
You just need to copy the vnstat-shell.sh to the server, of course gawk
is needed to install there. if use the vnStatXML to dump XML data
directly, should install vnStatXML and vnstat-c.sh there.

## Access

### Access from web browser with web service

Type the following link in your web browser:

http://host-ip-address/path/to/vnstatsvg-installation-root/index.xml

### Access from web browser without web service

To get a graphic output without web serivce, you can simply use vnstatgui:

    $ ./configure -m p
    $ make; make install
    $ pushd src/vnstatgui/
    $ install.sh
    $ vnstatgui
    Usage: vnstatgui.sh -i iface -t [m|h|d|t|s]
                        m month
                        h hour
                        d day
                        t top10
                        s summary
    $ ./vnstatgui.sh -i eth0 -t m

## More configuration

In the latest version of vnStatSVG, it use index.xml as the index page, so,
you'd better set index.xml as the index page via configuring the http
server.

## References & Links

* [Linux distributions list][1]
* [vnStat][2]
* [vnStatSVG][3]
* [Demo][4]

[1]: http://www.linux.org/dist/
[2]: http://humdi.net/vnstat/
[3]: http://www.tinylab.org/vnstatsvg/
[4]: http://tinylab.org/vnstatsvg-demo/
