<?xml version='1.0' encoding='UTF-8'?>
<!--
  Overview:
    Transforms DDI-XML into XSL-FO to produce study documentation in PDF format
    Developed for DDI documents produced by the International Household Survey Network
    Microdata Managemenet Toolkit (http://www.surveynetwork.org/toolkit) and
    Central Survey Catalog (http://www.surveynetwork.org/surveys)

  Authors: 
    Pascal Heus (pascal.heus@gmail.com)
    Version: July 2006
    Platform: XSL 1.0, Apache FOP 0.20.5

    Oistein Kristiansen (oistein.kristiansen@nsd.uib.no)
    Version: 2010
    Updated for FOP 0.93 2010

    Akira Olsbanning (akira.olsbanning@snd.gu.se)
    Current version (2012)

  License:
    Copyright 2006 Pascal Heus (pascal.heus@gmail.com)

    This program is free software; you can redistribute it and/or modify it under the terms of the
    GNU Lesser General Public License as published by the Free Software Foundation; either version
    2.1 of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
    without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
    See the GNU Lesser General Public License for more details.

    The full text of the license is available at http://www.gnu.org/copyleft/lesser.html

  References:
    XSL-FO:
      http://www.w3.org/Style/XSL/
      http://www.w3schools.com/xslfo/xslfo_reference.asp
      http://www.xslfo.info/
    Apache FOP:
      http://xmlgraphics.apache.org/fop/
    XSL-FO Tutorials:
      http://www.renderx.com/tutorial.html
      http://www.antennahouse.com/XSLsample/XSLsample.htm
    String trimming:
      http://skew.org/xml
--><!--
  2006-04:    Added multilingual support and French translation
  2006-06:    Added Spanish and new elements to match IHSN Template v1.2
  2006-07:    Minor fixes and typos
  2006-07:    Added option parameters to hide producers in cover
              page and questions in variables list page
  2010-03:    Made FOP 0.93 compatible
  2012-11-01: Broken up into parts using xsl:include
  2013-01-22: Changing the file names to match template names better
  2013-05-28: Using xincludes instead of xsl:includes
--><xsl:stylesheet xmlns:n1="http://www.icpsr.umich.edu/DDI" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ddi="http://www.icpsr.umich.edu/DDI" xmlns:date="http://exslt.org/dates-and-times" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:exsl="http://exslt.org/common" xmlns:math="http://exslt.org/math" xmlns:str="http://exslt.org/strings" xmlns:doc="http://www.icpsr.umich.edu/doc" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:xdt="http://www.w3.org/2005/xpath-datatypes" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xi="http://www.w3.org/2001/XInclude" version="1.0" extension-element-prefixes="date exsl str">

  <xsl:output version="1.0" encoding="UTF-8" indent="no" omit-xml-declaration="no" media-type="text/html"/>

  <!--
    Params/variables read:
    rdf-file, translations, language-code, report-title,
    report-acknowledgements, ... [param]

    Variables set:
    showVariableGroups, show-variables-list ...

    Functions and templates called:
    count(), normalize-space(), position(), substring() [Xpath 1.0]
    document() [XSLT 1.0]
    date:date
  -->

  <!--
    Sections in this file:
    1: Misc uses        strings, numbers    manual/param
    2: Show/hide        bools               manual/param
    3: Show/hide        bools               from DDI file
    4: Misc uses        strings, numbers    from DDI file
  -->

  <!--
    Main "sections" of the root template and their show/hide vars:
    0:  fo:layout-master-set    n/a
    1:  fo:bookmark-tree        show-bookmarks                param   1
    2:  Cover page:             show-cover-page               param   1
    3:  Metadata info:          show-metadata-info            param   1
    4:  Table of Contents:      show-toc                      param   1
    5:  Overview:               show-overview                 param   1
    6:  Files Description:      show-files-description        param   1
    7:  Variable List:          show-variables-list           spec*
    8:  Variable Groups:        showVariableGroups            spec**
    9:  Variables Description:  show-variables-description    file
    10: Documentation:          show-documentation            param   0

    *  If showVariableGroups is 1, this is set to 0
    ** Both parameter and DDI file
  -->

  <!-- ========================================================== -->
  <!-- [1] Misc                                                   -->
  <!-- ========================================================== -->

  <!-- Paths to external files -->
  <xsl:param name="rdf-file"/>
  <xsl:param name="translations"/>
  
  <!-- Used for ISO-date template -->
  <xsl:param name="language-code" select="en"/>
  
  <!-- Optional text -->
  <xsl:param name="report-title" select=" 'Study Documentation' "/>
  <xsl:param name="report-acknowledgments"/>
  <xsl:param name="report-notes"/>

  <!-- Page related -->
  <xsl:param name="page-format" select="us-letter"/>
  <xsl:param name="show-variables-list-layout">default-page</xsl:param>
  <xsl:param name="font-family">Times</xsl:param>

  <!-- Start page number, used by Overview -->
  <!-- (useful if running multi-survey reports) -->
  <xsl:param name="report-start-page-number" select="4"/>
  <xsl:param name="show-variables-description-categories-max" select="1000"/>
  <xsl:param name="variable-name-length" select="14"/>

  <!-- Params from OutputServlet.java (supposedly?) -->
  <!-- Not used, should be removed soon -->
  <xsl:param name="numberOfVars"/>
  <xsl:param name="numberOfGroups"/>
  <xsl:param name="subsetGroups"/>
  <xsl:param name="subsetVars"/>
  <xsl:param name="maxVars"/>
  <xsl:param name="allowHTML" select="0"/>

  <xsl:param name="report-date" select="$exslt-date"/>
    
  <!-- Use translations in external file -->
  <xsl:variable name="msg" select="document($translations)"/>
  
  <!-- Required by EXSLT date function -->
  <xsl:variable name="date:date-time" select="'2000-01-01T00:00:00Z'"/>

  <!-- Report date -->
  <xsl:variable name="exslt-date">
    <xsl:call-template name="date:date"/>
  </xsl:variable>

  <!-- Style Settings -->
  <xsl:variable name="cell-padding" select=" '3pt' "/>
  <xsl:variable name="default-border" select=" '0.5pt solid black' "/>
  <xsl:variable name="color-white" select=" '#ffffff' "/>
  <xsl:variable name="color-gray0" select=" '#f8f8f8' "/>
  <xsl:variable name="color-gray1" select=" '#f0f0f0' "/>
  <xsl:variable name="color-gray2" select=" '#e0e0e0' "/>
  <xsl:variable name="color-gray3" select=" '#d0d0d0' "/>
  <xsl:variable name="color-gray4" select=" '#c0c0c0' "/>
  
  <!-- ========================================================== -->
  <!-- [2] Show/hide sections (main/sub) in root template         -->
  <!-- ========================================================== -->

  <!-- Main sections in root template -->
  <xsl:param name="show-bookmarks" select="1"/>
  <xsl:param name="show-cover-page" select="1"/>
  <xsl:param name="show-metadata-info" select="1"/>
  <xsl:param name="show-toc" select="1"/>
  <xsl:param name="show-overview" select="1"/>
  <xsl:param name="show-files-description" select="1"/>
  <xsl:param name="show-documentation" select="0"/>

  <!-- Parts in the Cover page -->
  <xsl:param name="show-logo" select="0"/>
  <xsl:param name="show-geography" select="0"/>
  <xsl:param name="show-cover-page-producer" select="1"/>
  <xsl:param name="show-report-subtitle" select="0"/>
  <xsl:param name="show-date" select="0"/>

  <!-- Misc -->
  <xsl:param name="show-metadata-production" select="1"/>
  <xsl:param name="show-variables-list-question" select="1"/>
  <xsl:param name="show-variables-description-categories" select="1"/>

  <!-- documentation refer to a rdf file given as parameter which we dont have -->
  <xsl:param name="show-documentation-description" select="0"/>
  <xsl:param name="show-documentation-abstract" select="0"/>
  <xsl:param name="show-documentation-toc" select="0"/>
  <xsl:param name="show-documentation-subjects" select="0"/>

  <!-- from OutputServlet.java, supposedly? -->
  <xsl:param name="showVariableGroupsParam" select="1"/>

  <!-- ============================================================= -->
  <!-- [3] Show/hide sections (main/sub) in root template            -->
  <!-- ============================================================= -->

  <!-- Show variable groups only if there are any -->
  <xsl:variable name="showVariableGroups">
    <xsl:choose>
      <xsl:when test="$showVariableGroupsParam = 1 and count(/ddi:codeBook/ddi:dataDscr/ddi:varGrp) &gt; 0">1</xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- Show variable list if showing groups are disabled -->
  <xsl:variable name="show-variables-list">
    <xsl:choose>
      <xsl:when test="$showVariableGroups = 1">0</xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- If totalt amount of variables or given subsetamount       -->
  <!-- exceeds given max, then dont show extensive variable desc -->
  <xsl:variable name="show-variables-description">
    <xsl:choose>
      <xsl:when test="(count(/ddi:codeBook/ddi:dataDscr/ddi:var) &gt; $maxVars and $numberOfVars &lt; 1 )">0</xsl:when>
      <xsl:when test="($numberOfVars &gt; $maxVars)">0</xsl:when>
      <xsl:when test="(count(/ddi:codeBook/ddi:dataDscr/ddi:var) = 0)">0</xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="show-scope-and-coverage">
    <xsl:choose>
      <xsl:when test="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:notes">1</xsl:when>
      <xsl:when test="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:subject/ddi:keyword">1</xsl:when>
      <xsl:when test="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:geogCover">1</xsl:when>
      <xsl:when test="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:universe">1</xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="show-producers-and-sponsors">
    <xsl:choose>
      <xsl:when test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:rspStmt/ddi:AuthEnty">1</xsl:when>
      <xsl:when test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:prodStmt/ddi:producer">1</xsl:when>
      <xsl:when test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:prodStmt/ddi:fundAg">1</xsl:when>
      <xsl:when test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:rspStmt/ddi:othId">1</xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="show-sampling">
    <xsl:choose>
      <xsl:when test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:notes[@subject='sampling']">1</xsl:when>
      <xsl:when test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:sampProc">1</xsl:when>
      <xsl:when test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:deviat">1</xsl:when>
      <xsl:when test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:anlyInfo/ddi:respRate">1</xsl:when>
      <xsl:when test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:weight">1</xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="show-data-collection">
    <xsl:choose>
      <xsl:when test="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:collDate">1</xsl:when>
      <xsl:when test="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:timePrd">1</xsl:when>
      <xsl:when test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:collMode">1</xsl:when>
      <xsl:when test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:notes[@subject='collection']">1</xsl:when>
      <xsl:when test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:notes[@subject='processing']">1</xsl:when>
      <xsl:when test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:notes[@subject='cleaning']">1</xsl:when>
      <xsl:when test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:collSitu">1</xsl:when>
      <xsl:when test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:resInstru">1</xsl:when>
      <xsl:when test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:dataCollector">1</xsl:when>
      <xsl:when test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:actMin">1</xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="show-data-processing-and-appraisal">
    <xsl:choose>
      <xsl:when test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:cleanOps">1</xsl:when>
      <xsl:when test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:anlyInfo/ddi:EstSmpErr">1</xsl:when>
      <xsl:when test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:anlyInfo/ddi:dataAppr">1</xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="show-accessibility">
    <xsl:choose>
      <xsl:when test="/ddi:codeBook/ddi:stdyDscr/ddi:dataAccs/ddi:useStmt/ddi:contact">1</xsl:when>
      <xsl:when test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:distStmt/ddi:distrbtr">1</xsl:when>
      <xsl:when test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:distStmt/ddi:contact">1</xsl:when>
      <xsl:when test="/ddi:codeBook/ddi:stdyDscr/ddi:dataAccs/ddi:useStmt/ddi:confDec">1</xsl:when>
      <xsl:when test="/ddi:codeBook/ddi:stdyDscr/ddi:dataAccs/ddi:useStmt/ddi:conditions">1</xsl:when>
      <xsl:when test="/ddi:codeBook/ddi:stdyDscr/ddi:dataAccs/ddi:useStmt/ddi:citReq">1</xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="show-rights-and-disclaimer">
    <xsl:choose>
      <xsl:when test="/ddi:codeBook/ddi:stdyDscr/ddi:dataAccs/ddi:useStmt/ddi:disclaimer">1</xsl:when>
      <xsl:when test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:prodStmt/ddi:copyright">1</xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- ============================================================= -->
  <!-- [4] Misc                                                      -->
  <!-- ============================================================= -->

  <!-- toolkit: Microdata Management Toolkit or Nesstar Publishser 3.x -->
  <!-- ddp:     World Bank Data Development Platform -->
  <xsl:variable name="ddi-flavor">
    <xsl:choose>
      <xsl:when test="count(/ddi:codeBook/ddi:docDscr/ddi:citation/ddi:prodStmt/ddi:software[ contains( . , 'DDP' ) ])">ddp</xsl:when>
      <xsl:when test="count(/ddi:codeBook/ddi:docDscr/ddi:citation/ddi:prodStmt/ddi:software[ contains( . , 'Nesstar' ) ])">toolkit</xsl:when>
      <xsl:when test="count(/ddi:codeBook/ddi:docDscr/ddi:citation/ddi:prodStmt/ddi:software[ contains( . , 'Metadata Editor' ) ])">toolkit</xsl:when>
      <xsl:otherwise>toolkit</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- survey title -->
  <xsl:variable name="survey-title">
    <xsl:value-of select="normalize-space(/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:titlStmt/ddi:titl)"/>
    <!-- abbreviation is stored in the altTitl element -->
    <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:titlStmt/ddi:altTitl">
      (<xsl:value-of select="normalize-space(/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:titlStmt/ddi:altTitl)"/>)
    </xsl:if>
  </xsl:variable>

  <!-- geography -->
  <xsl:variable name="geography">
    <xsl:for-each select="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:nation">
      <xsl:if test="position()&gt;1">
        <xsl:text>, </xsl:text>
      </xsl:if>
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:for-each>
  </xsl:variable>

  <!-- yearFrom - the first data collection mode element with a 'start' event -->
  <!-- ToDO: collDate isnt always present, should test -->
  <!-- and possibly use /ddi:timePrd[@date] -->
  <xsl:variable name="yearFrom" select="substring(/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:collDate[@event='start'][1]/@date,1,4)"/>

  <!-- year to is the last data collection mode element with an 'end' event -->
  <xsl:variable name="yearToCount" select="count(/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:collDate[@event='end'])"/>
  <xsl:variable name="yearTo" select="substring(/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:collDate[@event='end'][$yearToCount]/@date,1,4)"/>
  <xsl:variable name="time">
    <xsl:if test="$yearFrom">
      <xsl:value-of select="$yearFrom"/>
      <xsl:if test="$yearTo &gt; $yearFrom">
        <xsl:text>-</xsl:text>
        <xsl:value-of select="$yearTo"/>
      </xsl:if>
    </xsl:if>
  </xsl:variable>

  <!-- If timeperiods returns empty, use timePrd instead -->
  <!-- ToDo: might not be needed -->
  <xsl:variable name="timeProduced" select="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:timePrd/@date"/>

  <!-- To avoid empty pages; use a huge chunksize for subsets -->
  <xsl:variable name="chunkSize">
    <xsl:choose>
      <xsl:when test="($numberOfVars &gt; 0 )">
        <xsl:value-of select="1000"/>
      </xsl:when>
      <xsl:otherwise>50</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- ================================= -->
  <!-- [5] Xincludes - include templates -->
  <!-- ================================= -->

  <!-- Match: / --><!-- Value: <fo:root> --><!-- the root of the FO document starts and ends in this template --><!--
  Sections:                           Value:
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
  10: Documentation                   <fo:page-sequence>
--><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="/" xml:base="includes/root_template.xml">

  <!-- content -->
  <fo:root>

    <!-- [0] setup page sizes and layouts -->
    <fo:layout-master-set>

      <!-- A4 page -->
      <fo:simple-page-master master-name="default-page" page-height="297mm" page-width="210mm" margin-left="20mm" margin-right="20mm" margin-top="20mm" margin-bottom="20mm">
        <fo:region-body region-name="xsl-region-body" margin-top="10mm" margin-bottom="10mm"/>
        <fo:region-before region-name="xsl-region-before" extent="10mm"/>
        <fo:region-after region-name="xsl-region-after" extent="10mm"/>
      </fo:simple-page-master>

    </fo:layout-master-set>

    <!-- ============================================ -->
    <!-- [1] Outline / Bookmarks                      -->
    <!-- [fo:bookmark-tree]                           -->
    <!-- ============================================ -->

    <!--
      Variables read:
      show-cover-page, show-metadata-info, show-toc, show-overview
      show-scope-and-coverage, show-producers-and-sponsors,
      show-sampling, show-data-collection, show-data-processing-and-appraisal,
      show-accessibility, show-rights-and-disclaimer, show-files-description,
      showVariableGroups, show-variables-list, show-variables-description,
      show-documentation

      Functions/templates called:
      nomalize-space(), contains(), concat(), string-length()
      trim
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

      <fo:bookmark-tree>

          <!-- 1) Cover_Page -->
          <xsl:if test="$show-cover-page = 1">
            <fo:bookmark internal-destination="cover-page">
              <fo:bookmark-title>
                <xsl:value-of select="$msg/*/entry[@key='Cover_Page']"/>
              </fo:bookmark-title>
            </fo:bookmark>
          </xsl:if>

          <!-- 2) Document_Information -->
          <xsl:if test="$show-metadata-info = 1">
            <fo:bookmark internal-destination="metadata-info">
              <fo:bookmark-title>
                <xsl:value-of select="$msg/*/entry[@key='Document_Information']"/>
              </fo:bookmark-title>
            </fo:bookmark>
          </xsl:if>

          <!-- 3) Table_of_Contents -->
          <xsl:if test="$show-toc = 1">
            <fo:bookmark internal-destination="toc">
              <fo:bookmark-title>
                <xsl:value-of select="$msg/*/entry[@key = 'Table_of_Contents']"/>
              </fo:bookmark-title>
            </fo:bookmark>
          </xsl:if>

          <!-- 4) Overview -->
          <xsl:if test="$show-overview = 1">
            <fo:bookmark internal-destination="overview">
              <fo:bookmark-title>
                <xsl:value-of select="$msg/*/entry[@key='Overview']"/>
              </fo:bookmark-title>

              <!-- 4.1) Scope_and_Coverage -->
              <xsl:if test="$show-scope-and-coverage = 1">
                <fo:bookmark internal-destination="scope-and-coverage">
                  <fo:bookmark-title>
                    <xsl:value-of select="$msg/*/entry[@key='Scope_and_Coverage']"/>
                  </fo:bookmark-title>
                </fo:bookmark>
              </xsl:if>

              <!-- 4.2) Producers_and_Sponsors -->
              <xsl:if test="$show-producers-and-sponsors = 1">
                <fo:bookmark internal-destination="producers-and-sponsors">
                  <fo:bookmark-title>
                    <xsl:value-of select="$msg/*/entry[@key='Producers_and_Sponsors']"/>
                  </fo:bookmark-title>
                </fo:bookmark>
              </xsl:if>

              <!-- 4.3) Sampling -->
              <xsl:if test="$show-sampling = 1">
                <fo:bookmark internal-destination="sampling">
                  <fo:bookmark-title>
                    <xsl:value-of select="$msg/*/entry[@key='Sampling']"/>
                  </fo:bookmark-title>
                </fo:bookmark>
              </xsl:if>

              <!-- 4.4) Data_Collection -->
              <xsl:if test="$show-data-collection = 1">
                <fo:bookmark internal-destination="data-collection">
                  <fo:bookmark-title>
                    <xsl:value-of select="$msg/*/entry[@key='Data_Collection']"/>
                  </fo:bookmark-title>
                </fo:bookmark>
              </xsl:if>

              <!-- 4.5) Data_Processing_and_Appraisal -->
              <xsl:if test="$show-data-processing-and-appraisal = 1">
                <fo:bookmark internal-destination="data-processing-and-appraisal">
                  <fo:bookmark-title>
                    <xsl:value-of select="$msg/*/entry[@key='Data_Processing_and_Appraisal']"/>
                  </fo:bookmark-title>
                </fo:bookmark>
              </xsl:if>

              <!-- 4.6 Accessibility -->
              <xsl:if test="$show-accessibility= 1">
                <fo:bookmark internal-destination="accessibility">
                  <fo:bookmark-title>
                    <xsl:value-of select="$msg/*/entry[@key='Accessibility']"/>
                  </fo:bookmark-title>
                </fo:bookmark>
              </xsl:if>

              <!-- 4.7 Rights_and_Disclaimer -->
              <xsl:if test="$show-rights-and-disclaimer = 1">
                <fo:bookmark internal-destination="rights-and-disclaimer">
                  <fo:bookmark-title>
                    <xsl:value-of select="$msg/*/entry[@key='Rights_and_Disclaimer']"/>
                  </fo:bookmark-title>
                </fo:bookmark>
              </xsl:if>
            </fo:bookmark>
          </xsl:if>

          <!-- 5) Files_Description -->
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

          <!-- 6) Variable_Groups -->
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

          <!-- 7) Variables list -->
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

          <!-- 8) Variables_Description -->
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
                    <xsl:if test="contains($subsetVars, concat(',',@ID,',')) or string-length($subsetVars)=0 ">
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

          <!-- 9) Documentation -->
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
        Variables read:
        show-logo, show-geography, show-cover-page-producer,
        show-report-subtitle, show-date

        Functions/templates called:
        normalize-space() [Xpath 1.0]
        trim, isodate-long
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
        <fo:page-sequence master-reference="default-page" font-family="Helvetica" font-size="10pt">
          <fo:flow flow-name="xsl-region-body">

            <!-- cover-page -->
            <fo:block id="cover-page">

              <!-- 1) logo graphic -->
              <xsl:if test="$show-logo">
                <fo:block>
                  <fo:external-graphic src="snd_logo_sv.png" horizontal-align="middle" content-height="5mm"/>
                </fo:block>
              </xsl:if>

              <!-- 2) geography -->
              <xsl:if test="$show-geography = 1">
                <fo:block font-size="14pt" font-weight="bold" space-before="0.5in" text-align="center" space-after="0.2in">
                  <xsl:value-of select="$geography"/>
                </fo:block>
              </xsl:if>

              <!-- 3) AuthEnty -->
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

              <!-- 4) titl -->
              <fo:block font-size="18pt" font-weight="bold" space-before="0.5in" text-align="center" space-after="0.0in">
                <xsl:value-of select="normalize-space(/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:titlStmt/ddi:titl)"/>
              </fo:block>

              <!-- 5) Report subtitle -->
              <xsl:if test="show-report-subtitle">
                <fo:block font-size="16pt" font-weight="bold" space-before="1.0in" text-align="center" space-after="0.0in">
                  <xsl:value-of select="$report-title"/>
                </fo:block>
              </xsl:if>

              <!-- 6) Date -->
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
        Variables read:
        msg, font-family, show-metadata-production,
        default-border, cell-padding

        Functions/templates called:
        boolean(), normalize-space() [Xpath 1.0]
        proportional-column-width() [FO]
        isodate-long
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

        <fo:page-sequence master-reference="default-page" font-family="{$font-family}" font-size="10pt">

          <fo:flow flow-name="xsl-region-body">
            <fo:block id="metadata-info"/>

            <xsl:if test="boolean($show-metadata-production)">

              <!-- Metadata_Production -->
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
        Variables read:
        font-family, msg, show-overview, show-scope-and-coverage,
        show-producers-and-sponsors, show-sampling, show-data-collection
        show-data-processing-and-appraisal, show-accessibility,
        show-rights-and-disclaimer, show-files-description, show-variables-list
        showVariableGroups, subsetGroups, show-documentation

        Functions called:
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

        <fo:page-sequence master-reference="default-page" font-family="{$font-family}" font-size="10pt">

          <fo:flow flow-name="xsl-region-body">

            <!-- Table_of_Contents -->
            <fo:block id="toc" font-size="18pt" font-weight="bold" space-before="0.5in" text-align="center" space-after="0.1in">
              <xsl:value-of select="$msg/*/entry[@key='Table_of_Contents']"/>
            </fo:block>

            <fo:block margin-left="0.5in" margin-right="0.5in">

              <!-- 1) Overview -->
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
        Variables read:
        msg, report-start-page-number, font-family, color-gray3
        default-border, cell-padding, survey-title, color-gray1, time

        Functions/templates called:
        nomalize-space(), position() [Xpath]
        proportional-column-width() [FO]
        header, footer
      -->

      <!--
           Page Header
           Page Footer
           Page Flow
        1: Title Header           <fo:table-row>

        55: Copyright             <fo:table-row>
      -->


      <xsl:if test="$show-overview = 1">

        <fo:page-sequence master-reference="default-page" initial-page-number="{$report-start-page-number}" font-family="{$font-family}" font-size="10pt">

          <!-- Page Header -->
          <xsl:call-template name="header">
            <xsl:with-param name="section">
              <xsl:value-of select="$msg/*/entry[@key='Overview']"/>
            </xsl:with-param>
          </xsl:call-template>

          <!-- Page Footer-->
          <xsl:call-template name="footer"/>

          <!-- Main page flow -->
          <fo:flow flow-name="xsl-region-body">
            <fo:table table-layout="fixed" width="100%">

              <!-- Table setup -->
              <fo:table-column column-width="proportional-column-width(20)"/>
              <fo:table-column column-width="proportional-column-width(80)"/>

              <fo:table-body>

                <!-- 1) Title header -->
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
                    <fo:block/>
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
        Variables read:
        msg, font-family

        Functions/templates called:
        count()
        header, footer
      -->

      <xsl:if test="$show-files-description = 1">

        <fo:page-sequence master-reference="default-page" font-family="{$font-family}" font-size="10pt">

          <!-- Page header -->
          <xsl:call-template name="header">
            <xsl:with-param name="section">
              <xsl:value-of select="$msg/*/entry[@key='Files_Description']"/>
            </xsl:with-param>
          </xsl:call-template>

          <!-- Page footer -->
          <xsl:call-template name="footer"/>

          <!-- Main Page Flow -->
          <fo:flow flow-name="xsl-region-body">

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
        Variables read:
        msg, show-variables-list-layout, font-family

        Functions/templates called
        count()
        header, footer
      -->

      <xsl:if test="$show-variables-list = 1">

        <fo:page-sequence master-reference="{$show-variables-list-layout}" font-family="{$font-family}" font-size="10pt">

          <!-- Page header -->
          <xsl:call-template name="header">
            <xsl:with-param name="section">
              <xsl:value-of select="$msg/*/entry[@key='Variables_List']"/>
            </xsl:with-param>
          </xsl:call-template>

          <!-- Page footer-->
          <xsl:call-template name="footer"/>

          <!-- main flow -->
          <fo:flow flow-name="xsl-region-body">

            <!-- Variables_List -->
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

            <!-- fileDscr -->
            <xsl:apply-templates select="/ddi:codeBook/ddi:fileDscr" mode="variables-list"/>

          </fo:flow>
        </fo:page-sequence>
      </xsl:if>


      <!-- ================================================ -->
      <!-- [8] Page sequence: Variable groups               -->
      <!-- [fo:page-sequence]                               -->
      <!-- ================================================ -->

      <!--
        Variables read:
        msg, font-family, numberOfGroups

        Functions/templates called:
        string-length(), count()
        header, footer
      -->

      <xsl:if test="$showVariableGroups = 1">

        <fo:page-sequence master-reference="default-page" font-family="{$font-family}" font-size="10pt">

          <!-- Page header -->
          <xsl:call-template name="header">
            <xsl:with-param name="section">
              <xsl:value-of select="$msg/*/entry[@key='Variables_Groups']"/>
            </xsl:with-param>
          </xsl:call-template>

          <!-- Page footer-->
          <xsl:call-template name="footer"/>

          <!-- main flow -->
          <fo:flow flow-name="xsl-region-body">

            <!-- Variables_Groups -->
            <fo:block id="variables-groups" font-size="18pt" font-weight="bold" space-after="0.1in">
              <xsl:value-of select="$msg/*/entry[@key='Variables_Groups']"/>
            </fo:block>

            <!-- Count -->
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

            <!-- varGrp -->
            <xsl:apply-templates select="/ddi:codeBook/ddi:dataDscr/ddi:varGrp"/>

          </fo:flow>
        </fo:page-sequence>
      </xsl:if>


      <!-- ==================================================== -->
      <!-- [9] Page sequence: Variables description             -->
      <!-- <fo:page-sequence>                                   -->
      <!-- ==================================================== -->

      <!--
        Variables read:
        font-family, msg, numberOfvars

        Functions/templates called
        count(), string-length()
        header, footer
      -->

      <xsl:if test="$show-variables-description = 1">

        <fo:page-sequence master-reference="default-page" font-family="{$font-family}" font-size="10pt">

          <!-- Page header -->
          <xsl:call-template name="header">
            <xsl:with-param name="section">
              <xsl:value-of select="$msg/*/entry[@key='Variables_Description']"/>
            </xsl:with-param>
          </xsl:call-template>

          <!-- Page footer-->
          <xsl:call-template name="footer"/>

          <!-- main flow -->
          <fo:flow flow-name="xsl-region-body">

            <!-- Variables_Description -->
            <fo:block id="variables-description" font-size="18pt" font-weight="bold" space-after="0.1in">
              <xsl:value-of select="$msg/*/entry[@key='Variables_Description']"/>
            </fo:block>

            <!-- Count -->
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

        <!-- fileDscr -->
        <xsl:apply-templates select="/ddi:codeBook/ddi:fileDscr" mode="variables-description"/>
      </xsl:if>


      <!-- =============================================== -->
      <!-- [10] Page sequence: Documentation               -->
      <!-- <fo:page-sequence>                              -->
      <!-- =============================================== -->

      <!--
        Variables set:
        rdf, adm-count, anl-count, qst-count, oth-count, ref-count,
        rep-count, tec-count, tbl-count, prg-count, unc-count

        Variables read:
        msg, rdf-file, font-family

        Functions/templates called:
        normalize-space(), count(), contains(), not() [Xpath]
        document() [XSLT 1.0]
        header, footer, documentation-toc-section
      -->

      <xsl:if test="$show-documentation = 1 and normalize-space($rdf-file)">

        <fo:page-sequence master-reference="default-page" font-family="{$font-family}" font-size="10pt">

          <!-- Page header -->
          <xsl:call-template name="header">
            <xsl:with-param name="section">
              <xsl:value-of select="$msg/*/entry[@key='Documentation']"/>
            </xsl:with-param>
          </xsl:call-template>

          <!-- Page footer-->
          <xsl:call-template name="footer"/>

          <!-- main flow -->
          <fo:flow flow-name="xsl-region-body">

            <!-- Documentation -->
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

            <!-- Table of contents -->
            <fo:block space-after="0.2in">

              <!-- Report/analytical -->
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

              <!-- Questionnaires -->
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

              <!-- Technical -->
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

              <!-- Administrative -->
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

              <!-- References -->
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

  <!-- templates matching the ddi: namespace -->
  <!-- Match: ddi:AuthEnty --><!-- Value: fo:block --><!--
  Functions/templates called:
  trim
