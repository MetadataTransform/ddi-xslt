<?xml version='1.0' encoding='utf-8'?>

<!-- trim.xsl -->

<xsl:stylesheet xmlns:n1="http://www.icpsr.umich.edu/DDI" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ddi="http://www.icpsr.umich.edu/DDI" xmlns:date="http://exslt.org/dates-and-times" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:exsl="http://exslt.org/common" xmlns:math="http://exslt.org/math" xmlns:str="http://exslt.org/strings" xmlns:doc="http://www.icpsr.umich.edu/doc" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:xdt="http://www.w3.org/2005/xpath-datatypes" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:fn="http://www.w3.org/2005/xpath-functions" version="1.0" extension-element-prefixes="date exsl str">
  <xsl:output version="1.0" encoding="UTF-8" indent="no" omit-xml-declaration="no" media-type="text/html"/>

  <!-- ========== -->
  <!--	 trim(s)    -->
  <!-- string     -->
  <!-- ========== -->

  <!--
    params:
    ($s)

    XPath 1.0 functions called:
    concat(), substring(), translate(), substring-after()

    templates called:
    [rtrim]
  -->

  <xsl:template name="trim">

    <!-- Parameters -->
    <xsl:param name="s"/>

    <!-- Perform trimming -->
    <xsl:call-template name="rtrim">
      <xsl:with-param name="s" select="concat(substring(translate($s,' &#x9;&#xA;&#xD;',''),1,1),substring-after($s,substring(translate($s,' &#x9;&#xA;&#xD;',''),1,1)))"/>
    </xsl:call-template>

  </xsl:template>
</xsl:stylesheet>