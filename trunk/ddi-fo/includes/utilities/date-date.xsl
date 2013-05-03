<?xml version='1.0' encoding='utf-8'?>

<!-- date-date.xsl -->

<xsl:stylesheet xmlns:n1="http://www.icpsr.umich.edu/DDI"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:ddi="http://www.icpsr.umich.edu/DDI"
                xmlns:date="http://exslt.org/dates-and-times"
                xmlns:dcterms="http://purl.org/dc/terms/"
                xmlns:exsl="http://exslt.org/common"
                xmlns:math="http://exslt.org/math"
                xmlns:str="http://exslt.org/strings"
                xmlns:doc="http://www.icpsr.umich.edu/doc"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:xdt="http://www.w3.org/2005/xpath-datatypes"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                version="1.0"
                extension-element-prefixes="date exsl str">
    
  <xsl:output version="1.0" encoding="UTF-8" indent="no"
              omit-xml-declaration="no" media-type="text/html"/>

  <!-- ============================================= -->
  <!-- date:date(date-time)                          -->
  <!-- string                                        -->
  <!--                                               -->
  <!-- Uses an EXSLT extension to determine the date -->
  <!-- ============================================= -->

  <!--
    params:
    ($date-time)

    global vars read:
    $date:date-time

    local vars set:
    $neg, $dt-no-neg, $dt-no-neg-length, $timezone,
    $tz, $date, $dt-length, $dt

    XPath 1.0 functions called:
    substring(), starts-with(), not(), string(), number()

    XSLT functions called:
    function-available(), date:date-time()
  -->


  <xsl:template name="date:date">

    <!-- ========== -->
    <!-- Parameters -->
    <!-- ========== -->
    <xsl:param name="date-time">
      <xsl:choose>
        <xsl:when test="function-available('date:date-time')">
          <xsl:value-of select="date:date-time()"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$date:date-time"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:param>

    <!-- ========= -->
    <!-- Variables -->
    <!-- ========= -->
    <xsl:variable name="neg" select="starts-with($date-time, '-')"/>

    <xsl:variable name="dt-no-neg">
      <xsl:choose>
        <xsl:when test="$neg or starts-with($date-time, '+')">
          <xsl:value-of select="substring($date-time, 2)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$date-time"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="dt-no-neg-length" select="string-length($dt-no-neg)"/>

    <xsl:variable name="timezone">
      <xsl:choose>
        <xsl:when test="substring($dt-no-neg, $dt-no-neg-length) = 'Z'">Z</xsl:when>
        <xsl:otherwise>
          <xsl:variable name="tz" select="substring($dt-no-neg, $dt-no-neg-length - 5)"/>
          <xsl:if test="(substring($tz, 1, 1) = '-' or       substring($tz, 1, 1) = '+') and       substring($tz, 4, 1) = ':'">
            <xsl:value-of select="$tz"/>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="date">
      <xsl:if test="not(string($timezone)) or     $timezone = 'Z' or     (substring($timezone, 2, 2) &lt;= 23 and     substring($timezone, 5, 2) &lt;= 59)">
        <xsl:variable name="dt" select="substring($dt-no-neg, 1, $dt-no-neg-length - string-length($timezone))"/>
        <xsl:variable name="dt-length" select="string-length($dt)"/>
        <xsl:if test="number(substring($dt, 1, 4)) and      substring($dt, 5, 1) = '-' and      substring($dt, 6, 2) &lt;= 12 and      substring($dt, 8, 1) = '-' and      substring($dt, 9, 2) &lt;= 31 and      ($dt-length = 10 or      (substring($dt, 11, 1) = 'T' and      substring($dt, 12, 2) &lt;= 23 and      substring($dt, 14, 1) = ':' and      substring($dt, 15, 2) &lt;= 59 and      substring($dt, 17, 1) = ':' and      substring($dt, 18) &lt;= 60))">
          <xsl:value-of select="substring($dt, 1, 10)"/>
        </xsl:if>
      </xsl:if>
    </xsl:variable>

    <!-- ============= -->
    <!-- Return result -->
    <!-- ============= -->
    <xsl:if test="string($date)">
      <xsl:if test="$neg">-</xsl:if>
      <xsl:value-of select="$date"/>
      <xsl:value-of select="$timezone"/>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>