--><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="ddi:AuthEnty" xml:base="includes/ddi/ddi-AuthEnty.xml">

  <fo:block>

    <!-- trim current node -->
    <xsl:call-template name="trim">
      <xsl:with-param name="s" select="."/>
    </xsl:call-template>

    <!-- affiliation attribute -->
    <xsl:if test="@affiliation">,
      <xsl:value-of select="@affiliation"/>
    </xsl:if>

  </fo:block>
</xsl:template>
  <!-- match: ddi:collDate --><!-- value: fo:block --><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="ddi:collDate" xml:base="includes/ddi/ddi-collDate.xml">

    <fo:block>

      <!-- @cycle -->
      <xsl:if test="@cycle">
        <xsl:value-of select="@cycle"/>
        <xsl:text>: </xsl:text>
      </xsl:if>

      <!-- @event -->
      <xsl:if test="@event">
        <xsl:value-of select="@event"/>
        <xsl:text> </xsl:text>
      </xsl:if>

      <!-- @date -->
      <xsl:value-of select="@date"/>

    </fo:block>

</xsl:template>
  <!-- match: ddi:contact --><!-- value: fo:block --><!--
  Functions/templates called:
  url() [FO]
--><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="ddi:contact" xml:base="includes/ddi/ddi-contact.xml">

    <fo:block>

      <!-- current Node -->
      <xsl:value-of select="."/>

      <!-- @affiliation -->
      <xsl:if test="@affiliation"> (
        <xsl:value-of select="@affiliation"/>)
      </xsl:if>

      <!-- [fo:basic-link] @URI -->
      <xsl:if test="@URI"> ,
        <fo:basic-link external-destination="url('{@URI}')" text-decoration="underline" color="blue">
          <xsl:value-of select="@URI"/>
        </fo:basic-link>
      </xsl:if>

      <!-- [fo:basic-link] @email -->
      <xsl:if test="@email"> ,
        <fo:basic-link external-destination="url('mailto:{@URI}')" text-decoration="underline" color="blue">
          <xsl:value-of select="@email"/>
        </fo:basic-link>
      </xsl:if>

    </fo:block>

