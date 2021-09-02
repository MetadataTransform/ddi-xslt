<?xml version='1.0' encoding='utf-8'?>
<!-- AuthEntry.xsl -->
<!-- ========================= -->
<!-- match: AuthEnty       -->
<!-- value: <fo:block>         -->
<!-- ========================= -->

<!-- functions: -->
<!-- util:trim() [local] -->

<xsl:template match="AuthEnty"
              xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <fo:block>
    <xsl:value-of select="util:trim(.)" />    
    <xsl:value-of select="if (@affiliation) then @affiliation else () "/>
  </fo:block>

</xsl:template>
