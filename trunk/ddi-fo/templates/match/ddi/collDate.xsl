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

      <!-- cycle -->
      <xsl:if test="@cycle">
        <xsl:value-of select="@cycle"/>
        <xsl:text>: </xsl:text>
      </xsl:if>

      <!-- event -->
      <xsl:if test="@event">
        <xsl:value-of select="@event"/>
        <xsl:text> </xsl:text>
      </xsl:if>

      <!-- date -->
      <xsl:value-of select="@date"/>

    </fo:block>

</xsl:template>
