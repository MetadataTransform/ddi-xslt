<?xml version='1.0' encoding='utf-8'?>
<!-- =================== -->
<!-- name: trim          -->
<!-- value: string       -->
<!-- =================== -->

<!-- read: -->
<!-- $string [param] -->

<!-- functions: -->
<!-- concat(), substring(), translate(), substring-after() [Xpath 1.0] -->

<!-- called: -->
<!-- rtrim -->

<xsl:template name="trim"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:fo="http://www.w3.org/1999/XSL/Format">

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
  <!-- -->
  <xsl:variable name="tmp3" select="concat($tmp1, $tmp2)" />

   <!-- select="concat(substring(translate($s ,' &#x9;&#xA;&#xD;',''), 1, 1),
      substring-after($s, substring(translate($s, ' &#x9;&#xA;&#xD;', ''), 1, 1)))" -->

  <!-- ======= -->
  <!-- content -->
  <!-- ======= -->

  <!-- perform trimming (from right)-->
  <xsl:call-template name="rtrim">
    <xsl:with-param name="s" select="$tmp3" />
  </xsl:call-template>

</xsl:template>
