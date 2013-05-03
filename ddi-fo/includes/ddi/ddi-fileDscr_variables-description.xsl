<?xml version='1.0' encoding='utf-8'?>

<!-- ddi-fileDsrc_variables-description.xsl -->

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

  <!-- =========================================== -->
  <!-- match: ddi:fileDsrc / variables-description -->
  <!-- fo:page-sequence (multiple)                 -->
  <!-- =========================================== -->

  <!--
    global vars read:
    $msg, $chunkSize, $font-family, $default-border

    local vars set:
    $fileId, $fileName

    XPath 1.0 functions called:
    position()

    FO functions called:
    proportional-column-width()

    templates called:
    [footer]
  -->

  <xsl:template match="ddi:fileDscr" mode="variables-description">

    <!-- ========= -->
    <!-- Variables -->
    <!-- ========= -->
    <xsl:variable name="fileId">
      <xsl:choose>

        <!-- fileName ID attribute -->
        <xsl:when test="ddi:fileTxt/ddi:fileName/@ID">
          <xsl:value-of select="ddi:fileTxt/ddi:fileName/@ID"/>
        </xsl:when>

        <!-- other ID attribute -->
        <xsl:when test="@ID">
          <xsl:value-of select="@ID"/>
        </xsl:when>

      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="fileName" select="ddi:fileTxt/ddi:fileName"/>

    <!-- ================================================= -->
    <!-- r) [fo:page-sequence] Main - Iterate through file -->
    <!-- ================================================= -->
    <xsl:for-each select="/ddi:codeBook/ddi:dataDscr/ddi:var[@files=$fileId][position() mod $chunkSize = 1]">
      <fo:page-sequence master-reference="default-page" font-family="{$font-family}" font-size="10pt">

        <xsl:call-template name="footer"/>

        <fo:flow flow-name="xsl-region-body">

          <!-- [fo:table] Header -->
          <!--	 (only written if at the start of file -->
          <xsl:if test="position() = 1">
            <fo:table id="vardesc-{$fileId}" table-layout="fixed" width="100%" font-size="8pt">
              <fo:table-column column-width="proportional-column-width(100)"/> <!-- column width -->

              <!-- [fo:table-header] -->
              <fo:table-header space-after="0.2in">

                <!-- [fo:table-row] File identification -->
                <fo:table-row text-align="center" vertical-align="top">
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block font-size="14pt" font-weight="bold">
                      <xsl:value-of select="$msg/*/entry[@key='File']"/>
                      <xsl:text> : </xsl:text>
                      <xsl:apply-templates select="$fileName"/>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>

              </fo:table-header>

              <!-- [fo:table-body] Variables -->
              <fo:table-body>
                <!-- needed in case of subset -->
                <fo:table-row>
                  <fo:table-cell>
                    <fo:block />
                  </fo:table-cell>
                </fo:table-row>
                <xsl:apply-templates select=".|following-sibling::ddi:var[@files=$fileId][$chunkSize &gt; position()]"/>
              </fo:table-body>

            </fo:table>
          </xsl:if>

          <!-- [fo:table] Variables -->
          <xsl:if test="position()&gt;1">
            <fo:table table-layout="fixed" width="100%" font-size="8pt">
              <fo:table-body>
                <!-- needed in case of subset -->
                <fo:table-row>
                  <fo:table-cell>
                    <fo:block/>
                  </fo:table-cell>
                </fo:table-row>
                <xsl:apply-templates select=".|following-sibling::ddi:var[@files=$fileId][$chunkSize &gt; position()]"/>
              </fo:table-body>
            </fo:table>
          </xsl:if>

        </fo:flow>
      </fo:page-sequence>
    </xsl:for-each>

  </xsl:template>
</xsl:stylesheet>