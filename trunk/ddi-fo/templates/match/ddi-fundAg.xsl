<?xml version='1.0' encoding='utf-8'?>
<!-- ddi-fundAg.xsl -->
<!-- ========================== -->
<!-- match: ddi:fundAg          -->
<!-- value: <fo:block>          -->
<!-- ========================== -->

<!-- functions: -->
<!-- util:trim() [local] -->

<xsl:template match="ddi:fundAg"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <fo:block>
    
    <xsl:value-of select="util:trim(.)" />

    <!-- @abbr -->
    <xsl:if test="@abbr">
      <xsl:text>(</xsl:text>
      <xsl:value-of select="@abbr"/>
      <xsl:text>)</xsl:text>
    </xsl:if>

    <!-- @role -->
    <xsl:if test="@role">
      <xsl:text> ,</xsl:text>
      <xsl:value-of select="@role"/>
    </xsl:if>

  </fo:block>

</xsl:template>