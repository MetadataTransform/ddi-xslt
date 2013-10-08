<?xml version='1.0' encoding='utf-8'?>
<!-- ==================== -->
<!-- match: ddi:IDNo      -->
<!-- value: <fo:block>    -->
<!-- ==================== -->

<!-- called: -->
<!-- trim -->

<xsl:template match="ddi:IDNo"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <fo:block>

    <!-- agency -->
    <xsl:if test="@agency">
      <xsl:value-of select="@agency"/>:
    </xsl:if>

    <!-- trim current node -->
    <xsl:call-template name="trim">
      <xsl:with-param name="s" select="."/>
    </xsl:call-template>

  </fo:block>

</xsl:template>
