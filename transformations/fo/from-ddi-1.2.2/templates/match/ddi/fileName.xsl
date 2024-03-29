<?xml version='1.0' encoding='utf-8'?>
<!-- fileName.xsl -->
<!-- ===================== -->
<!-- match: fileName       -->
<!-- value: string         -->
<!-- ===================== -->

<!-- set: -->
<!-- $filename -->

<!-- functions: -->
<!-- contains(), normalize-space(), string-length(), substring() [xpath 1.0] -->

<xsl:template match="fileName"
              xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <!-- variables -->
  <xsl:variable name="filename" select="normalize-space(.)" />

  <!-- content -->
  
  <!-- remove ".NSDstat" extension from filename -->  
  <xsl:value-of select="
    if (contains($filename, '.NSDstat')) then substring($filename, 1, string-length($filename) - 8)
    else $filename "/>

</xsl:template>

