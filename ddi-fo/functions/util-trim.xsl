<?xml version='1.0' encoding='utf-8'?>
<!-- =================== -->
<!-- xs:string trim()    -->
<!-- param: $s           -->
<!-- =================== -->

<!-- read: -->
<!-- $s [param] -->

<!-- functions: -->
<!-- concat(), substring(), translate(), substring-after() [Xpath 1.0] -->
<!-- util:rtrim() [local] -->

<xsl:function name="util:trim" as="xs:string"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- ====== -->
  <!-- params -->
  <!-- ====== -->
  <xsl:param name="s" />

  <!-- ========= -->
  <!-- variables -->
  <!-- ========= -->

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

  <!-- ======= -->
  <!-- content -->
  <!-- ======= -->
  <xsl:value-of select="util:rtrim($tmp3, string-length($tmp3))" />

</xsl:function>
