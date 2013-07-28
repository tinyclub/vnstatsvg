#!/bin/bash
# a shell script for showing the vnstat result in svg format

ifconfig=/sbin/ifconfig
# if you use the standalone vnstatxml, please remove the --dumpxml option
vnstat="/usr/lib/cgi-bin/vnstatxml"
browser=/usr/bin/firefox
vnstat_xsl=/etc/vnstat.xsl

while getopts  "i:t:" flag
do
    case $flag in
        i) IFACE=$OPTARG
        ;;
        t) TYPE=$OPTARG
        ;;
        *)  echo "Usage: `basename $0` -i iface -t [m|h|d|t|s]"
	    echo "                    m month"
	    echo "                    h hour"
	    echo "                    d day"
	    echo "                    t top10"
	    echo "                    s summary"
	    echo
	    exit -1
        ;;
    esac
done

[ -z "$IFACE" ] && IFACE=eth0
$ifconfig -s $IFACE >/dev/null
if [ $? -eq 0 ]; then
vnstat="$vnstat -i $IFACE"
else
echo "no such iface: $IFACE" && exit -1
fi

[ -z "$TYPE" ] && TYPE=s
if [ "$TYPE" = "d" -o "$TYPE" = "m" -o \
"$TYPE" = "t" -o "$TYPE" = "h" -o \
"$TYPE" = "s" ]; then 
if [ "$TYPE" = "s" ]; then
 vnstat="$vnstat"
else
 vnstat="$vnstat -$TYPE"
fi
fi

vnstat_xml=`mktemp`
vnstat_xsl_tmp=`mktemp`
cp $vnstat_xsl $vnstat_xsl_tmp
$vnstat > $vnstat_xml
sed -i "/<traffic/i <?xml-stylesheet type='text/xsl' href='`echo $vnstat_xsl_tmp`'?>" $vnstat_xml
$browser $vnstat_xml
