<?xml version="1.0" encoding="UTF-8"?>
<!-- util-isodate_month_name.xsl -->
<!-- ===================================== -->
<!-- xs:string util:isodate_month_name()   -->
<!-- param: xs:string isodate              -->
<!-- ===================================== -->

<!-- returns month name from a ISO-format date string -->

<!-- read: -->
<!-- $isodate [param] -->

<!-- set: -->
<!-- $month, $month_string -->

<!-- functions: -->
<!-- number(), substring(), contains() [Xpath 1.0] -->

<xsl:function name="util:isodate_month_name" as="xs:string"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- ========= -->
  <!-- params    -->
  <!-- ========= -->
  <xsl:param name="isodate" as="xs:string" /> 
  
  <!-- ========= -->
  <!-- variables -->
  <!-- ========= -->
  <!-- extract month number from date string -->
  <xsl:variable name="month" select="number(substring($isodate, 6, 2))"/>
  
  <!-- determine month name -->
  <xsl:variable name="month_string">
    <xsl:choose>
      <xsl:when test="$month=1">
        <xsl:value-of select="$strings/*/entry[@key='January']"/>
      </xsl:when>
      <xsl:when test="$month=2">
        <xsl:value-of select="$strings/*/entry[@key='February']"/>
      </xsl:when>
      <xsl:when test="$month=3">
        <xsl:value-of select="$strings/*/entry[@key='March']"/>
      </xsl:when>
      <xsl:when test="$month=4">
        <xsl:value-of select="$strings/*/entry[@key='April']"/>
      </xsl:when>
      <xsl:when test="$month=5">
        <xsl:value-of select="$strings/*/entry[@key='May']"/>
      </xsl:when>
      <xsl:when test="$month=6">
        <xsl:value-of select="$strings/*/entry[@key='June']"/>
      </xsl:when>
      <xsl:when test="$month=7">
        <xsl:value-of select="$strings/*/entry[@key='July']"/>
      </xsl:when>
      <xsl:when test="$month=8">
        <xsl:value-of select="$strings/*/entry[@key='August']"/>
      </xsl:when>
      <xsl:when test="$month=9">
        <xsl:value-of select="$strings/*/entry[@key='September']"/>
      </xsl:when>
      <xsl:when test="$month=10">
        <xsl:value-of select="$strings/*/entry[@key='October']"/>
      </xsl:when>
      <xsl:when test="$month=11">
        <xsl:value-of select="$strings/*/entry[@key='November']"/>
      </xsl:when>
      <xsl:when test="$month=12">
        <xsl:value-of select="$strings/*/entry[@key='December']"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <!-- ======= -->
  <!-- content -->
  <!-- ======= -->
  <xsl:value-of select="$month_string" />
  
</xsl:function>