</xsl:template>
  <!-- match: ddi:dataCollector --><!-- value: <fo:block> --><!--
  Functions/templates called:
  trim
--><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="ddi:dataCollector" xml:base="includes/ddi/ddi-dataCollector.xml">

  <fo:block>

    <!-- trim current node -->
    <xsl:call-template name="trim">
      <xsl:with-param name="s" select="."/>
    </xsl:call-template>

    <!-- @abbr -->
    <xsl:if test="@abbr">
      (<xsl:value-of select="@abbr"/>)
    </xsl:if>

    <!-- @affiliation -->
    <xsl:if test="@affiliation"> ,
      <xsl:value-of select="@affiliation"/>
    </xsl:if>

  </fo:block>

</xsl:template>
  <!-- match: ddi:fileDsrc / default --><!-- value: <fo:table> --><!--
  Variables read:
  msg, color-gray1, default-border, cell-padding

  Variables set:
  fileId, list

  Functions/templates called:
  concat(), contains(), normalize-space(), position() [Xpath 1.0]
  proportional-column-width() [FO]
--><!--
  1: Filename                 <fo:table-row>
  2: Cases                    <fo:table-row>
  3: Variables                <fo:table-row>
  4: File Structure           <fo:table-row>
  5: File Content             <fo:table-row>
  6: File Producer            <fo:table-row>
  7: File Version             <fo:table-row>
  8: File Processing Checks   <fo:table-row>
  9: File Missing Data        <fo:table-row>
  10: File Notes              <fo:table-row>
