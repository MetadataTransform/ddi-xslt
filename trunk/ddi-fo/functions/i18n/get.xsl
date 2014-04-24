<?xml version='1.0' encoding='utf-8'?>
<!-- get.xsl -->
<!-- ====================================== -->
<!-- xs:string i18n:get(english_string)     -->
<!-- ====================================== -->

<!-- read: -->
<!-- $strings [global] -->

<xsl:function name="i18n:get" as="xs:string"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- ################ -->
  <!-- ## parameters ## -->
  <!-- ################ -->
  <xsl:param name="english_string" />


  <!-- ############# -->
  <!-- ## content ## -->
  <!-- ############# -->
  <xsl:value-of select="$strings/*/entry[@key = $english_string]" />
            
</xsl:function>
