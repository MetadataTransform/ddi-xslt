<?xml version='1.0' encoding='utf-8'?>

<!-- ddi-fileDsrc_variables-list.xsl -->

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

  <!-- ===================================== -->
  <!-- match: ddi:fileDsrc / variables-list  -->
  <!-- fo:table                              -->
  <!-- ===================================== -->

  <!--
    global vars read:
    $default-border, $cell-padding, $msg,

    local vars set:
    $fileId

    templates called:
    [variables-table-col-width], [variables-table-col-header]
  -->

  <xsl:template match="ddi:fileDscr" mode="variables-list">

    <!-- ========= -->
    <!-- Variables -->
    <!-- ========= -->
    <xsl:variable name="fileId">
      <xsl:choose>

        <xsl:when test="ddi:fileTxt/ddi:fileName/@ID">
          <xsl:value-of select="ddi:fileTxt/ddi:fileName/@ID"/>
        </xsl:when>

        <xsl:when test="@ID">
          <xsl:value-of select="@ID"/>
        </xsl:when>

      </xsl:choose>
    </xsl:variable>

    <!-- ================== -->
    <!-- r) [fo:table] Main -->
    <!-- ================== -->
    <fo:table id="varlist-{ddi:fileTxt/ddi:fileName/@ID}" table-layout="fixed"
              width="100%" font-size="8pt"
              space-before="0.2in" space-after="0.2in">

      <xsl:call-template name="variables-table-col-width" />

      <!-- [fo:table-header] -->
      <fo:table-header>
        <fo:table-row text-align="center" vertical-align="top" keep-with-next="always">
          <fo:table-cell text-align="left" number-columns-spanned="8"
                         border="{$default-border}" padding="{$cell-padding}">
            <fo:block font-size="12pt" font-weight="bold">
              <xsl:value-of select="$msg/*/entry[@key='File']"/>
              <xsl:text> </xsl:text>
              <xsl:apply-templates select="ddi:fileTxt/ddi:fileName"/>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>

        <xsl:call-template name="variables-table-col-header"/>
      </fo:table-header>

      <!-- [fo:table-body] -->
      <fo:table-body>
        <fo:table-row>
          <fo:table-cell>
            <fo:block> <!-- ToDo: -->
            </fo:block>
          </fo:table-cell>
        </fo:table-row>

        <xsl:apply-templates select="/ddi:codeBook/ddi:dataDscr/ddi:var[@files=$fileId]" mode="variables-list"/>
      </fo:table-body>

    </fo:table>

  </xsl:template>
</xsl:stylesheet>