--><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="ddi:fileDscr" xml:base="includes/ddi/ddi-fileDscr.xml">

    <!-- variables -->
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

    <!-- content -->
    <fo:table id="file-{$fileId}" table-layout="fixed" width="100%" space-before="0.2in" space-after="0.2in">

      <!-- Set up column sizes -->
      <fo:table-column column-width="proportional-column-width(20)"/>
      <fo:table-column column-width="proportional-column-width(80)"/>

      <!-- [fo:table-body] -->
      <fo:table-body>

        <!-- 1) [fo:table-row] Filename -->
        <fo:table-row background-color="{$color-gray1}" keep-with-next="always">
          <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
            <fo:block font-size="12pt" font-weight="bold">
              <xsl:apply-templates select="ddi:fileTxt/ddi:fileName"/>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>

        <!-- 2) [fo:table-row] Cases -->
        <xsl:if test="ddi:fileTxt/ddi:dimensns/ddi:caseQnty">
          <fo:table-row>
            <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
              <fo:block>#
                <xsl:value-of select="$msg/*/entry[@key='Cases']"/>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
              <xsl:apply-templates select="ddi:fileTxt/ddi:dimensns/ddi:caseQnty"/>
            </fo:table-cell>
          </fo:table-row>
        </xsl:if>

        <!-- 3) [fo:table-row] Variables -->
        <xsl:if test="ddi:fileTxt/ddi:dimensns/ddi:varQnty">
          <fo:table-row>
            <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
              <fo:block>#
                <xsl:value-of select="$msg/*/entry[@key='Variables']"/>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
              <xsl:apply-templates select="ddi:fileTxt/ddi:dimensns/ddi:varQnty"/>
            </fo:table-cell>
          </fo:table-row>
        </xsl:if>

        <!-- 4) [fo:table-row] File structure -->
        <xsl:if test="ddi:fileTxt/ddi:fileStrc">
          <fo:table-row>

            <!-- [fo:table-cell] -->
            <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
              <fo:block>
                <xsl:value-of select="$msg/*/entry[@key='File_Structure']"/>
              </fo:block>
            </fo:table-cell>

            <!-- [fo:table-cell] -->
            <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
              <xsl:if test="ddi:fileTxt/ddi:fileStrc/@type">
                <fo:block>
                  <xsl:value-of select="$msg/*/entry[@key='Type']"/>:
                  <xsl:value-of select="ddi:fileTxt/ddi:fileStrc/@type"/>
                </fo:block>
              </xsl:if>

              <xsl:if test="ddi:fileTxt/ddi:fileStrc/ddi:recGrp/@keyvar">
                <fo:block>
                  <xsl:value-of select="$msg/*/entry[@key='Keys']"/>: 
                  <xsl:variable name="list" select="concat(ddi:fileTxt/ddi:fileStrc/ddi:recGrp/@keyvar,' ')"/>
                  <!-- add a space at the end of the list for matching puspose -->
                  <xsl:for-each select="/ddi:codeBook/ddi:dataDscr/ddi:var[contains($list,concat(@ID,' '))]">
                    <!-- add a space to the variable ID to avoid partial match -->
                    <xsl:if test="position()&gt;1">, </xsl:if>
                    <xsl:value-of select="./@name"/>
                    <xsl:if test="normalize-space(./ddi:labl)">
											 (
                      <xsl:value-of select="normalize-space(./ddi:labl)"/>)
                    </xsl:if>
                  </xsl:for-each>
                </fo:block>
              </xsl:if>

            </fo:table-cell>
          </fo:table-row>
        </xsl:if>

        <!-- 5) [fo:table-row] File content -->
        <xsl:for-each select="ddi:fileTxt/ddi:fileCont">
          <fo:table-row>
            <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
              <fo:block font-weight="bold" text-decoration="underline">
                <xsl:value-of select="$msg/*/entry[@key='File_Content']"/>
              </fo:block>
              <xsl:apply-templates select="."/>
            </fo:table-cell>
          </fo:table-row>
        </xsl:for-each>

        <!-- 6) [fo:table-row] File producer -->
        <xsl:for-each select="ddi:fileTxt/ddi:filePlac">
          <fo:table-row>
            <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
              <fo:block font-weight="bold" text-decoration="underline">
                <xsl:value-of select="$msg/*/entry[@key='Producer']"/>
              </fo:block>
              <xsl:apply-templates select="."/>
            </fo:table-cell>
          </fo:table-row>
        </xsl:for-each>

        <!-- 7) [fo:table-row] File version -->
        <xsl:for-each select="ddi:fileTxt/ddi:verStmt">
          <fo:table-row>
            <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
              <fo:block font-weight="bold" text-decoration="underline">
                <xsl:value-of select="$msg/*/entry[@key='Version']"/>
              </fo:block>
              <xsl:apply-templates select="."/>
            </fo:table-cell>
          </fo:table-row>
        </xsl:for-each>

        <!-- 8) [fo:table-row] File processing checks -->
        <xsl:for-each select="ddi:fileTxt/ddi:dataChck">
          <fo:table-row>
            <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
              <fo:block font-weight="bold" text-decoration="underline">
                <xsl:value-of select="$msg/*/entry[@key='Processing_Checks']"/>
              </fo:block>
              <xsl:apply-templates select="."/>
            </fo:table-cell>
          </fo:table-row>
        </xsl:for-each>

        <!-- 9) [fo:table-row] File missing data -->
        <xsl:for-each select="ddi:fileTxt/ddi:dataMsng">
          <fo:table-row>
            <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
              <fo:block font-weight="bold" text-decoration="underline">
                <xsl:value-of select="$msg/*/entry[@key='Missing_Data']"/>
              </fo:block>
              <xsl:apply-templates select="."/>
            </fo:table-cell>
          </fo:table-row>
        </xsl:for-each>

        <!-- 10) [fo:table-row] File notes -->
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

      </fo:table-body>
    </fo:table>

</xsl:template>
  <!-- ddi-fileDsrc_variables-description.xsl --><!-- =========================================== --><!-- match: ddi:fileDsrc / variables-description --><!-- fo:page-sequence (multiple)                 --><!-- =========================================== --><!--
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
--><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="ddi:fileDscr" mode="variables-description" xml:base="includes/ddi/ddi-fileDscr_variables-description.xml">

    <!-- variables -->
    <xsl:variable name="fileId">
      <xsl:choose>

        <!-- fileName ID attribute -->
        <xsl:when test="ddi:fileTxt/ddi:fileName/@ID">
          <xsl:value-of select="ddi:fileTxt/ddi:fileName/@ID"/>
        </xsl:when>

        <!-- ID attribute -->
        <xsl:when test="@ID">
          <xsl:value-of select="@ID"/>
        </xsl:when>

      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="fileName" select="ddi:fileTxt/ddi:fileName"/>

    <!-- content -->
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
                    <fo:block/>
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
  <!-- Match: ddi:fileDsrc / variables-list  --><!-- Value: fo:table --><!--
    Variables read:
    msg, default-border, cell-padding

    Variables set:
    fileId

    Functions/templates called:
    variables-table-col-width, variables-table-col-header
--><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="ddi:fileDscr" mode="variables-list" xml:base="includes/ddi/ddi-fileDscr_variables-list.xml">

  <!-- variables -->
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

  <!-- content -->
  <fo:table id="varlist-{ddi:fileTxt/ddi:fileName/@ID}" table-layout="fixed" width="100%" font-size="8pt" space-before="0.2in" space-after="0.2in">

    <xsl:call-template name="variables-table-col-width"/>

    <!-- [fo:table-header] -->
    <fo:table-header>
      <fo:table-row text-align="center" vertical-align="top" keep-with-next="always">
        <fo:table-cell text-align="left" number-columns-spanned="8" border="{$default-border}" padding="{$cell-padding}">
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
  <!-- Match: ddi:fileName --><!-- Value: filename minus .NSDstat extension --><!--
  Variables set:
  filename

  Functions/templates called:
  contains(), normalize-space(), string-length(), substring()
--><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="ddi:fileName" xml:base="includes/ddi/ddi-fileName.xml">

    <!-- variables -->
    <xsl:variable name="filename" select="normalize-space(.)"/>

    <!-- content -->
    <!-- Check if filename has .NSDstat extension -->
    <xsl:choose>

      <!-- filename contains .NSDstat-->
      <xsl:when test=" contains( $filename , '.NSDstat' )">
        <xsl:value-of select="substring($filename,1,string-length($filename)-8)"/>
      </xsl:when>

      <!-- does not contain .NSDstat -->
      <xsl:otherwise>
        <xsl:value-of select="$filename"/>
      </xsl:otherwise>

    </xsl:choose>

</xsl:template>
  <!-- Match: ddi:fundAg --><!-- Value: <fo:block> --><!--
  Functions/templates called:
  trim
--><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="ddi:fundAg" xml:base="includes/ddi/ddi-fundAg.xml">

  <fo:block>

    <!-- trim current node -->
    <xsl:call-template name="trim">
      <xsl:with-param name="s" select="."/>
    </xsl:call-template>

    <!-- @abbr -->
    <xsl:if test="@abbr">
      (<xsl:value-of select="@abbr"/>)
    </xsl:if>

    <!-- @role -->
    <xsl:if test="@role"> ,
      <xsl:value-of select="@role"/>
    </xsl:if>

  </fo:block>

</xsl:template>
  <!-- Match: ddi:IDNo --><!-- Value: <fo:block> --><!--
  Functions/templates called:
  trim
--><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="ddi:IDNo" xml:base="includes/ddi/ddi-IDNo.xml">

  <fo:block>

    <!-- @agency -->
    <xsl:if test="@agency">
      <xsl:value-of select="@agency"/>:
    </xsl:if>

    <!-- trim current node -->
    <xsl:call-template name="trim">
      <xsl:with-param name="s" select="."/>
    </xsl:call-template>

  </fo:block>

</xsl:template>
  <!-- Match: ddi:othId --><!-- Value: <fo:block> --><!--
  Functions/templates called:
  trim
--><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="ddi:othId" xml:base="includes/ddi/ddi-othId.xml">

  <fo:block>

    <!-- trim current node -->
    <xsl:call-template name="trim">
      <xsl:with-param name="s" select="ddi:p"/>
    </xsl:call-template>

    <!-- @role -->
    <xsl:if test="@role"> ,
      <xsl:value-of select="@role"/>
    </xsl:if>

    <!-- @affiliation -->
    <xsl:if test="@affiliation"> ,
      <xsl:value-of select="@affiliation"/>
    </xsl:if>

  </fo:block>

</xsl:template>
  <!-- Match: ddi:producer --><!-- Value: <fo:block> --><!--
  Functions/templates called:
  trim
--><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="ddi:producer" xml:base="includes/ddi/ddi-producer.xml">

  <fo:block>

    <!-- trim current node -->
    <xsl:call-template name="trim">
      <xsl:with-param name="s" select="."/>
    </xsl:call-template>

    <!-- @abbr -->
    <xsl:if test="@abbr">
      (<xsl:value-of select="@abbr"/>)
    </xsl:if>

    <!-- @affiliation -->
    <xsl:if test="@affiliation"> ,
      <xsl:value-of select="@affiliation"/>
    </xsl:if>

    <!-- @role -->
    <xsl:if test="@role"> ,
      <xsl:value-of select="@role"/>
    </xsl:if>

  </fo:block>
