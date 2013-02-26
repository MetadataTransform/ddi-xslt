<?xml version='1.0' encoding='utf-8'?>

<!-- variables-table-col-width.xsl -->
<!-- Header for variable table -->

<xsl:stylesheet xmlns:n1="http://www.icpsr.umich.edu/DDI" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ddi="http://www.icpsr.umich.edu/DDI" xmlns:date="http://exslt.org/dates-and-times" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:exsl="http://exslt.org/common" xmlns:math="http://exslt.org/math" xmlns:str="http://exslt.org/strings" xmlns:doc="http://www.icpsr.umich.edu/doc" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:xdt="http://www.w3.org/2005/xpath-datatypes" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:fn="http://www.w3.org/2005/xpath-functions" version="1.0" extension-element-prefixes="date exsl str">
  <xsl:output version="1.0" encoding="UTF-8" indent="no" omit-xml-declaration="no" media-type="text/html"/>

  <!-- =========================== -->
  <!-- variables-table-col-width() -->
  <!-- fo:table-column (multiple)  -->
  <!-- =========================== -->

  <!--
    global vars read:
    $show-variables-list-question

    FO functions called:
    proportional-column-width()
  -->

  <xsl:template name="variables-table-col-width">

    <fo:table-column column-width="proportional-column-width( 5)"/>
    <fo:table-column column-width="proportional-column-width(12)"/>
    <fo:table-column column-width="proportional-column-width(20)"/>
    <fo:table-column column-width="proportional-column-width(10)"/>
    <fo:table-column column-width="proportional-column-width(10)"/>
    <fo:table-column column-width="proportional-column-width( 8)"/>
    <fo:table-column column-width="proportional-column-width( 8)"/>

    <xsl:if test="$show-variables-list-question">
      <fo:table-column column-width="proportional-column-width(27)"/>
    </xsl:if>

  </xsl:template>
</xsl:stylesheet>