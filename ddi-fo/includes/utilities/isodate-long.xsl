<?xml version='1.0' encoding='utf-8'?>

<!-- isodate_long.xsl -->

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

  <!-- ============================== -->
  <!-- isodate-long(isodate)          -->
  <!-- string                         -->
  <!--                                -->
  <!-- converts an ISO date string to -->
  <!-- a "prettier" format            -->
  <!-- ============================== -->

  <!--
    params:
    ($isodate)

    global vars read:
    $language-code

    local vars set:
    $month

    XPath 1.0 functions called:
    number(), substring(), contains()

    templates called:
    [isodate-month]
  -->

  <xsl:template name="isodate-long">

    <!-- ========== -->
    <!-- Parameters -->
    <!-- ========== -->
    <xsl:param name="isodate" select=" '2005-12-31' "/>

    <!-- ========= -->
    <!-- Variables -->
    <!-- ========= -->

    <!-- determine name of month in date string -->
    <xsl:variable name="month">
      <xsl:call-template name="isodate-month">
        <xsl:with-param name="isodate" select="$report-date"/>
      </xsl:call-template>
    </xsl:variable>

    <!-- ============================== -->
    <!-- Return date in relevant format -->
    <!-- ============================== -->
    <xsl:choose>

      <!-- european format -->
      <xsl:when test="contains('fr es',$language-code)">
        <xsl:value-of select="number(substring($isodate,9,2))"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$month"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="substring($isodate,1,4)"/>
      </xsl:when>

      <!-- japanese format -->
      <xsl:when test="contains('ja',$language-code)">
        <xsl:value-of select="$isodate"/>
      </xsl:when>

      <!-- english format -->
      <xsl:otherwise>
        <xsl:value-of select="$month"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="number(substring($isodate,9,2))"/>
        <xsl:text>, </xsl:text>
        <xsl:value-of select="substring($isodate,1,4)"/>
      </xsl:otherwise>

    </xsl:choose>

  </xsl:template>
</xsl:stylesheet>
