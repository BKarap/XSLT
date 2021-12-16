<?xml version="1.0"?> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
								xmlns="http://www.w3.org/2000/svg"
								xmlns:xlink="http://www.w3.org/1999/xlink" version="1.0">

	<xsl:output method="html" indent="yes" version="4.0"/>
	<xsl:variable name="lower" select="'abcdefghijklmnopqrstuvwxyz'"/> 
	<xsl:variable name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
	<xsl:template match="/">
		<html><head><title>Статистика</title></head>
			<body>
				<table border="0" align="center">		
					<tr>
						<td><b>Статистика по типам событий</b></td>
						<td><b>Статистика по уровню событий</b></td>
					</tr>
					<tr>
						<td>
									<xsl:call-template name="drawCategories"/>
						</td>
						<td>
								<xsl:call-template name="drawSeveritie"/>
						</td>
					</tr>
				</table>
			</body>
		</html>
	</xsl:template>
	<xsl:template name="drawCategories">
		<svg width="380pt" height="200pt" version="1.1" style="font-family: Times New Roman; stroke: none;">
					<xsl:call-template name="draw-all">
						<xsl:with-param name="fontS" select="12"/>
						<xsl:with-param name="r" select="90"/>
						<xsl:with-param name="values" select="//TotalCategory/Total"/>
						<xsl:with-param name="labels" select="//TotalCategory/category"/>
					</xsl:call-template>		
		</svg>
	</xsl:template>
	<xsl:template name="drawSeveritie">
		<svg width="380pt" height="200pt" version="1.1" style="font-family: Times New Roman; stroke: none; font-size: 10px;">
					<xsl:call-template name="draw-all">
						<xsl:with-param name="fontS" select="12"/>
						<xsl:with-param name="r" select="90"/>
						<xsl:with-param name="values" select="//TotalSeverity/Total"/>
						<xsl:with-param name="labels" select="//TotalSeverity/severity"/>
					</xsl:call-template>		
		</svg>
	</xsl:template>
	
<!-- ======== svg-templates -->
	<xsl:template name="draw-all">
		<xsl:param name="labels"/>
		<xsl:param name="tLnght" select="20"/>
		<xsl:param name="values"/>
		<xsl:param name="total" select="sum($values)"/>
		<xsl:param name="ind" select="1"/>
		<xsl:param name="r"/>
		<xsl:param name="fontS" select="12"/>
		<xsl:param name="textL" select="20"/>
		<xsl:param name="fontCorr" select="0.2 * $fontS"/>
		<xsl:param name="startA" select="0"/><!-- accumulate alredy drawed fragments -->
		<xsl:param name="startX" select="0"/><!-- 12 o'cljck (0,R) in begining -->
		<xsl:param name="startY" select="$r"/>
		
		<xsl:param name="valueRel" select="$values[$ind] div $total"/> <!-- reletional value -->
		<xsl:param name="col">
			<xsl:call-template name="color_pick"><xsl:with-param name="ind" select="$ind"/></xsl:call-template>
		</xsl:param>
		<xsl:param name="space" select="$r*0.5"/> <!-- Adding some spases around of pie-->
		<xsl:param name="center" select="$r + $space"/>
		<!-- startP, endP is attributes in ready-for-use format -->
		<!-- draw pie -->
		<xsl:param name="ang"  select="360 * $valueRel"/>
		<xsl:param name="sinCurr">
			<xsl:call-template name="sin"><xsl:with-param name="pX" select="$ang"/></xsl:call-template>
		</xsl:param>
		<xsl:param name="cosCurr">
			<xsl:call-template name="cos"><xsl:with-param name="pX" select="$ang"/></xsl:call-template>
		</xsl:param>
		<xsl:param name="big">
			<xsl:choose>
				<xsl:when test="$ang &gt; 180"><xsl:value-of select="1"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="0"/></xsl:otherwise>
			</xsl:choose>
		</xsl:param>
		
		<g transform="translate({$r+5},{$r+5})">
			<path fill="{$col}" stroke="black" stroke-width="0.5" transform="rotate({$startA})"
			d="M0,0 v{-$r} a{$r},{$r} 0 {$big} 1 {$r * $sinCurr},{$r - $r * $cosCurr} z" />
