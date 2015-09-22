	
# vnStat SVG frontend

	1. Introduction
	2. Demo
	3. Usage
	4. Desgin
	5. More...

------------

## Introduction

[vnStat SVG frontend (vnStatsvg)][1] is another web-based graphical frontend
to [vnStat(a network traffic monitor for Linux)][3]. It is designed for the
distributed & embedded system built on Linux.

* Homepage: <http://tinylab.org/vnstatsvg/>
* Demo Site: <http://tinylab.org/vnstatsvg-demo>
* Git Repo: <https://github.com/tinyclub/vnstatsvg.git>

## Demo

<http://tinylab.org/vnstatsvg-demo/> is such a demo site.

See screenshot pictures under DEMO/ if can not access it.

* Browsers list tested by the latest vnStatSVG:

    	$ seamonkey --version
    		SeaMonkey 1.1.9, Copyright (c) 2003-2008 mozilla.org, build 2008031300
    	$ firefox --version
    		Mozilla Firefox 3.0, Copyright (c) 1998 - 2008 mozilla.org
    	$ chromium-browser --version
    		Chromium 25.0.1364.160 Ubuntu 12.10

* Http Servers list tested by the latest vnStatSVG:

  * Apache
  * [Nginx with fastcgi][6]
  * Busybox httpd applet

## Usage

Please read the INSTALL.md document for standard Linux distribution.
and INSTALL_Busybox.md document for Busybox based embedded system.
To learn multi-protocols configuration, please refer to INSTALL_MultiProtocol.md

For more details, please read it from `doc/` or its [homepage][1].

And some frequently asked questions will be added to FAQ.md.

## Desgin

It is based on HTML, XML, XSL, Javascript, CSS, SVG, for more information,
please read the [PAPER][5](this is a paper published in "The First IEEE
International Conference on Ubi-media Computing").

If interest, please try to use another [web-based vnStat frontendp][4]
and compare it with vnStatSVG, and then try to understand why
vnStatSVG is more suitable for the distributed & embedded system.

## More...

The new tool named vnstatgui can be used to generate the graphical
report. It is in src/vnstatgui/.

## References & Links

1. [vnStatsvg Homepage][1]
2. [vnStatsvg Demo][2]
3. [vnStat, a network traffic monitor for linux][3]
4. [vnStat PHP frontend, another web-based frontend][4]
5. [A CGI+AJAX+SVG based monitoring method for the distributed and embedded system][5]

[1]: http://www.tinylab.org/vnstatsvg/
[2]: http://www.tinylab.org/vnstatsvg-demo/
[3]: http://humdi.net/vnstat/
[4]: http://www.sqweek.com/sqweek/index.php?p=1
[5]: http://ieeexplore.ieee.org/xpl/mostRecentIssue.jsp?punumber=4562771
[6]: http://tinylab.org/add-cgi-support-for-nginx/
