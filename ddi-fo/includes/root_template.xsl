<?xml version='1.0' encoding='utf-8'?>

<!-- root_template.xsl -->

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

  <!--
    ===================================================================
    xsl:template match: /
    <fo:root>

    the root of the FO document starts and ends in this template
    ===================================================================
  -->

  <!--
    Sections:
    0: Setup FO page sizes and layouts  <fo:layout-master-set>
    1: Outline / Bookmarks              <fo:bookmark-tree>
    2: Cover page                       <fo:page-sequence>
    3: Metadata information             <fo:page-sequence>
    4: TOC                              <fo:page-sequence>
    5: Overview                         <fo:page-sequence>
    6: Files Description                <fo:page-sequence>
    7: Variables List                   <fo:page-sequence>
    8: Variable Groups                  <fo:page-sequence>
    9: Variables Description            <fo:page-sequence>
   10: Documentation                    <fo:page-sequence>
  -->

  <xsl:template match="/">
    <fo:root>

      <!-- ============================================ -->
      <!-- [0] Setup page sizes and layouts             -->
      <!-- [fo:layout-master-set]                       -->
      <!-- ============================================ -->
      <fo:layout-master-set>

        <!-- [fo:simple-page-master] US Letter (default page type) -->
        <fo:simple-page-master master-name="default-page"
                               page-height="11in" page-width="8.5in"
                               margin-left="0.7in" margin-right="0.7in"
                               margin-top="0.3in" margin-bottom="0.3in">
          <fo:region-body margin-top="0.5in" margin-bottom="0.5in" region-name="xsl-region-body"/>
          <fo:region-before extent="0.5in" region-name="xsl-region-before"/>
          <fo:region-after extent="0.5in" region-name="xsl-region-after"/>
        </fo:simple-page-master>

        <!-- [fo:simple-page-master] US Letter, landscape format -->
        <fo:simple-page-master master-name="landscape-page"
                               page-height="8.5in" page-width="11in"
                               margin-left="0.7in" margin-right="0.7in"
                               margin-top="0.3in" margin-bottom="0.3in">
          <fo:region-body margin-top="0.5in" margin-bottom="0.5in" region-name="xsl-region-body"/>
          <fo:region-before extent="0.5in" region-name="xsl-region-before"/>
          <fo:region-after extent="0.5in" region-name="xsl-region-after"/>
        </fo:simple-page-master>

        <!-- [fo:simple-page-master] A4 page -->
        <fo:simple-page-master master-name="A4"
                               page-height="297mm" page-width="210in"
                               margin-left="20mm" margin-right="20mm"
                               margin-top="20mm" margin-bottom="20mm">
          <fo:region-body margin-top="10mm" margin-bottom="10mm" region-name="xsl-region-body"/>
          <fo:region-before extent="10mm" region-name="xsl-region-before"/>
          <fo:region-after extent="10mm" region-name="xsl-region-after"/>
        </fo:simple-page-master>

      </fo:layout-master-set>


      <!-- ============================================ -->
      <!-- [1] Outline / Bookmarks                      -->
      <!-- [fo:bookmark-tree]                           -->
      <!-- ============================================ -->

      <!--
        global vars read:
        $show-cover-page, $show-metadata-info, $show-toc, $show-overview
        $show-scope-and-coverage, $show-producers-and-sponsors,
        $show-sampling, $show-data-collection, $show-data-processing-and-appraisal,
        $show-accessibility, $show-rights-and-disclaimer, $show-files-description,
        $showVariableGroups, $show-variables-list, $show-variables-description,
        $show-documentation

        XPath 1.0 functions called:
        nomalize-space(), contains(), concat(), string-length()

        templates called:
        [trim]
      -->

      <!--
        1: Cover Page                       <fo:bookmark>
        2: Metadata Info                    <fo:bookmark>
        3: TOC                              <fo:bookmark>
        4: Overview                         <fo:bookmark>
        4.1: Scope and Coverage             <fo:bookmark>
        4.2: Producers and Sponsors         <fo:bookmark>
        4.3: Sampling                       <fo:bookmark>
        4.4: Data Collection                <fo:bookmark>
        4.5: Data processing and Appraisal  <fo:bookmark>
        4.6: Accessibility                  <fo:bookmark>
        4.7: Rights and Disclaimer          <fo:bookmark>
        5: Files Description Section        <fo:bookmark>
        6: Variable Groups                  <fo:bookmark>
        7: Variables List                   <fo:bookmark>
        8: Variables Description            <fo:bookmark>
        9: Documentation Section            <fo:bookmark>
      -->

      <xsl:if test="$show-bookmarks = 1">

        <!-- ========================== -->
        <!-- r) [fo:bookmark-tree] Main -->
        <!-- ========================== -->
        <fo:bookmark-tree>

          <!-- 1) [fo:bookmark] Cover page -->
          <xsl:if test="$show-cover-page = 1">
            <fo:bookmark internal-destination="cover-page">
              <fo:bookmark-title>
                <xsl:value-of select="$msg/*/entry[@key='Cover_Page']"/>
              </fo:bookmark-title>
            </fo:bookmark>
          </xsl:if>

          <!-- 2) [fo:bookmark] metadata info -->
          <xsl:if test="$show-metadata-info = 1">
            <fo:bookmark internal-destination="metadata-info">
              <fo:bookmark-title>
                <xsl:value-of select="$msg/*/entry[@key='Document_Information']"/>
              </fo:bookmark-title>
            </fo:bookmark>
          </xsl:if>

          <!-- 3) [fo:bookmark] TOC -->
          <xsl:if test="$show-toc = 1">
            <fo:bookmark internal-destination="toc">
              <fo:bookmark-title>
                <xsl:value-of select="$msg/*/entry[@key='Table_of_Contents']"/>
              </fo:bookmark-title>
            </fo:bookmark>
          </xsl:if>

          <!-- 4) [fo:bookmark] overview -->
          <xsl:if test="$show-overview = 1">
            <fo:bookmark internal-destination="overview">
              <fo:bookmark-title>
                <xsl:value-of select="$msg/*/entry[@key='Overview']"/>
              </fo:bookmark-title>

              <!-- 4.1) [fo:bookmark] overview / scope and coverage -->
              <xsl:if test="$show-scope-and-coverage = 1">
                <fo:bookmark internal-destination="scope-and-coverage">
                  <fo:bookmark-title>
                    <xsl:value-of select="$msg/*/entry[@key='Scope_and_Coverage']"/>
                  </fo:bookmark-title>
                </fo:bookmark>
              </xsl:if>

              <!-- 4.2) [fo:bookmark] overview / producers and sponsors -->
              <xsl:if test="$show-producers-and-sponsors = 1">
                <fo:bookmark internal-destination="producers-and-sponsors">
                  <fo:bookmark-title>
                    <xsl:value-of select="$msg/*/entry[@key='Producers_and_Sponsors']"/>
                  </fo:bookmark-title>
                </fo:bookmark>
              </xsl:if>

              <!-- 4.3) [fo:bookmark] overview / sampling -->
              <xsl:if test="$show-sampling = 1">
                <fo:bookmark internal-destination="sampling">
                  <fo:bookmark-title>
                    <xsl:value-of select="$msg/*/entry[@key='Sampling']"/>
                  </fo:bookmark-title>
                </fo:bookmark>
              </xsl:if>

              <!-- 4.4) [fo:bookmark] overview / data collection -->
              <xsl:if test="$show-data-collection = 1">
                <fo:bookmark internal-destination="data-collection">
                  <fo:bookmark-title>
                    <xsl:value-of select="$msg/*/entry[@key='Data_Collection']"/>
                  </fo:bookmark-title>
                </fo:bookmark>
              </xsl:if>

              <!-- 4.5) [fo:bookmark] overview / data processing and appraisal -->
              <xsl:if test="$show-data-processing-and-appraisal = 1">
                <fo:bookmark internal-destination="data-processing-and-appraisal">
                  <fo:bookmark-title>
                    <xsl:value-of select="$msg/*/entry[@key='Data_Processing_and_Appraisal']"/>
                  </fo:bookmark-title>
                </fo:bookmark>
              </xsl:if>

              <!-- 4.6 [fo:bookmark] overview / accessibility -->
              <xsl:if test="$show-accessibility= 1">
                <fo:bookmark internal-destination="accessibility">
                  <fo:bookmark-title>
                    <xsl:value-of select="$msg/*/entry[@key='Accessibility']"/>
                  </fo:bookmark-title>
                </fo:bookmark>
              </xsl:if>

              <!-- 4.7 [fo:bookmark] overview / rights and disclaimer -->
              <xsl:if test="$show-rights-and-disclaimer = 1">
                <fo:bookmark internal-destination="rights-and-disclaimer">
                  <fo:bookmark-title>
                    <xsl:value-of select="$msg/*/entry[@key='Rights_and_Disclaimer']"/>
                  </fo:bookmark-title>
                </fo:bookmark>
              </xsl:if>
            </fo:bookmark>
          </xsl:if>

          <!-- 5) [fo:bookmark] files description -->
          <xsl:if test="$show-files-description = 1">
            <fo:bookmark internal-destination="files-description">
              <fo:bookmark-title>
                <xsl:value-of select="$msg/*/entry[@key='Files_Description']"/>
              </fo:bookmark-title>

              <xsl:for-each select="/ddi:codeBook/ddi:fileDscr">
                <fo:bookmark internal-destination="file-{ddi:fileTxt/ddi:fileName/@ID}">
                  <fo:bookmark-title>
                    <xsl:apply-templates select="ddi:fileTxt/ddi:fileName"/>
                  </fo:bookmark-title>
                </fo:bookmark>
              </xsl:for-each>
            </fo:bookmark>
          </xsl:if>

          <!-- 6) [fo:bookmark] variable groups -->
          <xsl:if test="$showVariableGroups = 1">
            <fo:bookmark internal-destination="variables-groups">
              <fo:bookmark-title>
                <xsl:value-of select="$msg/*/entry[@key='Variables_Groups']"/>
              </fo:bookmark-title>

              <xsl:for-each select="/ddi:codeBook/ddi:dataDscr/ddi:varGrp">
                <xsl:if test="contains($subsetGroups,concat(',',@ID,',')) or string-length($subsetGroups)=0">
                  <fo:bookmark internal-destination="vargrp-{@ID}">
                    <fo:bookmark-title>
                      <xsl:value-of select="normalize-space(ddi:labl)"/>
                    </fo:bookmark-title>
                  </fo:bookmark>
                </xsl:if>
              </xsl:for-each>
            </fo:bookmark>
          </xsl:if>

          <!-- 7) [fo:bookmark] variables list -->
          <xsl:if test="$show-variables-list = 1">
            <fo:bookmark internal-destination="variables-list">

              <fo:bookmark-title>
                <xsl:value-of select="$msg/*/entry[@key='Variables_List']"/>
              </fo:bookmark-title>

              <xsl:for-each select="/ddi:codeBook/ddi:fileDscr">
                <fo:bookmark internal-destination="varlist-{ddi:fileTxt/ddi:fileName/@ID}">
                  <fo:bookmark-title>
                    <xsl:apply-templates select="ddi:fileTxt/ddi:fileName"/>
                  </fo:bookmark-title>
                </fo:bookmark>
              </xsl:for-each>

            </fo:bookmark>
          </xsl:if>

          <!-- 8) [fo:bookmark] variables description -->
          <xsl:if test="$show-variables-description= 1">
            <fo:bookmark internal-destination="variables-description">
              <fo:bookmark-title>
                <xsl:value-of select="$msg/*/entry[@key='Variables_Description']"/>
              </fo:bookmark-title>

              <xsl:for-each select="/ddi:codeBook/ddi:fileDscr">
                <fo:bookmark internal-destination="vardesc-{ddi:fileTxt/ddi:fileName/@ID}">
                  <fo:bookmark-title>
                    <xsl:apply-templates select="ddi:fileTxt/ddi:fileName"/>
                  </fo:bookmark-title>
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

                  <xsl:for-each select="/ddi:codeBook/ddi:dataDscr/ddi:var[@files=$fileId]">
                    <xsl:if test="contains($subsetVars,concat(',',@ID,',')) or string-length($subsetVars)=0 ">
                      <fo:bookmark internal-destination="var-{@ID}">
                        <fo:bookmark-title>
                          <xsl:apply-templates select="@name"/>
                          <xsl:if test="normalize-space(ddi:labl)">
                            <xsl:text>: </xsl:text>
                            <xsl:call-template name="trim">
                              <xsl:with-param name="s" select="ddi:labl"/>
                            </xsl:call-template>
                          </xsl:if>
                        </fo:bookmark-title>
                      </fo:bookmark>
                    </xsl:if>
                  </xsl:for-each>

                </fo:bookmark>
              </xsl:for-each>
            </fo:bookmark>
          </xsl:if>

          <!-- 9) [fo:bookmark] Documentation section -->
          <xsl:if test="$show-documentation = 1 and normalize-space($rdf-file)">
            <fo:bookmark internal-destination="documentation">
              <fo:bookmark-title>
                <xsl:value-of select="$msg/*/entry[@key='Documentation']"/>
              </fo:bookmark-title>
            </fo:bookmark>
          </xsl:if>

        </fo:bookmark-tree>
      </xsl:if>


      <!-- ================================================= -->
      <!-- [2] Page sequence: Cover page                     -->
      <!-- [fo:page-sequence]                                -->
      <!-- ================================================= -->

      <!--
        global vars read:
        $show-logo, $show-geography, $show-cover-page-producer,
        $show-report-subtitle, $show-date

        functions called:
        normalize-space()

        templates called:
        [trim], [isodate-long]
      -->

      <!--
        1: Logo             <fo:block>
        2: Geography        <fo:block>
        3: Agency           <fo:block>
        4: Title            <fo:block>
        5: Report subtitle  <fo:block>
        6: Date             <fo:block>
      -->

      <xsl:if test="$show-cover-page = 1">

        <!-- ========================== -->
        <!-- r) [fo:page-sequence] Main -->
        <!-- ========================== -->
        <fo:page-sequence master-reference="default-page" font-family="Helvetica" font-size="10pt">

          <!-- [fo:flow] xsl-region-body -->
          <fo:flow flow-name="xsl-region-body">

            <!-- [fo:block] cover-page -->
            <fo:block id="cover-page">

              <!-- 1) [fo:block] Logo -->
              <xsl:if test="$show-logo" >
                <fo:block>
                  <fo:external-graphic src="snd_logo_sv.png" horizontal-align="middle" content-height="5mm"/>
                </fo:block>
              </xsl:if>

              <!-- 2) [fo:block] Geography -->
              <xsl:if test="$show-geography = 1">
                <fo:block font-size="14pt" font-weight="bold" space-before="0.5in" text-align="center" space-after="0.2in">
                  <xsl:value-of select="$geography"/>
                </fo:block>
              </xsl:if>

              <!-- 3) [fo:block] Agency/ies -->
              <xsl:if test="$show-cover-page-producer = 1">
                <xsl:for-each select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:rspStmt/ddi:AuthEnty">
                  <fo:block font-size="14pt" font-weight="bold" space-before="0.0in" text-align="center" space-after="0.0in">
                    <xsl:call-template name="trim">
                      <xsl:with-param name="s">
                        <xsl:value-of select="."/>
                      </xsl:with-param>
                    </xsl:call-template>
                    <xsl:if test="@affiliation">,
                      <xsl:value-of select="@affiliation"/>
                    </xsl:if>
                  </fo:block>
                </xsl:for-each>
              </xsl:if>

              <!-- 4) [fo:block] Title -->
              <fo:block font-size="18pt" font-weight="bold" space-before="0.5in" text-align="center" space-after="0.0in">
                <xsl:value-of select="normalize-space(/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:titlStmt/ddi:titl)"/>
              </fo:block>

              <!-- 5) [fo:block] Report subtitle -->
              <xsl:if test="show-report-subtitle">
                <fo:block font-size="16pt" font-weight="bold" space-before="1.0in" text-align="center" space-after="0.0in">
                  <xsl:value-of select="$report-title"/>
                </fo:block>
              </xsl:if>

              <!-- 6) [fo:block] Date -->
              <xsl:if test="$show-date = 1">
                <fo:block font-size="12pt" space-before="5.0in" text-align="center" space-after="0.1in">
                  <fo:block>
                    <xsl:call-template name="isodate-long">
                      <xsl:with-param name="isodate" select="$report-date"/>
                    </xsl:call-template>
                  </fo:block>
                </fo:block>
              </xsl:if>

            </fo:block>
          </fo:flow>
        </fo:page-sequence>
      </xsl:if>

      <!-- ==================================================== -->
      <!-- [3] Page sequence: Metadata information              -->
      <!-- [fo:page-sequence]                                   -->
      <!-- ==================================================== -->

      <!--
        global vars read:
        $font-family, $show-metadata-production, $msg,
        $default-border, $cell-padding

        XPath 1.0 functions called:
        boolean(), normalize-space()

        FO functions called:
        proportional-column-width()

        templates called:
        [isodate-long]
      -->

      <!--
        1: Metadata producers           <fo:table-row>
        2: Metadata Production Rate     <fo:table-row>
        3: Metadata Version             <fo:table-row>
        4: Metadata ID                  <fo:table-row>
        5: (Spacing?)                   <fo:table-row>
        6: Report Acknowledgements      <fo:block>
        7: Report Notes                 <fo:block>
      -->

      <xsl:if test="$show-metadata-info = 1">

        <!-- ========================== -->
        <!-- r) [fo:page-sequence] Main -->
        <!-- ========================== -->
        <fo:page-sequence master-reference="default-page"
                          font-family="{$font-family}" font-size="10pt">

          <!-- [fo:flow] xsl-region-body -->
          <fo:flow flow-name="xsl-region-body">

            <fo:block id="metadata-info" />

            <xsl:if test="boolean($show-metadata-production)">

              <!-- [fo:block] metadata-production -->
              <fo:block id="metadata-production" font-size="18pt" font-weight="bold" space-after="0.1in">
                <xsl:value-of select="$msg/*/entry[@key='Metadata_Production']"/>
              </fo:block>

              <!-- [fo:table] Metadata information main table -->
              <fo:table table-layout="fixed" width="100%" space-before="0.0in" space-after="0.2in">
                <fo:table-column column-width="proportional-column-width(20)"/>
                <fo:table-column column-width="proportional-column-width(80)"/>

                <fo:table-body>

                  <!-- 1) [fo:table-row] Metadata Producer(s) -->
                  <xsl:if test="/ddi:codeBook/ddi:docDscr/ddi:citation/ddi:prodStmt/ddi:producer">
                    <fo:table-row>
                      <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                        <fo:block>
                          <xsl:value-of select="$msg/*/entry[@key='Metadata_Producers']"/>
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                        <xsl:apply-templates select="/ddi:codeBook/ddi:docDscr/ddi:citation/ddi:prodStmt/ddi:producer"/>
                      </fo:table-cell>
                    </fo:table-row>
                  </xsl:if>

                  <!-- 2) [fo:table-row] Metadata Production Date -->
                  <xsl:if test="/ddi:codeBook/ddi:docDscr/ddi:citation/ddi:prodStmt/ddi:prodDate">
                    <fo:table-row>
                      <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                        <fo:block>
                          <xsl:value-of select="$msg/*/entry[@key='Production_Date']"/>
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                        <fo:block>
                          <xsl:call-template name="isodate-long">
                            <xsl:with-param name="isodate" select="normalize-space(/ddi:codeBook/ddi:docDscr/ddi:citation/ddi:prodStmt/ddi:prodDate)"/>
                          </xsl:call-template>
                        </fo:block>
                      </fo:table-cell>
                    </fo:table-row>
                  </xsl:if>

                  <!-- 3) [fo:table-row] Metadata Version -->
                  <xsl:if test="/ddi:codeBook/ddi:docDscr/ddi:citation/ddi:verStmt/ddi:version">
                    <fo:table-row>
                      <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                        <fo:block>
                          <xsl:value-of select="$msg/*/entry[@key='Version']"/>
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                        <xsl:apply-templates select="/ddi:codeBook/ddi:docDscr/ddi:citation/ddi:verStmt/ddi:version"/>
                      </fo:table-cell>
                    </fo:table-row>
                  </xsl:if>

                  <!-- 4) [fo:table-row] Metadata ID -->
                  <xsl:if test="/ddi:codeBook/ddi:docDscr/ddi:citation/ddi:titlStmt/ddi:IDNo">
                    <fo:table-row>
                      <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                        <fo:block>
                          <xsl:value-of select="$msg/*/entry[@key='Identification']"/>
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                        <xsl:apply-templates select="/ddi:codeBook/ddi:docDscr/ddi:citation/ddi:titlStmt/ddi:IDNo"/>
                      </fo:table-cell>
                    </fo:table-row>
                  </xsl:if>

                  <!-- 5) [fo:table-row] (Spacing?) -->
                  <fo:table-row>
                    <fo:table-cell>
                      <fo:block> </fo:block>
                    </fo:table-cell>
                  </fo:table-row>

                </fo:table-body>
              </fo:table>
            </xsl:if>

            <!-- 6) [fo:block] Report acknowledgements -->
            <xsl:if test="normalize-space($report-acknowledgments)">
              <fo:block font-size="18pt" font-weight="bold" space-after="0.1in">
                <xsl:value-of select="$msg/*/entry[@key='Acknowledgments']"/>
              </fo:block>
              <fo:block font-size="10pt" space-after="0.2in">
                <xsl:value-of select="$report-acknowledgments"/>
              </fo:block>
            </xsl:if>

            <!-- 7) [fo:block] Report notes -->
            <xsl:if test="normalize-space($report-notes)">
              <fo:block font-size="18pt" font-weight="bold" space-after="0.1in">
                <xsl:value-of select="$msg/*/entry[@key='Notes']"/>
              </fo:block>
              <fo:block font-size="10pt" space-after="0.2in">
                <xsl:value-of select="$report-notes"/>
              </fo:block>
            </xsl:if>

          </fo:flow>
        </fo:page-sequence>
      </xsl:if>


      <!-- ============================================== -->
      <!-- [4] Page sequence: TOC                         -->
      <!-- <fo:page-sequence>                             -->
      <!-- ============================================== -->

      <!--
        global vars read:
        $font-family, $msg, $show-overview, $show-scope-and-coverage,
        $show-producers-and-sponsors, $show-sampling, $show-data-collection
        $show-data-processing-and-appraisal, $show-accessibility,
        $show-rights-and-disclaimer, $show-files-description, $show-variables-list
        $showVariableGroups, $subsetGroups, $show-documentation

        XPath 1.0 functions called:
        normalize-space(), string-length(), contains(), concat()
      -->

      <!--
        1: Overview                       <fo:block>
        2: Scope and Coverage             <fo:block>
        3: Producers and Sponsors         <fo:block>
        4: Sampling                       <fo:block>
        5: Data Collection                <fo:block>
        6: Data Processing and Appraisal  <fo:block>
        7: Accessibility                  <fo:block>
        8: Rights and Disclaimer          <fo:block>
        9: Files and Description          <fo:block>
       10: Variables List                 <fo:block>
       11: Variable Groups                <fo:block>
       12: Variables Description          <fo:block>
       13: Documentation                  <fo:block>
      -->

      <xsl:if test="$show-toc = 1">

        <!-- ========================== -->
        <!-- r) [fo:page-sequence] Main -->
        <!-- ========================== -->
        <fo:page-sequence master-reference="default-page"
                          font-family="{$font-family}" font-size="10pt">

          <!-- [fo:flow] xsl-region-body -->
          <fo:flow flow-name="xsl-region-body">

            <!-- [fo:block] TOC -->
            <fo:block id="toc" font-size="18pt" font-weight="bold" space-before="0.5in" text-align="center" space-after="0.1in">
              <xsl:value-of select="$msg/*/entry[@key='Table_of_Contents']"/>
            </fo:block>

            <!-- [fo:block] Main block -->
            <fo:block margin-left="0.5in" margin-right="0.5in">

              <!-- 1) [fo:block] Overview -->
              <xsl:if test="$show-overview = 1">
                <fo:block font-size="10pt" text-align-last="justify">
                  <fo:basic-link internal-destination="overview" text-decoration="underline" color="blue">
                    <xsl:value-of select="$msg/*/entry[@key='Overview']"/>
                    <fo:leader leader-pattern="dots"/>
                    <fo:page-number-citation ref-id="overview"/>
                  </fo:basic-link>
                </fo:block>
              </xsl:if>

              <!-- 2) [fo:block] Scope and Coverage -->
              <xsl:if test="$show-scope-and-coverage = 1">
                <fo:block font-size="10pt" text-align-last="justify">
                  <fo:basic-link internal-destination="scope-and-coverage" text-decoration="underline" color="blue">
                    <xsl:value-of select="$msg/*/entry[@key='Scope_and_Coverage']"/>
                    <fo:leader leader-pattern="dots"/>
                    <fo:page-number-citation ref-id="scope-and-coverage"/>
                  </fo:basic-link>
                </fo:block>
              </xsl:if>

              <!-- 3) [fo:block] Producers and sponsors -->
              <xsl:if test="$show-producers-and-sponsors = 1">
                <fo:block font-size="10pt" text-align-last="justify">
                  <fo:basic-link internal-destination="producers-and-sponsors" text-decoration="underline" color="blue">
                    <xsl:value-of select="$msg/*/entry[@key='Producers_and_Sponsors']"/>
                    <fo:leader leader-pattern="dots"/>
                    <fo:page-number-citation ref-id="producers-and-sponsors"/>
                  </fo:basic-link>
                </fo:block>
              </xsl:if>

              <!-- 4) [fo:block] Sampling -->
              <xsl:if test="$show-sampling = 1">
                <fo:block font-size="10pt" text-align-last="justify">
                  <fo:basic-link internal-destination="sampling" text-decoration="underline" color="blue">
                    <xsl:value-of select="$msg/*/entry[@key='Sampling']"/>
                    <fo:leader leader-pattern="dots"/>
                    <fo:page-number-citation ref-id="sampling"/>
                  </fo:basic-link>
                </fo:block>
              </xsl:if>

              <!-- 5) [fo:block] Data collection -->
              <xsl:if test="$show-data-collection = 1">
                <fo:block font-size="10pt" text-align-last="justify">
                  <fo:basic-link internal-destination="data-collection" text-decoration="underline" color="blue">
                    <xsl:value-of select="$msg/*/entry[@key='Data_Collection']"/>
                    <fo:leader leader-pattern="dots"/>
                    <fo:page-number-citation ref-id="data-collection"/>
                  </fo:basic-link>
                </fo:block>
              </xsl:if>

              <!-- 6) [fo:block] Data processing and appraisal -->
              <xsl:if test="$show-data-processing-and-appraisal = 1">
                <fo:block font-size="10pt" text-align-last="justify">
                  <fo:basic-link internal-destination="data-processing-and-appraisal" text-decoration="underline" color="blue">
                    <xsl:value-of select="$msg/*/entry[@key='Data_Processing_and_Appraisal']"/>
                    <fo:leader leader-pattern="dots"/>
                    <fo:page-number-citation ref-id="data-processing-and-appraisal"/>
                  </fo:basic-link>
                </fo:block>
              </xsl:if>

              <!-- 7) [fo:block] Accessibility -->
              <xsl:if test="$show-accessibility= 1">
                <fo:block font-size="10pt" text-align-last="justify">
                  <fo:basic-link internal-destination="accessibility" text-decoration="underline" color="blue">
                    <xsl:value-of select="$msg/*/entry[@key='Accessibility']"/>
                    <fo:leader leader-pattern="dots"/>
                    <fo:page-number-citation ref-id="accessibility"/>
                  </fo:basic-link>
                </fo:block>
              </xsl:if>

              <!-- 8) [fo:block] Rights and disclaimer -->
              <xsl:if test="$show-rights-and-disclaimer = 1">
                <fo:block font-size="10pt" text-align-last="justify">
                  <fo:basic-link internal-destination="rights-and-disclaimer" text-decoration="underline" color="blue">
                    <xsl:value-of select="$msg/*/entry[@key='Rights_and_Disclaimer']"/>
                    <fo:leader leader-pattern="dots"/>
                    <fo:page-number-citation ref-id="rights-and-disclaimer"/>
                  </fo:basic-link>
                </fo:block>
              </xsl:if>

              <!-- 9) [fo:block] Files and description -->
              <xsl:if test="$show-files-description = 1">
                <fo:block font-size="10pt" text-align-last="justify">

                  <fo:basic-link internal-destination="files-description" text-decoration="underline" color="blue">
                    <xsl:value-of select="$msg/*/entry[@key='Files_Description']"/>
                    <fo:leader leader-pattern="dots"/>
                    <fo:page-number-citation ref-id="files-description"/>
                  </fo:basic-link>

                  <xsl:for-each select="/ddi:codeBook/ddi:fileDscr">
                    <fo:block margin-left="0.7in" font-size="10pt" text-align-last="justify">
                      <fo:basic-link internal-destination="file-{ddi:fileTxt/ddi:fileName/@ID}" text-decoration="underline" color="blue">
                        <xsl:apply-templates select="ddi:fileTxt/ddi:fileName"/>
                        <fo:leader leader-pattern="dots"/>
                        <fo:page-number-citation ref-id="file-{ddi:fileTxt/ddi:fileName/@ID}"/>
                      </fo:basic-link>
                    </fo:block>
                  </xsl:for-each>

                </fo:block>
              </xsl:if>

              <!-- 10) [fo:block] Variables list -->
              <xsl:if test="$show-variables-list = 1">
                <fo:block font-size="10pt" text-align-last="justify">
                  <fo:basic-link internal-destination="variables-list" text-decoration="underline" color="blue">
                    <xsl:value-of select="$msg/*/entry[@key='Variables_List']"/>
                    <fo:leader leader-pattern="dots"/>
                    <fo:page-number-citation ref-id="variables-list"/>
                  </fo:basic-link>
                  <xsl:for-each select="/ddi:codeBook/ddi:fileDscr">
                    <fo:block margin-left="0.7in" font-size="10pt" text-align-last="justify">
                      <fo:basic-link internal-destination="varlist-{ddi:fileTxt/ddi:fileName/@ID}" text-decoration="underline" color="blue">
                        <xsl:apply-templates select="ddi:fileTxt/ddi:fileName"/>
                        <fo:leader leader-pattern="dots"/>
                        <fo:page-number-citation ref-id="varlist-{ddi:fileTxt/ddi:fileName/@ID}"/>
                      </fo:basic-link>
                    </fo:block>
                  </xsl:for-each>
                </fo:block>
              </xsl:if>

              <!-- 11) [fo:block] Variable groups -->
              <xsl:if test="$showVariableGroups = 1">
                <fo:block font-size="10pt" text-align-last="justify">
                  <fo:basic-link internal-destination="variables-groups" text-decoration="underline" color="blue">
                    <xsl:value-of select="$msg/*/entry[@key='Variables_Groups']"/>
                    <fo:leader leader-pattern="dots"/>
                    <fo:page-number-citation ref-id="variables-groups"/>
                  </fo:basic-link>

                  <xsl:for-each select="/ddi:codeBook/ddi:dataDscr/ddi:varGrp">
                    <!-- Show group if its part of subset OR no subset is defined -->
                    <xsl:if test="contains($subsetGroups,concat(',',@ID,',')) or string-length($subsetGroups)=0">
                      <fo:block margin-left="0.7in" font-size="10pt" text-align-last="justify">
                        <fo:basic-link internal-destination="vargrp-{@ID}" text-decoration="underline" color="blue">
                          <xsl:value-of select="normalize-space(ddi:labl)"/>
                          <fo:leader leader-pattern="dots"/>
                          <fo:page-number-citation ref-id="vargrp-{@ID}"/>
                        </fo:basic-link>
                      </fo:block>
                    </xsl:if>
                  </xsl:for-each>
                </fo:block>
              </xsl:if>

              <!-- 12) [fo:block] Variables description -->
              <xsl:if test="$show-variables-description = 1">
                <fo:block font-size="10pt" text-align-last="justify">
                  <fo:basic-link internal-destination="variables-description" text-decoration="underline" color="blue">
                    <xsl:value-of select="$msg/*/entry[@key='Variables_Description']"/>
                    <fo:leader leader-pattern="dots"/>
                    <fo:page-number-citation ref-id="variables-description"/>
                  </fo:basic-link>
                  <xsl:for-each select="/ddi:codeBook/ddi:fileDscr">
                    <fo:block margin-left="0.7in" font-size="10pt" text-align-last="justify">
                      <fo:basic-link internal-destination="vardesc-{ddi:fileTxt/ddi:fileName/@ID}" text-decoration="underline" color="blue">
                        <xsl:apply-templates select="ddi:fileTxt/ddi:fileName"/>
                        <fo:leader leader-pattern="dots"/>
                        <fo:page-number-citation ref-id="vardesc-{ddi:fileTxt/ddi:fileName/@ID}"/>
                      </fo:basic-link>
                    </fo:block>
                  </xsl:for-each>
                </fo:block>
              </xsl:if>

              <!-- 13) [fo:block] Documentation -->
              <xsl:if test="$show-documentation">
                <fo:block font-size="10pt" text-align-last="justify">
                  <fo:basic-link internal-destination="documentation" text-decoration="underline" color="blue">
                    <xsl:value-of select="$msg/*/entry[@key='Documentation']"/>
                    <fo:leader leader-pattern="dots"/>
                    <fo:page-number-citation ref-id="documentation"/>
                  </fo:basic-link>
                </fo:block>
              </xsl:if>

            </fo:block>
          </fo:flow>
        </fo:page-sequence>
      </xsl:if>


      <!-- ================================================ -->
      <!-- [5] Page sequence: Overview                      -->
      <!-- <fo:page-sequence>                               -->
      <!-- ================================================ -->

      <!--
        global vars read:
        $report-start-page-number, $font-family, $msg, $color-gray3
        $default-border, $cell-padding, $survey-title, $color-gray1, $time

        XPath 1.0 functions called:
        nomalize-space(), position()

        FO functions called:
        proportional-column-width()

        templates called:
        [header], [footer]
      -->

      <!--
           Page Header
           Page Footer
           Page Flow
        1: Title Header           <fo:table-row>



        55: Copyright             <fo:table-row>
      -->


      <xsl:if test="$show-overview = 1">

        <!-- ========================== -->
        <!-- r) [fo:page-sequence] Main -->
        <!-- ========================== -->
        <fo:page-sequence master-reference="default-page"
                          initial-page-number="{$report-start-page-number}"
                          font-family="{$font-family}"
                          font-size="10pt">

          <!-- [-] Page Header -->
          <xsl:call-template name="header">
            <xsl:with-param name="section">
              <xsl:value-of select="$msg/*/entry[@key='Overview']"/>
            </xsl:with-param>
          </xsl:call-template>

          <!-- [-] Page Footer-->
          <xsl:call-template name="footer"/>

          <!-- [fo:flow] Main page flow -->
          <fo:flow flow-name="xsl-region-body">
            <fo:table table-layout="fixed" width="100%">

              <!-- [fo:table-column] Table setup -->
              <fo:table-column column-width="proportional-column-width(20)"/>
              <fo:table-column column-width="proportional-column-width(80)"/>

              <fo:table-body>

                <!-- 1) [fo:table-row] Title header -->
                <fo:table-row background-color="{$color-gray3}">
                  <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">

                    <!-- 1.1) [fo:block] Survey title and abbreviation -->
                    <fo:block font-size="14pt" font-weight="bold">
                      <xsl:value-of select="$survey-title"/>
                    </fo:block>

                    <!-- 1.2) [fo:block] Translated/parallel title -->
                    <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:titlStmt/ddi:parTitl">
                      <fo:block font-size="12pt" font-weight="bold" font-style="italic">
                        <xsl:value-of select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:titlStmt/ddi:parTitl"/>
                      </fo:block>
                    </xsl:if>

                  </fo:table-cell>
                </fo:table-row>

                <!-- [fo:table-row] =separator= -->
                <fo:table-row height="0.2in">
                  <fo:table-cell number-columns-spanned="2">
                    <fo:block />
                  </fo:table-cell>
                </fo:table-row>

                <!-- 3) [fo:table-row] Overview Section (Identification, Version and Overview ) -->
                <fo:table-row background-color="{$color-gray1}" keep-with-next="always">
                  <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block id="overview" font-size="12pt" font-weight="bold">
                      <xsl:value-of select="$msg/*/entry[@key='Overview']"/>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>

                <!-- 4) [fo:table-row] Type -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:serStmt/ddi:serName">
                  <fo:table-row>
                    <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block>
                        <xsl:value-of select="$msg/*/entry[@key='Type']"/>
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:serStmt/ddi:serName"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 5) [fo:table-row] Identification -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:titlStmt/ddi:IDNo">
                  <fo:table-row>
                    <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block>
                        <xsl:value-of select="$msg/*/entry[@key='Identification']"/>
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:titlStmt/ddi:IDNo"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 6) [fo:table-row] Version -->
                <xsl:for-each select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:verStmt/ddi:version">
                  <fo:table-row>
                    <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block>
                        <xsl:value-of select="$msg/*/entry[@key='Version']"/>
                      </fo:block>
                    </fo:table-cell>

                    <fo:table-cell border="{$default-border}" padding="{$cell-padding}">

                      <!-- production date & description -->
                      <xsl:for-each select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:verStmt/ddi:version">
                        <xsl:if test="@date">
                          <fo:block>
                            <xsl:value-of select="$msg/*/entry[@key='Production_Date']"/>:
                            <xsl:value-of select="@date"/>
                          </fo:block>
                        </xsl:if>
                        <xsl:apply-templates select="."/>
                      </xsl:for-each>

                      <xsl:for-each select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:verStmt/ddi:notes">
                        <fo:block text-decoration="underline">
                          <xsl:value-of select="$msg/*/entry[@key='Notes']"/>
                        </fo:block>
                        <xsl:apply-templates select="."/>
                      </xsl:for-each>

                    </fo:table-cell>
                  </fo:table-row>
                </xsl:for-each>

                <!-- 7) [fo:table-row] Series -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:serStmt/ddi:serInfo">
                  <fo:table-row>
                    <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block>
                        <xsl:value-of select="$msg/*/entry[@key='Series']"/>
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:serStmt/ddi:serInfo"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 8) [fo:table-row] Abstract -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:abstract">
                  <fo:table-row>
                    <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block font-weight="bold" text-decoration="underline">
                        <xsl:value-of select="$msg/*/entry[@key='Abstract']"/>
                      </fo:block>
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:abstract"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 9) [fo:table-row] Kind of Data -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:dataKind">
                  <fo:table-row>
                    <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block>
                        <xsl:value-of select="$msg/*/entry[@key='Kind_of_Data']"/>
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:dataKind"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 10) [fo:table-row] Unit of Analysis -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:anlyUnit">
                  <fo:table-row>
                    <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block>
                        <xsl:value-of select="$msg/*/entry[@key='Unit_of_Analysis']"/>
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:anlyUnit"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- ===[Separator]=== -->
                <fo:table-row height="0.2in">
                  <fo:table-cell number-columns-spanned="2">
                    <fo:block/>
                  </fo:table-cell>
                </fo:table-row>

                <!-- 11) [fo:table-row] Scope and Coverage -->
                <xsl:if test="$show-scope-and-coverage = 1">
                  <fo:table-row background-color="{$color-gray1}" keep-with-next="always">
                    <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block id="scope-and-coverage" font-size="12pt" font-weight="bold">
                        <xsl:value-of select="$msg/*/entry[@key='Scope_and_Coverage']"/>
                      </fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 12) [fo:table-row] Scope -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:notes">
                  <fo:table-row>
                    <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block font-weight="bold" text-decoration="underline">
                        <xsl:value-of select="$msg/*/entry[@key='Scope']"/>
                      </fo:block>
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:notes"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 13) [fo:table-row] Keywords -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:subject/ddi:keyword">
                  <fo:table-row>
                    <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block>
                        <xsl:value-of select="$msg/*/entry[@key='Keywords']"/>
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                      <fo:block>
                        <xsl:for-each select="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:subject/ddi:keyword">
                          <xsl:if test="position()&gt;1">, </xsl:if>
                          <xsl:value-of select="normalize-space(.)"/>
                        </xsl:for-each>
                      </fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 14) [fo:table-row] Topic Classifications -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:subject/ddi:topcClas">
                  <fo:table-row>
                    <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block>
                        <xsl:value-of select="$msg/*/entry[@key='Topics']"/>
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                      <fo:block>
                        <xsl:for-each select="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:subject/ddi:topcClas">
                          <xsl:if test="position()&gt;1">, </xsl:if>
                          <xsl:value-of select="normalize-space(.)"/>
                        </xsl:for-each>
                      </fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 15) [fo:table-row] Geographic Coverage -->
                <xsl:if test="string-length($time)&gt;3 or string-length($timeProduced)&gt;3">
                  <fo:table-row>
                    <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                      <fo:block font-weight="bold" text-decoration="underline">
                        <xsl:value-of select="$msg/*/entry[@key='Time_Periods']"/>
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                      <xsl:choose>
                        <xsl:when test="string-length($time)&gt;3">
                          <fo:block>
                            <xsl:value-of select="$time"/>
                          </fo:block>
                        </xsl:when>
                        <xsl:when test="string-length($timeProduced)&gt;3">
                          <fo:block>
                            <xsl:value-of select="$timeProduced"/>
                          </fo:block>
                        </xsl:when>
                      </xsl:choose>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 16) [fo:table-row] -->
                <fo:table-row>
                  <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                    <fo:block font-weight="bold" text-decoration="underline">
                      <xsl:value-of select="$msg/*/entry[@key='Countries']"/>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                    <fo:block>
                      <xsl:value-of select="$geography"/>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>

                <!-- 17) [fo:table-row] -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:geogCover">
                  <fo:table-row>
                    <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block font-weight="bold" text-decoration="underline">
                        <xsl:value-of select="$msg/*/entry[@key='Geographic_Coverage']"/>
                      </fo:block>
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:geogCover"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 18) [fo:table-row] Universe -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:universe">
                  <fo:table-row>
                    <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block font-weight="bold" text-decoration="underline">
                        <xsl:value-of select="$msg/*/entry[@key='Universe']"/>
                      </fo:block>
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:universe"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- ===[Separator]=== -->
                <fo:table-row height="0.2in">
                  <fo:table-cell number-columns-spanned="2">
                    <fo:block/>
                  </fo:table-cell>
                </fo:table-row>

                <!-- 19) [fo:table-row] Producers and Sponsors -->
                <xsl:if test="$show-producers-and-sponsors = 1">
                  <fo:table-row background-color="{$color-gray1}" keep-with-next="always">
                    <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block id="producers-and-sponsors" font-size="12pt" font-weight="bold">
                        <xsl:value-of select="$msg/*/entry[@key='Producers_and_Sponsors']"/>
                      </fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 20) [fo:table-row] Primary Investigator(s) -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:rspStmt/ddi:AuthEnty">
                  <fo:table-row>
                    <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block>
                        <xsl:value-of select="$msg/*/entry[@key='Primary_Investigators']"/>
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:rspStmt/ddi:AuthEnty"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 21) [fo:table-row] Other Producer(s) -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:prodStmt/ddi:producer">
                  <fo:table-row>
                    <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block>
                        <xsl:value-of select="$msg/*/entry[@key='Other_Producers']"/>
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:prodStmt/ddi:producer"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 22) [fo:table-row] Funding -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:prodStmt/ddi:fundAg">
                  <fo:table-row>
                    <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block>
                        <xsl:value-of select="$msg/*/entry[@key='Funding_Agencies']"/>
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:prodStmt/ddi:fundAg"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 23) [fo:table-row] Other Acknowledgements -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:rspStmt/ddi:othId">
                  <fo:table-row>
                    <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block>
                        <xsl:value-of select="$msg/*/entry[@key='Other_Acknowledgments']"/>
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:rspStmt/ddi:othId"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- ===[separator]=== -->
                <fo:table-row height="0.2in">
                  <fo:table-cell number-columns-spanned="2">
                    <fo:block/>
                  </fo:table-cell>
                </fo:table-row>

                <!-- 24) [fo:table-row] Sampling -->
                <xsl:if test="$show-sampling = 1">
                  <fo:table-row background-color="{$color-gray1}">
                    <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block id="sampling" font-size="12pt" font-weight="bold">
                        <xsl:value-of select="$msg/*/entry[@key='Sampling']"/>
                      </fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 25) [fo:table-row] Sampling Procedure -->
                <xsl:choose>

                  <!-- Case: DDI flavour is DDP -->
                  <!-- DDP: stores the sampling method in <sampProc> and comments -->
                  <!-- in a <notes> element with subject='sampling' -->
                  <xsl:when test=" $ddi-flavor='ddp' ">
                    <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:sampProc">
                      <fo:table-row>
                        <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                          <fo:block font-weight="bold">
                            <xsl:value-of select="$msg/*/entry[@key='Sampling']"/>
                          </fo:block>
                        </fo:table-cell>
                        <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                          <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:sampProc"/>
                        </fo:table-cell>
                      </fo:table-row>
                    </xsl:if>

                    <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:notes[@subject='sampling']">
                      <fo:table-row>
                        <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                          <fo:block font-weight="bold" text-decoration="underline">
                            <xsl:value-of select="$msg/*/entry[@key='Sampling_Notes']"/>
                          </fo:block>
                          <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:notes[@subject='sampling']"/>
                        </fo:table-cell>
                      </fo:table-row>
                    </xsl:if>
                  </xsl:when>

                  <!-- Toolkit: the sampling information is free text in -->
                  <!-- the <sampProc> element -->
                  <xsl:otherwise>
                    <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:sampProc">
                      <fo:table-row>
                        <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                          <fo:block font-weight="bold" text-decoration="underline">
                            <xsl:value-of select="$msg/*/entry[@key='Sampling_Procedure']"/>
                          </fo:block>
                          <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:sampProc"/>
                        </fo:table-cell>
                      </fo:table-row>
                    </xsl:if>
                  </xsl:otherwise>

                </xsl:choose>

                <!-- 26) [fo:table-row] Deviations from Sample -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:deviat">
                  <fo:table-row>
                    <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block font-weight="bold" text-decoration="underline">
                        <xsl:value-of select="$msg/*/entry[@key='Deviations_from_Sample_Design']"/>
                      </fo:block>
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:deviat"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 27) [fo:table-row] Response Rate -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:anlyInfo/ddi:respRate">
                  <fo:table-row>
                    <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block font-weight="bold" text-decoration="underline">
                        <xsl:value-of select="$msg/*/entry[@key='Response_Rate']"/>
                      </fo:block>
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:anlyInfo/ddi:respRate"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 28) [fo:table-row] Weighting -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:weight">
                  <fo:table-row>
                    <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block font-weight="bold" text-decoration="underline">
                        <xsl:value-of select="$msg/*/entry[@key='Weighting']"/>
                      </fo:block>
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:weight"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- ===[separator]=== -->
                <fo:table-row height="0.2in">
                  <fo:table-cell number-columns-spanned="2">
                    <fo:block/>
                  </fo:table-cell>
                </fo:table-row>

                <!-- 29) [fo:table-row] Data Collection -->
                <xsl:if test="$show-data-collection = 1">
                  <fo:table-row background-color="{$color-gray1}" keep-with-next="always">
                    <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block id="data-collection" font-size="12pt" font-weight="bold">
                        <xsl:value-of select="$msg/*/entry[@key='Data_Collection']"/>
                      </fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 30) [fo:table-row] Data Collection Dates -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:collDate">
                  <fo:table-row>
                    <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block>
                        <xsl:value-of select="$msg/*/entry[@key='Data_Collection_Dates']"/>
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:collDate"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 31) [fo:table-row] Time Periods -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:timePrd">
                  <fo:table-row>
                    <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block>
                        <xsl:value-of select="$msg/*/entry[@key='Time_Periods']"/>
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:timePrd"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 32) [fo:table-row] Data Collection Mode -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:collMode">
                  <fo:table-row>
                    <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block>
                        <xsl:value-of select="$msg/*/entry[@key='Data_Collection_Mode']"/>
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:collMode"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- DATA COLLECTION NOTES -->

                <!-- 33) [fo:table-row] DDP Data Collection Notes -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:notes[@subject='collection']">
                  <fo:table-row>
                    <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block font-weight="bold" text-decoration="underline">
                        <xsl:value-of select="$msg/*/entry[@key='Data_Collection_Notes']"/>
                      </fo:block>
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:notes[@subject='collection']"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 34) [fo:table-row] DDP Data Processing Notes -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:notes[@subject='processing']">
                  <fo:table-row>
                    <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block font-weight="bold" text-decoration="underline">
                        <xsl:value-of select="$msg/*/entry[@key='Data_Processing_Notes']"/>
                      </fo:block>
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:notes[@subject='collection']"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 35) [fo:table-row] DDP Data Cleaning Notes -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:notes[@subject='cleaning']">
                  <fo:table-row>
                    <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block font-weight="bold" text-decoration="underline">
                        <xsl:value-of select="$msg/*/entry[@key='Data_Cleaning_Notes']"/>
                      </fo:block>
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:notes[@subject='collection']"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 36) [fo:table-row] Default -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:collSitu">
                  <fo:table-row>
                    <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block font-weight="bold" text-decoration="underline">
                        <xsl:value-of select="$msg/*/entry[@key='Data_Collection_Notes']"/>
                      </fo:block>
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:collSitu"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 37) [fo:table-row] Questionnaires -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:resInstru">
                  <fo:table-row>
                    <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block font-weight="bold" text-decoration="underline">
                        <xsl:value-of select="$msg/*/entry[@key='Questionnaires']"/>
                      </fo:block>
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:resInstru"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 38) [fo:table-row] Data Collectors -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:dataCollector">
                  <fo:table-row>
                    <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block>
                        <xsl:value-of select="$msg/*/entry[@key='Data_Collectors']"/>
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:dataCollector"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 39) [fo:table-row] Supervision -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:actMin">
                  <fo:table-row>
                    <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block font-weight="bold" text-decoration="underline">
                        <xsl:value-of select="$msg/*/entry[@key='Supervision']"/>
                      </fo:block>
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:actMin"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- [fo:table-row] separator -->
                <fo:table-row height="0.2in">
                  <fo:table-cell number-columns-spanned="2">
                    <fo:block/>
                  </fo:table-cell>
                </fo:table-row>

                <!-- 40) [fo:table-row] Data Processing and Appraisal -->
                <xsl:if test="$show-data-processing-and-appraisal = 1">
                  <fo:table-row background-color="{$color-gray1}" keep-with-next="always">
                    <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block id="data-processing-and-appraisal" font-size="12pt" font-weight="bold">
                        <xsl:value-of select="$msg/*/entry[@key='Data_Processing_and_Appraisal']"/>
                      </fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 41) [fo:table-row] Data Editing -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:cleanOps">
                  <fo:table-row>
                    <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block font-weight="bold" text-decoration="underline">
                        <xsl:value-of select="$msg/*/entry[@key='Data_Editing']"/>
                      </fo:block>
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:cleanOps"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 42) [fo:table-row] Other Processing -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:notes">
                  <fo:table-row>
                    <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block font-weight="bold" text-decoration="underline">
                        <xsl:value-of select="$msg/*/entry[@key='Other_Processing']"/>
                      </fo:block>
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:notes"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 43) [fo:table-row] Estimates of Sampling Error -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:anlyInfo/ddi:EstSmpErr">
                  <fo:table-row>
                    <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block font-weight="bold" text-decoration="underline">
                        <xsl:value-of select="$msg/*/entry[@key='Estimates_of_Sampling_Error']"/>
                      </fo:block>
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:anlyInfo/ddi:EstSmpErr"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 44) [fo:table-row] Other Data Appraisal -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:anlyInfo/ddi:dataAppr">
                  <fo:table-row>
                    <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block font-weight="bold" text-decoration="underline">
                        <xsl:value-of select="$msg/*/entry[@key='Other_Forms_of_Data_Appraisal']"/>
                      </fo:block>
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:anlyInfo/ddi:dataAppr"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- [fo:table-row] (separator) -->
                <fo:table-row height="0.2in">
                  <fo:table-cell number-columns-spanned="2">
                    <fo:block/>
                  </fo:table-cell>
                </fo:table-row>

                <!-- 45) [fo:table-row] Accesibility -->
                <xsl:if test="$show-accessibility = 1">
                  <fo:table-row background-color="{$color-gray1}" keep-with-next="always">
                    <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block id="accessibility" font-size="12pt" font-weight="bold">
                        <xsl:value-of select="$msg/*/entry[@key='Accessibility']"/>
                      </fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 46) [fo:table-row] Access Authority -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:dataAccs/ddi:useStmt/ddi:contact">
                  <fo:table-row>
                    <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block>
                        <xsl:value-of select="$msg/*/entry[@key='Access_Authority']"/>
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:dataAccs/ddi:useStmt/ddi:contact"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 47) [fo:table-row] Contacts -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:distStmt/ddi:contact">
                  <fo:table-row>
                    <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block>
                        <xsl:value-of select="$msg/*/entry[@key='Contacts']"/>
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:distStmt/ddi:contact"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 48) [fo:table-row] Distributor -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:distStmt/ddi:distrbtr">
                  <fo:table-row>
                    <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block>
                        <xsl:value-of select="$msg/*/entry[@key='Distributors']"/>
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:distStmt/ddi:distrbtr"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 49) [fo:table-row] Depositor (DDP) -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:distStmt/ddi:depositr">
                  <fo:table-row>
                    <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block>
                        <xsl:value-of select="$msg/*/entry[@key='Depositors']"/>
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:distStmt/ddi:depositr"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 50) [fo:table-row] Confidentiality -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:dataAccs/ddi:useStmt/ddi:confDec">
                  <fo:table-row>
                    <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block font-weight="bold" text-decoration="underline">
                        <xsl:value-of select="$msg/*/entry[@key='Confidentiality']"/>
                      </fo:block>
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:dataAccs/ddi:useStmt/ddi:confDec"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 51) [fo:table-row] Access Conditions -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:dataAccs/ddi:useStmt/ddi:conditions">
                  <fo:table-row>
                    <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block font-weight="bold" text-decoration="underline">
                        <xsl:value-of select="$msg/*/entry[@key='Access_Conditions']"/>
                      </fo:block>
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:dataAccs/ddi:useStmt/ddi:conditions"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 52) [fo:table-row] Citation Requierments -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:dataAccs/ddi:useStmt/ddi:citReq">
                  <fo:table-row>
                    <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block font-weight="bold" text-decoration="underline">
                        <xsl:value-of select="$msg/*/entry[@key='Citation_Requirements']"/>
                      </fo:block>
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:dataAccs/ddi:useStmt/ddi:citReq"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- [fo:table-row] (separator) -->
                <fo:table-row height="0.2in">
                  <fo:table-cell number-columns-spanned="2">
                    <fo:block/>
                  </fo:table-cell>
                </fo:table-row>

                <!-- 53) [fo:table-row] Rights and Disclaimer -->
                <xsl:if test="$show-rights-and-disclaimer = 1">
                  <fo:table-row background-color="{$color-gray1}" keep-with-next="always">
                    <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block id="rights-and-disclaimer" font-size="12pt" font-weight="bold">
                        <xsl:value-of select="$msg/*/entry[@key='Rights_and_Disclaimer']"/>
                      </fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 54) [fo:table-row] Disclaimer -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:dataAccs/ddi:useStmt/ddi:disclaimer">
                  <fo:table-row>
                    <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block font-weight="bold" text-decoration="underline">
                        <xsl:value-of select="$msg/*/entry[@key='Disclaimer']"/>
                      </fo:block>
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:dataAccs/ddi:useStmt/ddi:disclaimer"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

                <!-- 55) [fo:table-row] Copyright -->
                <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:prodStmt/ddi:copyright">
                  <fo:table-row>
                    <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                      <fo:block>
                        <xsl:value-of select="$msg/*/entry[@key='Copyright']"/>
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                      <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:prodStmt/ddi:copyright"/>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:if>

              </fo:table-body>
            </fo:table>
          </fo:flow>
        </fo:page-sequence>
      </xsl:if>


      <!-- ======================================================== -->
      <!-- [6] Page sequence: Files description                     -->
      <!-- <fo:page-sequence>                                       -->
      <!-- ======================================================== -->

      <!--
        global vars read:
        $font-family, $msg

        XSLT 1.0 functions called:
        count(),

        templates called:
        [header], [footer]
      -->

      <xsl:if test="$show-files-description = 1">

        <!-- ========================== -->
        <!-- r) [fo:page-sequence] Main -->
        <!-- ========================== -->
        <fo:page-sequence master-reference="default-page"
                          font-family="{$font-family}"
                          font-size="10pt">

          <!-- [-] Page header -->
          <xsl:call-template name="header">
            <xsl:with-param name="section">
              <xsl:value-of select="$msg/*/entry[@key='Files_Description']"/>
            </xsl:with-param>
          </xsl:call-template>

          <!-- [-] Page footer -->
          <xsl:call-template name="footer"/>

          <!-- [fo:flow] Page Flow -->
          <fo:flow flow-name="xsl-region-body">

            <!-- [fo:block] -->
            <fo:block id="files-description" font-size="18pt" font-weight="bold" space-after="0.1in">
              <xsl:value-of select="$msg/*/entry[@key='Files_Description']"/>
            </fo:block>

            <!-- [fo:block] Count -->
            <fo:block font-weight="bold">
              <xsl:value-of select="$msg/*/entry[@key='Dataset_contains']"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="count(/ddi:codeBook/ddi:fileDscr)"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$msg/*/entry[@key='files']"/>
            </fo:block>

            <!-- [-] Files -->
            <xsl:apply-templates select="/ddi:codeBook/ddi:fileDscr"/>

          </fo:flow>
        </fo:page-sequence>
      </xsl:if>


      <!-- ================================================ -->
      <!-- [7] Page sequence: Variables list                -->
      <!-- <fo:page-sequence>                               -->
      <!-- ================================================ -->

      <!--
        global vars read:
        $show-variables-list-layout, $msg, $font-family

        XPath 1.0 functions called:
        count()

        templates called:
        [header], [footer]
      -->

      <xsl:if test="$show-variables-list = 1">

        <!-- ========================== -->
        <!-- r) [fo:page-sequence] Main -->
        <!-- ========================== -->
        <fo:page-sequence master-reference="{$show-variables-list-layout}"
                          font-family="{$font-family}" font-size="10pt">

          <!-- [-] Page header -->
          <xsl:call-template name="header">
            <xsl:with-param name="section">
              <xsl:value-of select="$msg/*/entry[@key='Variables_List']"/>
            </xsl:with-param>
          </xsl:call-template>

          <!-- [-] Page footer-->
          <xsl:call-template name="footer"/>

          <!-- [fo:flow] Page flow -->
          <fo:flow flow-name="xsl-region-body">

            <!-- [fo:block] Variables list -->
            <fo:block id="variables-list" font-size="18pt" font-weight="bold" space-after="0.1in">
              <xsl:value-of select="$msg/*/entry[@key='Variables_List']"/>
            </fo:block>

            <!-- [fo:block] Count -->
            <fo:block font-weight="bold">
              <xsl:value-of select="$msg/*/entry[@key='Dataset_contains']"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="count(/ddi:codeBook/ddi:dataDscr/ddi:var)"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$msg/*/entry[@key='variables']"/>
            </fo:block>

            <!-- [-] Variables -->
            <xsl:apply-templates select="/ddi:codeBook/ddi:fileDscr" mode="variables-list"/>

          </fo:flow>
        </fo:page-sequence>
      </xsl:if>


      <!-- ================================================ -->
      <!-- [8] Page sequence: Variable groups               -->
      <!-- [fo:page-sequence]                               -->
      <!-- ================================================ -->

      <!--
        global vars read:
        $font-family, $msg, $numberOfGroups

        XPath 1.0 functions called:
        string-length(), count(),

        templates called:
        [header], [footer]
      -->

      <xsl:if test="$showVariableGroups = 1">

        <!-- ========================== -->
        <!-- r) [fo:page-sequence] Main -->
        <!-- ========================== -->
        <fo:page-sequence master-reference="default-page"
                          font-family="{$font-family}" font-size="10pt">

          <!-- [-] Page header -->
          <xsl:call-template name="header">
            <xsl:with-param name="section">
              <xsl:value-of select="$msg/*/entry[@key='Variables_Groups']"/>
            </xsl:with-param>
          </xsl:call-template>

          <!-- [-] Page footer-->
          <xsl:call-template name="footer"/>

          <!-- [fo:flow] Page flow -->
          <fo:flow flow-name="xsl-region-body">

            <!-- [fo:block] -->
            <fo:block id="variables-groups" font-size="18pt" font-weight="bold" space-after="0.1in">
              <xsl:value-of select="$msg/*/entry[@key='Variables_Groups']"/>
            </fo:block>

            <!-- [fo:block] Count -->
            <fo:block font-weight="bold">
              <xsl:value-of select="$msg/*/entry[@key='Dataset_contains']"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="count(/ddi:codeBook/ddi:dataDscr/ddi:varGrp)"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$msg/*/entry[@key='groups']"/>
              <xsl:if test="string-length($subsetVars)&gt;0">
                <xsl:value-of select="$msg/*/entry[@key='ShowingSubset']"/>
                <xsl:value-of select="$numberOfGroups"/>
              </xsl:if>
            </fo:block>

            <!-- [-] Groups -->
            <xsl:apply-templates select="/ddi:codeBook/ddi:dataDscr/ddi:varGrp"/>

          </fo:flow>
        </fo:page-sequence>
      </xsl:if>


      <!-- ==================================================== -->
      <!-- [9] Page sequence: Variables description             -->
      <!-- <fo:page-sequence>                                   -->
      <!-- ==================================================== -->

      <!--
        global vars read:
        $font-family, $msg, $numberOfvars,

        XPath 1.0 functions called:
        count(), string-length()

        templates called:
        [header], [footer]
      -->

      <xsl:if test="$show-variables-description = 1">

        <!-- ========================== -->
        <!-- r) [fo:page-sequence] Main -->
        <!-- ========================== -->
        <fo:page-sequence master-reference="default-page"
                          font-family="{$font-family}" font-size="10pt">

          <!-- [-] Page header -->
          <xsl:call-template name="header">
            <xsl:with-param name="section">
              <xsl:value-of select="$msg/*/entry[@key='Variables_Description']"/>
            </xsl:with-param>
          </xsl:call-template>

          <!-- [-] Page footer-->
          <xsl:call-template name="footer"/>

          <!-- [fo:flow] Page flow -->
          <fo:flow flow-name="xsl-region-body">

            <!-- [fo:block] Variables description -->
            <fo:block id="variables-description" font-size="18pt" font-weight="bold" space-after="0.1in">
              <xsl:value-of select="$msg/*/entry[@key='Variables_Description']"/>
            </fo:block>

            <!-- [fo:block] Count -->
            <fo:block font-weight="bold">
              <xsl:value-of select="$msg/*/entry[@key='Dataset_contains']"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="count(/ddi:codeBook/ddi:dataDscr/ddi:var)"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$msg/*/entry[@key='variables']"/>
              <xsl:if test="string-length($subsetVars)&gt;0">
                <xsl:value-of select="$msg/*/entry[@key='ShowingSubset']"/>
                <xsl:value-of select="$numberOfVars"/>
              </xsl:if>
            </fo:block>

          </fo:flow>
        </fo:page-sequence>

        <!-- [-] Variables -->
        <xsl:apply-templates select="/ddi:codeBook/ddi:fileDscr" mode="variables-description"/>
      </xsl:if>


      <!-- =============================================== -->
      <!-- [10] Page sequence: Documentation               -->
      <!-- <fo:page-sequence>                              -->
      <!-- =============================================== -->

      <!--
        global vars read:
        $rdf-file, $font-family, $msg

        local vars set:
        $rdf, $adm-count, $anl-count, $qst-count, $oth-count, $ref-count,
        $rep-count, $tec-count, $tbl-count, $prg-count, $unc-count

        XPath 1.0 functions called:
        normalize-space(), count(), contains(), not()

        XSLT 1.0 functions called:
        document()

        templates called:
        [header], [footer], [documentation-toc-section]
      -->

      <xsl:if test="$show-documentation = 1 and normalize-space($rdf-file)">

        <!-- ========================== -->
        <!-- r) [fo:page-sequence] Main -->
        <!-- ========================== -->
        <fo:page-sequence master-reference="default-page"
                          font-family="{$font-family}" font-size="10pt">

          <!-- [-] Page header -->
          <xsl:call-template name="header">
            <xsl:with-param name="section">
              <xsl:value-of select="$msg/*/entry[@key='Documentation']"/>
            </xsl:with-param>
          </xsl:call-template>

          <!-- [-] page footer-->
          <xsl:call-template name="footer"/>

          <!-- [fo:flow] Page flow -->
          <fo:flow flow-name="xsl-region-body">

            <!-- [fo:block] -->
            <fo:block id="documentation" font-size="18pt" font-weight="bold" space-after="0.1in">
              <xsl:value-of select="$msg/*/entry[@key='Documentation']"/>
            </fo:block>

            <!--  get RDF document -->
            <xsl:variable name="rdf" select="document($rdf-file)"/>
            <!-- count documents by category -->
            <xsl:variable name="adm-count" select="count($rdf/rdf:RDF/rdf:Description[ contains(dc:type,'[doc/adm]') ]) "/>
            <xsl:variable name="anl-count" select="count($rdf/rdf:RDF/rdf:Description[ contains(dc:type,'[doc/anl]') ]) "/>
            <xsl:variable name="qst-count" select="count($rdf/rdf:RDF/rdf:Description[ contains(dc:type,'[doc/qst]') ]) "/>
            <xsl:variable name="oth-count" select="count($rdf/rdf:RDF/rdf:Description[ contains(dc:type,'[doc/oth]') ]) "/>
            <xsl:variable name="ref-count" select="count($rdf/rdf:RDF/rdf:Description[ contains(dc:type,'[doc/ref]') ]) "/>
            <xsl:variable name="rep-count" select="count($rdf/rdf:RDF/rdf:Description[ contains(dc:type,'[doc/rep]') ]) "/>
            <xsl:variable name="tec-count" select="count($rdf/rdf:RDF/rdf:Description[ contains(dc:type,'[doc/tec]') ]) "/>
            <xsl:variable name="tbl-count" select="count($rdf/rdf:RDF/rdf:Description[ contains(dc:type,'[tbl') ]) "/>
            <xsl:variable name="prg-count" select="count($rdf/rdf:RDF/rdf:Description[ contains(dc:type,'[prg') ]) "/>
            <xsl:variable name="unc-count" select="count($rdf/rdf:RDF/rdf:Description[not( contains(dc:type,'[doc') or contains(dc:type,'[tbl') or contains(dc:type,'[prg') ) ] )"/>

            <!-- [fo:block] Table of contents -->
            <fo:block space-after="0.2in">

              <!-- [fo:block] Report/analytical -->
              <xsl:if test="$rep-count &gt;0 or $anl-count &gt; 0">
                <fo:block font-size="8pt" text-align-last="justify" space-after="0.03in">
                  <fo:basic-link internal-destination="documentation-anl" text-decoration="underline" color="blue">
                    <xsl:value-of select="$msg/*/entry[@key='Reports_and_analytical_documents']"/>
                    <fo:leader leader-pattern="dots"/>
                    <fo:page-number-citation ref-id="documentation-anl"/>
                  </fo:basic-link>
                </fo:block>
                <xsl:call-template name="documentation-toc-section">
                  <xsl:with-param name="nodes" select="$rdf/rdf:RDF/rdf:Description[ contains(dc:type,'[doc/rep]')  or contains(dc:type,'[doc/anl]') ]"/>
                </xsl:call-template>
              </xsl:if>

              <!-- [fo:block] Questionnaires -->
              <xsl:if test="$qst-count &gt;0">
                <fo:block font-size="8pt" text-align-last="justify" space-after="0.03in">
                  <fo:basic-link internal-destination="documentation-qst" text-decoration="underline" color="blue">
                    <xsl:value-of select="$msg/*/entry[@key='Questionnaires']"/>
                    <fo:leader leader-pattern="dots"/>
                    <fo:page-number-citation ref-id="documentation-qst"/>
                  </fo:basic-link>
                </fo:block>
                <xsl:call-template name="documentation-toc-section">
                  <xsl:with-param name="nodes" select="$rdf/rdf:RDF/rdf:Description[ contains(dc:type,'[doc/qst]')]"/>
                </xsl:call-template>
              </xsl:if>

              <!-- [fo:block] Technical -->
              <xsl:if test="$tec-count &gt;0">
                <fo:block font-size="8pt" text-align-last="justify" space-after="0.03in">
                  <fo:basic-link internal-destination="documentation-tec" text-decoration="underline" color="blue">
                    <xsl:value-of select="$msg/*/entry[@key='Technical_documents']"/>
                    <fo:leader leader-pattern="dots"/>
                    <fo:page-number-citation ref-id="documentation-tec"/>
                  </fo:basic-link>
                </fo:block>
                <xsl:call-template name="documentation-toc-section">
                  <xsl:with-param name="nodes" select="$rdf/rdf:RDF/rdf:Description[ contains(dc:type,'[doc/tec]')]"/>
                </xsl:call-template>
              </xsl:if>

              <!-- [fo:block] Administrative -->
              <xsl:if test="$adm-count &gt;0">
                <fo:block font-size="8pt" text-align-last="justify" space-after="0.03in">
                  <fo:basic-link internal-destination="documentation-adm" text-decoration="underline" color="blue">
                    <xsl:value-of select="$msg/*/entry[@key='Administrative_documents']"/>
                    <fo:leader leader-pattern="dots"/>
                    <fo:page-number-citation ref-id="documentation-adm"/>
                  </fo:basic-link>
                </fo:block>
                <xsl:call-template name="documentation-toc-section">
                  <xsl:with-param name="nodes" select="$rdf/rdf:RDF/rdf:Description[ contains(dc:type,'[doc/adm]')]"/>
                </xsl:call-template>
              </xsl:if>

              <!-- [fo:block] References -->
              <xsl:if test="$ref-count &gt;0">
                <fo:block font-size="8pt" text-align-last="justify" space-after="0.03in">
                  <fo:basic-link internal-destination="documentation-ref" text-decoration="underline" color="blue">
                    <xsl:value-of select="$msg/*/entry[@key='References']"/>
                    <fo:leader leader-pattern="dots"/>
                    <fo:page-number-citation ref-id="documentation-ref"/>
                  </fo:basic-link>
                </fo:block>
                <xsl:call-template name="documentation-toc-section">
                  <xsl:with-param name="nodes" select="$rdf/rdf:RDF/rdf:Description[ contains(dc:type,'[doc/ref]')]"/>
                </xsl:call-template>
              </xsl:if>

              <!-- [fo:block] Other -->
              <xsl:if test="$oth-count &gt;0">
                <fo:block font-size="8pt" text-align-last="justify" space-after="0.03in">
                  <fo:basic-link internal-destination="documentation-oth" text-decoration="underline" color="blue">
                    <xsl:value-of select="$msg/*/entry[@key='Other_documents']"/>
                    <fo:leader leader-pattern="dots"/>
                    <fo:page-number-citation ref-id="documentation-oth"/>
                  </fo:basic-link>
                </fo:block>
                <xsl:call-template name="documentation-toc-section">
                  <xsl:with-param name="nodes" select="$rdf/rdf:RDF/rdf:Description[ contains(dc:type,'[doc/oth]')]"/>
                </xsl:call-template>
              </xsl:if>

              <!-- [fo:block] Statistical tables -->
              <xsl:if test="$tbl-count &gt;0">
                <fo:block font-size="8pt" text-align-last="justify" space-after="0.03in">
                  <fo:basic-link internal-destination="documentation-tbl" text-decoration="underline" color="blue">
                    <xsl:value-of select="$msg/*/entry[@key='Statistical_tables']"/>
                    <fo:leader leader-pattern="dots"/>
                    <fo:page-number-citation ref-id="documentation-tbl"/>
                  </fo:basic-link>
                </fo:block>
              </xsl:if>

              <!-- [fo:block] Scripts and programs -->
              <xsl:if test="$prg-count &gt;0">
                <fo:block font-size="8pt" text-align-last="justify" space-after="0.03in">
                  <fo:basic-link internal-destination="documentation-prg" text-decoration="underline" color="blue">
                    <xsl:value-of select="$msg/*/entry[@key='Scripts_and_programs']"/>
                    <fo:leader leader-pattern="dots"/>
                    <fo:page-number-citation ref-id="documentation-prg"/>
                  </fo:basic-link>
                </fo:block>
              </xsl:if>

              <!-- [fo:block] Other resources -->
              <xsl:if test="$unc-count &gt;0">
                <fo:block font-size="8pt" text-align-last="justify" space-after="0.03in">
                  <fo:basic-link internal-destination="documentation-unc" text-decoration="underline" color="blue">
                    <xsl:value-of select="$msg/*/entry[@key='Other_resources']"/>
                    <fo:leader leader-pattern="dots"/>
                    <fo:page-number-citation ref-id="documentation-unc"/>
                  </fo:basic-link>
                </fo:block>
                <xsl:call-template name="documentation-toc-section">
                  <xsl:with-param name="nodes" select=" $rdf/rdf:RDF/rdf:Description[ not( contains(dc:type,'[doc') or contains(dc:type,'[tbl') or contains(dc:type,'[prg') )  ] "/>
                </xsl:call-template>
              </xsl:if>
            </fo:block>

            <!-- DOCUMENTS -->

            <!-- [fo:block] Report/analytical -->
            <xsl:if test="$rep-count &gt;0 or $anl-count &gt; 0">
              <fo:block id="documentation-anl" font-size="14pt" font-weight="bold" space-after="0.1in">
                <xsl:value-of select="$msg/*/entry[@key='Reports_and_analytical_documents']"/>
              </fo:block>
              <xsl:apply-templates select="$rdf/rdf:RDF/rdf:Description[ contains(dc:type,'[doc/rep]')  or contains(dc:type,'[doc/anl]') ]"/>
            </xsl:if>

            <!-- [fo:block] Questionnaires -->
            <xsl:if test="$qst-count &gt; 0">
              <fo:block id="documentation-qst" font-size="14pt" font-weight="bold" space-after="0.1in">
                <xsl:value-of select="$msg/*/entry[@key='Questionnaires']"/>
              </fo:block>
              <xsl:apply-templates select="$rdf/rdf:RDF/rdf:Description[ contains(dc:type,'[doc/qst]') ]"/>
            </xsl:if>

            <!-- [fo:block] Technical -->
            <xsl:if test="$tec-count &gt; 0">
              <fo:block id="documentation-tec" font-size="14pt" font-weight="bold" space-after="0.1in">
                <xsl:value-of select="$msg/*/entry[@key='Technical_documents']"/>
              </fo:block>
              <xsl:apply-templates select="$rdf/rdf:RDF/rdf:Description[ contains(dc:type,'[doc/tec]') ]"/>
            </xsl:if>

            <!-- [fo:block] Administrative -->
            <xsl:if test="$adm-count &gt; 0">
              <fo:block id="documentation-adm" font-size="14pt" font-weight="bold" space-after="0.1in">
                <xsl:value-of select="$msg/*/entry[@key='Administrative_documents']"/>
              </fo:block>
              <xsl:apply-templates select="$rdf/rdf:RDF/rdf:Description[ contains(dc:type,'[doc/adm]') ]"/>
            </xsl:if>

            <!-- [fo:block] References -->
            <xsl:if test="$ref-count &gt; 0">
              <fo:block id="documentation-ref" font-size="14pt" font-weight="bold" space-after="0.1in">
                <xsl:value-of select="$msg/*/entry[@key='References']"/>
              </fo:block>
              <xsl:apply-templates select="$rdf/rdf:RDF/rdf:Description[ contains(dc:type,'[doc/ref]') ]"/>
            </xsl:if>

            <!-- [fo:block] Other documents-->
            <xsl:if test="$oth-count &gt; 0">
              <fo:block id="documentation-oth" font-size="14pt" font-weight="bold" space-after="0.1in">
                <xsl:value-of select="$msg/*/entry[@key='Other_documents']"/>
              </fo:block>
              <xsl:apply-templates select="$rdf/rdf:RDF/rdf:Description[ contains(dc:type,'[doc/oth]') ]"/>
            </xsl:if>

            <!-- [fo:block] Statistical tables -->
            <xsl:if test="$tbl-count &gt; 0">
              <fo:block id="documentation-tbl" font-size="14pt" font-weight="bold" space-after="0.1in">
                <xsl:value-of select="$msg/*/entry[@key='Statistical_Tables']"/>
              </fo:block>
              <xsl:apply-templates select="$rdf/rdf:RDF/rdf:Description[ contains(dc:type,'[tbl') ]"/>
            </xsl:if>

            <!-- [fo:block] Scripts and programs -->
            <xsl:if test="$prg-count &gt; 0">
              <fo:block id="documentation-prg" font-size="14pt" font-weight="bold" space-after="0.1in">
                <xsl:value-of select="$msg/*/entry[@key='Scripts_and_programs']"/>
              </fo:block>
              <xsl:apply-templates select="$rdf/rdf:RDF/rdf:Description[ contains(dc:type,'[prg') ]"/>
            </xsl:if>

            <!-- [fo:block] Other resources -->
            <xsl:if test="$unc-count &gt; 0">
              <fo:block id="documentation-unc" font-size="14pt" font-weight="bold" space-after="0.1in">
                <xsl:value-of select="$msg/*/entry[@key='Other_resources']"/>
              </fo:block>
              <xsl:apply-templates select="$rdf/rdf:RDF/rdf:Description[ not( contains(dc:type,'[doc') or contains(dc:type,'[tbl') or contains(dc:type,'[prg') )  ]"/>
            </xsl:if>

          </fo:flow>
        </fo:page-sequence>
      </xsl:if>

    </fo:root>

  </xsl:template>
</xsl:stylesheet>