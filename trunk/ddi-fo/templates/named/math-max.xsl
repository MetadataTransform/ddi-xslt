<?xml version='1.0' encoding='utf-8'?>
<!-- ===================== -->
<!-- name: math:max        -->
<!-- value: string         -->
<!-- ===================== -->

<!-- read: -->
<!-- $nodes [param] -->

<!-- functions: -->
<!-- not(), number(), position() [Xpath 1.0] -->

<xsl:template name="math:max"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:fo="http://www.w3.org/1999/XSL/Format">

    <!-- params -->
    <xsl:param name="nodes" select="/.."/>

    <!-- content -->
    <!-- count number of nodes -->
    <xsl:choose>

      <!-- Case: Not a Number -->
      <xsl:when test="not($nodes)">NaN</xsl:when>

      <!-- Actually a number -->
      <xsl:otherwise>
        <xsl:for-each select="$nodes">
          <xsl:sort data-type="number" order="descending"/>
          <xsl:if test="position() = 1">
            <xsl:value-of select="number(.)"/>
          </xsl:if>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>

</xsl:template>