</xsl:template>
  <!-- Match: ddi:timePrd --><!-- Value: <fo:block> --><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="ddi:timePrd" xml:base="includes/ddi/ddi-timePrd.xml">

  <fo:block>

      <!-- @cycle -->
      <xsl:if test="@cycle">
        <xsl:value-of select="@cycle"/>
        <xsl:text>: </xsl:text>
      </xsl:if>

      <!-- @event -->
      <xsl:if test="@event">
        <xsl:value-of select="@event"/>
        <xsl:text> </xsl:text>
      </xsl:if>

      <!-- @date -->
      <xsl:value-of select="@date"/>

  </fo:block>
</xsl:template>
  <!-- Match: ddi:var / default --><!-- Value: <fo:table-row> --><!--
  Parameters used:
  fileId

  Variables read:
  msg, cell-padding,  color-gray1, default-border,
  show-variables-description-categories-max, subsetVars,

  Variables set:
  statistics, type, label, category-count, is-weighted,
  catgry-freq-nodes, catgry-sum-freq, catgry-sum-freq-wgtd,
  catgry-max-freq, catgry-max-freq-wgtd, bar-column-width, catgry-freq

  Functions/templates called:
  concat(), contains(), string-length(), normalize-space(), number(),
  position(), string() [Xpath 1.0]
  math:max, trim
--><!--
  fo output by section:
  1: Information                <fo:table-row>
  2: Statistics                 <fo:table-row>
  3: Definition                 <fo:table-row>
  4: Universe                   <fo:table-row>
  5: Source                     <fo:table-row>
  6: Pre-Question               <fo:table-row>
  7: Question                   <fo:table-row>
  8: Post-Question              <fo:table-row>
  9: Interviewer Instructions   <fo:table-row>
  10: Imputation                <fo:table-row>
  11: Recoding                  <fo:table-row>
  12: Security                  <fo:table-row>
  13: Concepts                  <fo:table-row>
  14: Notes                     <fo:table-row>
  15: Categories                <fo:table-row>
