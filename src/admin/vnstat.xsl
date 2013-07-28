<?xml version= "1.0" encoding = "UTF-8" standalone = 'no' ?>
<xsl:stylesheet version = "1.0" xmlns:xsl = "http://www.w3.org/1999/XSL/Transform"> 

<!-- build the units "Array", which will be used with the key() function later --> 
<xsl:key name = "units" match = "traffic/us/u" use = "@id"/>
<xsl:template match="/">

<!-- get the page type: summary, hour, day, month, top10  --> 
<xsl:variable name = "TYPE" select = "traffic/@p"/>

<div>

<!-- if page is not summary, draw the picture, otherwise, just output the info in a table --> 
<xsl:if test = "$TYPE != 'summary' and $TYPE != 'second'">
<div id = 'main'> 

<!-- set the size of Height(H), Width(W), Left(L), Top(T), Bottom(B), Right(R), Row(HR), the width of rect(RW)--> 
  <xsl:variable name = "L" select = "45"/>
  <xsl:variable name = "B" select = "45"/>
  <xsl:variable name = "R" select = "20"/>
  <xsl:variable name = "T" select = "20"/>
  <xsl:variable name = "H" select = "280"/>
  <xsl:variable name = "W" select = "648"/>
  <xsl:variable name = "HR" select = "10"/>

  <!-- get the columns(VC) -->
  <xsl:variable name = "VC" select = "traffic/@colnum"/>

  <!-- draw the svg picture -->
  <svg xmlns = "http://www.w3.org/2000/svg" xmlns:xlink = "http://www.w3.org/1999/xlink" xml:space = "preserve" width = "{$W}" height = "{$H}" viewBox = "0 0 {$W} {$H}"> 
  <g class="gra0">

    <!-- get the size and unit of the max flow --> 
    <xsl:variable name = "MAX" select = "ceiling(traffic/mf/s)"/>
    <xsl:variable name = "MAX_UNIT" select = "key('units',traffic/mf/u)/@val"/>

    <!-- draw a rectangle as the background -->
    <rect class="fil0 str0" x = "0" y = "0" width = "100%" height = "100%"/>

    <!-- draw two arrows as x axis and y axis --> 
    <line class="str0" x1 = "{$L}" y1 = "{$H -$B}" x2 = "{$W -$R}" y2 = "{$H -$B}"/>
    <line class="str0" x1 = "{$L}" y1 = "{$H -$B}" x2 = "{$L}" y2 = "{$T}"/>

    <!-- draw y label & x label --> 
    <text class="anc0 fnt0" x = "{$W - $R}" y = "{$H - $T +5}">time / <xsl:value-of select = "$TYPE"/></text>    
    <text class="anc1 fnt0" x = "{$L}" y = "{$T -5}">traffic / <xsl:value-of select = "key('units',traffic/mf/u)/@sym"/></text> 

    <!-- draw the flag of Receive and Transmit -->
    <rect class="fil2" x = "{$L}" y = "{$H -$B +25}" width = "10" height = "10"/>
    <text class="fnt0" x = "{$L +15}" y = "{$H -$B +35}"> Receive </text> 
    <rect class="fil1" x = "{$L +100}" y = "{$H -$B +25}" width = "10" height = "10"/>
    <text class="fnt0" x = "{$L +115}" y = "{$H -$B +35}"> Transmit </text> 

    <!-- draw the rectangle for showing the flows(receive, transmit) -->
    <!-- get the stepping of x axis --> 
    <xsl:variable name = "Xstep" select = "($W -$L -$R) div $VC"/>

    <!-- traversal all of the r(row) nodes -->
    <xsl:for-each select = "traffic/r"> 

      <!-- calculate current X position, the Y position here is default as $H-$B+14 -->
      <xsl:variable name = "X" select = "(position()-1)*$Xstep +$L"/>

      <!-- get current X value(the x attribute in r node) and draw it in X position -->
      <text class="anc1 fnt1" x = "{$X +$Xstep div 2}" y = "{$H -$B +14}">
        <xsl:value-of select = "@x"/>
      </text> 

      <!-- draw the rectangle for reflecting the SIZE of received and transmited bytes(the following 3 means we not draw the total bytes) -->
      <xsl:for-each select = "f[position() &lt; 3 ]"> 

        <!-- get the size and unit of every flow, and translate it to the HEIGHT of the rectangle, here we used the units Array -->
        <xsl:variable name = "UNIT" select = "key('units',u)/@val"/>
        <xsl:variable name = "SIZE" select = "s*($UNIT div $MAX_UNIT)"/>
        <xsl:variable name = "HEIGHT" select = "$SIZE*($H -$T -$B) div $MAX"/>

        <!-- calculate the Y position of the rectangle -->
        <xsl:variable name = "Y" select = "$H -$HEIGHT -$B"/>

        <!-- set different colors for the renctangle of RECEIVE and TRANSMIT flow -->
        <xsl:variable name = "IND" select = "position() mod 2 +1"/>

        <!-- the X postion for TRANSMIT flow is $Xstep div 2 than the position of RECEIVE flow, the same as the width of the rectangle -->
        <rect class="fil{$IND}" x = "{$X +($Xstep*(position()-1) div 2)}" y = "{$Y}" width = "{$Xstep div 2}" height = "{$HEIGHT}"/>
      </xsl:for-each>
    </xsl:for-each>

    <!-- get the stepping of Y axis and the basic value of Y axis -->
    <xsl:variable name = "Ystep" select = "($H -$T -$B) div $HR"/>
    <xsl:variable name = "Yvalue" select = "$MAX div $HR"/>

    <!-- draw the GRID of the svg picture, including lines from X direction and Y direction -->
    <xsl:for-each select = "//*[position() &lt; $HR ]"> 
      <xsl:if test = "position() != ($HR+1)"> 

        <!-- draw the lines from Y direction -->
        <line class="str1" x1 = "{$L}" y1 = "{$H -$B -position()*$Ystep}" x2 = "{$W -$R}" y2 = "{$H -$B -position()*$Ystep}"/>
        <xsl:variable name = "y" select = "substring(position()*$Yvalue, 1, 3)"/>
        <xsl:variable name = "y_last" select = "substring(position()*$Yvalue, 4, 1)"/>
	
        <!-- draw the value of Y axis, calculated by the basic "Yvalue" -->
	<xsl:if test="$y_last != '.'">
            <text class="anc1 fnt1" x = "{$L div 2}" y = "{$H -$B + 10 -position()*$Ystep}"><xsl:value-of select="concat($y, $y_last)"/></text>
	</xsl:if>
	<xsl:if test="$y_last = '.'">
            <text class="anc1 fnt1" x = "{$L div 2}" y = "{$H -$B + 10 -position()*$Ystep}"><xsl:value-of select="$y"/></text>
	</xsl:if>
      </xsl:if>

      <!-- draw the line from X direction -->
      <xsl:if test = "position() != ($VC+1)">
        <line class="str2" x1 = "{$L +position()*$Xstep}" y1 = "{$H -$B}" x2 = "{$L +position()*$Xstep}" y2 = "{$T}"/>
      </xsl:if>
    </xsl:for-each>
  </g>
  </svg>
