<?xml version='1.0' encoding='utf-8'?>

<!-- isodate.xsl -->

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

  <!-- ====================== -->
  <!--	 isodate-month(isodate) -->
  <!-- string                 -->
  <!-- ====================== -->

  <!--
    params:
    ($isodate)

    global vars read:
    $msg

    local vars set:
    $month

    functions used:
    number(), substring()
  -->

  <xsl:template name="isodate-month">

    <!-- ========== -->
    <!-- Parameters -->
    <!-- ========== -->
    <xsl:param name="isodate" select=" '2005-12-31' "/>

    <!-- ========= -->
    <!-- Variables -->
    <!-- ========= -->
    <xsl:variable name="month" select="number(substring($isodate,6,2))"/>

    <!-- ================================== -->
    <!-- r) [-] Main - Determine month name -->
    <!-- ================================== -->
    <xsl:choose>

      <xsl:when test="$month=1">
        <xsl:value-of select="$msg/*/entry[@key='January']"/>
      </xsl:when>

      <xsl:when test="$month=2">
        <xsl:value-of select="$msg/*/entry[@key='February']"/>
      </xsl:when>

      <xsl:when test="$month=3">
        <xsl:value-of select="$msg/*/entry[@key='March']"/>
      </xsl:when>

      <xsl:when test="$month=4">
        <xsl:value-of select="$msg/*/entry[@key='April']"/>
      </xsl:when>

      <xsl:when test="$month=5">
        <xsl:value-of select="$msg/*/entry[@key='May']"/>
      </xsl:when>

      <xsl:when test="$month=6">
        <xsl:value-of select="$msg/*/entry[@key='June']"/>
      </xsl:when>

      <xsl:when test="$month=7">
        <xsl:value-of select="$msg/*/entry[@key='July']"/>
      </xsl:when>

      <xsl:when test="$month=8">
        <xsl:value-of select="$msg/*/entry[@key='August']"/>
      </xsl:when>

      <xsl:when test="$month=9">
        <xsl:value-of select="$msg/*/entry[@key='September']"/>
      </xsl:when>

      <xsl:when test="$month=10">
        <xsl:value-of select="$msg/*/entry[@key='October']"/>
      </xsl:when>

      <xsl:when test="$month=11">
        <xsl:value-of select="$msg/*/entry[@key='November']"/>
      </xsl:when>

      <xsl:when test="$month=12">
        <xsl:value-of select="$msg/*/entry[@key='December']"/>
      </xsl:when>
    </xsl:choose>

  </xsl:template>
</xsl:stylesheet>
