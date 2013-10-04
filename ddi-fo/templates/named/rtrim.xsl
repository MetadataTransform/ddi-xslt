<?xml version='1.0' encoding='utf-8'?>
<!-- ================= -->
<!-- name: rtrim       -->
<!-- value: string     -->
<!-- ================= -->

<!-- perform right trim on text through recursion -->

<!-- read: -->
<!-- $string, $index [param] -->

<!-- functions: -->
<!-- substring(), string-length(), translate() [Xpath 1.0] -->

<!-- called: -->
<!-- rtrim -->

<xsl:template name="rtrim"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:fo="http://www.w3.org/1999/XSL/Format">

    <!-- params -->
    <xsl:param name="s" />
    <xsl:param name="i" select="string-length($s)" />

    <!-- is further trimming needed?-->
    <xsl:choose>

      <xsl:when test="translate(substring($s, $i, 1), ' &#x9;&#xA;&#xD;', '')">
        <xsl:value-of select="substring($s, 1, $i)" />
      </xsl:when>

      <!-- case: string less than 2 (do nothing) -->
      <xsl:when test="$i &lt; 2" />

      <!-- call this template -->
      <xsl:otherwise>
        <xsl:call-template name="rtrim">
          <xsl:with-param name="s" select="$s" />
          <xsl:with-param name="i" select="$i - 1" />
        </xsl:call-template>
      </xsl:otherwise>

    </xsl:choose>

</xsl:template>
