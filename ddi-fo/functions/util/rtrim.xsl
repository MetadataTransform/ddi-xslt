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
  <xsl:param name="s" as="xs:string"/>
  <xsl:param name="i" as="xs:integer"/>

  <!-- ====================== -->
  <!-- perform right-trimming -->
  <!-- ====================== -->
  
  <!-- is further trimming needed?-->
  <xsl:variable name="tmp">
    <xsl:choose>

      <xsl:when test="translate(substring($s, $i, 1), ' &#x9;&#xA;&#xD;', '')">
        <xsl:value-of select="substring($s, 1, $i)" />
      </xsl:when>
      <xsl:when test="$i &lt; 2" />
      <!-- recurse -->
      <xsl:otherwise>
        <xsl:value-of select="util:rtrim($s, $i - 1)" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- <xsl:variable name="tmp"
    select="if (translate(substring($s, $i, 1), ' &#x9;&#xA;&#xD;', '')) then
              substring($s, 1, $i)
            (: case: string less than 2 (do nothing) :)
            else if ($1 &lt; 2) then ()
            (: recurse :)
            else util:rtrim($s, $i - 1) " /> -->

  <!-- return value -->
  <xsl:value-of select="$tmp" />

</xsl:function>
