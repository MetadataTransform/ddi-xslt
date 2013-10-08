<?xml version='1.0' encoding='utf-8'?>

<!-- Overview -->
<!-- =================================================================================== -->
<!-- Transforms DDI-XML into XSL-FO to produce study documentation in PDF format         -->
<!-- Developed for DDI documents produced by the International Household Survey Network  -->
<!-- Microdata Managemenet Toolkit (http://www.surveynetwork.org/toolkit) and            -->
<!-- Central Survey Catalog (http://www.surveynetwork.org/surveys)                       -->
<!-- =================================================================================== -->

<!-- Authors -->
<!-- ==================================================== -->
<!-- Pascal Heus (pascal.heus@gmail.com)                  -->
<!-- Version: July 2006                                   -->
<!-- Platform: XSL 1.0, Apache FOP 0.20.5                 -->
<!--                                                      -->
<!-- Oistein Kristiansen (oistein.kristiansen@nsd.uib.no) -->
<!-- Version: 2010                                        -->
<!-- Updated for FOP 0.93 2010                            -->
<!--                                                      -->
<!-- Akira Olsbänning (akira.olsbanning@snd.gu.se)        -->
<!-- Current version (2012-2013)                          -->
<!-- ==================================================== -->

<!-- License -->
<!-- ================================================================================================ -->
<!-- Copyright 2006 Pascal Heus (pascal.heus@gmail.com)                                               -->
<!--                                                                                                  -->
<!-- This program is free software; you can redistribute it and/or modify it under the terms of the   -->
<!-- GNU Lesser General Public License as published by the Free Software Foundation; either version   -->
<!-- 2.1 of the License, or (at your option) any later version.                                       -->
<!--                                                                                                  -->
<!-- This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;        -->
<!-- without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.        -->
<!-- See the GNU Lesser General Public License for more details.                                      -->
<!--                                                                                                  -->
<!-- The full text of the license is available at http://www.gnu.org/copyleft/lesser.html             -->
<!-- ================================================================================================ -->

<!-- References -->
<!-- ========================================================= -->
<!-- XSL-FO:                                                   -->
<!--   http://www.w3.org/Style/XSL/                            -->
<!--   http://www.w3schools.com/xslfo/xslfo_reference.asp      -->
<!--   http://www.xslfo.info/                                  -->
<!-- Apache FOP:                                               -->
<!--   http://xmlgraphics.apache.org/fop/                      -->
<!-- XSL-FO Tutorials:                                         -->
<!--   http://www.renderx.com/tutorial.html                    -->
<!--   http://www.antennahouse.com/XSLsample/XSLsample.htm     -->
<!-- String trimming:                                          -->
<!--  http://skew.org/xml                                      -->
<!-- ========================================================= -->

<!-- Changelog: -->
<!-- 2006-04: Added multilingual support and French translation -->
<!-- 2006-06: Added Spanish and new elements to match IHSN Template v1.2 -->
<!-- 2006-07: Minor fixes and typos -->
<!-- 2006-07: Added option parameters to hide producers in cover page and questions in variables list page -->
<!-- 2010-03: Made FOP 0.93 compatible -->
<!-- 2012-11-01: Broken up into parts using xsl:include -->
<!-- 2013-01-22: Changing the file names to match template names better -->
<!-- 2013-05-28: Using xincludes instead of xsl:includes -->
<!-- 2013-05-29: Including config in main file -->
<!-- Future changelogs can be read from the SVN repo at googlecode -->

<xsl:transform version="1.0"
               extension-element-prefixes="date exsl str"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:fo="http://www.w3.org/1999/XSL/Format"
               xmlns:xi="http://www.w3.org/2001/XInclude"
               xmlns:ddi="http://www.icpsr.umich.edu/DDI"
               xmlns:n1="http://www.icpsr.umich.edu/DDI"
               xmlns:dc="http://purl.org/dc/elements/1.1/"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:date="http://exslt.org/dates-and-times"
               xmlns:dcterms="http://purl.org/dc/terms/"
               xmlns:exsl="http://exslt.org/common"
               xmlns:math="http://exslt.org/math"
               xmlns:str="http://exslt.org/strings"
               xmlns:doc="http://www.icpsr.umich.edu/doc"
               xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
               xmlns:xdt="http://www.w3.org/2005/xpath-datatypes"
               xmlns:fn="http://www.w3.org/2005/xpath-functions">

  <xsl:output version="1.0"
              method="xml"
              encoding="UTF-8"
              indent="no"
              omit-xml-declaration="no" />

  <!-- functions: -->
  <!-- count(), normalize-space(), position(), substring() [Xpath 1.0] -->
  <!-- document() [XSLT 1.0] -->
  
  <!-- called: -->
  <!-- date -->

  <!-- =============================================================== -->
  <!-- Main "sections" of the root template and their show/hide vars   -->
  <!-- fo:layout-master-set    n/a                                     -->
  <!-- fo:bookmark-tree        show-bookmarks                param   1 -->
  <!-- Cover page:             show-cover-page               param   1 -->
  <!-- Metadata info:          show-metadata-info            param   1 -->
  <!-- Table of Contents:      show-toc                      param   1 -->
  <!-- Overview:               show-overview                 param   1 -->
  <!-- Files Description:      show-files-description        param   1 -->
  <!-- Variable List:          show-variables-list           spec*     -->
  <!-- Variable Groups:        show-variable-groups          spec**    -->
  <!-- Variables Description:  show-variables-description    file      -->
  <!--                                                                 -->
  <!-- *  If show-variable-groups is 1, this is set to 0               -->
  <!-- ** Both parameter and DDI file                                  -->
  <!-- =============================================================== -->

  <!-- params supplied by XSLT engine -->
  <!-- language-code. report-title, font-family.                         -->
  <!-- translation-file (http://xml.snd.gu.se/xsl/ddi2/i18n/{$lang}.xml) -->
  <!-- show-variables-list-question, show-cover-page                     -->

  <!-- ========================================================= -->
  <!-- Misc                                                      -->
  <!-- ========================================================= -->

  <!-- used in isodate-long template -->
  <xsl:param name="language-code" select="en" />

  <!-- translation file (path)-->
  <xsl:param name="translations-file" />
  <xsl:variable name="strings" select="document($translations-file)" />

  <!-- optional text -->
  <xsl:param name="report-title" select="'Study Documentation'" />
  <xsl:param name="report-acknowledgments" />
  <xsl:param name="report-notes" />

  <!-- params from OutputServlet.java -->
  <xsl:param name="number-of-groups" />
  <xsl:param name="subset-groups" />
  <xsl:param name="subset-vars" />

  <!-- Report date, from parameter or EXSLT date:date-time() if available -->
  <xsl:variable name="calculated-date">
    <xsl:call-template name="date" />
  </xsl:variable>
  <xsl:param name="report-date" select="$calculated-date" />

  <!-- Start page number, used by Overview -->
  <!-- (useful if running multi-survey reports) -->
  <xsl:param name="report-start-page-number" select="4" />
  <xsl:param name="show-variables-description-categories-max" select="1000" />
  <xsl:param name="variable-name-length" select="14" />

  <!-- ========================================================== -->
  <!-- Layout and style                                           -->
  <!-- ========================================================== -->

  <!-- To avoid empty pages; use a huge chunksize for subsets -->
  <xsl:variable name="chunk-size">50</xsl:variable>

  <!-- path to front page logo -->
  <xsl:param name="logo-file">http://xml.snd.gu.se/xsl/ddi2/ddi-fo/images/snd_logo_sv.png</xsl:param>

  <!-- Style and page layout -->
  <xsl:param name="page-layout">A4-page</xsl:param>
  <xsl:param name="font-family">Times</xsl:param>
  <xsl:param name="font-size">10</xsl:param>
  <xsl:param name="header-font-size">6</xsl:param>
  <xsl:param name="footer-font-size">6</xsl:param>

  <xsl:variable name="cell-padding" select="'3pt'" />
  <xsl:variable name="default-border" select="'0.5pt solid black'" />
  
  <xsl:variable name="color-white" select="'#ffffff'" />
  <xsl:variable name="color-gray0" select="'#f8f8f8'" />
  <xsl:variable name="color-gray1" select="'#f0f0f0'" />
  <xsl:variable name="color-gray2" select="'#e0e0e0'" />
  <xsl:variable name="color-gray3" select="'#d0d0d0'" />
  <xsl:variable name="color-gray4" select="'#c0c0c0'" />

  <!-- ============================================================= -->
  <!-- Layout and style params - show or hide                        -->
  <!-- ============================================================= -->

  <!-- main sections of root template -->
  <!-- <xsl:param name="show-bookmarks" select="1" /> -->
  <xsl:param name="show-bookmarks" >1</xsl:param>
  <xsl:param name="show-cover-page" >1</xsl:param>
  <xsl:param name="show-metadata-info" >1</xsl:param> 
  <xsl:param name="show-toc" >1</xsl:param>
  <xsl:param name="show-overview" >1</xsl:param>
  <xsl:param name="show-files-description" >1</xsl:param>

  <!-- parts of cover page -->
  <xsl:param name="show-logo" >1</xsl:param>
  <xsl:param name="show-geography" >0</xsl:param>
  <xsl:param name="show-cover-page-producer" >1</xsl:param>
  <xsl:param name="show-report-subtitle" >0</xsl:param>

  <!-- misc -->
  <xsl:param name="show-metadata-production" select="1" />
  <xsl:param name="show-variables-list-question" select="1" />
  <xsl:param name="show-variables-description-categories" select="1" />

  <!-- ==================================== -->
  <!-- string vars                          -->
  <!-- ==================================== -->

  <!-- survey title -->
  <xsl:variable name="survey-title">
    <xsl:value-of select="normalize-space(/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:titlStmt/ddi:titl)" />
    <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:titlStmt/ddi:altTitl">
      (<xsl:value-of select="normalize-space(/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:titlStmt/ddi:altTitl)" />)
    </xsl:if>
  </xsl:variable>

  <!-- geography -->
  <xsl:variable name="geography">
    <xsl:for-each select="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:nation">
      <xsl:if test="position() &gt; 1">
        <xsl:text>, </xsl:text>
      </xsl:if>
      <xsl:value-of select="normalize-space(.)" />
    </xsl:for-each>
  </xsl:variable>

  <!-- If timeperiods returns empty, use timePrd instead -->
  <xsl:variable name="time-produced" select="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:timePrd/@date" />

  <!-- ========================================= -->
  <!-- conditional boolean vars (co-dependant)   -->
  <!-- ========================================= -->

  <!-- Show variable groups only if there are any -->
  <xsl:variable name="show-variable-groups">
    <xsl:choose>
      <xsl:when test="count(/ddi:codeBook/ddi:dataDscr/ddi:varGrp) &gt; 0">1</xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- Show variable list if showing groups are disabled -->
  <xsl:variable name="show-variables-list">
    <xsl:choose>
      <xsl:when test="$show-variable-groups = 1">0</xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- If totalt amount of variables or given subsetamount       -->
  <!-- exceeds given max, then dont show extensive variable desc -->
  <xsl:variable name="show-variables-description">
    <xsl:choose>
      <xsl:when test="(count(/ddi:codeBook/ddi:dataDscr/ddi:var) = 0)">0</xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- ==================================== -->
  <!-- conditional boolean vars (direct)    -->
  <!-- ==================================== -->

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

  <!-- ================================================== -->
  <!-- time and date related                              -->
  <!-- ================================================== -->

  <!-- year-from - the first data collection mode element with a 'start' event -->
  <xsl:variable name="year-from" select="substring(/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:collDate[@event='start'][1]/@date, 1, 4)" />
  <!-- year to is the last data collection mode element with an 'end' event -->
  <xsl:variable name="year-to-count" select="count(/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:collDate[@event='end'])" />
  <xsl:variable name="year-to" select="substring(/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:collDate[@event='end'][$year-to-count]/@date, 1, 4)" />

  <xsl:variable name="time">
    <xsl:if test="$year-from">
      <xsl:value-of select="$year-from" />
      <xsl:if test="$year-to &gt; $year-from">
        <xsl:text>-</xsl:text>
        <xsl:value-of select="$year-to" />
      </xsl:if>
    </xsl:if>
  </xsl:variable>


  <!-- ===================================== -->
  <!-- i18n strings                          -->
  <!-- ===================================== -->

  <xsl:variable name="i18n-Abstract" select="$strings/*/entry[@key='Abstract']" />
  <xsl:variable name="i18n-Accessibility" select="$strings/*/entry[@key='Accessibility']" />
  <xsl:variable name="i18n-Access_Authority" select="$strings/*/entry[@key='Access_Authority']" />
  <xsl:variable name="i18n-Access_Conditions" select="$strings/*/entry[@key='Access_Conditions']" />
  <xsl:variable name="i18n-Acknowledgments" select="$strings/*/entry[@key='Acknowledgments']" />
  <xsl:variable name="i18n-Citation_Requirements" select="$strings/*/entry[@key='Citation_Requirements']" />
  <xsl:variable name="i18n-Confidentiality" select="$strings/*/entry[@key='Confidentiality']" />
  <xsl:variable name="i18n-Contacts" select="$strings/*/entry[@key='Contacts']" />
  <xsl:variable name="i18n-Copyright" select="$strings/*/entry[@key='Copyright']" />
  <xsl:variable name="i18n-Countries" select="$strings/*/entry[@key='Countries']" />
  <xsl:variable name="i18n-Data_Collection" select="$strings/*/entry[@key='Data_Collection']" />
  <xsl:variable name="i18n-Data_Collectors" select="$strings/*/entry[@key='Data_Collectors']" />
  <xsl:variable name="i18n-Data_Collection_Dates" select="$strings/*/entry[@key='Data_Collection_Dates']" /> 
  <xsl:variable name="i18n-Data_Collection_Mode" select="$strings/*/entry[@key='Data_Collection_Mode']" />
  <xsl:variable name="i18n-Data_Collection_Notes" select="$strings/*/entry[@key='Data_Collection_Notes']" />
  <xsl:variable name="i18n-Data_Cleaning_Notes" select="$strings/*/entry[@key='Data_Cleaning_Notes']" />
  <xsl:variable name="i18n-Data_Editing" select="$strings/*/entry[@key='Data_Editing']" />
  <xsl:variable name="i18n-Data_Processing_Notes" select="$strings/*/entry[@key='Data_Collection']" />
  <xsl:variable name="i18n-Data_Processing_and_Appraisal" select="$strings/*/entry[@key='Data_Processing_and_Appraisal']" />
  <xsl:variable name="i18n-Dataset_contains" select="$strings/*/entry[@key='Dataset_contains']" />
  <xsl:variable name="i18n-Depositors" select="$strings/*/entry[@key='Depositors']" />
  <xsl:variable name="i18n-Deviations_from_Sample_Design" select="$strings/*/entry[@key='Deviations_from_Sample_Design']" />
  <xsl:variable name="i18n-Distributors" select="$strings/*/entry[@key='Distributors']" />
  <xsl:variable name="i18n-Disclaimer" select="$strings/*/entry[@key='Disclaimer']" />
  <xsl:variable name="i18n-Estimates_of_Sampling_Error" select="$strings/*/entry[@key='Estimates_of_Sampling_Error']" />
  <xsl:variable name="i18n-files" select="$strings/*/entry[@key='files']" />
  <xsl:variable name="i18n-Files_Description" select="$strings/*/entry[@key='Files_Description']" />
  <xsl:variable name="i18n-Funding_Agencies" select="$strings/*/entry[@key='Funding_Agencies']" />
  <xsl:variable name="i18n-Geographic_Coverage" select="$strings/*/entry[@key='Geographic_Coverage']" />
  <xsl:variable name="i18n-groups" select="$strings/*/entry[@key='groups']" />
  <xsl:variable name="i18n-Identification" select="$strings/*/entry[@key='Identification']" />
  <xsl:variable name="i18n-Information" select="$strings/*/entry[@key='Information']" />
  <xsl:variable name="i18n-Keywords" select="$strings/*/entry[@key='Keywords']" />
  <xsl:variable name="i18n-Kind_of_Data" select="$strings/*/entry[@key='Kind_of_Data']" />
  <xsl:variable name="i18n-Metadata_Production" select="$strings/*/entry[@key='Metadata_Production']" />
  <xsl:variable name="i18n-Metadata_Producers" select="$strings/*/entry[@key='Metadata_Producers']" />
  <xsl:variable name="i18n-Notes" select="$strings/*/entry[@key='Notes']" />
  <xsl:variable name="i18n-Other_Acknowledgements" select="$strings/*/entry[@key='Other_Acknowledgements']" />
  <xsl:variable name="i18n-Other_Forms_of_Data_Appraisal" select="$strings/*/entry[@key='Other_Forms_of_Data_Appraisal']" />
  <xsl:variable name="i18n-Other_Processing" select="$strings/*/entry[@key='Other_Processing']" />
  <xsl:variable name="i18n-Other_Producers" select="$strings/*/entry[@key='Other_Producers']" />
  <xsl:variable name="i18n-Overview" select="$strings/*/entry[@key='Overview']" />
  <xsl:variable name="i18n-Primary_Investigators" select="$strings/*/entry[@key='Primary_Investigators']" /> 
  <xsl:variable name="i18n-Producers_and_Sponsors" select="$strings/*/entry[@key='Producers_and_Sponsors']" />
  <xsl:variable name="i18n-Production_Date" select="$strings/*/entry[@key='Production_Date']" />
  <xsl:variable name="i18n-Questionnaires" select="$strings/*/entry[@key='Questionnaires']" />
  <xsl:variable name="i18n-Response_Rate" select="$strings/*/entry[@key='Response_Rate']" />
  <xsl:variable name="i18n-Rights_and_Disclaimer" select="$strings/*/entry[@key='Rights_and_Disclaimer']" />
  <xsl:variable name="i18n-Sampling" select="$strings/*/entry[@key='Sampling']" />
  <xsl:variable name="i18n-Sampling_Procedure" select="$strings/*/entry[@key='Sampling_Procedure']" />
  <xsl:variable name="i18n-Scope" select="$strings/*/entry[@key='Scope']" />
  <xsl:variable name="i18n-Scope_and_Coverage" select="$strings/*/entry[@key='Scope_and_Coverage']" />
  <xsl:variable name="i18n-Series" select="$strings/*/entry[@key='Series']" />
  <xsl:variable name="i18n-ShowingSubset" select="$strings/*/entry[@key='ShowingSubset']" />
  <xsl:variable name="i18n-Supervision" select="$strings/*/entry[@key='Supervision']" />
  <xsl:variable name="i18n-Table_of_Contents" select="$strings/*/entry[@key='Table_of_Contents']" />
  <xsl:variable name="i18n-Time_Periods" select="$strings/*/entry[@key='Time_Periods']" />
  <xsl:variable name="i18n-Topics" select="$strings/*/entry[@key='Topics']" />
  <xsl:variable name="i18n-Type" select="$strings/*/entry[@key='Type']" />
  <xsl:variable name="i18n-Unit_of_Analysis" select="$strings/*/entry[@key='Unit_of_Analysis']" />
  <xsl:variable name="i18n-Universe" select="$strings/*/entry[@key='Universe']" />
  <xsl:variable name="i18n-variables" select="$strings/*/entry[@key='variables']" />
  <xsl:variable name="i18n-Variables_List" select="$strings/*/entry[@key='Variables_List']" />
  <xsl:variable name="i18n-Variables_Groups" select="$strings/*/entry[@key='Variables_Groups']" />
  <xsl:variable name="i18n-Variables_Description" select="$strings/*/entry[@key='Variables_Description']" />
  <xsl:variable name="i18n-Version" select="$strings/*/entry[@key='Version']" />
  <xsl:variable name="i18n-Weighting" select="$strings/*/entry[@key='Weighting']" />
  

  <!-- ===================================== -->
  <!-- matching templates                    -->
  <!-- ===================================== -->
  <xi:include href="templates/match/root.xsl" />
  <xi:include href="templates/match/ddi-AuthEnty.xsl" />
  <xi:include href="templates/match/ddi-collDate.xsl" />
  <xi:include href="templates/match/ddi-contact.xsl" />
  <xi:include href="templates/match/ddi-dataCollector.xsl" />
  <xi:include href="templates/match/ddi_default_text.xsl" />
  <xi:include href="templates/match/ddi-fileDscr.xsl" />
  <xi:include href="templates/match/ddi-fileDscr_variables-description.xsl" />
  <xi:include href="templates/match/ddi-fileDscr_variables-list.xsl" />
  <xi:include href="templates/match/ddi-fileName.xsl" />
  <xi:include href="templates/match/ddi-fundAg.xsl" />
  <xi:include href="templates/match/ddi-IDNo.xsl" />
  <xi:include href="templates/match/ddi-othId.xsl" />
  <xi:include href="templates/match/ddi-producer.xsl" />
  <xi:include href="templates/match/ddi-timePrd.xsl" />
  <xi:include href="templates/match/ddi-var.xsl" />
  <xi:include href="templates/match/ddi-var_variablesList.xsl" />
  <xi:include href="templates/match/ddi-varGrp.xsl" />

  <!-- ==================================== -->
  <!-- named templates                      -->
  <!-- ==================================== -->
  <xi:include href="templates/named/date.xsl" />
  <xi:include href="templates/named/isodate-long.xsl" />
  <xi:include href="templates/named/isodate-month.xsl" />
  <xi:include href="templates/named/math-max.xsl" />
  <xi:include href="templates/named/rtrim.xsl" />
  <xi:include href="templates/named/trim.xsl" />
  
  <xi:include href="templates/named/page_footer.xsl" />
  

</xsl:transform>
