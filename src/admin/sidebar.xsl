<?xml version= "1.0" encoding = "UTF-8" standalone = 'no' ?>
<xsl:stylesheet version = "1.0" xmlns:xsl = "http://www.w3.org/1999/XSL/Transform"> 
<xsl:template match="/">
  <ul class = "iface"> 
    <xsl:for-each select="sidebar/iface"> 
      <li class = "iface"> 
      <xsl:value-of select = "alias"/>
      <xsl:variable name = "ALIAS" select = "alias"/>
      <xsl:variable name = "IFACE" select = "name"/>
      <xsl:variable name = "IP_DN" select = "ip_dn"/>
      <xsl:variable name = "PROTO" select = "proto"/>
      <xsl:variable name = "CGI_BIN" select = "cgi_bin"/>
        <ul class = "page"> 
          <li class = "page"> 
            <a onclick = "showCurrent('{$ALIAS}','{$IFACE}','{$IP_DN}','{$PROTO}','{$CGI_BIN}','summary','Summary')"> summary </a> 
          </li> 
          <li class = "page"> 
            <a onclick = "showCurrent('{$ALIAS}','{$IFACE}','{$IP_DN}','{$PROTO}','{$CGI_BIN}','top10','Top 10 days')"> top10 </a> 
          </li> 
          <li class = "page"> 
            <a onclick = "showCurrent('{$ALIAS}','{$IFACE}','{$IP_DN}','{$PROTO}','{$CGI_BIN}','hour', 'Last 24 hours')"> hours </a> 
          </li> 
          <li class = "page"> 
            <a onclick = "showCurrent('{$ALIAS}','{$IFACE}','{$IP_DN}','{$PROTO}','{$CGI_BIN}','day','Last 30 days')"> days </a>
          </li> 
          <li class = "page"> 
            <a onclick = "showCurrent('{$ALIAS}','{$IFACE}','{$IP_DN}','{$PROTO}','{$CGI_BIN}','month','Last 12 months')"> months </a> 
          </li> 
	  <li class = "page"> 
            <a onclick = "showCurrent('{$ALIAS}','{$IFACE}','{$IP_DN}','{$PROTO}','{$CGI_BIN}','second','Last 1 second')"> second </a> 
          </li> 

        </ul> 
       </li> 
    </xsl:for-each>
   </ul> 
</xsl:template> 
</xsl:stylesheet>
