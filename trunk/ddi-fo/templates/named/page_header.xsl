<?xml version="1.0" encoding="UTF-8"?>
<!-- page_header.xsl -->

<xsl:template name="page_header"
              xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:xs="http://www.w3.org/2001/XMLSchema"
              xmlns:fo="http://www.w3.org/1999/XSL/Format">
  
  <!-- ====== -->
  <!-- params -->
  <!-- ====== -->
  <xsl:param name="section_name" />
  
  <!-- ======= -->
  <!-- content -->
  <!-- ======= -->
  <fo:static-content flow-name="before">
    <fo:block font-size="{$header-font-size}" text-align="center">
      <xsl:value-of select="/codeBook/stdyDscr/citation/titlStmt/titl" />
      <xsl:text> - </xsl:text>
      <xsl:value-of select="$section_name" />
    </fo:block>
  </fo:static-content>
  
</xsl:template>