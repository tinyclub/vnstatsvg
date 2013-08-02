#!/bin/sh
# vnstat-update.sh -- a simple daemon to update database of vnstat in specified period
VNSTAT=/usr/bin/vnstat
IFACE=eth0
PERIOD=5

while :;
do
        $VNSTAT -u -i $IFACE
        sleep $PERIOD
done
