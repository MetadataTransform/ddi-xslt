<?xml version='1.0' encoding='utf-8'?>
<!-- IDNo.xsl -->
<!-- ==================== -->
<!-- match: IDNo          -->
<!-- value: <fo:block>    -->
<!-- ==================== -->

<!-- functions: -->
<!-- util:trim() -->

<xsl:template match="IDNo"
              xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <fo:block>

    <!-- agency -->
    <xsl:if test="@agency">
      <xsl:value-of select="@agency"/>:
    </xsl:if>
    
    <xsl:value-of select="util:trim(.)" />

  </fo:block>

</xsl:template>