--><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="ddi:var" xml:base="includes/ddi/ddi-var.xml">

  <!-- params -->
  <xsl:param name="fileId" select="./@files"/> <!-- use first file in @files if not specified) -->

  <!-- content -->
  <xsl:if test="contains($subsetVars, concat(',',@ID,',')) or string-length($subsetVars) = 0 ">
    <fo:table-row text-align="center" vertical-align="top">
      <fo:table-cell>
        <fo:table id="var-{@ID}" table-layout="fixed" width="100%" font-size="8pt" space-after="0.3in">
          <fo:table-column column-width="proportional-column-width(20)"/>
          <fo:table-column column-width="proportional-column-width(80)"/>

          <!-- =================================== -->
          <!-- [fo:table-header] Main table Header -->
          <!-- =================================== -->
          <fo:table-header>
            <fo:table-row background-color="{$color-gray1}" text-align="center" vertical-align="top">
              <fo:table-cell number-columns-spanned="2" font-size="10pt" font-weight="bold" text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <fo:inline font-size="8pt" font-weight="normal" vertical-align="text-top">#
                    <xsl:value-of select="./@id"/>
                    <xsl:text> </xsl:text>
                  </fo:inline>

                  <xsl:value-of select="./@name"/>

                  <xsl:if test="normalize-space(./ddi:labl)">
                    <xsl:text>: </xsl:text>
                    <xsl:value-of select="normalize-space(./ddi:labl)"/>
                  </xsl:if>

                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-header>

            <!-- =============================== -->
            <!-- [fo:table-body] Main table body -->
            <!-- =============================== -->
            <fo:table-body>

              <!-- 1) [fo:table-row] Information -->
              <fo:table-row text-align="center" vertical-align="top">

                <fo:table-cell font-weight="bold" text-align="left" border="{$default-border}" padding="{$cell-padding}">
                  <fo:block>
                    <xsl:value-of select="$msg/*/entry[@key='Information']"/>
                  </fo:block>
                </fo:table-cell>

                <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                  <fo:block>

                    <!-- Information: Type -->
                    <xsl:if test="normalize-space(@intrvl)">
                      <xsl:text> [</xsl:text>
                      <xsl:value-of select="$msg/*/entry[@key='Type']"/>=
                      <xsl:choose>
                        <xsl:when test="@intrvl='discrete'">
                          <xsl:value-of select="$msg/*/entry[@key='discrete']"/>
                        </xsl:when>
                        <xsl:when test="@intrvl='contin'">
                          <xsl:value-of select="$msg/*/entry[@key='continuous']"/>
                        </xsl:when>
                      </xsl:choose>
                      <xsl:text>] </xsl:text>
                    </xsl:if>

                    <!-- Information: Format -->
                    <xsl:for-each select="ddi:varFormat">
                      <xsl:text> [</xsl:text>
                      <xsl:value-of select="$msg/*/entry[@key='Format']"/>=
                      <xsl:value-of select="@type"/>
                      <xsl:if test="normalize-space(ddi:location/@width)">
                        <xsl:text>-</xsl:text>
                        <xsl:value-of select="ddi:location/@width"/>
                      </xsl:if>
                      <xsl:if test="normalize-space(@dcml)">
                        <xsl:text>.</xsl:text>
                        <xsl:value-of select="@dcml"/>
                      </xsl:if>
                      <xsl:text>] </xsl:text>
                    </xsl:for-each>

                    <!-- Information: Range -->
                    <xsl:for-each select="ddi:valrng/ddi:range">
                      <xsl:text> [</xsl:text>
                      <xsl:value-of select="$msg/*/entry[@key='Range']"/>=
                      <xsl:value-of select="@min"/>-
                      <xsl:value-of select="@max"/>
                      <xsl:text>] </xsl:text>
                    </xsl:for-each>

                    <!-- Infotmation: Missing -->
                    <xsl:text> [</xsl:text>
                    <xsl:value-of select="$msg/*/entry[@key='Missing']"/>
                    <xsl:text>=*</xsl:text>
                    <xsl:for-each select="ddi:invalrng/ddi:item">
                      <xsl:text>/</xsl:text>
                      <xsl:value-of select="@VALUE"/>
                    </xsl:for-each>
                    <xsl:text>] </xsl:text>

                  </fo:block>
                </fo:table-cell>
              </fo:table-row>

              <!-- 2) [fo:table-row] Statistics -->
              <xsl:variable name="statistics" select="ddi:sumStat[contains('vald invd mean stdev',@type)]"/>

              <xsl:if test="$statistics">
                <fo:table-row text-align="center" vertical-align="top">
                  <fo:table-cell font-weight="bold" text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block>
                      <xsl:value-of select="$msg/*/entry[@key='Statistics']"/>
                      <xsl:text> [</xsl:text>
                      <xsl:value-of select="$msg/*/entry[@key='Abbrev_NotWeighted']"/>
                      <xsl:text>/ </xsl:text>
                      <xsl:value-of select="$msg/*/entry[@key='Abbrev_Weighted']"/>
                      <xsl:text>]</xsl:text>
                    </fo:block>
                  </fo:table-cell>

                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block>

                      <!-- Statistics: Summary statistics -->
                      <xsl:for-each select="$statistics[not(@wgtd)]">
                        <xsl:variable name="type" select="@type"/>

                        <xsl:variable name="label">
                          <xsl:choose>
                            <xsl:when test="@type='vald' ">
                              <xsl:value-of select="$msg/*/entry[@key='Valid']"/>
                            </xsl:when>
                            <xsl:when test="@type='invd' ">
                              <xsl:value-of select="$msg/*/entry[@key='Invalid']"/>
                            </xsl:when>
                            <xsl:when test="@type='mean' ">
                              <xsl:value-of select="$msg/*/entry[@key='Mean']"/>
                            </xsl:when>
                            <xsl:when test="@type='stdev' ">
                              <xsl:value-of select="$msg/*/entry[@key='StdDev']"/>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="@type"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:variable>

                        <xsl:text> [</xsl:text>
                        <xsl:value-of select="$label"/>
                        <xsl:text>=</xsl:text>
                        <xsl:value-of select="normalize-space(.)"/>

                        <!-- Statistics: Weighted value -->
                        <xsl:text> /</xsl:text>
                        <xsl:choose>
                          <xsl:when test="following-sibling::ddi:sumStat[1]/@type=$type and following-sibling::ddi:sumStat[1]/@wgtd">
                            <xsl:value-of select="following-sibling::ddi:sumStat[1]"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:text>-</xsl:text>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:text>] </xsl:text>
                      </xsl:for-each>
                    </fo:block>
                  </fo:table-cell>

                </fo:table-row>
              </xsl:if>

              <!-- 3) [fo:table-row] Definition  -->
              <xsl:if test="normalize-space(./ddi:txt)">
                <fo:table-row text-align="center" vertical-align="top">
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block font-weight="bold">
                      <xsl:value-of select="$msg/*/entry[@key='Definition']"/>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block>
                      <xsl:apply-templates select="./ddi:txt"/>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </xsl:if>

              <!-- 4) [fo:table-row] Universe  -->
              <xsl:if test="normalize-space(./ddi:universe)">
                <fo:table-row text-align="center" vertical-align="top">
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block font-weight="bold">
                      <xsl:value-of select="$msg/*/entry[@key='Universe']"/>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block>
                      <xsl:apply-templates select="./ddi:universe"/>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </xsl:if>

              <!-- 5) [fo:table-row] Source -->
              <xsl:if test="normalize-space(./ddi:respUnit)">
                <fo:table-row text-align="center" vertical-align="top">
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block font-weight="bold">
                      <xsl:value-of select="$msg/*/entry[@key='Source']"/>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block>
                      <xsl:apply-templates select="./ddi:respUnit"/>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </xsl:if>

              <!-- 6) [fo:table-row] Pre-Question -->
              <xsl:if test="normalize-space(./ddi:qstn/ddi:preQTxt)">
                <fo:table-row text-align="center" vertical-align="top">
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block font-weight="bold">
                      <xsl:value-of select="$msg/*/entry[@key='Pre-question']"/>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block>
                      <xsl:apply-templates select="./ddi:qstn/ddi:preQTxt"/>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </xsl:if>

              <!-- 7) [fo:table-row] Question -->
              <xsl:if test="normalize-space(./ddi:qstn/ddi:qstnLit)">
                <fo:table-row text-align="center" vertical-align="top">
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block font-weight="bold">
                      <xsl:value-of select="$msg/*/entry[@key='Literal_question']"/>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block>
                      <xsl:apply-templates select="./ddi:qstn/ddi:qstnLit"/>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </xsl:if>

              <!-- 8) [fo:table-row] Post-question -->
              <xsl:if test="normalize-space(./ddi:qstn/ddi:postQTxt)">
                <fo:table-row text-align="center" vertical-align="top">
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block font-weight="bold">
                      <xsl:value-of select="$msg/*/entry[@key='Post-question']"/>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block>
                      <xsl:apply-templates select="./ddi:qstn/ddi:postQTxt"/>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </xsl:if>

              <!-- 9) [fo:table-row] Interviewer instructions -->
              <xsl:if test="normalize-space(./ddi:qstn/ddi:ivuInstr)">
                <fo:table-row text-align="center" vertical-align="top">
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block font-weight="bold">
                      <xsl:value-of select="$msg/*/entry[@key='Interviewers_instructions']"/>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block>
                      <xsl:apply-templates select="./ddi:qstn/ddi:ivuInstr"/>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </xsl:if>

              <!-- 10) [fo:table-row] Imputation -->
              <xsl:if test="normalize-space(./ddi:imputation)">
                <fo:table-row text-align="center" vertical-align="top">
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block font-weight="bold">
                      <xsl:value-of select="$msg/*/entry[@key='Imputation']"/>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block>
                      <xsl:apply-templates select="./ddi:imputation"/>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </xsl:if>

              <!-- 11) [fo:table-row] Recoding -->
              <xsl:if test="normalize-space(./ddi:codInstr)">
                <fo:table-row text-align="center" vertical-align="top">
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block font-weight="bold">
                      <xsl:value-of select="$msg/*/entry[@key='Recoding_and_Derivation']"/>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block>
                      <xsl:apply-templates select="./ddi:codInstr"/>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </xsl:if>

              <!-- 12) [fo:table-row] Security -->
              <xsl:if test="normalize-space(./ddi:security)">
                <fo:table-row text-align="center" vertical-align="top">
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block font-weight="bold">
                      <xsl:value-of select="$msg/*/entry[@key='Security']"/>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block>
                      <xsl:apply-templates select="./ddi:security"/>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </xsl:if>

              <!-- 13) [fo:table-row] Concepts -->
              <xsl:if test="normalize-space(./ddi:concept)">
                <fo:table-row text-align="center" vertical-align="top">
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block font-weight="bold">
                      <xsl:value-of select="$msg/*/entry[@key='Concepts']"/>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block>
                      <xsl:for-each select="./ddi:concept">
                        <xsl:if test="position()&gt;1">, </xsl:if>
                        <xsl:value-of select="normalize-space(.)"/>
                      </xsl:for-each>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </xsl:if>

              <!-- 14) [fo:table-row] Notes -->
              <xsl:if test="normalize-space(./ddi:notes)">
                <fo:table-row text-align="center" vertical-align="top">
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block font-weight="bold">
                      <xsl:value-of select="$msg/*/entry[@key='Notes']"/>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block>
                      <xsl:apply-templates select="./ddi:notes"/>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </xsl:if>

              <!-- 15) [fo:table-row] Categories -->
              <xsl:if test="$show-variables-description-categories=1 and normalize-space(./ddi:catgry)">
                <xsl:variable name="category-count" select="count(ddi:catgry)"/>

                <fo:table-row text-align="center" vertical-align="top">
                  <xsl:choose>

                    <!-- ======================= -->
                    <!-- Case 1) [fo:table-cell] -->
                    <!-- ======================= -->
                    <xsl:when test="number($show-variables-description-categories-max) &gt;= $category-count">
                      <fo:table-cell text-align="left" border="{$default-border}" number-columns-spanned="2" padding="{$cell-padding}">


                        <!-- Variables -->
                        <xsl:variable name="is-weighted" select="count(ddi:catgry/ddi:catStat[@type='freq' and @wgtd='wgtd' ]) &gt; 0"/>
                        <xsl:variable name="catgry-freq-nodes" select="ddi:catgry[not(@missing='Y')]/ddi:catStat[@type='freq']"/>
                        <xsl:variable name="catgry-sum-freq" select="sum($catgry-freq-nodes[ not(@wgtd='wgtd') ])"/>
                        <xsl:variable name="catgry-sum-freq-wgtd" select="sum($catgry-freq-nodes[ @wgtd='wgtd'])"/>

                        <xsl:variable name="catgry-max-freq">
                          <xsl:call-template name="math:max">
                            <xsl:with-param name="nodes" select="$catgry-freq-nodes[ not(@wgtd='wgtd') ]"/>
                          </xsl:call-template>
                        </xsl:variable>

                        <xsl:variable name="catgry-max-freq-wgtd">
                          <xsl:call-template name="math:max">
                            <xsl:with-param name="nodes" select="$catgry-freq-nodes[@type='freq' and @wgtd='wgtd' ]"/>
                          </xsl:call-template>
                        </xsl:variable>

                        <!-- [fo:table] Render table -->
                        <fo:table id="var-{@ID}-cat" table-layout="fixed" width="100%" font-size="8pt">
                          <fo:table-column column-width="proportional-column-width(12)"/>
                          <xsl:choose>
                            <xsl:when test="$is-weighted">
                              <fo:table-column column-width="proportional-column-width(33)"/>
                              <fo:table-column column-width="proportional-column-width(8)"/>
                              <fo:table-column column-width="proportional-column-width(12)"/>
                            </xsl:when>
                            <xsl:otherwise>
                              <fo:table-column column-width="proportional-column-width(45)"/>
                              <fo:table-column column-width="proportional-column-width(8)"/>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:variable name="bar-column-width" select="2.5"/>
                          <fo:table-column column-width="{$bar-column-width}in"/>

                          <!-- [fo:table-header] Table header -->
                          <fo:table-header>
                            <fo:table-row background-color="{$color-gray1}" text-align="left" vertical-align="top">
                              <fo:table-cell border="0.5pt solid white" padding="{$cell-padding}">
                                <fo:block font-weight="bold">
                                  <xsl:value-of select="$msg/*/entry[@key='Value']"/>
                                </fo:block>
                              </fo:table-cell>
                              <fo:table-cell border="0.5pt solid white" padding="{$cell-padding}">
                                <fo:block font-weight="bold">
                                  <xsl:value-of select="$msg/*/entry[@key='Label']"/>
                                </fo:block>
                              </fo:table-cell>
                              <fo:table-cell border="0.4pt solid white" padding="{$cell-padding}" text-align="center">
                                <fo:block font-weight="bold">
                                  <xsl:value-of select="$msg/*/entry[@key='Cases_Abbreviation']"/>
                                </fo:block>
                              </fo:table-cell>
                              <xsl:if test="$is-weighted">
                                <fo:table-cell border="0.4pt solid white" padding="{$cell-padding}" text-align="center">
                                  <fo:block font-weight="bold">
                                    <xsl:value-of select="$msg/*/entry[@key='Weighted']"/>
                                  </fo:block>
                                </fo:table-cell>
                              </xsl:if>
                              <fo:table-cell border="0.4pt solid white" padding="{$cell-padding}" text-align="center">
                                <fo:block font-weight="bold">
                                  <xsl:value-of select="$msg/*/entry[@key='Percentage']"/>
                                  <xsl:if test="$is-weighted"> (
                                    <xsl:value-of select="$msg/*/entry[@key='Weighted']"/>)
                                  </xsl:if>
                                </fo:block>
                              </fo:table-cell>
                            </fo:table-row>
                          </fo:table-header>

                          <!-- [fo:table-body] Table body -->
                          <fo:table-body>
                            <xsl:for-each select="ddi:catgry">
                              <fo:table-row background-color="{$color-gray2}" text-align="center" vertical-align="top">

                                <!-- [fo:table-cell] Value -->
                                <fo:table-cell text-align="left" border="0.5pt solid white" padding="2pt">
                                  <fo:block>
                                    <xsl:call-template name="trim">
                                      <xsl:with-param name="s" select="ddi:catValu"/>
                                    </xsl:call-template>
                                  </fo:block>
                                </fo:table-cell>

                                <!-- [fo:table-cell] Label -->
                                <fo:table-cell text-align="left" border="0.5pt solid white" padding="2pt">
                                  <fo:block>
                                    <xsl:call-template name="trim">
                                      <xsl:with-param name="s" select="ddi:labl"/>
                                    </xsl:call-template>
                                  </fo:block>
                                </fo:table-cell>

                                <!-- [fo:table-cell] Frequency -->
                                <xsl:variable name="catgry-freq" select="ddi:catStat[@type='freq' and not(@wgtd='wgtd') ]"/>
                                <fo:table-cell text-align="center" border="0.5pt solid white" padding="2pt">
                                  <fo:block>
                                    <xsl:call-template name="trim">
                                      <xsl:with-param name="s" select="$catgry-freq"/>
                                    </xsl:call-template>
                                  </fo:block>
                                </fo:table-cell>

                                <!-- [fo:table-cell] Weighted frequency -->
                                <xsl:variable name="catgry-freq-wgtd" select="ddi:catStat[@type='freq' and @wgtd='wgtd' ]"/>
                                <xsl:if test="$is-weighted">
                                  <fo:table-cell text-align="center" border="0.5pt solid white" padding="2pt">
                                    <fo:block>
                                      <xsl:call-template name="trim">
                                        <xsl:with-param name="s" select="format-number($catgry-freq-wgtd,'0.0')"/>
                                      </xsl:call-template>
                                    </fo:block>
                                  </fo:table-cell>
                                </xsl:if>

                                <!-- Percentage Bar-->
                                <!-- compute percentage -->
                                <xsl:variable name="catgry-pct">
                                  <xsl:choose>
                                    <xsl:when test="$is-weighted">
                                      <xsl:value-of select="$catgry-freq-wgtd div $catgry-sum-freq-wgtd"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      <xsl:value-of select="$catgry-freq div $catgry-sum-freq"/>
                                    </xsl:otherwise>
                                  </xsl:choose>
                                </xsl:variable>
                                <!-- compute bar width (percentage of highest value minus some space to display the percentage value) -->
                                <xsl:variable name="tmp-col-width-1">
                                  <xsl:choose>
                                    <xsl:when test="$is-weighted">
                                      <xsl:value-of select="($catgry-freq-wgtd div $catgry-max-freq-wgtd) * ($bar-column-width - 0.5)"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      <xsl:value-of select="($catgry-freq div $catgry-max-freq) * ($bar-column-width - 0.5)"/>
                                    </xsl:otherwise>
                                  </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="col-width-1">
                                  <!--	ToDO: handle exceptions regarding column-width	-->
                                  <xsl:choose>
                                    <xsl:when test="string(number($tmp-col-width-1)) != 'NaN'">
                                      <xsl:value-of select="$tmp-col-width-1"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      0
                                    </xsl:otherwise>
                                  </xsl:choose>
                                </xsl:variable>
                                <!-- compute remaining space for second column -->
                                <xsl:variable name="col-width-2" select="$bar-column-width - $col-width-1"/>
                                <!-- display the bar but not for missing values or if there was a problem computing the width -->
                                <xsl:if test="not(@missing='Y') and $col-width-1 &gt; 0">
                                  <fo:table-cell text-align="left" border="0.5pt solid white" padding="2pt">
                                    <fo:table table-layout="fixed" width="100%">
                                      <fo:table-column column-width="{$col-width-1}in"/>
                                      <fo:table-column column-width="{$col-width-2}in"/>
                                      <fo:table-body>
                                        <fo:table-row>
                                          <fo:table-cell background-color="{$color-gray4}">
                                            <fo:block> </fo:block>
                                          </fo:table-cell>
                                          <fo:table-cell margin-left="0.05in">
                                            <fo:block>
                                              <xsl:value-of select="format-number($catgry-pct , '#0.0%')"/>
                                            </fo:block>
                                          </fo:table-cell>
                                        </fo:table-row>
                                      </fo:table-body>
                                    </fo:table>
                                    <!-- end bar table -->
                                  </fo:table-cell>
                                </xsl:if>
                              </fo:table-row>
                            </xsl:for-each>
                            <!-- category total -->
                            <!-- TODO -->
                          </fo:table-body>
                        </fo:table>

                        <!-- [fo:block] Warning about summary of statistics? -->
                        <fo:block font-weight="bold" color="#400000" font-size="6pt" font-style="italic">
                          <xsl:value-of select="$msg/*/entry[@key='SumStat_Warning']"/>
                        </fo:block>

                      </fo:table-cell>
                    </xsl:when>

                    <!-- ======================= -->
                    <!-- Case 2) [fo:table-cell] -->
                    <!-- ======================= -->
                    <xsl:otherwise>
                      <fo:table-cell background-color="{$color-gray1}" text-align="center" font-style="italic" border="{$default-border}" number-columns-spanned="2" padding="{$cell-padding}">
                        <fo:block>
                          <xsl:value-of select="$msg/*/entry[@key='Frequency_table_not_shown']"/>
                          <xsl:text> </xsl:text>(
                          <xsl:value-of select="$category-count"/>
                          <xsl:text> </xsl:text>
                          <xsl:value-of select="$msg/*/entry[@key='Modalities']"/>)
                        </fo:block>
                      </fo:table-cell>
                    </xsl:otherwise>

                  </xsl:choose>
                </fo:table-row>
              </xsl:if>

            </fo:table-body>
          </fo:table> <!-- end of variable table -->

        </fo:table-cell>
      </fo:table-row>

    </xsl:if>

