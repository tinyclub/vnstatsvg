<?xml version= "1.0" encoding = "UTF-8" standalone = 'no' ?>
<xsl:stylesheet version = "1.0" xmlns:xsl = "http://www.w3.org/1999/XSL/Transform"> 
<xsl:template match="/">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>vnStat - SVG frontend</title>
    <script src="vnstat.js"></script>
    <link rel="stylesheet" type="text/css" href="vnstat.css" />
  </head>
<body onload="showSidebar()">

<div id="content">
  <div id="sidebar">
  </div>

  <div id="header"><xsl:value-of select="project/header"/><span id="status"></span> </div>
  <div id="caption"></div>
  <div id="main_wrapper">
	<pre><xsl:value-of select="project/description"/></pre>
  </div>
  <div id="footer">
    <xsl:variable name = "HOMEPAGE" select = "project/homepage"/>
    <xsl:variable name = "WEBSITE" select = "project/copyright/website"/>
    <a href="{$HOMEPAGE}"><xsl:value-of select="project/name"/></a> <xsl:value-of select="project/version"/> - ©<xsl:value-of select="project/copyright/year"/> <xsl:value-of select="project/copyright/author"/><xsl:value-of select="project/copyright/email"/> of <a href="{$WEBSITE}"><xsl:value-of select="project/copyright/institution"/></a> 
  </div>
</div>

</body>
</html>
</xsl:template> 
</xsl:stylesheet>
