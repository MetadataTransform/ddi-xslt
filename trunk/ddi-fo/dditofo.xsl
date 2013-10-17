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
<!-- Platform: XSLT 1.0, Apache FOP 0.20.5                -->
<!--                                                      -->
<!-- Oistein Kristiansen (oistein.kristiansen@nsd.uib.no) -->
<!-- Version: 2010                                        -->
<!-- Platform: updated for FOP 0.93 2010                  -->
<!--                                                      -->
<!-- Akira Olsbänning (akira.olsbanning@snd.gu.se)        -->
<!-- Current version (2012-2013)                          -->
<!-- Platform: updated to XSLT 2.0                        -->
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

<xsl:transform version="2.0"
               extension-element-prefixes="date exsl str"
               exclude-result-prefixes="util"
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
               xmlns:fn="http://www.w3.org/2005/xpath-functions"
               xmlns:util="https://code.google.com/p/ddixslt/#util">

  <xsl:output method="xml"
              encoding="UTF-8"
              indent="no"
              omit-xml-declaration="no" />

  <!-- functions: -->
  <!-- count(), normalize-space(), position(), substring() [Xpath 1.0] -->
  <!-- document() [XSLT 1.0] -->
  
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

  <!-- used in util:isodate-long() -->
  <xsl:param name="language-code" select="'en'" />

  <!-- translation file path-->
  <xsl:param name="translations-file" />

  <!-- params from OutputServlet.java -->
  <!-- never used, will be removed -->
  <xsl:param name="subset-groups" />
  <xsl:param name="subset-vars" />

  <xsl:param name="report-start-page-number" select="4" />
  <xsl:param name="show-variables-description-categories-max" select="1000" />
  <xsl:param name="variable-name-length" select="14" />

  <!-- ========================================================== -->
  <!-- Layout and style                                           -->
  <!-- ========================================================== -->

  <!-- To avoid empty pages; use a huge chunksize for subsets -->
  <xsl:variable name="chunk-size" select="50" />

  <!-- path to front page logo -->
  <xsl:param name="logo-file" select="'http://xml.snd.gu.se/xsl/ddi2/ddi-fo/images/snd_logo_sv.png'" />

  <!-- Style and page layout -->
  <xsl:param name="page-layout" select="'A4-page'" />
  <xsl:param name="font-family" select="'Times'" />
  <xsl:param name="font-size" select="10" />
  <xsl:param name="header-font-size" select="6" />

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
  <xsl:param name="show-bookmarks" select="'True'" />
  <xsl:param name="show-cover-page" select="'True'" />
  <xsl:param name="show-metadata-info" select="'True'" /> 
  <xsl:param name="show-toc" select="'True'" />
  <xsl:param name="show-overview" select="'True'" />
  <xsl:param name="show-files-description" select="'True'" />

  <!-- misc -->
  <xsl:param name="show-variables-description-categories" select="'True'" />
  
  <!-- ==================================== -->
  <!-- string vars                          -->
  <!-- ==================================== -->

  <!-- survey title -->
  <xsl:variable name="survey-title"
                xpath-default-namespace="http://www.icpsr.umich.edu/DDI">
    <xsl:value-of select="normalize-space(/codeBook/stdyDscr/citation/titlStmt/titl)" />
    <xsl:if test="/codeBook/stdyDscr/citation/titlStmt/altTitl">
      <xsl:text>(</xsl:text>
      <xsl:value-of select="normalize-space(/codeBook/stdyDscr/citation/titlStmt/altTitl)" />
      <xsl:text>)</xsl:text>
    </xsl:if>
  </xsl:variable>

  <!-- geography -->
  <xsl:variable name="geography"
                xpath-default-namespace="http://www.icpsr.umich.edu/DDI">
    <xsl:for-each select="/codeBook/stdyDscr/stdyInfo/sumDscr/nation">
      <xsl:if test="position() &gt; 1">
        <xsl:text>, </xsl:text>
      </xsl:if>
      <xsl:value-of select="normalize-space(.)" />
    </xsl:for-each>
  </xsl:variable>

  <!-- If timeperiods returns empty, use timePrd instead -->
  <xsl:variable name="time-produced"
                xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
                select="/codeBook/stdyDscr/stdyInfo/sumDscr/timePrd/@date" />

  <!-- ========================================= -->
  <!-- conditional boolean vars (co-dependant)   -->
  <!-- ========================================= -->

  <!-- Show variable groups only if there are any -->
  <xsl:variable name="show-variable-groups"
                xpath-default-namespace="http://www.icpsr.umich.edu/DDI">
    <xsl:choose>
      <xsl:when test="count(/codeBook/dataDscr/varGrp) &gt; 0">True</xsl:when>
      <xsl:otherwise>False</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- Show variable list if showing groups are disabled -->
  <xsl:variable name="show-variables-list">
    <xsl:choose>
      <xsl:when test="$show-variable-groups = 'True'">False</xsl:when>
      <xsl:otherwise>True</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- If totalt amount of variables or given subsetamount       -->
  <!-- exceeds given max, then dont show extensive variable desc -->
  <xsl:variable name="show-variables-description"
                xpath-default-namespace="http://www.icpsr.umich.edu/DDI">
    <xsl:choose>
      <xsl:when test="(count(/codeBook/dataDscr/var) = 0)">False</xsl:when>
      <xsl:otherwise>True</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- ==================================== -->
  <!-- conditional boolean vars (direct)    -->
  <!-- ==================================== -->

  <xsl:variable name="show-scope-and-coverage"
                xpath-default-namespace="http://www.icpsr.umich.edu/DDI">
    <xsl:choose>
      <xsl:when test="/codeBook/stdyDscr/stdyInfo/notes">True</xsl:when>
      <xsl:when test="/codeBook/stdyDscr/stdyInfo/subject/keyword">True</xsl:when>
      <xsl:when test="/codeBook/stdyDscr/stdyInfo/sumDscr/geogCover">True</xsl:when>
      <xsl:when test="/codeBook/stdyDscr/stdyInfo/sumDscr/universe">True</xsl:when>
      <xsl:otherwise>False</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="show-producers-and-sponsors"
                xpath-default-namespace="http://www.icpsr.umich.edu/DDI">
    <xsl:choose>
      <xsl:when test="/codeBook/stdyDscr/citation/rspStmt/AuthEnty">True</xsl:when>
      <xsl:when test="/codeBook/stdyDscr/citation/prodStmt/producer">True</xsl:when>
      <xsl:when test="/codeBook/stdyDscr/citation/prodStmt/fundAg">True</xsl:when>
      <xsl:when test="/codeBook/stdyDscr/citation/rspStmt/othId">True</xsl:when>
      <xsl:otherwise>False</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="show-sampling"
                xpath-default-namespace="http://www.icpsr.umich.edu/DDI">
    <xsl:choose>
      <xsl:when test="/codeBook/stdyDscr/method/notes[@subject='sampling']">True</xsl:when>
      <xsl:when test="/codeBook/stdyDscr/method/dataColl/sampProc">True</xsl:when>
      <xsl:when test="/codeBook/stdyDscr/method/dataColl/deviat">True</xsl:when>
      <xsl:when test="/codeBook/stdyDscr/method/anlyInfo/respRate">True</xsl:when>
      <xsl:when test="/codeBook/stdyDscr/method/dataColl/weight">True</xsl:when>
      <xsl:otherwise>False</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="show-data-collection"
                xpath-default-namespace="http://www.icpsr.umich.edu/DDI">
    <xsl:choose>
      <xsl:when test="/codeBook/stdyDscr/stdyInfo/sumDscr/collDate">True</xsl:when>
      <xsl:when test="/codeBook/stdyDscr/stdyInfo/sumDscr/timePrd">True</xsl:when>
      <xsl:when test="/codeBook/stdyDscr/method/dataColl/collMode">True</xsl:when>
      <xsl:when test="/codeBook/stdyDscr/method/notes[@subject='collection']">True</xsl:when>
      <xsl:when test="/codeBook/stdyDscr/method/notes[@subject='processing']">True</xsl:when>
      <xsl:when test="/codeBook/stdyDscr/method/notes[@subject='cleaning']">True</xsl:when>
      <xsl:when test="/codeBook/stdyDscr/method/dataColl/collSitu">True</xsl:when>
      <xsl:when test="/codeBook/stdyDscr/method/dataColl/resInstru">True</xsl:when>
      <xsl:when test="/codeBook/stdyDscr/method/dataColl/dataCollector">True</xsl:when>
      <xsl:when test="/codeBook/stdyDscr/method/dataColl/actMin">True</xsl:when>
      <xsl:otherwise>False</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="show-data-processing-and-appraisal"
                xpath-default-namespace="http://www.icpsr.umich.edu/DDI">
    <xsl:choose>
      <xsl:when test="/codeBook/stdyDscr/method/dataColl/cleanOps">True</xsl:when>
      <xsl:when test="/codeBook/stdyDscr/method/anlyInfo/EstSmpErr">True</xsl:when>
      <xsl:when test="/codeBook/stdyDscr/method/anlyInfo/dataAppr">True</xsl:when>
      <xsl:otherwise>False</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="show-accessibility"
                xpath-default-namespace="http://www.icpsr.umich.edu/DDI">
    <xsl:choose>
      <xsl:when test="/codeBook/stdyDscr/dataAccs/useStmt/contact">True</xsl:when>
      <xsl:when test="/codeBook/stdyDscr/citation/distStmt/distrbtr">True</xsl:when>
      <xsl:when test="/codeBook/stdyDscr/citation/distStmt/contact">True</xsl:when>
      <xsl:when test="/codeBook/stdyDscr/dataAccs/useStmt/confDec">True</xsl:when>
      <xsl:when test="/codeBook/stdyDscr/dataAccs/useStmt/conditions">True</xsl:when>
      <xsl:when test="/codeBook/stdyDscr/dataAccs/useStmt/citReq">True</xsl:when>
      <xsl:otherwise>False</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="show-rights-and-disclaimer"
                xpath-default-namespace="http://www.icpsr.umich.edu/DDI">
    <xsl:choose>
      <xsl:when test="/codeBook/stdyDscr/dataAccs/useStmt/disclaimer">True</xsl:when>
      <xsl:when test="/codeBook/stdyDscr/citation/prodStmt/copyright">True</xsl:when>
      <xsl:otherwise>False</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- ================================================== -->
  <!-- time and date related                              -->
  <!-- ================================================== -->

  <!-- year-from - the first data collection mode element with a 'start' event -->
  <xsl:variable name="year-from"
                xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
                select="substring(/codeBook/stdyDscr/stdyInfo/sumDscr/collDate[@event='start'][1]/@date, 1, 4)" />

  <!-- year to is the last data collection mode element with an 'end' event -->
  <xsl:variable name="year-to-count" 
                xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
                select="count(/codeBook/stdyDscr/stdyInfo/sumDscr/collDate[@event='end'])" />
  <xsl:variable name="year-to" 
                xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
                select="substring(/codeBook/stdyDscr/stdyInfo/sumDscr/collDate[@event='end'][$year-to-count]/@date, 1, 4)" />

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

  <xsl:variable name="strings" select="document($translations-file)" />

  <xsl:variable name="i18n-Abstract" select="$strings/*/entry[@key='Abstract']" />
  <xsl:variable name="i18n-Abbrev_NotWeighted" select="$strings/*/entry[@key='Abbrev_NotWeighted']" />
  <xsl:variable name="i18n-Abbrev_Weighted" select="$strings/*/entry[@key='Abbrev_Weighted']" />
  <xsl:variable name="i18n-Accessibility" select="$strings/*/entry[@key='Accessibility']" />
  <xsl:variable name="i18n-Access_Authority" select="$strings/*/entry[@key='Access_Authority']" />
  <xsl:variable name="i18n-Access_Conditions" select="$strings/*/entry[@key='Access_Conditions']" />
  <xsl:variable name="i18n-Acknowledgments" select="$strings/*/entry[@key='Acknowledgments']" />
  <xsl:variable name="i18n-Cases" select="$strings/*/entry[@key='Cases']" />
  <xsl:variable name="i18n-Cases_Abbreviation" select="$strings/*/entry[@key='Cases_Abbreviation']" />
  <xsl:variable name="i18n-Citation_Requirements" select="$strings/*/entry[@key='Citation_Requirements']" />
  <xsl:variable name="i18n-Concepts" select="$strings/*/entry[@key='Concepts']" />
  <xsl:variable name="i18n-Confidentiality" select="$strings/*/entry[@key='Confidentiality']" />
  <xsl:variable name="i18n-Contacts" select="$strings/*/entry[@key='Contacts']" />
  <xsl:variable name="i18n-Copyright" select="$strings/*/entry[@key='Copyright']" />
  <xsl:variable name="i18n-Countries" select="$strings/*/entry[@key='Countries']" />
  <xsl:variable name="i18n-continuous" select="$strings/*/entry[@key='continuous']" />
  <xsl:variable name="i18n-Cover_Page" select="$strings/*/entry[@key='Cover_Page']" />
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
  <xsl:variable name="i18n-Definition" select="$strings/*/entry[@key='Definitions']" />
  <xsl:variable name="i18n-Depositors" select="$strings/*/entry[@key='Depositors']" />
  <xsl:variable name="i18n-Deviations_from_Sample_Design" select="$strings/*/entry[@key='Deviations_from_Sample_Design']" />
  <xsl:variable name="i18n-Distributors" select="$strings/*/entry[@key='Distributors']" />
  <xsl:variable name="i18n-Disclaimer" select="$strings/*/entry[@key='Disclaimer']" />
  <xsl:variable name="i18n-discrete" select="$strings/*/entry[@key='discrete']" />
  <xsl:variable name="i18n-Document_Information" select="$strings/*/entry[@key='Document_Information']" />
  <xsl:variable name="i18n-Estimates_of_Sampling_Error" select="$strings/*/entry[@key='Estimates_of_Sampling_Error']" />
  <xsl:variable name="i18n-files" select="$strings/*/entry[@key='files']" />
  <xsl:variable name="i18n-Files_Description" select="$strings/*/entry[@key='Files_Description']" />
  <xsl:variable name="i18n-File_Structure" select="$strings/*/entry[@key='File_Structure']" />
  <xsl:variable name="i18n-Format" select="$strings/*/entry[@key='Format']" />
  <xsl:variable name="i18n-File" select="$strings/*/entry[@key='File']" />
  <xsl:variable name="i18n-File_Content" select="$strings/*/entry[@key='File_Content']" />
  <xsl:variable name="i18n-Frequency_table_not_shown" select="$strings/*/entry[@key='Frequency_table_not_shown']" />
  <xsl:variable name="i18n-Funding_Agencies" select="$strings/*/entry[@key='Funding_Agencies']" />
  <xsl:variable name="i18n-Geographic_Coverage" select="$strings/*/entry[@key='Geographic_Coverage']" />
  <xsl:variable name="i18n-Group" select="$strings/*/entry[@key='Group']" />
  <xsl:variable name="i18n-groups" select="$strings/*/entry[@key='groups']" />
  <xsl:variable name="i18n-Identification" select="$strings/*/entry[@key='Identification']" />
  <xsl:variable name="i18n-Imputation" select="$strings/*/entry[@key='Imputation']" />
  <xsl:variable name="i18n-Information" select="$strings/*/entry[@key='Information']" />
  <xsl:variable name="i18n-Interviewers_instructions" select="$strings/*/entry[@key='Interviewers_instructions']" />
  <xsl:variable name="i18n-Invalid" select="$strings/*/entry[@key='Invalid']" />
  <xsl:variable name="i18n-Keys" select="$strings/*/entry[@key='Keys']" />
  <xsl:variable name="i18n-Keywords" select="$strings/*/entry[@key='Keywords']" />
  <xsl:variable name="i18n-Kind_of_Data" select="$strings/*/entry[@key='Kind_of_Data']" />
  <xsl:variable name="i18n-Label" select="$strings/*/entry[@key='Label']" />
  <xsl:variable name="i18n-Literal_question" select="$strings/*/entry[@key='Literal_question']" />
  <xsl:variable name="i18n-Mean" select="$strings/*/entry[@key='Mean']" />
  <xsl:variable name="i18n-Metadata_Production" select="$strings/*/entry[@key='Metadata_Production']" />
  <xsl:variable name="i18n-Metadata_Producers" select="$strings/*/entry[@key='Metadata_Producers']" />
  <xsl:variable name="i18n-Missing" select="$strings/*/entry[@key='Missing']" />
  <xsl:variable name="i18n-Missing_Data" select="$strings/*/entry[@key='Missing_Data']" />
  <xsl:variable name="i18n-Modalities" select="$strings/*/entry[@key='Modalities']" />
  <xsl:variable name="i18n-Name" select="$strings/*/entry[@key='Name']" />
  <xsl:variable name="i18n-Notes" select="$strings/*/entry[@key='Notes']" />
  <xsl:variable name="i18n-Other_Acknowledgements" select="$strings/*/entry[@key='Other_Acknowledgements']" />
  <xsl:variable name="i18n-Other_Forms_of_Data_Appraisal" select="$strings/*/entry[@key='Other_Forms_of_Data_Appraisal']" />
  <xsl:variable name="i18n-Other_Processing" select="$strings/*/entry[@key='Other_Processing']" />
  <xsl:variable name="i18n-Other_Producers" select="$strings/*/entry[@key='Other_Producers']" />
  <xsl:variable name="i18n-Overview" select="$strings/*/entry[@key='Overview']" />
  <xsl:variable name="i18n-Percentage" select="$strings/*/entry[@key='Percentage']" />
  <xsl:variable name="i18n-Post-question" select="$strings/*/entry[@key='Post-question']" />
  <xsl:variable name="i18n-Pre-question" select="$strings/*/entry[@key='Pre-question']" />
  <xsl:variable name="i18n-Primary_Investigators" select="$strings/*/entry[@key='Primary_Investigators']" />
  <xsl:variable name="i18n-Processing_Checks" select="$strings/*/entry[@key='Processing_Checks']" />
  <xsl:variable name="i18n-Producer" select="$strings/*/entry[@key='Producer']" />
  <xsl:variable name="i18n-Producers_and_Sponsors" select="$strings/*/entry[@key='Producers_and_Sponsors']" />
  <xsl:variable name="i18n-Production_Date" select="$strings/*/entry[@key='Production_Date']" />
  <xsl:variable name="i18n-Question" select="$strings/*/entry[@key='Question']" />
  <xsl:variable name="i18n-Questionnaires" select="$strings/*/entry[@key='Questionnaires']" />
  <xsl:variable name="i18n-Range" select="$strings/*/entry[@key='Range']" />
  <xsl:variable name="i18n-Recoding_and_Derivation" select="$strings/*/entry[@key='Recoding_and_Derivation']" />
  <xsl:variable name="i18n-Response_Rate" select="$strings/*/entry[@key='Response_Rate']" />
  <xsl:variable name="i18n-Rights_and_Disclaimer" select="$strings/*/entry[@key='Rights_and_Disclaimer']" />
  <xsl:variable name="i18n-Sampling" select="$strings/*/entry[@key='Sampling']" />
  <xsl:variable name="i18n-Sampling_Procedure" select="$strings/*/entry[@key='Sampling_Procedure']" />
  <xsl:variable name="i18n-Scope" select="$strings/*/entry[@key='Scope']" />
  <xsl:variable name="i18n-Scope_and_Coverage" select="$strings/*/entry[@key='Scope_and_Coverage']" />
  <xsl:variable name="i18n-Security" select="$strings/*/entry[@key='Security']" />
  <xsl:variable name="i18n-Series" select="$strings/*/entry[@key='Series']" />
  <xsl:variable name="i18n-ShowingSubset" select="$strings/*/entry[@key='ShowingSubset']" />
  <xsl:variable name="i18n-Source" select="$strings/*/entry[@key='Source']" />
  <xsl:variable name="i18n-StdDev" select="$strings/*/entry[@key='StdDev']" />
  <xsl:variable name="i18n-Statistics" select="$strings/*/entry[@key='Statistics']" />
  <xsl:variable name="i18n-Subgroups" select="$strings/*/entry[@key='Subgroups']" />
  <xsl:variable name="i18n-SumStat_Warning" select="$strings/*/entry[@key='SumStat_Warning']" />
  <xsl:variable name="i18n-Supervision" select="$strings/*/entry[@key='Supervision']" />
  <xsl:variable name="i18n-Table_of_Contents" select="$strings/*/entry[@key='Table_of_Contents']" />
  <xsl:variable name="i18n-Time_Periods" select="$strings/*/entry[@key='Time_Periods']" />
  <xsl:variable name="i18n-Topics" select="$strings/*/entry[@key='Topics']" />
  <xsl:variable name="i18n-Type" select="$strings/*/entry[@key='Type']" />
  <xsl:variable name="i18n-Unit_of_Analysis" select="$strings/*/entry[@key='Unit_of_Analysis']" />
  <xsl:variable name="i18n-Universe" select="$strings/*/entry[@key='Universe']" />
  <xsl:variable name="i18n-Valid" select="$strings/*/entry[@key='Valid']" />
  <xsl:variable name="i18n-Value" select="$strings/*/entry[@key='Value']" />
  <xsl:variable name="i18n-variables" select="$strings/*/entry[@key='variables']" />
  <xsl:variable name="i18n-Variables" select="$strings/*/entry[@key='Variables']" />
  <xsl:variable name="i18n-Variables_List" select="$strings/*/entry[@key='Variables_List']" />
  <xsl:variable name="i18n-Variables_Groups" select="$strings/*/entry[@key='Variables_Groups']" />
  <xsl:variable name="i18n-Variables_Description" select="$strings/*/entry[@key='Variables_Description']" />
  <xsl:variable name="i18n-Version" select="$strings/*/entry[@key='Version']" />
  <xsl:variable name="i18n-Weighted" select="$strings/*/entry[@key='Weighted']" />
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
  <xi:include href="templates/named/page_header.xsl" />
  <xi:include href="templates/named/page_footer.xsl" />
    
  <!-- ==================================== -->
  <!-- functions                            -->
  <!-- ==================================== -->
  <xi:include href="functions/util-isodate_month_name.xsl" />
  <xi:include href="functions/util-isodate_long.xsl" />
  <xi:include href="functions/util-trim.xsl" />
  <xi:include href="functions/util-rtrim.xsl" />
  <xi:include href="functions/util-math_max.xsl" />
  
</xsl:transform>
