<?xml version='1.0' encoding='utf-8'?>
<!-- othId.xsl -->
<!-- =================== -->
<!-- match: othId        -->
<!-- value: <fo:block>   -->
<!-- =================== -->

<!-- called: -->
<!-- trim -->

<xsl:template match="othId"
              xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <fo:block>  
    <xsl:value-of select="util:trim(ddi:p)"/>
    <xsl:value-of select="if (@role) then @role else () "/>  
    <xsl:value-of select="if (@affiliation) then @affiliation else () "/>  
  </fo:block>

</xsl:template>
