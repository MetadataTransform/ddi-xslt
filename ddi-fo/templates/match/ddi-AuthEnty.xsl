<?xml version='1.0' encoding='utf-8'?>
<!-- Match: ddi:AuthEnty -->
<!-- Value: fo:block -->

<!--
  Functions/templates called:
  trim
-->

<xsl:template match="ddi:AuthEnty"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <fo:block>

    <!-- trim current node -->
    <xsl:call-template name="trim">
      <xsl:with-param name="s" select="."/>
    </xsl:call-template>

    <!-- affiliation -->
    <xsl:if test="@affiliation">,
      <xsl:value-of select="@affiliation"/>
    </xsl:if>

  </fo:block>
</xsl:template>