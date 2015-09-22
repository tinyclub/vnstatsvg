
# FAQ

## XSL can not be loaded automatically

* Q

> Firefox says in JS debug "xslHttp.responseXML is null" on vnstat.js:154:7 It looks like it can't request the sidebar.xsl but it works manually.

* A

> The 'XSL' file type must be added to the server's MIME support list.
>
> For SuSE Linux, edit `/etc/mime.types`, add the line like 'text/xml xml xsl'
