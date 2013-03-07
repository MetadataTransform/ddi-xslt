<?xml version='1.0' encoding='utf-8'?>

<!-- ddi_varGrp.xsl -->

<xsl:stylesheet xmlns:n1="http://www.icpsr.umich.edu/DDI" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ddi="http://www.icpsr.umich.edu/DDI" xmlns:date="http://exslt.org/dates-and-times" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:exsl="http://exslt.org/common" xmlns:math="http://exslt.org/math" xmlns:str="http://exslt.org/strings" xmlns:doc="http://www.icpsr.umich.edu/doc" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:xdt="http://www.w3.org/2005/xpath-datatypes" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:fn="http://www.w3.org/2005/xpath-functions" version="1.0" extension-element-prefixes="date exsl str">
  <xsl:output version="1.0" encoding="UTF-8" indent="no" omit-xml-declaration="no" media-type="text/html"/>

  <!-- ================= -->
  <!-- match: ddi:varGrp -->
  <!-- fo:table          -->
  <!-- ================= -->

  <!--
    global vars read:
    $subsetGroups, $msg, $default-border, $cell-padding

    local vars set:
    $list

    Xpath 1.0 functions called:
    contains(), concat(), position(), string-length(), normalize-space()

    FO functions called:
    proportional-column-width()

    templates called:
    [variables-table-column-width], [variables-table-column-header]
  -->

  <!--
    1: Group Name     <fo:table-row>
    2: Text           <fo:table-row>
    3: Definition     <fo:table-row>
    4: Universe       <fo:table-row>
    5: Notes          <fo:table-row>
    6: Subgroups      <fo:table-row>
  -->

  <xsl:template match="ddi:varGrp">
    <xsl:if test="contains($subsetGroups,concat(',',@ID,',')) or string-length($subsetGroups)=0">

      <!-- ================== -->
      <!-- r) [fo:table] Main -->
      <!-- ================== -->
      <fo:table id="vargrp-{@ID}" table-layout="fixed" width="100%" space-before="0.2in">

        <!-- Set up columns -->
        <fo:table-column column-width="proportional-column-width(20)"/>
        <fo:table-column column-width="proportional-column-width(80)"/>

        <fo:table-body>

          <!-- 1) [fo:table-row] Group name -->
          <fo:table-row>
            <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
              <fo:block font-size="12pt" font-weight="bold">
                <xsl:value-of select="$msg/*/entry[@key='Group']"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="normalize-space(ddi:labl)"/>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>

          <!-- 2) [fo:table-row] Text -->
          <xsl:for-each select="ddi:txt">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="."/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:for-each>

          <!-- 3) [fo:table-row] Definition -->
          <xsl:for-each select="ddi:defntn">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$msg/*/entry[@key='Definition']"/>
                </fo:block>
                <xsl:apply-templates select="."/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:for-each>

          <!-- 4) [fo:table-row] Universe-->
          <xsl:for-each select="ddi:universe">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$msg/*/entry[@key='Universe']"/>
                </fo:block>
                <xsl:apply-templates select="."/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:for-each>

          <!-- 5) [fo:table-row] Notes -->
          <xsl:for-each select="ddi:notes">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$msg/*/entry[@key='Notes']"/>
                </fo:block>
                <xsl:apply-templates select="."/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:for-each>

          <!-- 6) [fo:table-row] Subgroups -->
          <xsl:if test="./@varGrp">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$msg/*/entry[@key='Subgroups']"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <!-- loop over groups in codeBook that are in this sequence -->
                  <xsl:variable name="list" select="concat(./@varGrp,' ')"/>
                  <!-- add a space at the end of the list for matching purposes -->
                  <xsl:for-each select="/ddi:codeBook/ddi:dataDscr/ddi:varGrp[contains($list,concat(@ID,' '))]">
                    <!-- add a space to the ID to avoid partial match -->
                    <xsl:if test="position()&gt;1">,</xsl:if>
                    <xsl:value-of select="./ddi:labl"/>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
        </fo:table-body>
      </fo:table>


      <!-- ========================== -->
      <!-- [fo:table] Variables table -->
      <!-- ========================== -->
      <xsl:if test="./@var"> <!-- Look for variables in this group -->
        <fo:table id="varlist-{@ID}" table-layout="fixed"
                  width="100%" font-size="8pt" space-after="0.0in">

          <xsl:call-template name="variables-table-col-width"/>

          <!-- table header -->
          <fo:table-header>
            <xsl:call-template name="variables-table-col-header"/>
          </fo:table-header>

          <!-- table body -->
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell>
                <fo:block>
                  <!-- ToDo: -->
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
            <xsl:variable name="list" select="concat(./@var,' ')"/>
            <!-- add a space at the end of the list for matching purposes -->
            <xsl:apply-templates select="/ddi:codeBook/ddi:dataDscr/ddi:var[ contains($list,concat(@ID,' ')) ]" mode="variables-list"/>
            <!-- add a space to the ID to avoid partial match -->
          </fo:table-body>
        </fo:table>
      </xsl:if>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>