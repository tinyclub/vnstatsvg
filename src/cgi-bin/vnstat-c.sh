#!/bin/sh
# vnstat.sh -- generate an xml file from the vnStat database: $ vnstat --dumpdb -i iface
# author: falcon <zhangjinw@gmail.com>, http://dslab.lzu.edu.cn/members/falcon
# update: 2008-06-14

# print the header of xml file
echo "content-type:text/xml"
echo ""

# indicate several commands
VNSTAT="./vnstatxml"

# get the arguments from a http client

ST1=$(echo "$QUERY_STRING" | cut -d'&' -f1)
ST2=$(echo "$QUERY_STRING" | cut -d'&' -f2)

IFACE=$(echo "$ST1" | cut -d'=' -f2)
PAGE=$(echo "$ST2" | cut -d'=' -f2)

# for debugging
[ -z "$IFACE" ] && IFACE=eth0
[ -z "$PAGE" ] && PAGE=summary

# ensure the arguments are legal, NOTE: if you have other names of network interface, please add them here
[ "$IFACE" != "eth0" -a "$IFACE" != "eth1" ] && exit -1
[ "$PAGE" != "summary" -a "$PAGE" != "hour" -a "$PAGE" != "day" -a "$PAGE" != "month" -a "$PAGE" != "top10" -a "$PAGE" != "second" ] && exit -1

VNSTAT_BASENAME=${VNSTAT##*/}
if [ "$VNSTAT_BASENAME" == "vnstat" ]; then
VNSTAT=$VNSTAT" --dumpxml -i $IFACE"
else
VNSTAT=$VNSTAT" -i $IFACE"
fi

# get the traffic info of every type: summary, top10, hour, day, month
case $PAGE in
	summary) 
		$VNSTAT
		;;
	top10) 
		$VNSTAT -t
		;;
	day)   
		$VNSTAT -d
		;;
	hour)
		$VNSTAT -h
		;;
	month)
		$VNSTAT -m
		;;
	second) info=$(cat /proc/net/dev | grep "$IFACE" | tr ":" " " |  awk '{printf("%s %s\n", $2/1024, $10/1024);}' \
	| awk -v page="$PAGE" 'BEGIN{
		printf("<traffic id=\"content\" p=\"%s\">\n", page);
		printf("<us><u id=\"0\" sym=\" KB\" val=\"1\"/><u id=\"1\" sym=\" MB\" val=\"1024\"/><u id=\"2\" sym=\" GB\" val=\"1048576\"/></us>\n");
		}{
			printf("<r f1=\"%s\">", strftime("%Y/%m/%d %H:%M:%S",systime()));
			
			r = $1/1048576;
			t = $2/1048576;
			s = ($1+$2)/1048576;
			r_unit = 2;
			t_unit = 2;
			s_unit = 2
		 	
			if(r < 1) { r=r*1024; r_unit=1; }
		        if(r < 1) { r=r*1024; r_unit=0; }
        		if(t < 1) { t=t*1024; t_unit=1; }
		        if(t < 1) { t=t*1024; t_unit=0; }
			if(s < 1) { s=s*1024; s_unit=1; }
	        	if(s < 1) { s=s*1024; s_unit=0; }

			printf("<f><s>%s</s><u>%s</u></f>\n", r, r_unit);
			printf("<f><s>%s</s><u>%s</u></f>\n", t, t_unit);
			printf("<f><s>%s</s><u>%s</u></f>\n", s, s_unit);

			printf("</r>\n");
		}END{printf("</traffic>");}');
		echo $info
		exit
	;;
	*) echo "not support this page option: $page" && exit -1
	;;
esac
