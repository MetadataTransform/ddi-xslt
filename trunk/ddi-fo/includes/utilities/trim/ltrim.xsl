<?xml version='1.0' encoding='utf-8'?>

<!-- ltrim.xsl -->

<xsl:stylesheet xmlns:n1="http://www.icpsr.umich.edu/DDI" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ddi="http://www.icpsr.umich.edu/DDI" xmlns:date="http://exslt.org/dates-and-times" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:exsl="http://exslt.org/common" xmlns:math="http://exslt.org/math" xmlns:str="http://exslt.org/strings" xmlns:doc="http://www.icpsr.umich.edu/doc" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:xdt="http://www.w3.org/2005/xpath-datatypes" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:fn="http://www.w3.org/2005/xpath-functions" version="1.0" extension-element-prefixes="date exsl str">
  <xsl:output version="1.0" encoding="UTF-8" indent="no" omit-xml-declaration="no" media-type="text/html"/>

  <!-- ========================= -->
  <!--	 ltrim(s)                  -->
  <!-- string                    -->
  <!--                           -->
  <!-- perform left trim on text -->
  <!-- ========================= -->

  <!--
    params:
    ($s)

    local vars set:
    $s-no-ws, $s-first-non-ws, $s-no-leading-ws

    XPath 1.0 functions called:
    translate(), concat(), substring(), substring-after()
  -->

  <xsl:template name="ltrim">

    <!-- ========== -->
    <!-- Parameters -->
    <!-- ========== -->
    <xsl:param name="s"/>

    <!-- ========= -->
    <!-- Variables -->
    <!-- ========= -->
    <xsl:variable name="s-no-ws" select="translate($s,' &#x9;&#xA;&#xD;','$%*!')"/>
    <xsl:variable name="s-first-non-ws" select="substring($s-no-ws,1,1)"/>
    <xsl:variable name="s-no-leading-ws" select="concat($s-first-non-ws,substring-after($s,$s-first-non-ws))"/>

    <!-- =========================== -->
    <!-- r) [-] Main - Return result -->
    <!-- =========================== -->
    <xsl:value-of select="concat('[',$s-first-non-ws,'|',$s-no-ws,']')"/>

  </xsl:template>
</xsl:stylesheet>