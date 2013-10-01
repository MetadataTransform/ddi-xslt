<?xml version='1.0' encoding='utf-8'?>
<!-- Name: isodate-month(isodate) -->
<!-- Value: string -->

<!--
    Params/variables read:
    isodate [param]
    msg

    Variables set:
    month

    Functions/templates called:
    number(), substring()
-->

<xsl:template name="isodate-month"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:fo="http://www.w3.org/1999/XSL/Format">

    <!-- params -->
    <xsl:param name="isodate" select=" '2005-12-31' "/>

    <!-- variables -->
    <xsl:variable name="month" select="number(substring($isodate,6,2))"/>

    <!-- content -->
    <!-- determine month name -->
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

</xsl:template>
