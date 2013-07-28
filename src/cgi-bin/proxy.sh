#!/bin/bash
# proxy.sh -- get the XML web page from another server
# author: falcon <zhangjinw@gmail.com>
# update: 2008-06-14
# usage: proxy.sh?url="url_address"

# print the content type header: "content-type: text/xml\n"

echo -e "content-type: text/xml\n"

# call a light-weight http client, this http client just request the content of
# an XML file, hence the content-type header should be output above to stand to
# the CGI standard. if you have instaled lynx, you can use "lynx -source "
# instead of ./httpclient.

if [ -n "$QUERY_STRING" ]; then
	./httpclient $QUERY_STRING
else
	[ -n "$1" ] && ./httpclient $1
fi
