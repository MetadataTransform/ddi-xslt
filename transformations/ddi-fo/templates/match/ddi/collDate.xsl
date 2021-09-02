<?xml version='1.0' encoding='utf-8'?>
<!-- collDate.xsl -->
<!-- ============================ -->
<!-- match: collDate              -->
<!-- value: <fo:block>            -->
<!-- ============================ -->

<xsl:template match="collDate"
              xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:fo="http://www.w3.org/1999/XSL/Format">

    <fo:block>      
      <xsl:value-of select="if (@cycle) then concat(@cycle, ': ') else () "/>      
      <xsl:value-of select="if (@event) then concat(@event, ' ') else () "/>
      <xsl:value-of select="@date" />
    </fo:block>

</xsl:template>