<!--		<xsl:if test="not($values[$ind + 1])">
			<circle cx="0" cy="0" r="{$r}" stroke="black" stroke-width="1" fill="none"/> 
		</xsl:if> -->
		</g>
		<!-- draw bar-legend -->
		<!-- right-alligned to X=$AREA - $textL - $FONT-SIZE point -->
			<rect x="{2 * $center - $textL - $fontS - $fontCorr * $valueRel * 100}" 
								y="{1.5  * $ind * $fontS - $fontS}" 
								width="{$fontCorr * $valueRel * 100}" 
								height="{$fontS * 1.2}" fill="{$col}" stroke="black"/>
			<text x="{2 * $center - $textL}" y="{$ind * $fontS * 1.5}" style="font-size: {$fontS}; font-family: Times New Roman;">
				<xsl:call-template name="rus-label">
					<xsl:with-param name="l" select="$labels[$ind]"/>
				</xsl:call-template>
				<xsl:value-of select="concat(' - ',$values[$ind],' (',round($valueRel * 100),'%)')"/>				
			</text>

		<xsl:if test="$values[$ind + 1]">
			<xsl:call-template name="draw-all">
				<xsl:with-param name="ind" select="$ind+1"/>
				<xsl:with-param name="fontS" select="$fontS"/>
				<xsl:with-param name="r" select="$r"/>
				<xsl:with-param name="labels" select="$labels"/>
				<xsl:with-param name="values" select="$values"/>
				<xsl:with-param name="total" select="$total"/>
				<xsl:with-param name="startA" select="$startA + $ang"/>
				<xsl:with-param name="startX" select="$r * $sinCurr"/>
				<xsl:with-param name="startY" select="$r * $cosCurr"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="not($values[$ind + 1])">
		<g transform="translate({$r+5},{$r+5})">
			<circle cx="0" cy="0" r="6" stroke="black" fill="white"/> <!-- marked center of pie -->
		</g>
		</xsl:if>
	</xsl:template>
<!-- (240, 128, 128) (240, 230, 140) (240, 248, 255) (240, 255, 240) (240, 230, 140) 
			-->	

		<xsl:template name="color_pick">
		<xsl:param name="ind"/>
		<xsl:param name="clr" select="'000000FF0C99BC8F8FCC3300CCCCC0F02B3B9FA3BBA30F99FFA80FFF668FCCFFCC33CCC0FFFF00'"/>
																<!--     1     2     3     4     5     6     7     8     9     10    11    12    -->
		<xsl:variable name="c" select="substring('AAF0D0B09070503010E0C0A08060402000A',$ind *2 +1,2)"/>
		<xsl:variable name="cc" select="substring('AAF0D0B09070503010E0C0A08060402000',$ind *2 + 5,2)"/>
<!--		<xsl:value-of select="concat('#',substring($clr,$ind * 6, 6))"/> -->
		<xsl:choose>
			<xsl:when test="($ind mod 3) = 0">
				<xsl:value-of select="concat('#','F0',$c,$cc)"/>
			</xsl:when>
			<xsl:when test="($ind mod 3) = 1">
				<xsl:value-of select="concat('#',$c,'F0',$cc)"/>
			</xsl:when>
			<xsl:when test="($ind mod 3) = 2">
				<xsl:value-of select="concat('#',$c,$cc,'F0')"/>
			</xsl:when>
		</xsl:choose>
		</xsl:template>
		
	<!-- ========= -->
	<xsl:template name="sin">
		<xsl:param name="pX"/>
		<xsl:variable name="sign"> <!-- Sin(-X) == -Sin(X), see <xsl:value-of select="$sign * $val"> -->
			<xsl:choose>
				<xsl:when test="(0 &lt;= $pX and $pX &lt; 180) or $pX &gt;= 360"> <!-- last case for cos template -->
					<xsl:value-of select="1"/> 
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="- 1"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="normA"><!-- reduction to 0 .. 90 interval -->
			<xsl:choose> <!-- simple math -->
				<xsl:when test="0 &lt;= $pX and $pX &lt; 90">  <xsl:value-of select="$pX"/></xsl:when>
				<xsl:when test="90 &lt;= $pX and $pX &lt; 180"><xsl:value-of select="180 - $pX"/></xsl:when>
				<xsl:when test="180 &lt;= $pX and $pX &lt; 270"><xsl:value-of select="$pX - 180"/></xsl:when>
				<xsl:when test="270 &lt;= $pX and $pX &lt; 360"><xsl:value-of select="360 - $pX"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$pX - 360"/></xsl:otherwise>
			</xsl:choose>   
		</xsl:variable>
		<xsl:variable name="val">
			<xsl:call-template name="sinValue">
				<xsl:with-param name="a" select="$normA"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="$sign * $val"/> 
	</xsl:template> 
	<!--==========================================================================
		Template: cos
		 Purpose: Return the cosine of X
	Parameters: $pX - the angle in degrees  
	========================================================================== -->
	<xsl:template name="cos">
		<xsl:param name="pX"/>
		<xsl:call-template name="sin">
			<xsl:with-param name="pX" select="$pX+90"/>
		</xsl:call-template>
	</xsl:template>
	<!--  =========================================================--> 
	<!--  Called template for calculating colors                    --> 
	<!--  this is a crude way of giving each segment a different    --> 
	<!--  color - calculated according to a relative position       --> 

	<xsl:template name="sinValue">
		<xsl:param name="a"/>
		<xsl:choose>	
