#!/bin/sh
# vnstat.sh -- generate an xml file from the vnStat database: $ vnstat --dumpdb -i iface
# author: falcon <zhangjinw@gmail.com>, http://dslab.lzu.edu.cn/members/falcon
# update: 2008-06-14

# print the header of xml file
if [ -n "$QUERY_STRING" ]; then
	INPUT_STRING=$QUERY_STRING
	echo "content-type:text/xml"
	echo ""
	echo "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>"
else
	if [ -n "$1" ]; then
		INPUT_STRING=$1
	else
		echo "ERROR: No input."
		exit -1
	fi
fi

# indicate several commands
VNSTAT="/usr/bin/vnstat"
VNSTAT_DB_DIR="/var/lib/vnstat"

# get the arguments from a http client

ST1=$(echo "$INPUT_STRING" | cut -d'&' -f1)
ST2=$(echo "$INPUT_STRING" | cut -d'&' -f2)

IFACE=$(echo "$ST1" | cut -d'=' -f2)
PAGE=$(echo "$ST2" | cut -d'=' -f2)

# for debugging
[ -z "$IFACE" ] && IFACE=eth0
[ -z "$PAGE" ] && PAGE=summary

# ensure the arguments are legal, NOTE: if you have other names of network interface, please add them here
# By default, 'second' data is read from /proc/net/dev, but for remote hosts, the data
# must be collected to the default db directory: ${VNSTAT_DB_DIR}/${IFACE}-second periodically previously.
second_data_file=/proc/net/dev
if [ "$IFACE" != "eth0" -a "$IFACE" != "eth1" ]; then
	second_data_file=${VNSTAT_DB_DIR}/${IFACE}-second
	IFACE_END=$(echo "$IFACE" | cut -d '-' -f2)
	[ "$IFACE_END" != "eth0" -a "$IFACE_END" != "eth1" ] && exit -1
fi
[ "$PAGE" != "summary" -a "$PAGE" != "hour" -a "$PAGE" != "day" -a "$PAGE" != "month" -a "$PAGE" != "top10" -a "$PAGE" != "second" ] && exit -1

VNSTAT=$VNSTAT" --dumpdb -i $IFACE"

# get the traffic info of every type: summary, top10, hour, day, month
case $PAGE in
	summary) info=$($VNSTAT | awk -F";" 'BEGIN{ch=strftime("%k", systime()); sub(" ","", ch);} { if($0 ~ "^total|^d;0|^m;0|^h;"ch";|^created|^updated") {if($1 ~ "^created") {printf("%s", strftime("%y/%m/%d-->", $2));} else if ($1 ~ "^updated") {printf("%s;0;0;", strftime("%y/%m/%d", $2));} else  if($1 ~ "^total") { printf("%s;", $2); if($1 ~ "txk$") printf("1\n");} else {printf("%s",$0); if($1 == "h") printf(";1\n"); else printf("\n");}}}')
	;;
	top10) info=$($VNSTAT | grep "^t;" | grep -v ";0$" | sort -t ";" -g -k3)
	;;
	hour) info=$($VNSTAT | grep "^h;" | grep -v ";0$" | sort -t ";" -g -k3)
	;;
	day) info=$($VNSTAT | grep "^d;.*1$" | sort -t ";" -g -k3)
	;;
	month) info=$($VNSTAT | grep "^m;.*1$" | sort -t ";" -g -k3)
	;;
	second) info=$(cat $second_data_file | grep "$IFACE" | tr ":" " " |  awk '{printf("%s %s\n", $2/1024, $10/1024);}' \
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
	*) echo "there is no page named $PAGE" && exit -1
	;;
esac

# generate the XML result

echo "$info" | tr ' ' '\n' | \
awk -v page="$PAGE" -F";" 'BEGIN{
	printf("<traffic id=\"content\" p=\"%s\"", page);
	if(page=="summary") { 
		map["d"]="today: %Y/%m/%d";map["m"]="this month: %Y/%m";map["h"]="current hour: %H:00";
	} else {
		colnum["top10"]=10;colnum["day"]=30;colnum["month"]=12;colnum["hour"]=24;
		fullmap["t"]="%Y-%m-%d";fullmap["h"]="%Y-%m-%d %H:00";fullmap["m"]="%Y-%m";fullmap["d"]="%Y-%m-%d";
		map["t"]="%m-%d";map["h"]="%H";map["m"]="%m";map["d"]="%d";
		printf(" colnum=\"%s\"", colnum[page]);
	}
	printf(">\n");
	printf("<us><u id=\"0\" sym=\" KB\" val=\"1\"/><u id=\"1\" sym=\" MB\" val=\"1024\"/><u id=\"2\" sym=\" GB\" val=\"1048576\"/></us>\n");
	max=0;
	}{
		if(page=="summary") {
			if ($1 ~ "d|m|h") printf("<r f1=\"%s\"", strftime(map[$1], systime()));
			else printf("<r f1=\"%s\"", $1);
		} else {
			printf("<r f1=\"%s\" x=\"%s\"", strftime(fullmap[$1], $3), strftime(map[$1], $3));
		}

		if($1 == "h") {
			r=$4/1048576;
        	        t=$5/1048576;
		} else {
			r=($4*1024+$6)/1048576;
        	        t=($5*1024+$7)/1048576;
                }
		
		if (r > max) max=r;
		if (t > max) max=t;
        	s=r+t;

	        s_unit=2;
        	r_unit=2;
	        t_unit=2;
        	if(s < 1) { s=s*1024; s_unit=1; }
	        if(s < 1) { s=s*1024; s_unit=0; }
	        if(r < 1) { r=r*1024; r_unit=1; }
        	if(r < 1) { r=r*1024; r_unit=0; }
	        if(t < 1) { t=t*1024; t_unit=1; }
	        if(t < 1) { t=t*1024; t_unit=0; }

		printf(">");
		printf("<f><s>%s</s><u>%s</u></f>",r, r_unit);
		printf("<f><s>%s</s><u>%s</u></f>",t, t_unit);
		printf("<f><s>%s</s><u>%s</u></f>",s, s_unit);
		printf("</r>\n");
	}END{
		if(page != "summary") {
			max_unit=2;
			if(max < 1) { max=max*1024; max_unit=1; }
		       	if(max < 1) { max=max*1024; max_unit=0; } 
			printf("<mf><s>%s</s><u>%s</u></mf>\n",max, max_unit);
		}
	}'
echo "</traffic>"
