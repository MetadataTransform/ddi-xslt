<?xml version='1.0' encoding='utf-8'?>
<!-- fundAg.xsl -->
<!-- ========================== -->
<!-- match: fundAg          -->
<!-- value: <fo:block>          -->
<!-- ========================== -->

<!-- functions: -->
<!-- util:trim() [local] -->

<xsl:template match="fundAg"
              xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <fo:block>    
    <xsl:value-of select="util:trim(.)" />
    <xsl:value-of select="if (@abbr) then concat('(', @abbr, ')') else () "/> 
    <xsl:value-of select="if (@role) then concat(',', @role) else () "/>
  </fo:block>

</xsl:template>