</div> 
</xsl:if>

<!-- print the table from the XML info -->
<div id = "main"> 
  <table width = "650" cellspacing = "0"> 
    <tbody>

      <!-- draw the header of the table --> 
      <tr> 
        <th class = "label" style = "width: 120px;"></th> 
        <th class = "label" style = "width: 174px;"> Receive </th> 
        <th class = "label" style = "width: 174px;"> Transmit </th> 
        <th class = "label" style = "width: 174px;"> Total </th> 
      </tr> 
     <xsl:for-each select = "traffic/r"> 
       <tr> 
         <xsl:variable name = "FLAG" select = "(position() mod 2)"/>
         <xsl:variable name = "START" select = "$FLAG*3+1"/>
         <xsl:variable name = "END" select = "$START+2+$FLAG"/>
         <xsl:variable name = "STYLE" select = "substring('oddeven',$START,$END)"/>

         <!-- get the value of the first column and print it -->
         <td class = "label_{$STYLE}">
           <xsl:value-of select = "@f1"/>
         </td> 
         <xsl:for-each select = "f"> 

         <!-- get the size and unit of every flow, and print them, here we used the units Array -->
           <td class = "numeric_{$STYLE}"> 
             <xsl:value-of select = "s"/>
             <xsl:value-of select = "key('units',u)/@sym"/>
           </td> 
         </xsl:for-each>
      </tr> 
     </xsl:for-each>
    </tbody> 
  </table> 
</div> 

</div>

</xsl:template> 
</xsl:stylesheet>
