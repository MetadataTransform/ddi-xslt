<?xml version='1.0' encoding='utf-8'?>
<!-- util-trim.xsl -->
<!-- =================== -->
<!-- xs:string trim(s)    -->
<!-- =================== -->

<!-- functions: -->
<!-- concat(), substring(), translate(), substring-after() [Xpath 1.0] -->
<!-- util:rtrim() [local] -->

<xsl:function name="util:trim" as="xs:string"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:param name="s" />


  <!-- perform trimming -->

  <!-- &#x9; TAB-character -->
  <!-- &#xA; LF-character -->
  <!-- &#xD; CR-character -->

  <!-- replace TAB, LF and CR and with '' -->
  <xsl:variable name="translated" select="translate($s, '&#x9;&#xA;&#xD;', '')" />
  <!-- extract all characters in string after the first one -->
  <xsl:variable name="tmp1" select="substring($translated, 1, 1)" />
  <!-- extract all character in string after found string -->
  <xsl:variable name="tmp2" select="substring-after($s, $tmp1)" />
  
  <xsl:variable name="tmp3" select="concat($tmp1, $tmp2)" />

  <xsl:variable name="tmp4" select="util:rtrim($tmp3, string-length($tmp3))" />


  <!-- return value -->
  <xsl:value-of select="$tmp4" />

</xsl:function>
