<?xml version='1.0' encoding='utf-8'?>

<!-- footer.xsl -->
<!-- Named template for creating page footer -->

<xsl:stylesheet xmlns:n1="http://www.icpsr.umich.edu/DDI" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ddi="http://www.icpsr.umich.edu/DDI" xmlns:date="http://exslt.org/dates-and-times" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:exsl="http://exslt.org/common" xmlns:math="http://exslt.org/math" xmlns:str="http://exslt.org/strings" xmlns:doc="http://www.icpsr.umich.edu/doc" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:xdt="http://www.w3.org/2005/xpath-datatypes" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:fn="http://www.w3.org/2005/xpath-functions" version="1.0" extension-element-prefixes="date exsl str">
  <xsl:output version="1.0" encoding="UTF-8" indent="no" omit-xml-declaration="no" media-type="text/html"/>

  <!-- =================== -->
  <!--	 footer()            -->
  <!-- [fo:static-content] -->
  <!--                     -->
  <!-- creates page footer -->
  <!-- =================== -->
  <xsl:template name="footer">

    <!-- =========================== -->
    <!-- r) [fo:static-content] Main -->
    <!-- =========================== -->
    <fo:static-content flow-name="xsl-region-after">
      <fo:block font-size="6" text-align="center" space-before="0.3in">
        -
        <fo:page-number />
        -
      </fo:block>
    </fo:static-content>

  </xsl:template>
</xsl:stylesheet>