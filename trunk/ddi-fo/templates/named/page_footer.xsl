<?xml version="1.0" encoding="UTF-8"?>
<!-- ==================================================== -->
<!-- name: page_footer                                    -->
<!-- value: <fo:static-content>                           -->
<!-- ==================================================== -->

<!-- read: -->
<!-- $header-font-size -->

<xsl:template name="page_footer"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format">
  
  <fo:static-content flow-name="after">
    <fo:block font-size="{$footer-font-size}" text-align="center" space-before="0.3in">
      - <fo:page-number /> -
    </fo:block>
  </fo:static-content>
  
</xsl:template>