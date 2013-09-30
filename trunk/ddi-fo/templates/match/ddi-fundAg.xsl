<?xml version='1.0' encoding='utf-8'?>
<!-- Match: ddi:fundAg -->
<!-- Value: <fo:block> -->

<!--
  Functions/templates called:
  trim
-->

<xsl:template match="ddi:fundAg"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <fo:block>

    <!-- trim current node -->
    <xsl:call-template name="trim">
      <xsl:with-param name="s" select="."/>
    </xsl:call-template>

    <!-- @abbr -->
    <xsl:if test="@abbr">
      (<xsl:value-of select="@abbr"/>)
    </xsl:if>

    <!-- @role -->
    <xsl:if test="@role"> ,
      <xsl:value-of select="@role"/>
    </xsl:if>

  </fo:block>

</xsl:template>
