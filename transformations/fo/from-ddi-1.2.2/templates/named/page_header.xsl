<?xml version="1.0" encoding="UTF-8"?>
<!-- page_header.xsl -->

<xsl:template name="page_header"
              xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:xs="http://www.w3.org/2001/XMLSchema"
              xmlns:fo="http://www.w3.org/1999/XSL/Format">
  <xsl:param name="section_name" />
  

  <!-- original content -->
<!--  <fo:static-content flow-name="before">
    <fo:block font-size="{$layout.header_font_size}" text-align="center">
      <xsl:value-of select="concat(/codeBook/stdyDscr/citation/titlStmt/titl, ' - ', $section_name)"/>   
    </fo:block>
  </fo:static-content>-->  

  <!-- imported from FORS vesion -->
  <fo:static-content flow-name="before">
    
    <fo:table table-layout="fixed" width="100%" space-before="0cm" space-after="0cm">
      <fo:table-column column-width="proportional-column-width(70)" />
      <fo:table-column column-width="proportional-column-width(30)" />
      
      <fo:table-body>
        <fo:table-row border-bottom="1pt solid black">
          <fo:table-cell display-align="after">
            <fo:block font-size="{$layout.header_font_size}" text-align="left">
              <xsl:value-of select="/codeBook/stdyDscr/citation/titlStmt/titl"/>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block font-size="{$layout.header_font_size}" text-align="right">
              <xsl:value-of select="$section_name"/>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
  </fo:static-content>

</xsl:template>