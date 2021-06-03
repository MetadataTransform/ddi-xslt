<?xml version='1.0' encoding='utf-8'?>
<!-- get.xsl -->
<!-- ====================================== -->
<!-- xs:string i18n:get(english_string)     -->
<!-- ====================================== -->

<!-- read: -->
<!-- $i18n_strings [global] -->

<xsl:function name="i18n:get" as="xs:string"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:param name="english_string" />


  <!-- return value -->
  <!-- <xsl:value-of select="$i18n_strings/*/entry[@key = $english_string]" /> -->
  <xsl:value-of select="$i18n.strings/*/entry[@key = $english_string]" />
  
  
</xsl:function>
