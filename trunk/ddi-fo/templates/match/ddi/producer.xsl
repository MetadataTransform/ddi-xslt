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

    <!-- abbreviation -->
    <xsl:if test="@abbr">
      (<xsl:value-of select="@abbr"/>)
    </xsl:if>

    <!-- affiliation -->
    <xsl:if test="@affiliation"> ,
      <xsl:value-of select="@affiliation"/>
    </xsl:if>

    <!-- role -->
    <xsl:if test="@role"> ,
      <xsl:value-of select="@role"/>
    </xsl:if>

  </fo:block>
</xsl:template>

