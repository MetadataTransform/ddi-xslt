<?xml version='1.0' encoding='utf-8'?>
<!-- rtrim.xsl -->

<!-- ================================================ -->
<!-- xs:string util:rtrim(xs:string s, xs:integer i)  -->
<!-- ================================================ -->

<!-- perform right trim on text through recursion -->

<!-- called: -->
<!-- substring(), string-length(), translate() [Xpath 1.0] -->
<!-- self [local] -->

<xsl:function name="util:rtrim" as="xs:string"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:param name="input_string" as="xs:string"/>
  <xsl:param name="length" as="xs:integer"/>

  <xsl:variable name="tmp">
    <xsl:choose>

      <!-- 1) what? -->
      <xsl:when test="translate(substring($input_string, $length, 1), ' &#x9;&#xA;&#xD;', '')">
        <xsl:value-of select="substring($input_string, 1, $length)" />
      </xsl:when>

      <!-- 2) -->
      <xsl:when test="$length &lt; 2" />

      <!-- 3) recurse -->
      <xsl:otherwise>
        <xsl:value-of select="util:rtrim($input_string, $length - 1)" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- return value -->
  <xsl:value-of select="$tmp" />

</xsl:function>
