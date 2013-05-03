<?xml version='1.0' encoding='utf-8'?>

<!-- ddi_default_text.xsl -->

<xsl:stylesheet xmlns:n1="http://www.icpsr.umich.edu/DDI"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:ddi="http://www.icpsr.umich.edu/DDI"
                xmlns:date="http://exslt.org/dates-and-times"
                xmlns:dcterms="http://purl.org/dc/terms/"
                xmlns:exsl="http://exslt.org/common"
                xmlns:math="http://exslt.org/math"
                xmlns:str="http://exslt.org/strings"
                xmlns:doc="http://www.icpsr.umich.edu/doc"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:xdt="http://www.w3.org/2005/xpath-datatypes"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                version="1.0"
                extension-element-prefixes="date exsl str">
    
  <xsl:output version="1.0" encoding="UTF-8" indent="no"
              omit-xml-declaration="no" media-type="text/html"/>

  <!-- =================== -->
  <!-- match: ddi:*|text() -->
  <!-- [fo:block] / [-]    -->
  <!--                     -->
  <!-- the default text    -->
  <!-- =================== -->

  <!--
    local vars set:
    $trimmed

    templates called:
    [trim], [FixHTML]
  -->

  <xsl:template match="ddi:*|text()">

    <!-- ======================== -->
    <!-- Case 1) [-] HTML content -->
    <!-- ======================== -->
    <xsl:if test="$allowHTML = 1">
      <xsl:call-template name="FixHTML">
        <xsl:with-param name="InputString" select="."/>
      </xsl:call-template>
    </xsl:if>

    <!-- =========================== -->
    <!-- Case 2) [-] No HTML content -->
    <!-- =========================== -->
    <xsl:if test="$allowHTML = 0">

      <!-- 1) [-] Trim current node -->
      <xsl:variable name="trimmed">
        <xsl:call-template name="trim">
          <xsl:with-param name="s" select="."/>
        </xsl:call-template>
      </xsl:variable>

      <!-- 2) [fo:block] Current node content -->
      <fo:block linefeed-treatment="preserve" white-space-collapse="false"
                space-after="0.0in">
        <xsl:value-of select="$trimmed"/>
      </fo:block>

    </xsl:if>

  </xsl:template>
</xsl:stylesheet>

