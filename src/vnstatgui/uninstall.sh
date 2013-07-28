#!/bin/bash

[ `id -u` -ne 0 ] && echo "Please login as root firstly." && exit -1
rm -i /etc/vnstat.xsl
rm -i /usr/bin/vnstatgui
