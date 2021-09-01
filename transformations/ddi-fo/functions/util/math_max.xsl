<?xml version='1.0' encoding='utf-8'?>
<!-- util-math_max.xsl -->
<!-- ===================== -->
<!-- util:math_max()       -->
<!-- param: $nodes         -->
<!-- ===================== -->

<!-- read: -->
<!-- $nodes [param] -->

<!-- functions: -->
<!-- not(), number(), position() [Xpath 1.0] -->

<xsl:function name="util:math_max"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:param name="nodes" />


  <!-- count number of nodes -->
  <xsl:variable name="tmp">
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
  </xsl:variable>


  <!-- return value -->
  <xsl:value-of select="$tmp" />

</xsl:function>
