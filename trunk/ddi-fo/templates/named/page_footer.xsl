<?xml version="1.0" encoding="UTF-8"?>
<!-- page_footer.xsl -->
<!-- ==================================================== -->
<!-- name: page_footer                                    -->
<!-- value: <fo:static-content>                           -->
<!-- ==================================================== -->

<xsl:template name="page_footer"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:fo="http://www.w3.org/1999/XSL/Format">
  
  <fo:static-content flow-name="after">
    <fo:block font-size="7" text-align="center" space-before="0.3in">
      <xsl:text>- </xsl:text>
      <fo:page-number />
      <xsl:text> -</xsl:text>
    </fo:block>
  </fo:static-content>
  
</xsl:template>