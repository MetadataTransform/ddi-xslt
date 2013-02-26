<?xml version='1.0' encoding='utf-8'?>

<!-- ddi_match.xsl                              -->
<!-- Matching templates for ddi: namespace tags -->

<xsl:stylesheet xmlns:n1="http://www.icpsr.umich.edu/DDI"xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ddi="http://www.icpsr.umich.edu/DDI" xmlns:date="http://exslt.org/dates-and-times" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:exsl="http://exslt.org/common" xmlns:math="http://exslt.org/math" xmlns:str="http://exslt.org/strings" xmlns:doc="http://www.icpsr.umich.edu/doc" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:xdt="http://www.w3.org/2005/xpath-datatypes" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:fn="http://www.w3.org/2005/xpath-functions" version="1.0" extension-element-prefixes="date exsl str">
  <xsl:output version="1.0" encoding="UTF-8" indent="no" omit-xml-declaration="no" media-type="text/html"/>

  <!-- =============================== -->
  <!-- match: ddi:var / variables-list -->
  <!-- fo:table-row                    -->
  <!-- =============================== -->

  <!--
    parameters:
    ($fileId)

    global vars read:
    $subserVars, $color-white, $default-border, $cell-padding,
    $show-variables-list, $variable-name-length,

    XPath 1.0 functions called:
    concat(), contains(), count(), position(), normalize-space(),
    string-length(), substring()
  -->

  <!--
    1: Variable Position          <fo:table-cell>
    2: Variable Name              <fo:table-cell>
    3: Variable Label             <fo:table-cell>
    4: Variable Type              <fo:table-cell>
    5: Variable Format            <fo:table-cell>
    6: Variable Valid             <fo:table-cell>
    7: Variable Invalid           <fo:table-cell>
    8: Variable Literal Question  <fo:table-cell>
  -->

  <xsl:template match="ddi:var" mode="variables-list">

    <!-- ========== -->
    <!-- Parameters -->
    <!-- ========== -->
    <xsl:param name="fileId" select="./@files"/> <!-- (use first file in @files if not specified) -->

    <!-- ====================== -->
    <!-- r) [fo:table-row] Main -->
    <!-- ====================== -->
    <xsl:if test="contains($subsetVars,concat(',',@ID,',')) or string-length($subsetVars)=0 ">
      <fo:table-row text-align="center" vertical-align="top">

        <!-- Set background colour for this row -->
        <!-- (choosing between two of the same?)-->
        <xsl:choose>
          <xsl:when test="position() mod 2 = 0">
            <xsl:attribute name="background-color">
              <xsl:value-of select="$color-white"/>
            </xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="background-color">
              <xsl:value-of select="$color-white"/>
            </xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>

        <!-- 1) [fo:table-cell] Variable Position -->
        <fo:table-cell text-align="center" border="{$default-border}" padding="{$cell-padding}">
          <fo:block>
            <xsl:value-of select="position()"/>
          </fo:block>
        </fo:table-cell>

        <!-- 2) [fo:table-cell] Variable Name-->
        <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
          <fo:block>
            <xsl:choose>
              <xsl:when test="$show-variables-list = 1">
                <fo:basic-link internal-destination="var-{@ID}" text-decoration="underline" color="blue">
                  <xsl:if test="string-length(@name) &gt; 10">
                    <xsl:value-of select="substring(./@name,0,$variable-name-length)"/> ..
                  </xsl:if>
                  <xsl:if test="11 &gt; string-length(@name)">
                    <xsl:value-of select="./@name"/>
                  </xsl:if>
                </fo:basic-link>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="./@name"/>
              </xsl:otherwise>
            </xsl:choose>
          </fo:block>
        </fo:table-cell>

        <!-- 3) [fo:table-cell] Variable Label -->
        <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
          <fo:block>
            <xsl:choose>
              <xsl:when test="normalize-space(./ddi:labl)">
                <xsl:value-of select="normalize-space(./ddi:labl)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>-</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </fo:block>
        </fo:table-cell>

        <!-- 4) [fo:table-cell] Variable type -->
        <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
          <fo:block>
            <xsl:choose>
              <xsl:when test="normalize-space(@intrvl)">
                <xsl:choose>
                  <xsl:when test="@intrvl='discrete'">
                    <xsl:value-of select="$msg/*/entry[@key='discrete']"/>
                  </xsl:when>
                  <xsl:when test="@intrvl='contin'">
                    <xsl:value-of select="$msg/*/entry[@key='continuous']"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$msg/*/entry[@key='Undetermined']"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>-</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </fo:block>
        </fo:table-cell>

        <!-- 5) [fo:table-cell] Variable format -->
        <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
          <fo:block>
            <xsl:choose>
              <xsl:when test="normalize-space(ddi:varFormat/@type)">
                <xsl:value-of select="ddi:varFormat/@type"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>-</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="normalize-space(ddi:location/@width)">
              <xsl:text>-</xsl:text>
              <xsl:value-of select="ddi:location/@width"/>
            </xsl:if>
            <xsl:if test="normalize-space(@dcml)">
              <xsl:text>.</xsl:text>
              <xsl:value-of select="@dcml"/>
            </xsl:if>
          </fo:block>
        </fo:table-cell>

        <!-- 6) [fo:table-cell] Variable valid -->
        <fo:table-cell text-align="center" border="{$default-border}" padding="{$cell-padding}">
          <fo:block>
            <xsl:choose>
              <xsl:when test="count(ddi:sumStat[@type='vald'])&gt;0">
                <xsl:for-each select="ddi:sumStat[@type='vald']">
                  <xsl:if test="position()=1">
                    <xsl:value-of select="."/>
                  </xsl:if>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>-</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </fo:block>
        </fo:table-cell>

        <!-- 7) [fo:table-cell] Variable invalid -->
        <fo:table-cell text-align="center" border="{$default-border}" padding="{$cell-padding}">
          <fo:block>
            <xsl:choose>
              <xsl:when test="count(ddi:sumStat[@type='invd'])&gt;0">
                <xsl:for-each select="ddi:sumStat[@type='invd']">
                  <xsl:if test="position()=1">
                    <xsl:value-of select="."/>
                  </xsl:if>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>-</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </fo:block>
        </fo:table-cell>

        <!-- 8) [fo:table-cell] Variable literal question -->
        <xsl:if test="$show-variables-list-question">
          <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
            <fo:block>
              <xsl:choose>
                <xsl:when test="normalize-space(./ddi:qstn/ddi:qstnLit)">
                  <xsl:value-of select="normalize-space(./ddi:qstn/ddi:qstnLit)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>-</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </fo:block>
          </fo:table-cell>
        </xsl:if>

      </fo:table-row>
    </xsl:if>

  </xsl:template>
</xsl:stylesheet>