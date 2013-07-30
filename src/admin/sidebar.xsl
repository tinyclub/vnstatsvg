<?xml version= "1.0" encoding = "UTF-8" standalone = 'no' ?>
<xsl:stylesheet version = "1.0" xmlns:xsl = "http://www.w3.org/1999/XSL/Transform"> 
<xsl:template match="/">
  <ul class = "iface"> 
    <xsl:for-each select="sidebar/iface">
      <xsl:variable name = "FLAG" select = "(position() mod 2)"/>
      <xsl:variable name = "START" select = "$FLAG*3+1"/>
      <xsl:variable name = "END" select = "$START+2+$FLAG"/>
      <xsl:variable name = "STYLE" select = "substring('oddeven',$START,$END)"/>
      <xsl:variable name = "ALIAS" select = "alias"/>
      <xsl:variable name = "IFACE" select = "name"/>
      <xsl:variable name = "HOST" select = "ip_dn"/>
      <xsl:variable name = "PROTO" select = "proto"/>
      <xsl:variable name = "CGI" select = "cgi_bin"/>
      <xsl:variable name = "HOST_ID" select = "concat($HOST, position())"/>
      <li class = "iface_{$STYLE}" onclick="showMenu('{$HOST}', '{$IFACE}','{position()}');"> 
	<xsl:choose>
         <xsl:when test = "$ALIAS != ''">
          <xsl:value-of select="alias"/>
 	 </xsl:when>
	 <xsl:otherwise>
          <xsl:value-of select="ip_dn"/>
	 </xsl:otherwise>
	</xsl:choose>
	
	<span id="SPAN_{$HOST_ID}" alias="{$ALIAS}" proto="{$PROTO}" cgi="{$CGI}">+</span>
      </li> 
      <div class = "submenu_{$STYLE}" id="{$HOST_ID}"/>
    </xsl:for-each>
   </ul> 
</xsl:template> 
</xsl:stylesheet>
