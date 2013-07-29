#!/bin/sh
# proxy.sh -- get the XML web page from another server
# author: falcon <zhangjinw@gmail.com>
# update: 2008-06-14
# usage: proxy.sh?url="url_address"

# call a light-weight http client, this http client just request the content of
# an XML file, hence the content-type header should be output above to stand to
# the CGI standard. if you have instaled lynx, you can use "lynx -source "
# instead of ./httpclient.

if [ -n "$QUERY_STRING" ]; then
	INPUT="$QUERY_STRING"
else
	# Test with
	# /usr/lib/cgi-bin/proxy.sh "file://localhost/usr/bin/cgi-bin/vnstat.sh?i=eth0&p=hour"
	if [ -n "$1" ]; then
		INPUT="$1"
	else
		echo "ERROR: No input."
		exit -1
	fi
fi

# Get protocol
PROTO=$(echo "$INPUT" | cut -d':' -f1)

# Get host
HOST=$(echo "$INPUT" | cut -d'/' -f3)

# Get tool
TOOL="/"$(echo "$INPUT" | cut -d'?' -f1 | cut -d '/' -f4- | sed -e "s/%20/ /g")

# Get iface and page
ST1=$(echo "$INPUT" | cut -d'&' -f1)
ST2=$(echo "$INPUT" | cut -d'&' -f2)

IFACE=$(echo "$ST1" | cut -d'=' -f2)
PAGE=$(echo "$ST2" | cut -d'=' -f2)

# Debugging
#echo "protocol: $PROTO; host: $HOST; tool: $TOOL; iface: $IFACE; PAGE: $PAGE"

case $PROTO in
	"http")
		# print the content type header: "content-type: text/xml\n"
		echo -e "content-type: text/xml\n"

		./httpclient $INPUT
		;;
	"file")
		$TOOL "'?i='$IFACE'&p='$PAGE"
		;;
	*)
		echo "Don't support such protocol" && exit -1
esac
