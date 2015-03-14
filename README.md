	
	vnStat SVG frontend

	1. Introduction
	2. Demo
	3. Usage
	4. Desgin
	5. More...

------------

1. Introduction

    [vnStat SVG frontend (vnStatsvg)][1] is another web-based graphical frontend
    to [vnStat(a network traffic monitor for Linux)][3]. It is suited to the
    distributed & embedded system built on linux.

2. Demo

    PLEASE use mozilla-5.0 based browsers to access vnStatSVG:

    <http://tinylab.org/vnstatsvg/> is such a demo site.

    See screenshot pictures under DEMO/ if can not access it.

   * Browsers list supported by the latest vnStatSVG (1.0.0):

	$ seamonkey --version
		SeaMonkey 1.1.9, Copyright (c) 2003-2008 mozilla.org, build 2008031300
	$ firefox --version
		Mozilla Firefox 3.0, Copyright (c) 1998 - 2008 mozilla.org
	$ chromium-browser --version
		Chromium 25.0.1364.160 Ubuntu 12.10

3. Usage

	Please read the INSTALL document for standard Linux distribution.
	and INSTALL_Busybox document for Busybox based embedded system.
	To learn multi-protocols configuration, please refer to INSTALL_MultiProtocol

4. Desgin

    It is based on HTML, XML, XSL, Javascript, CSS, SVG, for more information,
    please read the [PAPER][5](this is a paper I have published in "The First
    IEEE International Conference on Ubi-media Computing").

    If you have interest, you can try to use another [web-based vnStat frontendp][4]
    and compare it with vnStatSVG, and then try to understand why
    vnStatSVG is more suited to distributed & embedded system.

5. More...

    The new tool named vnstatgui can be used to generate the graphical
    report. It is in src/vnstatgui/.

References & Links

1. [vnStatsvg Homepage][1]
2. [vnStatsvg Demo][2]
3. [vnStat, a network traffic monitor for linux][3]
4. [vnStat PHP frontend, another web-based frontend][4]
5. [A CGI+AJAX+SVG based monitoring method for the distributed and embedded system][5]

[1]: http://www.tinylab.org/project/vnstatsvg/
[2]: http://www.tinylab.org/vnstatsvg/
[3]: http://humdi.net/vnstat/
[4]: http://www.sqweek.com/sqweek/index.php?p=1
[5]: http://ieeexplore.ieee.org/xpl/mostRecentIssue.jsp?punumber=4562771