</xsl:template>
  <!-- ddi_match.xsl --><!-- =============================== --><!-- match: ddi:var / variables-list --><!-- fo:table-row                    --><!-- =============================== --><!--
  parameters:
  ($fileId)

  global vars read:
  $subserVars, $color-white, $default-border, $cell-padding,
  $show-variables-list, $variable-name-length,

  XPath 1.0 functions called:
    concat(), contains(), count(), position(), normalize-space(),
    string-length(), substring()
--><!--
    1: Variable Position          <fo:table-cell>
    2: Variable Name              <fo:table-cell>
    3: Variable Label             <fo:table-cell>
    4: Variable Type              <fo:table-cell>
    5: Variable Format            <fo:table-cell>
    6: Variable Valid             <fo:table-cell>
    7: Variable Invalid           <fo:table-cell>
    8: Variable Literal Question  <fo:table-cell>
--><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="ddi:var" mode="variables-list" xml:base="includes/ddi/ddi-var_variablesList.xml">
    <!-- params -->
    <xsl:param name="fileId" select="./@files"/> <!-- (use first file in @files if not specified) -->

    <!-- content -->
    <!-- [fo:table-row] Main -->
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
  <!-- Match: ddi:varGrp --><!-- Value: <fo:table> --><!--
    Variables read:
    msg, subsetGroups, default-border, cell-padding

    Variables set:
    list

    Functions and templates called:
    contains(), concat(), position(), string-length(),
    normalize-space() [Xpath 1.0]
    proportional-column-width() [FO]
    variables-table-column-width, variables-table-column-header
--><!--
    1: Group Name     <fo:table-row>
    2: Text           <fo:table-row>
    3: Definition     <fo:table-row>
    4: Universe       <fo:table-row>
    5: Notes          <fo:table-row>
    6: Subgroups      <fo:table-row>
--><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="ddi:varGrp" xml:base="includes/ddi/ddi-varGrp.xml">

    <xsl:if test="contains($subsetGroups,concat(',',@ID,',')) or string-length($subsetGroups)=0">

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
        <fo:table id="varlist-{@ID}" table-layout="fixed" width="100%" font-size="8pt" space-after="0.0in">

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
  <!-- match: ddi:*|text() --><!-- value: <fo:block> / [-] --><!-- the default text --><!--
  Variables set:
  trimmed

  Functions/templates called:
  trim, FixHTML
--><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="ddi:*|text()" xml:base="includes/ddi/ddi_default_text.xml">

    <!-- Case 1) HTML content -->
    <xsl:if test="$allowHTML = 1">
      <xsl:call-template name="FixHTML">
        <xsl:with-param name="InputString" select="."/>
      </xsl:call-template>
    </xsl:if>

    <!-- Case 2) No HTML content -->
    <xsl:if test="$allowHTML = 0">

      <!-- variables -->
      <xsl:variable name="trimmed">
        <xsl:call-template name="trim">
          <xsl:with-param name="s" select="."/>
        </xsl:call-template>
      </xsl:variable>

      <!-- content -->
      <fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0in">
        <xsl:value-of select="$trimmed"/>
      </fo:block>

    </xsl:if>

</xsl:template>

  <!-- templates matching the rdf: namespace -->
  <!-- Match: rdf:Description --><!-- Value: <fo:block> --><!--
    Parameters/variables read:
    msg, color-gray1, color-gray2, color-white,
    show-documentation-description

    Variables set:
    date

    Functions/templates called:
    normalize-space(), string-length(), boolean(), position() [Xpath 1.0]
    generate-id() [XSLT 1.0]
    isodate-month, trim
--><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="rdf:Description" xml:base="includes/rdf/rdf-Description.xml">


    <!-- content -->
    <fo:block id="{generate-id()}" background-color="{$color-gray1}" space-after="0.2in" border-top="0.5pt solid {$color-gray2}" border-bottom="0.5pt solid {$color-gray2}" padding-bottom="0.05in" padding-top="0.05in">

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

  <!-- Named/utility templates -->
  <!-- Name: documentation-toc-section --><!-- Value: <fo:block> --><!--
    Params/variables read:
    nodes [param]
    msg

    Functions/templates called:
    normalize-space() [Xpath 1.0]
    generate-id() [FO]
--><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" name="documentation-toc-section" xml:base="includes/named/documentation-toc-section.xml">

    <!-- params -->
    <xsl:param name="nodes"/>

    <!-- ==================================== -->
    <!-- r) [fo:block] Iterate through $nodes -->
    <!-- ==================================== -->
    <xsl:for-each select="$nodes">
      <fo:block margin-left="0.1in" font-size="8pt" text-align-last="justify" space-after="0.03in">

        <!-- [fo:basic-link] -->
        <fo:basic-link internal-destination="{generate-id()}" text-decoration="underline" color="blue">
          <xsl:choose>
            <xsl:when test="normalize-space(dc:title)">
              <xsl:value-of select="normalize-space(dc:title)"/>
            </xsl:when>

            <xsl:otherwise>
              <xsl:text>*** </xsl:text>
              <xsl:value-of select="$msg/*/entry[@key='Untitled']"/>
              <xsl:text> ****</xsl:text>
            </xsl:otherwise>
          </xsl:choose>

          <fo:leader leader-pattern="dots"/>
          <fo:page-number-citation ref-id="{generate-id()}"/>
        </fo:basic-link>

      </fo:block>
    </xsl:for-each>

</xsl:template>
  <!-- Name: variables-table-col-header --><!-- Value: <fo:table-row> --><!-- Header for variable table --><!--
    Params/variables read:
    msg, show-variables-list-question
--><!--
    1: #-character    <fo:table-cell>
    2: Name           <fo:table-cell>
    3: Label          <fo:table-cell>
    4: Type           <fo:table-cell>
    5: Format         <fo:table-cell>
    6: Valid          <fo:table-cell>
    7: Invalid        <fo:table-cell>
    8: Question       <fo:table-cell>
--><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" name="variables-table-col-header" xml:base="includes/named/variables-table-col-header.xml">

    <!-- content -->
    <fo:table-row text-align="center" vertical-align="top" font-weight="bold" keep-with-next="always">

      <!-- 1) [fo:table-cell] #-character -->
      <fo:table-cell border="0.5pt solid black" padding="3pt">
        <fo:block>#</fo:block>
      </fo:table-cell>

      <!-- 2) [fo:table-cell] Name -->
      <fo:table-cell border="0.5pt solid black" padding="3pt">
        <fo:block>
          <xsl:value-of select="$msg/*/entry[@key='Name']"/>
        </fo:block>
      </fo:table-cell>

      <!-- 3) [fo:table-cell] Label -->
      <fo:table-cell border="0.5pt solid black" padding="3pt">
        <fo:block>
          <xsl:value-of select="$msg/*/entry[@key='Label']"/>
        </fo:block>
      </fo:table-cell>

      <!-- 4) [fo:table-cell]Type -->
      <fo:table-cell border="0.5pt solid black" padding="3pt">
        <fo:block>
          <xsl:value-of select="$msg/*/entry[@key='Type']"/>
        </fo:block>
      </fo:table-cell>

      <!-- 5) [fo:table-cell] Format -->
      <fo:table-cell border="0.5pt solid black" padding="3pt">
        <fo:block>
          <xsl:value-of select="$msg/*/entry[@key='Format']"/>
        </fo:block>
      </fo:table-cell>

      <!-- 6) [fo:table-cell] Valid -->
      <fo:table-cell border="0.5pt solid black" padding="3pt">
        <fo:block>
          <xsl:value-of select="$msg/*/entry[@key='Valid']"/>
        </fo:block>
      </fo:table-cell>

      <!-- 7) [fo:table-cell] Invalid -->
      <fo:table-cell border="0.5pt solid black" padding="3pt">
        <fo:block>
          <xsl:value-of select="$msg/*/entry[@key='Invalid']"/>
        </fo:block>
      </fo:table-cell>

      <!-- 8) [fo:table-cell] Question -->
      <xsl:if test="$show-variables-list-question">
        <fo:table-cell border="0.5pt solid black" padding="3pt">
          <fo:block>
            <xsl:value-of select="$msg/*/entry[@key='Question']"/>
          </fo:block>
        </fo:table-cell>
      </xsl:if>

    </fo:table-row>

</xsl:template>
  <!-- Name: variables-table-col-width --><!-- Value: <fo:table-column> --><!-- Header for variable table --><!--
    Parameters/variables read:
    show-variables-list-question [var]

    Functions/templates called: 
    proportional-column-width() [FO]
--><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" name="variables-table-col-width" xml:base="includes/named/variables-table-col-width.xml">

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
  <!-- Name: header --><!-- Value: <fo:block> --><!-- Creates page header --><!--
    Params/variables read:
    section [param]
--><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" name="header" xml:base="includes/named/header.xml">

    <!-- params -->
    <xsl:param name="section"/>

    <!-- content -->
    <fo:static-content flow-name="xsl-region-before">
      <fo:block font-size="6" text-align="center">

        <!-- title and section-->
        <xsl:value-of select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:titlStmt/ddi:titl"/> -
        <xsl:value-of select="$section"/>
      </fo:block>
    </fo:static-content>
    
</xsl:template>
  <!-- Name: footer --><!-- Value: <fo:static-content> --><!-- Creates page footer --><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" name="footer" xml:base="includes/named/footer.xml">

    <fo:static-content flow-name="xsl-region-after">
      <fo:block font-size="6" text-align="center" space-before="0.3in">
        -
        <fo:page-number/>
        -
      </fo:block>
    </fo:static-content>

</xsl:template>

  <!-- Name: isodate-long(isodate)    --><!-- Value: string                  --><!-- converts an ISO date string to a "prettier" format --><!--
    Params/variables read:
    isodate [param]
    language-code

    Variables set:
    month

    Functions/templates called:
    number(), substring(), contains() [Xpath 1.0]
    isodate-month
--><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" name="isodate-long" xml:base="includes/utilities/isodate-long.xml">

    <!-- params -->
    <xsl:param name="isodate" select=" '2005-12-31' "/>

    <!-- variables -->
    <!-- determine name of month in date string -->
    <xsl:variable name="month">
      <xsl:call-template name="isodate-month">
        <xsl:with-param name="isodate" select="$report-date"/>
      </xsl:call-template>
    </xsl:variable>

    <!-- content -->
    <!-- return date in relevant format -->
    <xsl:choose>

      <!-- european format -->
      <xsl:when test="contains('fr es',$language-code)">
        <xsl:value-of select="number(substring($isodate,9,2))"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$month"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="substring($isodate,1,4)"/>
      </xsl:when>

      <!-- japanese format -->
      <xsl:when test="contains('ja',$language-code)">
        <xsl:value-of select="$isodate"/>
      </xsl:when>

      <!-- english format -->
      <xsl:otherwise>
        <xsl:value-of select="$month"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="number(substring($isodate,9,2))"/>
        <xsl:text>, </xsl:text>
        <xsl:value-of select="substring($isodate,1,4)"/>
      </xsl:otherwise>

    </xsl:choose>

