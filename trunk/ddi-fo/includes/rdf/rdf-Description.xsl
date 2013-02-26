<?xml version='1.0' encoding='utf-8'?>

<!-- rdf-Description.xsl -->

<xsl:stylesheet xmlns:n1="http://www.icpsr.umich.edu/DDI" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ddi="http://www.icpsr.umich.edu/DDI" xmlns:date="http://exslt.org/dates-and-times" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:exsl="http://exslt.org/common" xmlns:math="http://exslt.org/math" xmlns:str="http://exslt.org/strings" xmlns:doc="http://www.icpsr.umich.edu/doc" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:xdt="http://www.w3.org/2005/xpath-datatypes" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:fn="http://www.w3.org/2005/xpath-functions" version="1.0" extension-element-prefixes="date exsl str">
  <xsl:output version="1.0" encoding="UTF-8" indent="no" omit-xml-declaration="no" media-type="text/html"/>

  <!-- ====================== -->
  <!-- match: rdf:Description -->
  <!-- [fo:block]             -->
  <!-- ====================== -->

  <!--
    global vars read:
    $msg, $color-gray1, $color-gray2, $color-white,
    $show-documentation-description,

    local vars set:
    $date

    XPath 1.0 functions called:
    normalize-space(), string-length(), boolean(), position()

    XSLT 1.0 functions called:
    generate-id()

    templates called:
    [isodate-month], [trim]
  -->

  <xsl:template match="rdf:Description">

    <!-- ================== -->
    <!-- r) [fo:block] Main -->
    <!-- ================== -->
    <fo:block id="{generate-id()}" background-color="{$color-gray1}" space-after="0.2in"
              border-top="0.5pt solid {$color-gray2}"
              border-bottom="0.5pt solid {$color-gray2}"
              padding-bottom="0.05in" padding-top="0.05in">

      <!-- 1) [fo:inline] Title -->
      <fo:inline font-weight="bold">
        <xsl:choose>
          <xsl:when test="normalize-space(dc:title)">
            <xsl:value-of select="normalize-space(dc:title)"/>
          </xsl:when>
          <xsl:otherwise>***
            <xsl:value-of select="$msg/*/entry[@key='Untitled']"/>
            ***
          </xsl:otherwise>
        </xsl:choose>
      </fo:inline>

      <!-- 2) [fo:inline] Subtitle -->
      <xsl:if test="normalize-space(dcterms:alternative)">
        <xsl:text>, </xsl:text>
        <fo:inline font-style="italic">
          <xsl:value-of select="normalize-space(dcterms:alternative)"/>
        </fo:inline>
      </xsl:if>

      <!-- 3) [-] Author -->
      <xsl:if test="normalize-space(dc:creator)">
        <xsl:text>, </xsl:text>
        <xsl:value-of select="normalize-space(dc:creator)"/>
      </xsl:if>

      <!-- 4) [-] Date -->
      <xsl:if test="normalize-space(dcterms:created)">
        <xsl:variable name="date" select="normalize-space(dcterms:created)"/>
        <xsl:text>, </xsl:text>
        <xsl:if test="string-length($date) &gt;= 7">
          <xsl:call-template name="isodate-month">
            <xsl:with-param name="isodate" select="$date"/>
          </xsl:call-template>
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:if test="string-length($date) &gt;= 4">
          <xsl:value-of select="substring($date,1,4)"/>
        </xsl:if>
      </xsl:if>

      <!-- 5) [-] Country -->
      <xsl:if test="normalize-space(dcterms:spatial)">
        <xsl:text>, </xsl:text>
        <xsl:value-of select="normalize-space(dcterms:spatial)"/>
      </xsl:if>

      <!-- 6) [-] Language -->
      <xsl:if test="normalize-space(dc:language)">
        <xsl:text>, </xsl:text>
        <xsl:value-of select="normalize-space(dc:language)"/>
      </xsl:if>

      <!-- 7) [-] Source -->
      <xsl:if test="normalize-space(@rdf:about)">
        <xsl:text>,  "</xsl:text>
        <xsl:value-of select="normalize-space(@rdf:about)"/>
        <xsl:text>"</xsl:text>
      </xsl:if>

      <!-- 8) [fo:block] Description -->
      <xsl:if test="boolean($show-documentation-description)">
        <xsl:if test="normalize-space(dc:description)">
          <fo:block background-color="{$color-gray2}" border-top="0.5pt solid {$color-white}" font-size="8pt" font-weight="bold" padding-top="0.05in" space-before="0.05in">
            <xsl:value-of select="$msg/*/entry[@key='Description']"/>
          </fo:block>
          <fo:block font-size="8pt" padding-top="0.05in" white-space-collapse="false">
            <xsl:call-template name="trim">
              <xsl:with-param name="s" select="dc:description"/>
            </xsl:call-template>
          </fo:block>
        </xsl:if>
      </xsl:if>

      <!-- 9) [fo:block] Abstract -->
      <xsl:if test="boolean($show-documentation-abstract)">
        <xsl:if test="normalize-space(dcterms:abstract)">
          <fo:block background-color="{$color-gray2}" border-top="0.5pt solid {$color-white}" font-size="8pt" font-weight="bold" padding-top="0.05in" space-before="0.05in">
            <xsl:value-of select="$msg/*/entry[@key='Abstract']"/>
          </fo:block>
          <fo:block font-size="8pt" padding-top="0.05in" white-space-collapse="false">
            <xsl:call-template name="trim">
              <xsl:with-param name="s" select="dcterms:abstract"/>
            </xsl:call-template>
          </fo:block>
        </xsl:if>
      </xsl:if>

      <!-- 10) [fo:block] TOC-->
      <xsl:if test="boolean($show-documentation-toc)">
        <xsl:if test="normalize-space(dcterms:tableOfContents)">
          <fo:block background-color="{$color-gray2}" border-top="0.5pt solid {$color-white}" font-size="8pt" font-weight="bold" padding-top="0.05in" space-before="0.05in">
            <xsl:value-of select="$msg/*/entry[@key='Table_of_Contents']"/>
          </fo:block>
          <fo:block font-size="8pt" padding-top="0.05in" white-space-collapse="false">
            <xsl:call-template name="trim">
              <xsl:with-param name="s" select="dcterms:tableOfContents"/>
            </xsl:call-template>
          </fo:block>
        </xsl:if>
      </xsl:if>

      <!-- 11) [fo:block] Subjects -->
      <xsl:if test="boolean($show-documentation-subjects)">
        <xsl:if test="normalize-space(dc:subject)">
          <fo:block background-color="{$color-gray2}" border-top="0.5pt solid {$color-white}" font-size="8pt" font-weight="bold" padding-top="0.05in" space-before="0.05in">
            <xsl:value-of select="$msg/*/entry[@key='Subjects']"/>
          </fo:block>
          <fo:block font-size="8pt" padding-top="0.05in" white-space-collapse="false">
            <xsl:for-each select="dc:subject">
              <xsl:if test="position()&gt;1">
                <xsl:text>, </xsl:text>
              </xsl:if>
              <xsl:value-of select="normalize-space(.)"/>
            </xsl:for-each>
          </fo:block>
        </xsl:if>
      </xsl:if>

    </fo:block>

  </xsl:template>
</xsl:stylesheet>