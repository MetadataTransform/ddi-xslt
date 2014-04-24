<?xml version='1.0' encoding='utf-8'?>
<!-- ddi_default_text.xsl -->
<!-- ============================== -->
<!-- match: ddi:*|text()            -->
<!-- value: <fo:block>              -->
<!-- ============================== -->

<!-- set: -->
<!-- $trimmed -->

<!-- functions: -->
<!-- util:trim() [local] -->

<xsl:template match="*|text()"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:fo="http://www.w3.org/1999/XSL/Format">
  
  <fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0mm">
    <xsl:value-of select="util:trim(.)" />
  </fo:block>

</xsl:template>
