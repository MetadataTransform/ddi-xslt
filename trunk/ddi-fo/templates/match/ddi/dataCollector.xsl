<?xml version='1.0' encoding='utf-8'?>
<!-- dataCollector.xsl -->
<!-- ============================== -->
<!-- match: dataCollector           -->
<!-- value: <fo:block>              -->
<!-- ============================== -->

<!-- functions: -->
<!-- util:trim() [local] -->

<xsl:template match="dataCollector"
              xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <fo:block>  
    <xsl:value-of select="util:trim(.)" />

    <!-- abbr -->
    <!-- <xsl:if test="@abbr">
      <xsl:text>(</xsl:text>
      <xsl:value-of select="@abbr"/>
      <xsl:text>)</xsl:text>
    </xsl:if> -->

    <xsl:value-of select="if (@abbr) then
                            string-join(('(', @abbr, ')'), '')
                          else () "/>

    <!-- affiliation -->
    <!-- <xsl:if test="@affiliation"> ,
      <xsl:value-of select="@affiliation" />
    </xsl:if> -->

    <xsl:value-of select="if (@affiliation) then @affiliation else () "/>

  </fo:block>

</xsl:template>
