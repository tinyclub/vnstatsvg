#!/bin/bash

[ `id -u` -ne 0 ] && echo "Please login as root firstly." && exit -1
cp vnstat.xsl /etc
cp vnstatgui.sh /usr/bin/vnstatgui
chmod +x /usr/bin/vnstatgui