<xsl:when test="$a &lt;= 1"><xsl:value-of select="0.017452406"/></xsl:when>
<xsl:when test="$a &lt;= 2"><xsl:value-of select="0.034899497"/></xsl:when>
<xsl:when test="$a &lt;= 3"><xsl:value-of select="0.052335956"/></xsl:when>
<xsl:when test="$a &lt;= 4"><xsl:value-of select="0.069756474"/></xsl:when>
<xsl:when test="$a &lt;= 5"><xsl:value-of select="0.087155743"/></xsl:when>
<xsl:when test="$a &lt;= 6"><xsl:value-of select="0.104528463"/></xsl:when>
<xsl:when test="$a &lt;= 7"><xsl:value-of select="0.121869343"/></xsl:when>
<xsl:when test="$a &lt;= 8"><xsl:value-of select="0.139173101"/></xsl:when>
<xsl:when test="$a &lt;= 9"><xsl:value-of select="0.156434465"/></xsl:when>
<xsl:when test="$a &lt;= 10"><xsl:value-of select="0.173648178"/></xsl:when>
<xsl:when test="$a &lt;= 11"><xsl:value-of select="0.190808995"/></xsl:when>
<xsl:when test="$a &lt;= 12"><xsl:value-of select="0.207911691"/></xsl:when>
<xsl:when test="$a &lt;= 13"><xsl:value-of select="0.224951054"/></xsl:when>
<xsl:when test="$a &lt;= 14"><xsl:value-of select="0.241921896"/></xsl:when>
<xsl:when test="$a &lt;= 15"><xsl:value-of select="0.258819045"/></xsl:when>
<xsl:when test="$a &lt;= 16"><xsl:value-of select="0.275637356"/></xsl:when>
<xsl:when test="$a &lt;= 17"><xsl:value-of select="0.292371705"/></xsl:when>
<xsl:when test="$a &lt;= 18"><xsl:value-of select="0.309016994"/></xsl:when>
<xsl:when test="$a &lt;= 19"><xsl:value-of select="0.325568154"/></xsl:when>
<xsl:when test="$a &lt;= 20"><xsl:value-of select="0.342020143"/></xsl:when>
<xsl:when test="$a &lt;= 21"><xsl:value-of select="0.35836795"/></xsl:when>
<xsl:when test="$a &lt;= 22"><xsl:value-of select="0.374606593"/></xsl:when>
<xsl:when test="$a &lt;= 23"><xsl:value-of select="0.390731128"/></xsl:when>
<xsl:when test="$a &lt;= 24"><xsl:value-of select="0.406736643"/></xsl:when>
<xsl:when test="$a &lt;= 25"><xsl:value-of select="0.422618262"/></xsl:when>
<xsl:when test="$a &lt;= 26"><xsl:value-of select="0.438371147"/></xsl:when>
<xsl:when test="$a &lt;= 27"><xsl:value-of select="0.4539905"/></xsl:when>
<xsl:when test="$a &lt;= 28"><xsl:value-of select="0.469471563"/></xsl:when>
<xsl:when test="$a &lt;= 29"><xsl:value-of select="0.48480962"/></xsl:when>
<xsl:when test="$a &lt;= 30"><xsl:value-of select="0.5"/></xsl:when>
<xsl:when test="$a &lt;= 31"><xsl:value-of select="0.515038075"/></xsl:when>
<xsl:when test="$a &lt;= 32"><xsl:value-of select="0.529919264"/></xsl:when>
<xsl:when test="$a &lt;= 33"><xsl:value-of select="0.544639035"/></xsl:when>
<xsl:when test="$a &lt;= 34"><xsl:value-of select="0.559192903"/></xsl:when>
<xsl:when test="$a &lt;= 35"><xsl:value-of select="0.573576436"/></xsl:when>
<xsl:when test="$a &lt;= 36"><xsl:value-of select="0.587785252"/></xsl:when>
<xsl:when test="$a &lt;= 37"><xsl:value-of select="0.601815023"/></xsl:when>
<xsl:when test="$a &lt;= 38"><xsl:value-of select="0.615661475"/></xsl:when>
<xsl:when test="$a &lt;= 39"><xsl:value-of select="0.629320391"/></xsl:when>
<xsl:when test="$a &lt;= 40"><xsl:value-of select="0.64278761"/></xsl:when>
<xsl:when test="$a &lt;= 41"><xsl:value-of select="0.656059029"/></xsl:when>
<xsl:when test="$a &lt;= 42"><xsl:value-of select="0.669130606"/></xsl:when>
<xsl:when test="$a &lt;= 43"><xsl:value-of select="0.68199836"/></xsl:when>
<xsl:when test="$a &lt;= 44"><xsl:value-of select="0.69465837"/></xsl:when>
<xsl:when test="$a &lt;= 45"><xsl:value-of select="0.707106781"/></xsl:when>
<xsl:when test="$a &lt;= 46"><xsl:value-of select="0.7193398"/></xsl:when>
<xsl:when test="$a &lt;= 47"><xsl:value-of select="0.731353702"/></xsl:when>
<xsl:when test="$a &lt;= 48"><xsl:value-of select="0.743144825"/></xsl:when>
<xsl:when test="$a &lt;= 49"><xsl:value-of select="0.75470958"/></xsl:when>
<xsl:when test="$a &lt;= 50"><xsl:value-of select="0.766044443"/></xsl:when>
<xsl:when test="$a &lt;= 51"><xsl:value-of select="0.777145961"/></xsl:when>
<xsl:when test="$a &lt;= 52"><xsl:value-of select="0.788010754"/></xsl:when>
<xsl:when test="$a &lt;= 53"><xsl:value-of select="0.79863551"/></xsl:when>
<xsl:when test="$a &lt;= 54"><xsl:value-of select="0.809016994"/></xsl:when>
<xsl:when test="$a &lt;= 55"><xsl:value-of select="0.819152044"/></xsl:when>
<xsl:when test="$a &lt;= 56"><xsl:value-of select="0.829037573"/></xsl:when>
<xsl:when test="$a &lt;= 57"><xsl:value-of select="0.838670568"/></xsl:when>
<xsl:when test="$a &lt;= 58"><xsl:value-of select="0.848048096"/></xsl:when>
<xsl:when test="$a &lt;= 59"><xsl:value-of select="0.857167301"/></xsl:when>
<xsl:when test="$a &lt;= 60"><xsl:value-of select="0.866025404"/></xsl:when>
<xsl:when test="$a &lt;= 61"><xsl:value-of select="0.874619707"/></xsl:when>
<xsl:when test="$a &lt;= 62"><xsl:value-of select="0.882947593"/></xsl:when>
<xsl:when test="$a &lt;= 63"><xsl:value-of select="0.891006524"/></xsl:when>
<xsl:when test="$a &lt;= 64"><xsl:value-of select="0.898794046"/></xsl:when>
<xsl:when test="$a &lt;= 65"><xsl:value-of select="0.906307787"/></xsl:when>
<xsl:when test="$a &lt;= 66"><xsl:value-of select="0.913545458"/></xsl:when>
<xsl:when test="$a &lt;= 67"><xsl:value-of select="0.920504853"/></xsl:when>
<xsl:when test="$a &lt;= 68"><xsl:value-of select="0.927183855"/></xsl:when>
<xsl:when test="$a &lt;= 69"><xsl:value-of select="0.933580426"/></xsl:when>
<xsl:when test="$a &lt;= 70"><xsl:value-of select="0.939692621"/></xsl:when>
<xsl:when test="$a &lt;= 71"><xsl:value-of select="0.945518576"/></xsl:when>
<xsl:when test="$a &lt;= 72"><xsl:value-of select="0.951056516"/></xsl:when>
<xsl:when test="$a &lt;= 73"><xsl:value-of select="0.956304756"/></xsl:when>
<xsl:when test="$a &lt;= 74"><xsl:value-of select="0.961261696"/></xsl:when>
<xsl:when test="$a &lt;= 75"><xsl:value-of select="0.965925826"/></xsl:when>
<xsl:when test="$a &lt;= 76"><xsl:value-of select="0.970295726"/></xsl:when>
<xsl:when test="$a &lt;= 77"><xsl:value-of select="0.974370065"/></xsl:when>
<xsl:when test="$a &lt;= 78"><xsl:value-of select="0.978147601"/></xsl:when>
<xsl:when test="$a &lt;= 79"><xsl:value-of select="0.981627183"/></xsl:when>
<xsl:when test="$a &lt;= 80"><xsl:value-of select="0.984807753"/></xsl:when>
<xsl:when test="$a &lt;= 81"><xsl:value-of select="0.987688341"/></xsl:when>
<xsl:when test="$a &lt;= 82"><xsl:value-of select="0.990268069"/></xsl:when>
<xsl:when test="$a &lt;= 83"><xsl:value-of select="0.992546152"/></xsl:when>
<xsl:when test="$a &lt;= 84"><xsl:value-of select="0.994521895"/></xsl:when>
<xsl:when test="$a &lt;= 85"><xsl:value-of select="0.996194698"/></xsl:when>
<xsl:when test="$a &lt;= 86"><xsl:value-of select="0.99756405"/></xsl:when>
<xsl:when test="$a &lt;= 87"><xsl:value-of select="0.998629535"/></xsl:when>
<xsl:when test="$a &lt;= 88"><xsl:value-of select="0.999390827"/></xsl:when>
<xsl:when test="$a &lt;= 89"><xsl:value-of select="0.999847695"/></xsl:when>
			<xsl:otherwise><!-- xsl:when test="87 &lt; $a and $a &lt;= 90" -->
			<xsl:value-of select="1"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	
	<!-- ========= -->
	<xsl:template name="rus-label">
		<xsl:param name="l"/>
		<xsl:param name="tl" select="translate($l,$lower,$upper)"/>
		<xsl:choose>
			<xsl:when test="$tl = 'ENV'"><xsl:value-of select="'Экологические'"/></xsl:when>
			<xsl:when test="$tl = 'FIRE'"><xsl:value-of select="'Пожары'"/></xsl:when>
			<xsl:when test="$tl = 'HEALTH' or $tl = 'HELTH'"><xsl:value-of select="'Здравоохранение'"/></xsl:when>
			<xsl:when test="$tl = 'GEO'"><xsl:value-of select="' Геофизические'"/></xsl:when>
			<xsl:when test="$tl = 'MET'"><xsl:value-of select="'Метеорологические'"/></xsl:when>
			<xsl:when test="$tl = 'SAFETY'"><xsl:value-of select="'Безопасность'"/></xsl:when>
			<xsl:when test="$tl = 'SECURITY'"><xsl:value-of select="'Правоохранительные'"/></xsl:when>
			<xsl:when test="$tl = 'RESCUE'"><xsl:value-of select="'Спасательно-восстановительные'"/></xsl:when>
			<xsl:when test="$tl = 'TRANSPORT'"><xsl:value-of select="'Транспортные'"/></xsl:when>
			<xsl:when test="$tl = 'INFRA'"><xsl:value-of select="'Инфраструктурные'"/></xsl:when>
			<xsl:when test="$tl = 'CBRNE'"><xsl:value-of select="'БиоХимЯдерные аварии'"/></xsl:when>
			<xsl:when test="$tl = 'OTHER'"><xsl:value-of select="'Прочие'"/></xsl:when>
			
			<xsl:when test="$tl = 'EXTREME'"><xsl:value-of select="'Чрезвычайные'"/></xsl:when>
			<xsl:when test="$tl = 'SEVERE'"><xsl:value-of select="'Существенные'"/></xsl:when>
			<xsl:when test="$tl = 'MODERATE'"><xsl:value-of select="'Неущественные'"/></xsl:when>
			<xsl:when test="$tl = 'MINOR'"><xsl:value-of select="'Малозначимые'"/></xsl:when>
			<xsl:when test="$tl = 'UNKNOWN'"><xsl:value-of select="'Неопределенные'"/></xsl:when>
			
			<xsl:when test="$tl = 'ACTUAL'"><xsl:value-of select="'Актуальное'"/></xsl:when>
			<xsl:when test="$tl = 'EXERCISE'"><xsl:value-of select="'Учебное'"/></xsl:when>
			<xsl:when test="$tl = 'SYSTEM'"><xsl:value-of select="'Системное'"/></xsl:when>
			<xsl:when test="$tl = 'TEST'"><xsl:value-of select="'Тестовое'"/></xsl:when>
			<xsl:when test="$tl = 'DRAFT'"><xsl:value-of select="'Предварительное'"/></xsl:when>
			
			<xsl:when test="$tl = 'ALERT'"><xsl:value-of select="'Предупреждение'"/></xsl:when>
			<xsl:when test="$tl = 'UPDATE'"><xsl:value-of select="'Обновление'"/></xsl:when>
			<xsl:when test="$tl = 'CANCEL'"><xsl:value-of select="'Отмена'"/></xsl:when>
			<xsl:when test="$tl = 'ACK'"><xsl:value-of select="'Подтверждение'"/></xsl:when>
			<xsl:when test="$tl = 'ERROR'"><xsl:value-of select="'Ошибочное'"/></xsl:when>
			<xsl:otherwise> <xsl:value-of select="$l"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ========= -->
</xsl:stylesheet>