</xsl:template>
  <!-- Name: isodate-month(isodate) --><!-- Value: string --><!--
    Params/variables read:
    isodate [param]
    msg

    Variables set:
    month

    Functions/templates called:
    number(), substring()
--><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" name="isodate-month" xml:base="includes/utilities/isodate-month.xml">

    <!-- params -->
    <xsl:param name="isodate" select=" '2005-12-31' "/>

    <!-- variables -->
    <xsl:variable name="month" select="number(substring($isodate,6,2))"/>

    <!-- content -->
    <!-- determine month name -->
    <xsl:choose>

      <xsl:when test="$month=1">
        <xsl:value-of select="$msg/*/entry[@key='January']"/>
      </xsl:when>

      <xsl:when test="$month=2">
        <xsl:value-of select="$msg/*/entry[@key='February']"/>
      </xsl:when>

      <xsl:when test="$month=3">
        <xsl:value-of select="$msg/*/entry[@key='March']"/>
      </xsl:when>

      <xsl:when test="$month=4">
        <xsl:value-of select="$msg/*/entry[@key='April']"/>
      </xsl:when>

      <xsl:when test="$month=5">
        <xsl:value-of select="$msg/*/entry[@key='May']"/>
      </xsl:when>

      <xsl:when test="$month=6">
        <xsl:value-of select="$msg/*/entry[@key='June']"/>
      </xsl:when>

      <xsl:when test="$month=7">
        <xsl:value-of select="$msg/*/entry[@key='July']"/>
      </xsl:when>

      <xsl:when test="$month=8">
        <xsl:value-of select="$msg/*/entry[@key='August']"/>
      </xsl:when>

      <xsl:when test="$month=9">
        <xsl:value-of select="$msg/*/entry[@key='September']"/>
      </xsl:when>

      <xsl:when test="$month=10">
        <xsl:value-of select="$msg/*/entry[@key='October']"/>
      </xsl:when>

      <xsl:when test="$month=11">
        <xsl:value-of select="$msg/*/entry[@key='November']"/>
      </xsl:when>

      <xsl:when test="$month=12">
        <xsl:value-of select="$msg/*/entry[@key='December']"/>
      </xsl:when>
    </xsl:choose>

</xsl:template>
  <!-- Name: ltrim(s) --><!-- Value: string --><!-- perform left trim on text --><!--
    Params/variables read:
    s [param]

    Variables set:
    s-no-ws, s-first-non-ws, s-no-leading-ws

    Functions/templates called:
    translate(), concat(), substring(), substring-after() [Xpath 1.0]
--><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" name="ltrim" xml:base="includes/utilities/trim/ltrim.xml">

    <!-- params -->
    <xsl:param name="s"/>

    <!-- variables -->
    <xsl:variable name="s-no-ws" select="translate($s,' &#9;&#10;&#13;','$%*!')"/>
    <xsl:variable name="s-first-non-ws" select="substring($s-no-ws,1,1)"/>
    <xsl:variable name="s-no-leading-ws" select="concat($s-first-non-ws,substring-after($s,$s-first-non-ws))"/>

    <!-- content -->
    <xsl:value-of select="concat('[',$s-first-non-ws,'|',$s-no-ws,']')"/>

</xsl:template>
  <!-- Name: rtrim(s, i) --><!-- Value: string --><!-- perform right trim on text --><!--
    Parameters/variables read:
    s, i [params]

    Functions/templates called:
    substring(), string-length(), translate() [Xpath 1.0]
    rtrim
--><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" name="rtrim" xml:base="includes/utilities/trim/rtrim.xml">

    <!-- params -->
    <xsl:param name="s"/>
    <xsl:param name="i" select="string-length($s)"/>

    <!-- Is further trimming needed or not?-->
    <xsl:choose>

      <xsl:when test="translate(substring($s,$i,1),' &#9;&#10;&#13;','')">
        <xsl:value-of select="substring($s,1,$i)"/>
      </xsl:when>

      <!-- Do nothing if string is less than 2 -->
      <xsl:when test="$i&lt;2"/>

      <!-- More trimming -->
      <xsl:otherwise>
        <xsl:call-template name="rtrim">
          <xsl:with-param name="s" select="$s"/>
          <xsl:with-param name="i" select="$i - 1"/>
        </xsl:call-template>
      </xsl:otherwise>

    </xsl:choose>

</xsl:template>
  <!-- Name: trim(s) --><!-- Value: string --><!--
    Params/variables read:
    s [param]

    Functions/templates called:
    concat(), substring(), translate(), substring-after() [Xpath 1.0]
    rtrim
--><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" name="trim" xml:base="includes/utilities/trim/trim.xml">

    <!-- params -->
    <xsl:param name="s"/>

    <!-- Perform trimming -->
    <xsl:call-template name="rtrim">
      <xsl:with-param name="s" select="concat(substring(translate($s,' &#9;&#10;&#13;',''),1,1),substring-after($s,substring(translate($s,' &#9;&#10;&#13;',''),1,1)))"/>
    </xsl:call-template>

</xsl:template>
  <!-- Name: FixHTML --><!-- Value: --><!-- creates FOP equivalent from a subset of HTML --><!--
    Params: InputString

    Variables set:
    headStart, headEnd, break, beforeEnd

    Functions/templates called:
    substring-after, substring-before(), contains()
    string-length(), not() [Xpath 1.0]
    FixHTML
--><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" name="FixHTML" xml:base="includes/utilities/FixHTML.xml">

    <!-- params -->
    <xsl:param name="InputString"/>

    <!-- variables -->
    <xsl:variable name="headStart">
      <xsl:text>&lt;h2&gt;</xsl:text>
    </xsl:variable>

    <xsl:variable name="headEnd">
      <xsl:text>&lt;/h2&gt;</xsl:text>
    </xsl:variable>

    <xsl:variable name="break">
      <xsl:text>&lt;br/&gt;</xsl:text>
    </xsl:variable>

    <!-- content -->
    <!-- what to do -->
    <xsl:choose>

      <!-- Case 1: Make a header -->
      <xsl:when test="(contains($InputString,$headEnd) and string-length(substring-before($InputString,$headEnd)) &lt; string-length(substring-before($InputString,$break))) or (not(contains($InputString,$break))and contains($InputString,$headEnd))">
        <xsl:variable name="beforeEnd" select="substring-before($InputString,$headEnd)"/>

        <fo:block font-weight="bold">
          <xsl:value-of select="substring-after($beforeEnd,$headStart)"/>
        </fo:block>

        <xsl:call-template name="FixHTML">
          <xsl:with-param name="InputString">
            <xsl:value-of select="substring-after($InputString,$headEnd)"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>

      <!-- Case 2: Make a newline -->
      <xsl:when test="contains($InputString,$break)">
        <xsl:if test="string-length(substring-before($InputString,$break))=0">
          <fo:block> </fo:block>
        </xsl:if>

        <fo:block>
          <xsl:value-of select="substring-before($InputString,$break)"/>
        </fo:block>

        <xsl:call-template name="FixHTML">
          <xsl:with-param name="InputString">
            <xsl:value-of select="substring-after($InputString,$break)"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>

      <!-- Case 3: If no headers or breaks left in string, display all -->
      <xsl:otherwise>
        <fo:block>
          <xsl:value-of select="$InputString"/>
        </fo:block>
      </xsl:otherwise>

    </xsl:choose>

</xsl:template>
  <!-- Name: date:date --><!-- Value: string --><!-- Uses an EXSLT extension to determine the date --><!--
    Params/variables read:
    date-time [param]
    date:date-time

    Variables set:
    neg, dt-no-neg, dt-no-neg-length, timezone,
    tz, date, dt-length, dt

    Functions/templates called:
    substring(), starts-with(), not(), string(), number() [Xpath 1.0]
    function-available(), date:date-time() [XSLT 1.0]
--><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" name="date:date" xml:base="includes/utilities/date-date.xml">

    <!-- params -->
    <xsl:param name="date-time">
      <xsl:choose>
        <xsl:when test="function-available('date:date-time')">
          <xsl:value-of select="date:date-time()"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$date:date-time"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:param>

    <!-- variables -->
    <xsl:variable name="neg" select="starts-with($date-time, '-')"/>

    <xsl:variable name="dt-no-neg">
      <xsl:choose>
        <xsl:when test="$neg or starts-with($date-time, '+')">
          <xsl:value-of select="substring($date-time, 2)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$date-time"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="dt-no-neg-length" select="string-length($dt-no-neg)"/>

    <xsl:variable name="timezone">
      <xsl:choose>
        <xsl:when test="substring($dt-no-neg, $dt-no-neg-length) = 'Z'">Z</xsl:when>
        <xsl:otherwise>
          <xsl:variable name="tz" select="substring($dt-no-neg, $dt-no-neg-length - 5)"/>
          <xsl:if test="(substring($tz, 1, 1) = '-' or       substring($tz, 1, 1) = '+') and       substring($tz, 4, 1) = ':'">
            <xsl:value-of select="$tz"/>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="date">
      <xsl:if test="not(string($timezone)) or     $timezone = 'Z' or     (substring($timezone, 2, 2) &lt;= 23 and     substring($timezone, 5, 2) &lt;= 59)">
        <xsl:variable name="dt" select="substring($dt-no-neg, 1, $dt-no-neg-length - string-length($timezone))"/>
        <xsl:variable name="dt-length" select="string-length($dt)"/>
        <xsl:if test="number(substring($dt, 1, 4)) and      substring($dt, 5, 1) = '-' and      substring($dt, 6, 2) &lt;= 12 and      substring($dt, 8, 1) = '-' and      substring($dt, 9, 2) &lt;= 31 and      ($dt-length = 10 or      (substring($dt, 11, 1) = 'T' and      substring($dt, 12, 2) &lt;= 23 and      substring($dt, 14, 1) = ':' and      substring($dt, 15, 2) &lt;= 59 and      substring($dt, 17, 1) = ':' and      substring($dt, 18) &lt;= 60))">
          <xsl:value-of select="substring($dt, 1, 10)"/>
        </xsl:if>
      </xsl:if>
    </xsl:variable>

    <!-- content -->
    <xsl:if test="string($date)">
      <xsl:if test="$neg">-</xsl:if>
      <xsl:value-of select="$date"/>
      <xsl:value-of select="$timezone"/>
    </xsl:if>

</xsl:template>
  <!-- Name: math:max(nodes) --><!-- Value: string? --><!--
    Params/variables read:
    nodes [param]

    Functions/templates called:
    not(), number(), position() [Xpath 1.0]
--><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" name="math:max" xml:base="includes/utilities/math-max.xml">

    <!-- params -->
    <xsl:param name="nodes" select="/.."/>

    <!-- content -->
    <!-- count number of nodes -->
    <xsl:choose>

      <!-- Case 1: Not a Number -->
      <xsl:when test="not($nodes)">NaN</xsl:when>

      <!-- Case 2: Actually a number -->
      <xsl:otherwise>
        <xsl:for-each select="$nodes">
          <xsl:sort data-type="number" order="descending"/>
          <xsl:if test="position() = 1">
            <xsl:value-of select="number(.)"/>
          </xsl:if>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>

</xsl:template>

</xsl:stylesheet>