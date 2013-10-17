<?xml version='1.0' encoding='utf-8'?>
<!-- ============================== -->
<!-- match: ddi:dataCollector       -->
<!-- value: <fo:block>              -->
<!-- ============================== -->

<!-- functions: -->
<!-- util:trim() -->

<xsl:template match="ddi:dataCollector"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <fo:block>  
    <xsl:value-of select="util:trim(.)" />

    <!-- abbr -->
    <xsl:if test="@abbr">
      <xsl:text>(</xsl:text>
      <xsl:value-of select="@abbr"/>
      <xsl:text>)</xsl:text>
    </xsl:if>

    <!-- affiliation -->
    <xsl:if test="@affiliation"> ,
      <xsl:value-of select="@affiliation" />
    </xsl:if>

  </fo:block>

</xsl:template>
