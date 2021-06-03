<?xml version='1.0' encoding='utf-8'?>
<!-- producer.xsl -->
<!-- ========================== -->
<!-- match: producer            -->
<!-- value: <fo:block>          -->
<!-- ========================== -->

<!-- called: -->
<!-- trim -->

<xsl:template match="producer"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <fo:block>
    <xsl:value-of select="util:trim(.)"/>
    <xsl:value-of select="if (@abbr) then concat('(', @abbr, ')') else () "/>     
    <xsl:value-of select="if (@affiliation) then @affiliation else () "/> 
    <xsl:value-of select="if (@role) then @role else () "/> 
  </fo:block>
  
</xsl:template>

