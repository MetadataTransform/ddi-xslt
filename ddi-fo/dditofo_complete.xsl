<?xml version='1.0' encoding='UTF-8'?>
<!-- Overview --><!-- =================================================================================== --><!-- Transforms DDI-XML into XSL-FO to produce study documentation in PDF format         --><!-- Developed for DDI documents produced by the International Household Survey Network  --><!-- Microdata Managemenet Toolkit (http://www.surveynetwork.org/toolkit) and            --><!-- Central Survey Catalog (http://www.surveynetwork.org/surveys)                       --><!-- =================================================================================== --><!-- Authors --><!-- ==================================================== --><!-- Pascal Heus (pascal.heus@gmail.com)                  --><!-- Version: July 2006                                   --><!-- Platform: XSLT 1.0, Apache FOP 0.20.5                --><!--                                                      --><!-- Oistein Kristiansen (oistein.kristiansen@nsd.uib.no) --><!-- Version: 2010                                        --><!-- Platform: updated for FOP 0.93 2010                  --><!--                                                      --><!-- Akira Olsbänning (akira.olsbanning@snd.gu.se)        --><!-- Current version 2012-                                --><!-- Platform: updated to XSLT 2.0                        --><!-- ==================================================== --><!-- License --><!-- ================================================================================================ --><!-- Copyright 2006 Pascal Heus (pascal.heus@gmail.com)                                               --><!--                                                                                                  --><!-- This program is free software; you can redistribute it and/or modify it under the terms of the   --><!-- GNU Lesser General Public License as published by the Free Software Foundation; either version   --><!-- 2.1 of the License, or (at your option) any later version.                                       --><!--                                                                                                  --><!-- This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;        --><!-- without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.        --><!-- See the GNU Lesser General Public License for more details.                                      --><!--                                                                                                  --><!-- The full text of the license is available at http://www.gnu.org/copyleft/lesser.html             --><!-- ================================================================================================ --><!-- References --><!-- ========================================================= --><!-- XSL-FO:                                                   --><!--   http://www.w3.org/Style/XSL/                            --><!--   http://www.w3schools.com/xslfo/xslfo_reference.asp      --><!--   http://www.xslfo.info/                                  --><!-- Apache FOP:                                               --><!--   http://xmlgraphics.apache.org/fop/                      --><!-- XSL-FO Tutorials:                                         --><!--   http://www.renderx.com/tutorial.html                    --><!--   http://www.antennahouse.com/XSLsample/XSLsample.htm     --><!-- String trimming:                                          --><!--  http://skew.org/xml                                      --><!-- ========================================================= --><!-- Changelog: --><!-- 2006-04: Added multilingual support and French translation --><!-- 2006-06: Added Spanish and new elements to match IHSN Template v1.2 --><!-- 2006-07: Minor fixes and typos --><!-- 2006-07: Added option parameters to hide producers in cover page and questions in variables list page --><!-- 2010-03: Made FOP 0.93 compatible --><!-- 2012-11-01: Broken up into parts using xsl:include --><!-- 2013-01-22: Changing the file names to match template names better --><!-- 2013-05-28: Using xincludes instead of xsl:includes --><!-- 2013-05-29: Including config in main file --><!-- Future changelogs can be read from the SVN repo at googlecode --><xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:ddi="http://www.icpsr.umich.edu/DDI" xmlns:n1="http://www.icpsr.umich.edu/DDI" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:date="http://exslt.org/dates-and-times" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:exsl="http://exslt.org/common" xmlns:math="http://exslt.org/math" xmlns:str="http://exslt.org/strings" xmlns:doc="http://www.icpsr.umich.edu/doc" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:xdt="http://www.w3.org/2005/xpath-datatypes" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:util="https://code.google.com/p/ddixslt/#util" version="2.0" extension-element-prefixes="date exsl str" exclude-result-prefixes="util">

  <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>

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


  <!-- ################################################### -->
  <!-- ### global parameters                           ### -->
  <!-- ################################################### -->

  <!-- used in util:isodate-long() -->
  <xsl:param name="language-code" select="'en'"/>

  <!-- translation file path-->
  <xsl:param name="translations-file"/>

  <xsl:param name="report-start-page-number" select="4"/>
  <xsl:param name="show-variables-description-categories-max" select="1000"/>
  <xsl:param name="variable-name-length" select="14"/>

  <!-- path to front page logo -->
  <xsl:param name="logo-file" select="'http://xml.snd.gu.se/xsl/ddi2/ddi-fo/images/snd_logo_sv.png'"/>

  <!-- Style and page layout -->
  <xsl:param name="page-layout" select="'A4-page'"/>
  <xsl:param name="font-family" select="'Times'"/>
  <xsl:param name="font-size" select="10"/>
  <xsl:param name="header-font-size" select="6"/>

  <!-- toggle main sections of root template -->
  <xsl:param name="show-bookmarks" select="'True'"/>
  <xsl:param name="show-cover-page" select="'True'"/>
  <xsl:param name="show-metadata-info" select="'True'"/>
  <xsl:param name="show-toc" select="'True'"/>
  <xsl:param name="show-overview" select="'True'"/>
  <xsl:param name="show-files-description" select="'True'"/>
  
  <!-- misc -->
  <xsl:param name="show-variables-description-categories" select="'True'"/>


  <!-- #################################################### -->
  <!-- ### layout and style                             ### -->
  <!-- #################################################### -->

  <!-- To avoid empty pages; use a huge chunksize for subsets -->
  <xsl:variable name="chunk-size" select="50"/>

  <!-- table cells -->
  <xsl:variable name="cell-padding" select="'3pt'"/>
  <xsl:variable name="default-border" select="'0.5pt solid black'"/>
  
  <!-- colors -->
  <xsl:variable name="color-white" select="'#ffffff'"/>
  <xsl:variable name="color-gray0" select="'#f8f8f8'"/>
  <xsl:variable name="color-gray1" select="'#f0f0f0'"/>
  <xsl:variable name="color-gray2" select="'#e0e0e0'"/>
  <xsl:variable name="color-gray3" select="'#d0d0d0'"/>
  <xsl:variable name="color-gray4" select="'#c0c0c0'"/>


  <!-- #################################################### -->
  <!-- ### gather some info                             ### -->
  <!-- #################################################### -->
  
  <!-- survey title -->
  <xsl:variable name="survey-title" xpath-default-namespace="http://www.icpsr.umich.edu/DDI">
    <xsl:value-of select="normalize-space(/codeBook/stdyDscr/citation/titlStmt/titl)"/>
    <xsl:value-of select="if (/codeBook/stdyDscr/citation/titlStmt/altTitl) then                             string-join(('(', /codeBook/stdyDscr/citation/titlStmt/altTitl, ')'), '')                           else () "/>
  </xsl:variable>

  <!-- geography -->
  <xsl:variable name="geography" xpath-default-namespace="http://www.icpsr.umich.edu/DDI">
    <xsl:for-each select="/codeBook/stdyDscr/stdyInfo/sumDscr/nation">
      <xsl:value-of select="if (position() &gt; 1) then ', ' else ()"/>
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:for-each>
  </xsl:variable>

  <!-- time period -->
  <xsl:variable name="time-produced" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" select="/codeBook/stdyDscr/stdyInfo/sumDscr/timePrd/@date"/>

  <!-- ================================================== -->
  <!-- time and date related                              -->
  <!-- ================================================== -->
  
  <!-- year-from - the first data collection mode element with a 'start' event -->
  <xsl:variable name="year-from" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" select="substring(/codeBook/stdyDscr/stdyInfo/sumDscr/collDate[@event='start'][1]/@date, 1, 4)"/>
  
  <!-- year to is the last data collection mode element with an 'end' event -->
  <xsl:variable name="year-to-count" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" select="count(/codeBook/stdyDscr/stdyInfo/sumDscr/collDate[@event = 'end'])"/>

  <xsl:variable name="year-to" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" select="substring(/codeBook/stdyDscr/stdyInfo/sumDscr/collDate[@event = 'end'][$year-to-count]/@date, 1, 4)"/>
  
  <xsl:variable name="time">
    <xsl:if test="$year-from">
      <xsl:value-of select="$year-from"/>
      <xsl:value-of select="if ($year-to &gt; $year-from) then                               string-join(('-', $year-from), '')                             else () "/>
    </xsl:if>
  </xsl:variable>
  

  <!-- #################################################### -->
  <!-- ### toggle parts of document                     ### -->
  <!-- #################################################### -->

  <!-- Show variable groups only if there are any -->
  <xsl:variable name="show-variable-groups" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" select="if (count(/codeBook/dataDscr/varGrp) &gt; 0) then 'True' else 'False' "/>

  <!-- Show variable list if showing variable groups are disabled -->
  <xsl:variable name="show-variables-list" select="if ($show-variable-groups = 'True') then 'False' else 'True' "/>

  <!-- If totalt amount of variables or given subsetamount       -->
  <!-- exceeds given max, then dont show extensive variable desc -->
  <xsl:variable name="show-variables-description" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" select="if (count(/codeBook/dataDscr/var) = 0) then 'False' else 'True' "/>
      
  <xsl:variable name="show-scope-and-coverage" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" select="if (/codeBook/stdyDscr/stdyInfo/notes) then 'True'             else if (/codeBook/stdyDscr/stdyInfo/subject/keyword) then 'True'             else if (/codeBook/stdyDscr/stdyInfo/sumDscr/geogCover) then 'True'             else if (/codeBook/stdyDscr/stdyInfo/sumDscr/universe) then 'True'             else 'False' "/>

  <xsl:variable name="show-producers-and-sponsors" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" select="if (/codeBook/stdyDscr/citation/rspStmt/AuthEnty) then 'True'             else if (/codeBook/stdyDscr/citation/prodStmt/producer) then 'True'             else if (/codeBook/stdyDscr/citation/prodStmt/fundAg) then 'True'             else if (/codeBook/stdyDscr/citation/rspStmt/othId) then 'True'             else 'False' "/>

  <xsl:variable name="show-sampling" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" select="if (/codeBook/stdyDscr/method/notes[@subject='sampling']) then 'True'             else if (/codeBook/stdyDscr/method/dataColl/sampProc) then 'True'             else if (/codeBook/stdyDscr/method/dataColl/deviat) then 'True'             else if (/codeBook/stdyDscr/method/anlyInfo/respRate) then 'True'             else if (/codeBook/stdyDscr/method/dataColl/weight) then 'True'             else 'False' "/>    

  <xsl:variable name="show-data-collection" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" select="if (/codeBook/stdyDscr/stdyInfo/sumDscr/collDate) then 'True'             else if (/codeBook/stdyDscr/stdyInfo/sumDscr/timePrd) then 'True'             else if (/codeBook/stdyDscr/method/dataColl/collMode) then 'True'             else if (/codeBook/stdyDscr/method/notes[@subject='collection']) then 'True'             else if (/codeBook/stdyDscr/method/notes[@subject='processing']) then 'True'             else if (/codeBook/stdyDscr/method/notes[@subject='cleaning']) then 'True'             else if (/codeBook/stdyDscr/method/dataColl/collSitu) then 'True'             else if (/codeBook/stdyDscr/method/dataColl/resInstru) then 'True'             else if (/codeBook/stdyDscr/method/dataColl/dataCollector) then 'True'             else if (/codeBook/stdyDscr/method/dataColl/actMin) then 'True'             else 'False' "/>
    
  <xsl:variable name="show-data-processing-and-appraisal" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" select="if (/codeBook/stdyDscr/method/dataColl/cleanOps) then 'True'             else if (/codeBook/stdyDscr/method/anlyInfo/EstSmpErr) then 'True'             else if (/codeBook/stdyDscr/method/anlyInfo/dataAppr) then 'True'             else 'False' "/>
    
  <xsl:variable name="show-accessibility" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" select="if (/codeBook/stdyDscr/dataAccs/useStmt/contact) then 'True'             else if (/codeBook/stdyDscr/citation/distStmt/distrbtr) then 'True'             else if (/codeBook/stdyDscr/citation/distStmt/contact) then 'True'             else if (/codeBook/stdyDscr/dataAccs/useStmt/confDec) then 'True'             else if (/codeBook/stdyDscr/dataAccs/useStmt/conditions) then 'True'             else if (/codeBook/stdyDscr/dataAccs/useStmt/citReq) then 'True'             else 'False' "/>

  <xsl:variable name="show-rights-and-disclaimer" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" select="if (/codeBook/stdyDscr/dataAccs/useStmt/disclaimer) then 'True'             else if (/codeBook/stdyDscr/citation/prodStmt/copyright) then 'True'             else 'False' "/>


  <!-- #################################################### -->
  <!-- ### i18n strings                                 ### -->
  <!-- #################################################### -->

  <!-- read strings from selected translations file-->
  <xsl:variable name="strings" select="document($translations-file)"/>

  <!-- put i18n strings in separate variables -->
  <xsl:variable name="i18n-Abstract" select="$strings/*/entry[@key='Abstract']"/>
  <xsl:variable name="i18n-Abbrev_NotWeighted" select="$strings/*/entry[@key='Abbrev_NotWeighted']"/>
  <xsl:variable name="i18n-Abbrev_Weighted" select="$strings/*/entry[@key='Abbrev_Weighted']"/>
  <xsl:variable name="i18n-Accessibility" select="$strings/*/entry[@key='Accessibility']"/>
  <xsl:variable name="i18n-Access_Authority" select="$strings/*/entry[@key='Access_Authority']"/>
  <xsl:variable name="i18n-Access_Conditions" select="$strings/*/entry[@key='Access_Conditions']"/>
  <xsl:variable name="i18n-Acknowledgments" select="$strings/*/entry[@key='Acknowledgments']"/>
  <xsl:variable name="i18n-Cases" select="$strings/*/entry[@key='Cases']"/>
  <xsl:variable name="i18n-Cases_Abbreviation" select="$strings/*/entry[@key='Cases_Abbreviation']"/>
  <xsl:variable name="i18n-Citation_Requirements" select="$strings/*/entry[@key='Citation_Requirements']"/>
  <xsl:variable name="i18n-Concepts" select="$strings/*/entry[@key='Concepts']"/>
  <xsl:variable name="i18n-Confidentiality" select="$strings/*/entry[@key='Confidentiality']"/>
  <xsl:variable name="i18n-Contacts" select="$strings/*/entry[@key='Contacts']"/>
  <xsl:variable name="i18n-Copyright" select="$strings/*/entry[@key='Copyright']"/>
  <xsl:variable name="i18n-Countries" select="$strings/*/entry[@key='Countries']"/>
  <xsl:variable name="i18n-continuous" select="$strings/*/entry[@key='continuous']"/>
  <xsl:variable name="i18n-Cover_Page" select="$strings/*/entry[@key='Cover_Page']"/>
  <xsl:variable name="i18n-Data_Collection" select="$strings/*/entry[@key='Data_Collection']"/>
  <xsl:variable name="i18n-Data_Collectors" select="$strings/*/entry[@key='Data_Collectors']"/>
  <xsl:variable name="i18n-Data_Collection_Dates" select="$strings/*/entry[@key='Data_Collection_Dates']"/> 
  <xsl:variable name="i18n-Data_Collection_Mode" select="$strings/*/entry[@key='Data_Collection_Mode']"/>
  <xsl:variable name="i18n-Data_Collection_Notes" select="$strings/*/entry[@key='Data_Collection_Notes']"/>
  <xsl:variable name="i18n-Data_Cleaning_Notes" select="$strings/*/entry[@key='Data_Cleaning_Notes']"/>
  <xsl:variable name="i18n-Data_Editing" select="$strings/*/entry[@key='Data_Editing']"/>
  <xsl:variable name="i18n-Data_Processing_Notes" select="$strings/*/entry[@key='Data_Collection']"/>
  <xsl:variable name="i18n-Data_Processing_and_Appraisal" select="$strings/*/entry[@key='Data_Processing_and_Appraisal']"/>
  <xsl:variable name="i18n-Dataset_contains" select="$strings/*/entry[@key='Dataset_contains']"/>
  <xsl:variable name="i18n-Definition" select="$strings/*/entry[@key='Definitions']"/>
  <xsl:variable name="i18n-Depositors" select="$strings/*/entry[@key='Depositors']"/>
  <xsl:variable name="i18n-Deviations_from_Sample_Design" select="$strings/*/entry[@key='Deviations_from_Sample_Design']"/>
  <xsl:variable name="i18n-Distributors" select="$strings/*/entry[@key='Distributors']"/>
  <xsl:variable name="i18n-Disclaimer" select="$strings/*/entry[@key='Disclaimer']"/>
  <xsl:variable name="i18n-discrete" select="$strings/*/entry[@key='discrete']"/>
  <xsl:variable name="i18n-Document_Information" select="$strings/*/entry[@key='Document_Information']"/>
  <xsl:variable name="i18n-Estimates_of_Sampling_Error" select="$strings/*/entry[@key='Estimates_of_Sampling_Error']"/>
  <xsl:variable name="i18n-files" select="$strings/*/entry[@key='files']"/>
  <xsl:variable name="i18n-Files_Description" select="$strings/*/entry[@key='Files_Description']"/>
  <xsl:variable name="i18n-File_Structure" select="$strings/*/entry[@key='File_Structure']"/>
  <xsl:variable name="i18n-Format" select="$strings/*/entry[@key='Format']"/>
  <xsl:variable name="i18n-File" select="$strings/*/entry[@key='File']"/>
  <xsl:variable name="i18n-File_Content" select="$strings/*/entry[@key='File_Content']"/>
  <xsl:variable name="i18n-Frequency_table_not_shown" select="$strings/*/entry[@key='Frequency_table_not_shown']"/>
  <xsl:variable name="i18n-Funding_Agencies" select="$strings/*/entry[@key='Funding_Agencies']"/>
  <xsl:variable name="i18n-Geographic_Coverage" select="$strings/*/entry[@key='Geographic_Coverage']"/>
  <xsl:variable name="i18n-Group" select="$strings/*/entry[@key='Group']"/>
  <xsl:variable name="i18n-groups" select="$strings/*/entry[@key='groups']"/>
  <xsl:variable name="i18n-Identification" select="$strings/*/entry[@key='Identification']"/>
  <xsl:variable name="i18n-Imputation" select="$strings/*/entry[@key='Imputation']"/>
  <xsl:variable name="i18n-Information" select="$strings/*/entry[@key='Information']"/>
  <xsl:variable name="i18n-Interviewers_instructions" select="$strings/*/entry[@key='Interviewers_instructions']"/>
  <xsl:variable name="i18n-Invalid" select="$strings/*/entry[@key='Invalid']"/>
  <xsl:variable name="i18n-Keys" select="$strings/*/entry[@key='Keys']"/>
  <xsl:variable name="i18n-Keywords" select="$strings/*/entry[@key='Keywords']"/>
  <xsl:variable name="i18n-Kind_of_Data" select="$strings/*/entry[@key='Kind_of_Data']"/>
  <xsl:variable name="i18n-Label" select="$strings/*/entry[@key='Label']"/>
  <xsl:variable name="i18n-Literal_question" select="$strings/*/entry[@key='Literal_question']"/>
  <xsl:variable name="i18n-Mean" select="$strings/*/entry[@key='Mean']"/>
  <xsl:variable name="i18n-Metadata_Production" select="$strings/*/entry[@key='Metadata_Production']"/>
  <xsl:variable name="i18n-Metadata_Producers" select="$strings/*/entry[@key='Metadata_Producers']"/>
  <xsl:variable name="i18n-Missing" select="$strings/*/entry[@key='Missing']"/>
  <xsl:variable name="i18n-Missing_Data" select="$strings/*/entry[@key='Missing_Data']"/>
  <xsl:variable name="i18n-Modalities" select="$strings/*/entry[@key='Modalities']"/>
  <xsl:variable name="i18n-Name" select="$strings/*/entry[@key='Name']"/>
  <xsl:variable name="i18n-Notes" select="$strings/*/entry[@key='Notes']"/>
  <xsl:variable name="i18n-Other_Acknowledgements" select="$strings/*/entry[@key='Other_Acknowledgements']"/>
  <xsl:variable name="i18n-Other_Forms_of_Data_Appraisal" select="$strings/*/entry[@key='Other_Forms_of_Data_Appraisal']"/>
  <xsl:variable name="i18n-Other_Processing" select="$strings/*/entry[@key='Other_Processing']"/>
  <xsl:variable name="i18n-Other_Producers" select="$strings/*/entry[@key='Other_Producers']"/>
  <xsl:variable name="i18n-Overview" select="$strings/*/entry[@key='Overview']"/>
  <xsl:variable name="i18n-Percentage" select="$strings/*/entry[@key='Percentage']"/>
  <xsl:variable name="i18n-Post-question" select="$strings/*/entry[@key='Post-question']"/>
  <xsl:variable name="i18n-Pre-question" select="$strings/*/entry[@key='Pre-question']"/>
  <xsl:variable name="i18n-Primary_Investigators" select="$strings/*/entry[@key='Primary_Investigators']"/>
  <xsl:variable name="i18n-Processing_Checks" select="$strings/*/entry[@key='Processing_Checks']"/>
  <xsl:variable name="i18n-Producer" select="$strings/*/entry[@key='Producer']"/>
  <xsl:variable name="i18n-Producers_and_Sponsors" select="$strings/*/entry[@key='Producers_and_Sponsors']"/>
  <xsl:variable name="i18n-Production_Date" select="$strings/*/entry[@key='Production_Date']"/>
  <xsl:variable name="i18n-Question" select="$strings/*/entry[@key='Question']"/>
  <xsl:variable name="i18n-Questionnaires" select="$strings/*/entry[@key='Questionnaires']"/>
  <xsl:variable name="i18n-Range" select="$strings/*/entry[@key='Range']"/>
  <xsl:variable name="i18n-Recoding_and_Derivation" select="$strings/*/entry[@key='Recoding_and_Derivation']"/>
  <xsl:variable name="i18n-Response_Rate" select="$strings/*/entry[@key='Response_Rate']"/>
  <xsl:variable name="i18n-Rights_and_Disclaimer" select="$strings/*/entry[@key='Rights_and_Disclaimer']"/>
  <xsl:variable name="i18n-Sampling" select="$strings/*/entry[@key='Sampling']"/>
  <xsl:variable name="i18n-Sampling_Procedure" select="$strings/*/entry[@key='Sampling_Procedure']"/>
  <xsl:variable name="i18n-Scope" select="$strings/*/entry[@key='Scope']"/>
  <xsl:variable name="i18n-Scope_and_Coverage" select="$strings/*/entry[@key='Scope_and_Coverage']"/>
  <xsl:variable name="i18n-Security" select="$strings/*/entry[@key='Security']"/>
  <xsl:variable name="i18n-Series" select="$strings/*/entry[@key='Series']"/>
  <xsl:variable name="i18n-ShowingSubset" select="$strings/*/entry[@key='ShowingSubset']"/>
  <xsl:variable name="i18n-Source" select="$strings/*/entry[@key='Source']"/>
  <xsl:variable name="i18n-StdDev" select="$strings/*/entry[@key='StdDev']"/>
  <xsl:variable name="i18n-Statistics" select="$strings/*/entry[@key='Statistics']"/>
  <xsl:variable name="i18n-Subgroups" select="$strings/*/entry[@key='Subgroups']"/>
  <xsl:variable name="i18n-SumStat_Warning" select="$strings/*/entry[@key='SumStat_Warning']"/>
  <xsl:variable name="i18n-Supervision" select="$strings/*/entry[@key='Supervision']"/>
  <xsl:variable name="i18n-Table_of_Contents" select="$strings/*/entry[@key='Table_of_Contents']"/>
  <xsl:variable name="i18n-Time_Periods" select="$strings/*/entry[@key='Time_Periods']"/>
  <xsl:variable name="i18n-Topics" select="$strings/*/entry[@key='Topics']"/>
  <xsl:variable name="i18n-Type" select="$strings/*/entry[@key='Type']"/>
  <xsl:variable name="i18n-Unit_of_Analysis" select="$strings/*/entry[@key='Unit_of_Analysis']"/>
  <xsl:variable name="i18n-Universe" select="$strings/*/entry[@key='Universe']"/>
  <xsl:variable name="i18n-Valid" select="$strings/*/entry[@key='Valid']"/>
  <xsl:variable name="i18n-Value" select="$strings/*/entry[@key='Value']"/>
  <xsl:variable name="i18n-variables" select="$strings/*/entry[@key='variables']"/>
  <xsl:variable name="i18n-Variables" select="$strings/*/entry[@key='Variables']"/>
  <xsl:variable name="i18n-Variables_List" select="$strings/*/entry[@key='Variables_List']"/>
  <xsl:variable name="i18n-Variables_Groups" select="$strings/*/entry[@key='Variables_Groups']"/>
  <xsl:variable name="i18n-Variables_Description" select="$strings/*/entry[@key='Variables_Description']"/>
  <xsl:variable name="i18n-Version" select="$strings/*/entry[@key='Version']"/>
  <xsl:variable name="i18n-Weighted" select="$strings/*/entry[@key='Weighted']"/>
  <xsl:variable name="i18n-Weighting" select="$strings/*/entry[@key='Weighting']"/>


  <!-- #################################################### -->
  <!-- ### xinclude other files                         ### -->
  <!-- #################################################### -->
  
  <!-- ================== -->
  <!-- matching templates -->
  <!-- ================== -->
  <!-- root.xsl --><!-- ========================== --><!-- match: /                   --><!-- value: <fo:root>           --><!-- ========================== --><!-- ============================================================= --><!-- Setup page sizes and layouts     [layout-master-set]          --><!-- Outline / Bookmarks              [bookmark-tree]              --><!-- Cover page                       [page-sequence]              --><!-- Metadata information             [page-sequence] with [table] --><!-- Table of contents                [page-sequence]              --><!-- Overview                         [page-sequence] with [table] --><!-- Files Description                [page-sequence]              --><!-- Variables List                   [page-sequence]              --><!-- Variable Groups                  [page-sequence]              --><!-- Variables Description            [page-sequence]              --><!-- ============================================================= --><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xi="http://www.w3.org/2001/XInclude" match="/" xml:base="templates/match/root.xsl">
  <fo:root>

    <!-- ================================ -->
    <!-- Setup page size and layout       -->
    <!-- ================================ -->

    <fo:layout-master-set>

      <!-- A4 page -->
      <fo:simple-page-master master-name="A4-page" page-height="297mm" page-width="210mm" margin-left="20mm" margin-right="20mm" margin-top="20mm" margin-bottom="20mm">
        
        <fo:region-body region-name="body" margin-top="10mm" margin-bottom="10mm"/>      
        <fo:region-before region-name="before" extent="10mm"/>
        <fo:region-after region-name="after" extent="10mm"/>
      </fo:simple-page-master>

    </fo:layout-master-set>

    <!-- ================================ -->
    <!-- Other sections                   -->
    <!-- ================================ -->    
    <!-- bookmarks.xsl --><!-- =========================================== --><!-- <xls:if> bookmarks                          --><!-- value: <fo:bookmark-tree>                   --><!-- =========================================== --><!-- read: --><!-- show-cover-page, show-metadata-info, show-toc, show-overview             --><!-- show-scope-and-coverage, show-producers-and-sponsors,                    --><!-- show-sampling, show-data-collection, show-data-processing-and-appraisal, --><!-- show-accessibility, show-rights-and-disclaimer, show-files-description,  --><!-- show-variable-groups, show-variables-list, show-variables-description    --><!-- functions: --><!-- nomalize-space(), contains(), concat(), string-length() [xpath 1.0] --><!-- called: --><!-- trim --><xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" test="$show-bookmarks='True'" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="root_template_xincludes/bookmark-tree.xsl">

  <fo:bookmark-tree>

    <!-- Cover_Page -->
    <xsl:if test="$show-cover-page='True'">
      <fo:bookmark internal-destination="cover-page">
        <fo:bookmark-title>
          <xsl:value-of select="$i18n-Cover_Page"/>
        </fo:bookmark-title>
      </fo:bookmark>
    </xsl:if>

    <!-- Document_Information -->
    <xsl:if test="$show-metadata-info = 'True'">
      <fo:bookmark internal-destination="metadata-info">
        <fo:bookmark-title>
          <xsl:value-of select="$i18n-Document_Information"/>
        </fo:bookmark-title>
      </fo:bookmark>
    </xsl:if>

    <!-- Table_of_Contents -->
    <xsl:if test="$show-toc = 'True'">
      <fo:bookmark internal-destination="toc">
        <fo:bookmark-title>
          <xsl:value-of select="$i18n-Table_of_Contents"/>
        </fo:bookmark-title>
      </fo:bookmark>
    </xsl:if>

    <!-- ============= -->
    <!-- Overview      -->
    <!-- ============= -->

    <xsl:if test="$show-overview = 'True'">

      <fo:bookmark internal-destination="overview">
        <fo:bookmark-title>
          <xsl:value-of select="$i18n-Overview"/>
        </fo:bookmark-title>

        <!-- Scope_and_Coverage -->
        <xsl:if test="$show-scope-and-coverage = 'True'">
          <fo:bookmark internal-destination="scope-and-coverage">
            <fo:bookmark-title>
              <xsl:value-of select="$i18n-Scope_and_Coverage"/>
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:if>

        <!-- Producers_and_Sponsors -->
        <xsl:if test="$show-producers-and-sponsors = 'True'">
          <fo:bookmark internal-destination="producers-and-sponsors">
            <fo:bookmark-title>
              <xsl:value-of select="$i18n-Producers_and_Sponsors"/>
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:if>

        <!-- Sampling -->
        <xsl:if test="$show-sampling = 'True'">
          <fo:bookmark internal-destination="sampling">
            <fo:bookmark-title>
              <xsl:value-of select="$i18n-Sampling"/>
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:if>

        <!-- Data_Collection -->
        <xsl:if test="$show-data-collection = 'True'">
          <fo:bookmark internal-destination="data-collection">
            <fo:bookmark-title>
              <xsl:value-of select="$i18n-Data_Collection"/>
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:if>

        <!-- Data_Processing_and_Appraisal -->
        <xsl:if test="$show-data-processing-and-appraisal = 'True'">
          <fo:bookmark internal-destination="data-processing-and-appraisal">
            <fo:bookmark-title>
              <xsl:value-of select="$i18n-Data_Processing_and_Appraisal"/>
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:if>

        <!-- Accessibility -->
        <xsl:if test="$show-accessibility = 'True'">
          <fo:bookmark internal-destination="accessibility">
            <fo:bookmark-title>
              <xsl:value-of select="$i18n-Accessibility"/>
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:if>

        <!-- Rights_and_Disclaimer -->
        <xsl:if test="$show-rights-and-disclaimer = 'True'">
          <fo:bookmark internal-destination="rights-and-disclaimer">
            <fo:bookmark-title>
              <xsl:value-of select="$i18n-Rights_and_Disclaimer"/>
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:if>

      </fo:bookmark>
    </xsl:if>

    <!-- Files_Description -->
    <xsl:if test="$show-files-description = 'True'">
      <fo:bookmark internal-destination="files-description">

        <fo:bookmark-title>
          <xsl:value-of select="$i18n-Files_Description"/>
        </fo:bookmark-title>

        <xsl:for-each select="/codeBook/fileDscr">
          <fo:bookmark internal-destination="file-{fileTxt/fileName/@ID}">
            <fo:bookmark-title>
              <xsl:apply-templates select="fileTxt/fileName"/>
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:for-each>
      </fo:bookmark>
    </xsl:if>

    <!-- Variables_Groups -->
    <xsl:if test="$show-variable-groups = 'True'">
      <fo:bookmark internal-destination="variables-groups">
        <fo:bookmark-title>
          <xsl:value-of select="$i18n-Variables_Groups"/>
        </fo:bookmark-title>

        <xsl:for-each select="/codeBook/dataDscr/varGrp">
            <fo:bookmark internal-destination="vargrp-{@ID}">
              <fo:bookmark-title>
                <xsl:value-of select="normalize-space(labl)"/>
              </fo:bookmark-title>
            </fo:bookmark>          
        </xsl:for-each>
      </fo:bookmark>
    </xsl:if>

    <!-- Variables_List -->
    <xsl:if test="$show-variables-list = 'True'">
      <fo:bookmark internal-destination="variables-list">
        <fo:bookmark-title>
          <xsl:value-of select="$i18n-Variables_List"/>
        </fo:bookmark-title>

        <xsl:for-each select="/codeBook/fileDscr">
          <fo:bookmark internal-destination="varlist-{fileTxt/fileName/@ID}">
            <fo:bookmark-title>
              <xsl:apply-templates select="fileTxt/fileName"/>
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:for-each>
      </fo:bookmark>
    </xsl:if>

    <!-- Variables_Description -->
    <xsl:if test="$show-variables-description = 'True'">
      <fo:bookmark internal-destination="variables-description">
        <fo:bookmark-title>
          <xsl:value-of select="$i18n-Variables_Description"/>
        </fo:bookmark-title>

        <xsl:for-each select="/codeBook/fileDscr">
          <fo:bookmark internal-destination="vardesc-{fileTxt/fileName/@ID}">
            <fo:bookmark-title>
              <xsl:apply-templates select="fileTxt/fileName"/>
            </fo:bookmark-title>

            <xsl:variable name="fileId" select="if (fileTxt/fileName/@ID) then fileTxt/fileName/@ID                       else if (@ID) then @ID                       else () "/>

            <xsl:for-each select="/codeBook/dataDscr/var[@files=$fileId]">
                <fo:bookmark internal-destination="var-{@ID}">
                  <fo:bookmark-title>
                    <xsl:apply-templates select="@name"/>

                    <xsl:value-of select="if (normalize-space(labl)) then                                             string-join((': ', util:trim(labl)), '')                                           else () "/>

                  </fo:bookmark-title>
                </fo:bookmark>            
            </xsl:for-each>

          </fo:bookmark>
        </xsl:for-each>
      </fo:bookmark>
    </xsl:if>

  </fo:bookmark-tree>
</xsl:if>    
    <!-- cover_page.xsl --><!-- ========================= --><!-- <xsl:if> cover page       --><!-- value: <fo:page-sequence> --><!-- ========================= --><!-- functions: --><!-- normalize-space() [Xpath 1.0] --><!-- util:trim() [local]           --><xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" test="$show-cover-page = 'True'" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="root_template_xincludes/page-sequence/cover_page.xsl">

  <fo:page-sequence master-reference="{$page-layout}" font-family="Helvetica" font-size="{$font-size}">

    <!-- =========================================== -->
    <!-- page content                                -->
    <!-- =========================================== -->

    <fo:flow flow-name="body">

      <fo:block id="cover-page">

        <!-- logo graphic -->
        <fo:block text-align="center">
          <fo:external-graphic src="{$logo-file}"/>
        </fo:block>      

        <!-- title -->
        <fo:block font-size="18pt" font-weight="bold" space-before="5mm" text-align="center" space-after="0.0mm">
          <xsl:value-of select="normalize-space(/codeBook/stdyDscr/citation/titlStmt/titl)"/>
        </fo:block>

        <!-- ID-number -->
        <!-- <fo:block font-size="15pt" text-align="center" space-before="5mm">
          <xsl:value-of select="/codeBook/docDscr/docSrc/titlStmt/IDNo" />
        </fo:block> -->

        <!-- blank line (&#x00A0; is the equivalent of HTML &nbsp;) -->
        <fo:block white-space-treatment="preserve">   </fo:block>

        <!-- responsible party(ies) -->      
        <xsl:for-each select="/codeBook/stdyDscr/citation/rspStmt/AuthEnty">
          <fo:block font-size="14pt" font-weight="bold" space-before="0.0mm" text-align="center" space-after="0.0mm">
            <xsl:value-of select="util:trim(.)"/>
          </fo:block>

          <xsl:if test="@affiliation">
            <fo:block font-size="12pt" text-align="center">
              <xsl:value-of select="@affiliation"/>
            </fo:block>
          </xsl:if>           
            
          <fo:block white-space-treatment="preserve" font-size="5pt">   </fo:block>
            
        </xsl:for-each>
        
      </fo:block>
    </fo:flow>
  </fo:page-sequence>
</xsl:if>
    <!-- metadata_information.xsl --><!-- ================================================= --><!-- <xsl:if> metadata information                     --><!-- value: <fo:page-sequence>                         --><!-- ================================================= --><!-- read: --><!-- $strings, $font-family --><!-- $default-border, $cell-padding --><!-- functions: --><!-- boolean(), normalize-space() [Xpath 1.0] --><!-- proportional-column-width() [FO]         --><!-- util:isodate_long() [functions] --><!-- Metadata production        [table]      --><!--   Metadata producers       [table-row]  --><!--   Metadata Production Date [table-row]  --><!--   Metadata Version         [table-row]  --><!--   Metadata ID              [table-row]  --><!--   Spacer                   [table-row]  --><!-- Report Acknowledgements    [block]      --><!-- Report Notes               [block]      --><xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" test="$show-metadata-info = 'True'" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="root_template_xincludes/page-sequence/metadata_information.xsl">
  
  <fo:page-sequence master-reference="{$page-layout}" font-family="{$font-family}" font-size="{$font-size}">
    
    <!-- =========================================== -->
    <!-- page content                                -->
    <!-- =========================================== -->
    
    <fo:flow flow-name="body">
      <fo:block id="metadata-info"/>
      
      <!-- Title -->
      <fo:block id="metadata-production" font-size="18pt" font-weight="bold" space-after="2.5mm">
        <xsl:value-of select="$i18n-Metadata_Production"/>
      </fo:block>
      
      <fo:table table-layout="fixed" width="100%" space-before="0.0in" space-after="5mm">
        <fo:table-column column-width="proportional-column-width(20)"/>
        <fo:table-column column-width="proportional-column-width(80)"/>
        
        <fo:table-body>
          
          <!-- Metadata Producers -->
          <xsl:if test="/codeBook/docDscr/citation/prodStmt/producer">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$i18n-Metadata_Producers"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/codeBook/docDscr/citation/prodStmt/producer"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Production Date -->
          <xsl:if test="/codeBook/docDscr/citation/prodStmt/prodDate">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$i18n-Production_Date"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <fo:block>                  
                  <xsl:value-of select="util:isodate_long(normalize-space(/codeBook/docDscr/citation/prodStmt/prodDate))"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Version -->
          <!-- <xsl:if test="/codeBook/docDscr/citation/verStmt/version">
            <fo:table-row>
            <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
            <fo:block>
            <xsl:value-of select="$i18n-Version"/>
            </fo:block>
            </fo:table-cell>
            <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
            <xsl:apply-templates select="/codeBook/docDscr/citation/verStmt/version" />
            </fo:table-cell>
            </fo:table-row>
            </xsl:if> -->
          
          <!-- Identification -->
          <xsl:if test="/codeBook/docDscr/citation/titlStmt/IDNo">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$i18n-Identification"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/codeBook/docDscr/citation/titlStmt/IDNo"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
        </fo:table-body>
      </fo:table>
      
    </fo:flow>
  </fo:page-sequence>
</xsl:if>
    <!-- table_of_contents.xsl --><!-- ============================================== --><!-- <xsl:if> table of contents                     --><!-- value: <fo:page-sequence>                      --><!-- ============================================== --><!-- read: --><!-- $font-family, $show-overview, $show-scope-and-coverage, --><!-- $show-producers-and-sponsors, $show-sampling, $show-data-collection --><!-- $show-data-processing-and-appraisal, $show-accessibility, --><!-- $show-rights-and-disclaimer, $show-files-description, --><!-- $show-variables-list, $show-variable-groups --><!-- functions: --><!-- normalize-space(), string-length(), contains(), concat() [xpath 1.0] --><xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" test="$show-toc = 'True'" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="root_template_xincludes/page-sequence/table_of_contents.xsl">

  <fo:page-sequence master-reference="{$page-layout}" font-family="{$font-family}" font-size="{$font-size}">

    <fo:flow flow-name="body">

      <!-- ====================================== -->
      <!-- TOC heading                            -->
      <!-- ====================================== -->

      <fo:block id="toc" font-size="18pt" font-weight="bold" space-before="12mm" text-align="center" space-after="2.5mm">
        <xsl:value-of select="$i18n-Table_of_Contents"/>
      </fo:block>


      <!-- ====================================== -->
      <!-- actual TOC lines                       -->
      <!-- ====================================== -->

      <fo:block margin-left="12mm" margin-right="12mm">

        <!-- ============ -->
        <!-- Static lines -->
        <!-- ============ -->

        <!-- Overview -->
        <xsl:if test="$show-overview = 'True'">
          <fo:block font-size="{$font-size}" text-align-last="justify">
            <fo:basic-link internal-destination="overview" text-decoration="underline" color="blue">
              <xsl:value-of select="$i18n-Overview"/>
              <fo:leader leader-pattern="dots"/>
              <fo:page-number-citation ref-id="overview"/>
            </fo:basic-link>
          </fo:block>
        </xsl:if>

        <!-- Scope and Coverage -->
        <xsl:if test="$show-scope-and-coverage = 'True'">
          <fo:block font-size="{$font-size}" text-align-last="justify">
            <fo:basic-link internal-destination="scope-and-coverage" text-decoration="underline" color="blue">
              <xsl:value-of select="$i18n-Scope_and_Coverage"/>
              <fo:leader leader-pattern="dots"/>
              <fo:page-number-citation ref-id="scope-and-coverage"/>
            </fo:basic-link>
          </fo:block>
        </xsl:if>

        <!-- Producers and Sponsors -->
        <xsl:if test="$show-producers-and-sponsors = 'True'">
          <fo:block font-size="{$font-size}" text-align-last="justify">
            <fo:basic-link internal-destination="producers-and-sponsors" text-decoration="underline" color="blue">
              <xsl:value-of select="$i18n-Producers_and_Sponsors"/>
              <fo:leader leader-pattern="dots"/>
              <fo:page-number-citation ref-id="producers-and-sponsors"/>
            </fo:basic-link>
          </fo:block>
        </xsl:if>

        <!-- Sampling -->
        <xsl:if test="$show-sampling = 'True'">
          <fo:block font-size="{$font-size}" text-align-last="justify">
            <fo:basic-link internal-destination="sampling" text-decoration="underline" color="blue">
              <xsl:value-of select="$i18n-Sampling"/>
              <fo:leader leader-pattern="dots"/>
              <fo:page-number-citation ref-id="sampling"/>
            </fo:basic-link>
          </fo:block>
        </xsl:if>

        <!-- Data Collection -->
        <xsl:if test="$show-data-collection = 'True'">
          <fo:block font-size="{$font-size}" text-align-last="justify">
            <fo:basic-link internal-destination="data-collection" text-decoration="underline" color="blue">
              <xsl:value-of select="$i18n-Data_Collection"/>
              <fo:leader leader-pattern="dots"/>
              <fo:page-number-citation ref-id="data-collection"/>
            </fo:basic-link>
          </fo:block>
        </xsl:if>

        <!-- Data Processing and Appraisal -->
        <xsl:if test="$show-data-processing-and-appraisal = 'True'">
          <fo:block font-size="{$font-size}" text-align-last="justify">
            <fo:basic-link internal-destination="data-processing-and-appraisal" text-decoration="underline" color="blue">
              <xsl:value-of select="$i18n-Data_Processing_and_Appraisal"/>
              <fo:leader leader-pattern="dots"/>
              <fo:page-number-citation ref-id="data-processing-and-appraisal"/>
            </fo:basic-link>
          </fo:block>
        </xsl:if>

        <!-- Accessibility -->
        <xsl:if test="$show-accessibility= 'True'">
          <fo:block font-size="{$font-size}" text-align-last="justify">
            <fo:basic-link internal-destination="accessibility" text-decoration="underline" color="blue">
              <xsl:value-of select="$i18n-Accessibility"/>
              <fo:leader leader-pattern="dots"/>
              <fo:page-number-citation ref-id="accessibility"/>
            </fo:basic-link>
          </fo:block>
        </xsl:if>

        <!-- Rights and Disclaimer -->
        <xsl:if test="$show-rights-and-disclaimer = 'True'">
          <fo:block font-size="{$font-size}" text-align-last="justify">
            <fo:basic-link internal-destination="rights-and-disclaimer" text-decoration="underline" color="blue">
              <xsl:value-of select="$i18n-Rights_and_Disclaimer"/>
              <fo:leader leader-pattern="dots"/>
              <fo:page-number-citation ref-id="rights-and-disclaimer"/>
            </fo:basic-link>
          </fo:block>
        </xsl:if>


        <!-- ============= -->
        <!-- Dynamic lines -->
        <!-- ============= -->

        <!-- Files Description -->
        <xsl:if test="$show-files-description = 'True'">
          <fo:block font-size="{$font-size}" text-align-last="justify">

            <fo:basic-link internal-destination="files-description" text-decoration="underline" color="blue">
              <xsl:value-of select="$i18n-Files_Description"/>
              <fo:leader leader-pattern="dots"/>
              <fo:page-number-citation ref-id="files-description"/>
            </fo:basic-link>

            <xsl:for-each select="/codeBook/fileDscr">
              <fo:block margin-left="0.7in" font-size="{$font-size}" text-align-last="justify">
                <fo:basic-link internal-destination="file-{fileTxt/fileName/@ID}" text-decoration="underline" color="blue">
                  <xsl:apply-templates select="fileTxt/fileName"/>
                  <fo:leader leader-pattern="dots"/>
                  <fo:page-number-citation ref-id="file-{fileTxt/fileName/@ID}"/>
                </fo:basic-link>
              </fo:block>
            </xsl:for-each>
          </fo:block>
        </xsl:if>

        <!-- Variables List -->
        <xsl:if test="$show-variables-list = 'True'">
          <fo:block font-size="{$font-size}" text-align-last="justify">
            <fo:basic-link internal-destination="variables-list" text-decoration="underline" color="blue">
              <xsl:value-of select="$i18n-Variables_List"/>
              
              <fo:leader leader-pattern="dots"/>
              <fo:page-number-citation ref-id="variables-list"/>
            </fo:basic-link>
            <xsl:for-each select="/codeBook/fileDscr">
              <fo:block margin-left="0.7in" font-size="{$font-size}" text-align-last="justify">
                <fo:basic-link internal-destination="varlist-{fileTxt/fileName/@ID}" text-decoration="underline" color="blue">
                  <xsl:apply-templates select="fileTxt/fileName"/>
                  <fo:leader leader-pattern="dots"/>
                  <fo:page-number-citation ref-id="varlist-{fileTxt/fileName/@ID}"/>
                </fo:basic-link>
              </fo:block>
            </xsl:for-each>
          </fo:block>
        </xsl:if>

        <!-- Variables Groups -->
        <xsl:if test="$show-variable-groups = 'True'">
          <fo:block font-size="{$font-size}" text-align-last="justify">
            <fo:basic-link internal-destination="variables-groups" text-decoration="underline" color="blue">
              <xsl:value-of select="$i18n-Variables_Groups"/>
              <fo:leader leader-pattern="dots"/>
              <fo:page-number-citation ref-id="variables-groups"/>
            </fo:basic-link>

            <xsl:for-each select="/codeBook/dataDscr/varGrp">
                <fo:block margin-left="0.7in" font-size="{$font-size}" text-align-last="justify">
                  <fo:basic-link internal-destination="vargrp-{@ID}" text-decoration="underline" color="blue">
                    <xsl:value-of select="normalize-space(labl)"/>
                    <fo:leader leader-pattern="dots"/>
                    <fo:page-number-citation ref-id="vargrp-{@ID}"/>
                  </fo:basic-link>
                </fo:block>              
            </xsl:for-each>
          </fo:block>
        </xsl:if>

        <!-- Variables_Description -->
        <xsl:if test="$show-variables-description = 'True'">
          <fo:block font-size="{$font-size}" text-align-last="justify">

            <fo:basic-link internal-destination="variables-description" text-decoration="underline" color="blue">
              <xsl:value-of select="$i18n-Variables_Description"/>
              <fo:leader leader-pattern="dots"/>
              <fo:page-number-citation ref-id="variables-description"/>
            </fo:basic-link>

            <xsl:for-each select="/codeBook/fileDscr">
              <fo:block margin-left="0.7in" font-size="{$font-size}" text-align-last="justify">
                <fo:basic-link internal-destination="vardesc-{fileTxt/fileName/@ID}" text-decoration="underline" color="blue">
                  <xsl:apply-templates select="fileTxt/fileName"/>
                  <fo:leader leader-pattern="dots"/>
                  <fo:page-number-citation ref-id="vardesc-{fileTxt/fileName/@ID}"/>
                </fo:basic-link>
              </fo:block>
            </xsl:for-each>
          </fo:block>
        </xsl:if>

      </fo:block>
    </fo:flow>
  </fo:page-sequence>
</xsl:if>
    <!-- overview.xsl --><!-- =========================================== --><!-- <xsl:if> overview                           --><!-- value: <fo:page-sequence>                   --><!-- =========================================== --><!-- read: --><!-- $strings, $report-start-page-number, $font-family, $color-gray3   --><!-- $default-border, $cell-padding, $survey-title, $color-gray1, $time --><!-- functions: --><!-- nomalize-space(), position() [Xpath] --><!-- proportional-column-width() [FO] --><xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" test="$show-overview = 'True'" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="root_template_xincludes/page-sequence/overview.xsl">

  <fo:page-sequence master-reference="{$page-layout}" initial-page-number="{$report-start-page-number}" font-family="{$font-family}" font-size="{$font-size}">

    <!-- =========================================== -->
    <!-- page header and footer                      -->
    <!-- =========================================== -->

    <xsl:call-template name="page_header">
      <xsl:with-param name="section_name" select="$i18n-Overview"/>
    </xsl:call-template>

    <xsl:call-template name="page_footer"/>

    <!-- =========================================== -->
    <!-- page content                                -->
    <!-- =========================================== -->
    
    <fo:flow flow-name="body">
 
      <fo:table table-layout="fixed" width="100%">
        <fo:table-column column-width="proportional-column-width(20)"/>
        <fo:table-column column-width="proportional-column-width(80)"/>

        <fo:table-body>

          <!-- ========================= -->
          <!-- title header              -->
          <!-- ========================= -->
          <fo:table-row background-color="{$color-gray3}">
            <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
              <fo:block font-size="14pt" font-weight="bold">
                <xsl:value-of select="$survey-title"/>
              </fo:block>
              <xsl:if test="/codeBook/stdyDscr/citation/titlStmt/parTitl">
                <fo:block font-size="12pt" font-weight="bold" font-style="italic">
                  <xsl:value-of select="/codeBook/stdyDscr/citation/titlStmt/parTitl"/>
                </fo:block>
              </xsl:if>
            </fo:table-cell>
          </fo:table-row>

          <!-- Space -->
          <fo:table-row height="5mm">
            <fo:table-cell number-columns-spanned="2">
              <fo:block/>
            </fo:table-cell>
          </fo:table-row>

          <!-- ========================= -->
          <!-- Overview                  -->
          <!-- ========================= -->
          <!-- Heading (two col) -->
          <fo:table-row background-color="{$color-gray1}" keep-with-next="always">
            <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
              <fo:block id="overview" font-size="12pt" font-weight="bold">
                <xsl:value-of select="$i18n-Overview"/>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>

          <!-- Type  -->
          <xsl:if test="/codeBook/stdyDscr/citation/serStmt/serName">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$i18n-Type"/>                 
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/citation/serStmt/serName"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Identification -->
          <xsl:if test="/codeBook/stdyDscr/citation/titlStmt/IDNo">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$i18n-Identification"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/citation/titlStmt/IDNo"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Version -->
          <xsl:for-each select="/codeBook/stdyDscr/citation/verStmt/version">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$i18n-Version"/>
                </fo:block>
              </fo:table-cell>

              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">

                <!-- Production_Date -->
                <xsl:for-each select="/codeBook/stdyDscr/citation/verStmt/version">
                  <xsl:if test="@date">
                    <fo:block>
                      <!-- <xsl:value-of select="$i18n-Production_Date" />:
                      <xsl:value-of select="@date" /> -->
                      
                      <xsl:value-of select="string-join(($i18n-Production_Date, @date), '')"/>
                    </fo:block>
                  </xsl:if>
                  <xsl:apply-templates select="."/>
                </xsl:for-each>

                <!-- Notes -->
                <xsl:for-each select="/codeBook/stdyDscr/citation/verStmt/notes">
                  <fo:block text-decoration="underline">
                    <xsl:value-of select="$i18n-Notes"/>
                  </fo:block>
                  <xsl:apply-templates select="."/>
                </xsl:for-each>

              </fo:table-cell>
            </fo:table-row>
          </xsl:for-each>

          <!-- Series -->
          <xsl:if test="/codeBook/stdyDscr/citation/serStmt/serInfo">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                   <xsl:value-of select="$i18n-Series"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/citation/serStmt/serInfo"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Abstract -->
          <xsl:if test="/codeBook/stdyDscr/stdyInfo/abstract">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$i18n-Abstract"/>
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/stdyInfo/abstract"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Kind of Data -->
          <xsl:if test="/codeBook/stdyDscr/stdyInfo/sumDscr/dataKind">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$i18n-Kind_of_Data"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/stdyInfo/sumDscr/dataKind"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Unit of Analysis  -->
          <xsl:if test="/codeBook/stdyDscr/stdyInfo/sumDscr/anlyUnit">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$i18n-Unit_of_Analysis"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/stdyInfo/sumDscr/anlyUnit"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Space -->
          <fo:table-row height="5mm">
            <fo:table-cell number-columns-spanned="2">
              <fo:block/>
            </fo:table-cell>
          </fo:table-row>

          <!-- =========================== -->
          <!-- Scope_and_Coverage          -->
          <!-- =========================== -->    
          <!-- heading (two col) -->
          <xsl:if test="$show-scope-and-coverage = 'True'">
            <fo:table-row background-color="{$color-gray1}" keep-with-next="always">
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block id="scope-and-coverage" font-size="12pt" font-weight="bold">
                  <xsl:value-of select="$i18n-Scope_and_Coverage"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Scope -->
          <xsl:if test="/codeBook/stdyDscr/stdyInfo/notes">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                   <xsl:value-of select="$i18n-Scope"/>
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/stdyInfo/notes"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Keywords -->
          <xsl:if test="/codeBook/stdyDscr/stdyInfo/subject/keyword">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                   <xsl:value-of select="$i18n-Keywords"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:for-each select="/codeBook/stdyDscr/stdyInfo/subject/keyword">
                    <xsl:if test="position()&gt;1">, </xsl:if>
                    <xsl:value-of select="normalize-space(.)"/>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Topics -->
          <xsl:if test="/codeBook/stdyDscr/stdyInfo/subject/topcClas">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$i18n-Topics"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:for-each select="/codeBook/stdyDscr/stdyInfo/subject/topcClas">
                    <!-- <xsl:if test="position()&gt;1">, </xsl:if> -->
                    <xsl:value-of select="if (position() &gt; 1) then ', ' else ()"/>                    
                    <xsl:value-of select="normalize-space(.)"/>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Time_Periods -->
          <xsl:if version="1.0" test="string-length($time) &gt; 3 or string-length($time-produced) &gt; 3">
            <fo:table-row>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$i18n-Time_Periods"/>
                </fo:block>
              </fo:table-cell>

              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:choose>
                  <xsl:when test="string-length($time) &gt; 3">
                    <fo:block>
                      <xsl:value-of select="$time"/>
                    </fo:block>
                  </xsl:when>
                  <xsl:when test="string-length($time-produced) &gt; 3">
                    <fo:block>
                      <xsl:value-of select="$time-produced"/>
                    </fo:block>
                  </xsl:when>
                </xsl:choose>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Countries -->
          <fo:table-row>
            <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
              <fo:block font-weight="bold" text-decoration="underline">
                <xsl:value-of select="$i18n-Countries"/>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
              <fo:block>
                <xsl:value-of select="$geography"/>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>

          <!-- Geographic_Coverage -->
          <xsl:if test="/codeBook/stdyDscr/stdyInfo/sumDscr/geogCover">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$i18n-Geographic_Coverage"/>
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/stdyInfo/sumDscr/geogCover"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Universe -->
          <xsl:if test="/codeBook/stdyDscr/stdyInfo/sumDscr/universe">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$i18n-Universe"/>
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/stdyInfo/sumDscr/universe"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Space -->
          <fo:table-row height="5mm">
            <fo:table-cell number-columns-spanned="2">
              <fo:block/>
            </fo:table-cell>
          </fo:table-row>

          <!-- ====================== -->
          <!-- Producers and Sponsors -->
          <!-- ====================== -->
          <!-- heading (two col) -->
          <xsl:if test="$show-producers-and-sponsors = 'True'">
            <fo:table-row background-color="{$color-gray1}" keep-with-next="always">
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block id="producers-and-sponsors" font-size="12pt" font-weight="bold">
                  <xsl:value-of select="$i18n-Producers_and_Sponsors"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Primary Investigator(s) -->
          <xsl:if test="/codeBook/stdyDscr/citation/rspStmt/AuthEnty">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$i18n-Primary_Investigators"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/citation/rspStmt/AuthEnty"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Other_Producers -->
          <xsl:if test="/codeBook/stdyDscr/citation/prodStmt/producer">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$i18n-Other_Producers"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/citation/prodStmt/producer"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Funding_Agencies -->
          <xsl:if test="/codeBook/stdyDscr/citation/prodStmt/fundAg">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$i18n-Funding_Agencies"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/citation/prodStmt/fundAg"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Other Acknowledgements -->
          <xsl:if test="/codeBook/stdyDscr/citation/rspStmt/othId">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$i18n-Other_Acknowledgements"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/citation/rspStmt/othId"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Space -->
          <fo:table-row height="5mm">
            <fo:table-cell number-columns-spanned="2">
              <fo:block/>
            </fo:table-cell>
          </fo:table-row>

          <!-- ======== -->
          <!-- Sampling -->
          <!-- ======== -->
          <!-- heading (two col) -->
          <xsl:if test="$show-sampling = 'True'">
            <fo:table-row background-color="{$color-gray1}">
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block id="sampling" font-size="12pt" font-weight="bold">
                  <xsl:value-of select="$i18n-Sampling"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Sampling Procedure -->
          <xsl:if test="/codeBook/stdyDscr/method/dataColl/sampProc">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$i18n-Sampling_Procedure"/>
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/dataColl/sampProc"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Deviations_from_Sample_Design -->
          <xsl:if test="/codeBook/stdyDscr/method/dataColl/deviat">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$i18n-Deviations_from_Sample_Design"/>
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/dataColl/deviat"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Response_Rate -->
          <xsl:if test="/codeBook/stdyDscr/method/anlyInfo/respRate">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$i18n-Response_Rate"/>
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/anlyInfo/respRate"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Weighting -->
          <xsl:if test="/codeBook/stdyDscr/method/dataColl/weight">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$i18n-Weighting"/>
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/dataColl/weight"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Space -->
          <fo:table-row height="5mm">
            <fo:table-cell number-columns-spanned="2">
              <fo:block/>
            </fo:table-cell>
          </fo:table-row>

          <!-- =============== -->
          <!-- Data Collection -->
          <!-- =============== -->
          <!-- heading (two col) -->
          <xsl:if test="$show-data-collection = 'True'">
            <fo:table-row background-color="{$color-gray1}" keep-with-next="always">
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block id="data-collection" font-size="12pt" font-weight="bold">
                   <xsl:value-of select="$i18n-Data_Collection"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Data Collection Dates -->
          <xsl:if test="/codeBook/stdyDscr/stdyInfo/sumDscr/collDate">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$i18n-Data_Collection_Dates"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/stdyInfo/sumDscr/collDate"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Time Periods -->
          <xsl:if test="/codeBook/stdyDscr/stdyInfo/sumDscr/timePrd">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$i18n-Time_Periods"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/stdyInfo/sumDscr/timePrd"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Data Collection Mode -->
          <xsl:if test="/codeBook/stdyDscr/method/dataColl/collMode">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                   <xsl:value-of select="$i18n-Data_Collection_Mode"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/method/dataColl/collMode"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Data Collection Notes -->
          <xsl:if test="/codeBook/stdyDscr/method/notes[@subject='collection']">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$i18n-Data_Collection_Notes"/>
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/notes[@subject='collection']"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Data Processing Notes -->
          <xsl:if test="/codeBook/stdyDscr/method/notes[@subject='processing']">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                   <xsl:value-of select="$i18n-Data_Processing_Notes"/>
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/notes[@subject='collection']"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Data Cleaning Notes -->
          <xsl:if test="/codeBook/stdyDscr/method/notes[@subject='cleaning']">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$i18n-Data_Cleaning_Notes"/>
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/notes[@subject='collection']"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Data Collection Notes -->
          <xsl:if test="/codeBook/stdyDscr/method/dataColl/collSitu">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                   <xsl:value-of select="$i18n-Data_Collection_Notes"/>
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/dataColl/collSitu"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Questionnaires -->
          <xsl:if test="/codeBook/stdyDscr/method/dataColl/resInstru">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$i18n-Questionnaires"/>
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/dataColl/resInstru"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Data Collectors -->
          <xsl:if test="/codeBook/stdyDscr/method/dataColl/dataCollector">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$i18n-Data_Collectors"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/method/dataColl/dataCollector"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Supervision -->
          <xsl:if test="/codeBook/stdyDscr/method/dataColl/actMin">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$i18n-Supervision"/>
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/dataColl/actMin"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Space -->
          <fo:table-row height="5mm">
            <fo:table-cell number-columns-spanned="2">
              <fo:block/>
            </fo:table-cell>
          </fo:table-row>

          <!-- ============================= -->
          <!-- Data Processing and Appraisal -->
          <!-- ============================= -->
          <!-- heading (two col) -->
          <xsl:if test="$show-data-processing-and-appraisal = 'True'">
            <fo:table-row background-color="{$color-gray1}" keep-with-next="always">
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block id="data-processing-and-appraisal" font-size="12pt" font-weight="bold">
                  <xsl:value-of select="i18n-Data_Processing_and_Appraisal"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Data Editing -->
          <xsl:if test="/codeBook/stdyDscr/method/dataColl/cleanOps">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$i18n-Data_Editing"/>
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/dataColl/cleanOps"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Other Processing -->
          <xsl:if test="/codeBook/stdyDscr/method/notes">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$i18n-Other_Processing"/>
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/notes"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Estimates of Sampling Error -->
          <xsl:if test="/codeBook/stdyDscr/method/anlyInfo/EstSmpErr">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$i18n-Estimates_of_Sampling_Error"/>
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/anlyInfo/EstSmpErr"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Other Forms of Data Appraisal -->
          <xsl:if test="/codeBook/stdyDscr/method/anlyInfo/dataAppr">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                   <xsl:value-of select="$i18n-Other_Forms_of_Data_Appraisal"/>
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/anlyInfo/dataAppr"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Space -->
          <fo:table-row height="5mm">
            <fo:table-cell number-columns-spanned="2">
              <fo:block/>
            </fo:table-cell>
          </fo:table-row>

          <!-- ============ -->
          <!-- Accesibility -->
          <!-- ============ -->
          <!-- heading (2 col) -->
          <xsl:if test="$show-accessibility = 'True'">
            <fo:table-row background-color="{$color-gray1}" keep-with-next="always">
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block id="accessibility" font-size="12pt" font-weight="bold">
                  <xsl:value-of select="$i18n-Accessibility"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Access Authority -->
          <xsl:if test="/codeBook/stdyDscr/dataAccs/useStmt/contact">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$i18n-Access_Authority"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/dataAccs/useStmt/contact"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Contacts -->
          <xsl:if test="/codeBook/stdyDscr/citation/distStmt/contact">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                   <xsl:value-of select="$i18n-Contacts"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/citation/distStmt/contact"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Distributors -->
          <xsl:if test="/codeBook/stdyDscr/citation/distStmt/distrbtr">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$i18n-Distributors"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/citation/distStmt/distrbtr"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Depositors (DDP) -->
          <xsl:if test="/codeBook/stdyDscr/citation/distStmt/depositr">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$i18n-Depositors"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/citation/distStmt/depositr"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Confidentiality -->
          <xsl:if test="/codeBook/stdyDscr/dataAccs/useStmt/confDec">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$i18n-Confidentiality"/>
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/dataAccs/useStmt/confDec"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Access Conditions -->
          <xsl:if test="/codeBook/stdyDscr/dataAccs/useStmt/conditions">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$i18n-Access_Conditions"/>
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/dataAccs/useStmt/conditions"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Citation Requierments -->
          <xsl:if test="/codeBook/stdyDscr/dataAccs/useStmt/citReq">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                   <xsl:value-of select="$i18n-Citation_Requirements"/>
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/dataAccs/useStmt/citReq"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Space -->
          <fo:table-row height="5mm">
            <fo:table-cell number-columns-spanned="2">
              <fo:block/>
            </fo:table-cell>
          </fo:table-row>

          <!-- ===================== -->
          <!-- Rights and Disclaimer -->
          <!-- ===================== -->
          <!-- heading (2 col) -->
          <xsl:if test="$show-rights-and-disclaimer = 'True'">
            <fo:table-row background-color="{$color-gray1}" keep-with-next="always">
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block id="rights-and-disclaimer" font-size="12pt" font-weight="bold">
                  <xsl:value-of select="$i18n-Rights_and_Disclaimer"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Disclaimer -->
          <xsl:if test="/codeBook/stdyDscr/dataAccs/useStmt/disclaimer">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$i18n-Disclaimer"/>
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/dataAccs/useStmt/disclaimer"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Copyright -->
          <xsl:if test="/codeBook/stdyDscr/citation/prodStmt/copyright">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$i18n-Copyright"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/citation/prodStmt/copyright"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

        </fo:table-body>
      </fo:table>
    </fo:flow>
  </fo:page-sequence>
</xsl:if>
    <!-- files_description.xsl --><!-- ============================= --><!-- <xsl:if> files description    --><!-- value: <fo:page-sequence>     --><!-- ============================= --><!-- read: --><!-- $page-layout, $strings, $font-family, $font-size, $header-font-size --><!-- functions --><!-- count() [xpath 1.0] --><xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" test="$show-files-description = 'True'" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="root_template_xincludes/page-sequence/files_description.xsl">

  <fo:page-sequence master-reference="{$page-layout}" font-family="{$font-family}" font-size="{$font-size}">

    <!-- =========================================== -->
    <!-- page header and footer                      -->
    <!-- =========================================== -->
    <xsl:call-template name="page_header">
      <xsl:with-param name="section_name" select="$i18n-Files_Description"/>
    </xsl:call-template>

    <xsl:call-template name="page_footer"/>

    <!-- =========================================== -->
    <!-- page content                                -->
    <!-- =========================================== -->
    <fo:flow flow-name="body">

      <!-- heading -->
      <fo:block id="files-description" font-size="18pt" font-weight="bold" space-after="2.5mm">
        <xsl:value-of select="$i18n-Files_Description"/>
      </fo:block>

      <!-- number of files in data set -->
      <fo:block font-weight="bold">
        <xsl:value-of select="string-join(($i18n-Dataset_contains, ' ', xs:string(count(/codeBook/fileDscr)), ' ', $i18n-files), '') "/>
      </fo:block>

      <!-- fileDscr -->
      <xsl:apply-templates select="/codeBook/fileDscr"/>

    </fo:flow>
  </fo:page-sequence>
</xsl:if>
    <!-- variables_list.xsl --><!-- ===================================== --><!-- <xsl:if> variables list               --><!-- value: <fo:page-sequence>             --><!-- ===================================== --><!-- read: --><!-- $strings, $show-variables-list-layout, $font-family --><!-- functions: --><!-- count() [Xpath 1.0] --><xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" test="$show-variables-list = 'True'" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="root_template_xincludes/page-sequence/variables_list.xsl">

  <fo:page-sequence master-reference="{$page-layout}" font-family="{$font-family}" font-size="{$font-size}">

    <!-- =========================================== -->
    <!-- page header                                 -->
    <!-- =========================================== -->
    <xsl:call-template name="page_header">
      <xsl:with-param name="section_name" select="$i18n-Variables_List"/>
    </xsl:call-template>

    <xsl:call-template name="page_footer"/>

    <!-- =========================================== -->
    <!-- page content                                -->
    <!-- =========================================== -->
    <fo:flow flow-name="body">

      <!-- Heading -->
      <fo:block id="variables-list" font-size="18pt" font-weight="bold" space-after="2.5mm">
        <xsl:value-of select="$i18n-Variables_List"/>
      </fo:block>

      <!-- number of groups in data set -->
      <!-- <fo:block font-weight="bold">
        <xsl:value-of select="$i18n-Dataset_contains" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="count(/codeBook/dataDscr/var)" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="$i18n-variables" />
      </fo:block> -->
      
      <fo:block font-weight="bold">
        <xsl:value-of select="string-join(($i18n-Dataset_contains, ' ', xs:string(count(/codeBook/dataDscr/var)), ' ', $i18n-variables), '') "/>       
      </fo:block>

      <!-- the actual tables -->
      <xsl:apply-templates select="/codeBook/fileDscr" mode="variables-list"/>

    </fo:flow>
  </fo:page-sequence>
</xsl:if>
    <!-- variable_groups.xsl --><!-- ================================================ --><!-- <xsl:if> variable groups                         --><!-- value: <fo:page-sequence>                        --><!-- ================================================ --><!-- read: --><!-- $font-family, $number-of-groups --><!-- functions: --><!-- string-length(), count() [xpath 1.0] --><xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" test="$show-variable-groups = 'True'" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="root_template_xincludes/page-sequence/variable_groups.xsl">

  <fo:page-sequence master-reference="{$page-layout}" font-family="{$font-family}" font-size="{$font-size}">
    
    <!-- =========================================== -->
    <!-- page header and footer                      -->
    <!-- =========================================== -->
    <xsl:call-template name="page_header">
      <xsl:with-param name="section_name" select="$i18n-Variables_Groups"/>
    </xsl:call-template>
  
    <xsl:call-template name="page_footer"/>

    <!-- =========================================== -->
    <!-- page content                                 -->
    <!-- =========================================== -->    
    <fo:flow flow-name="body">

      <!-- heading -->
      <fo:block id="variables-groups" font-size="18pt" font-weight="bold" space-after="2.5mm">
        <xsl:value-of select="$i18n-Variables_Groups"/>
      </fo:block>

      <!-- number of variable groups in data set -->      
      <fo:block font-weight="bold">
        <xsl:value-of select="string-join(($i18n-Dataset_contains, ' ', xs:string(count(/codeBook/dataDscr/varGrp)), ' ', $i18n-groups), '') "/>       
      </fo:block>
      
      <!-- the actual variable groups table -->
      <xsl:apply-templates select="/codeBook/dataDscr/varGrp"/>

    </fo:flow>
  </fo:page-sequence>
</xsl:if>
    <!-- variables_description.xsl --><!-- ==================================================== --><!-- <xsl:if> variables description                       --><!-- value: <fo:page-sequence>                            --><!-- ==================================================== --><!-- read: --><!-- $font-family --><!-- functions: --><!-- count(), string-length() [Xpath 1.0] --><xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" test="$show-variables-description = 'True'" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="root_template_xincludes/page-sequence/variables_description.xsl">

  <fo:page-sequence master-reference="{$page-layout}" font-family="{$font-family}" font-size="{$font-size}">

    <!-- =========================================== -->
    <!-- page header                                 -->
    <!-- =========================================== -->
    <xsl:call-template name="page_header">
      <xsl:with-param name="section_name" select="$i18n-Variables_Description"/>
    </xsl:call-template>

    <xsl:call-template name="page_footer"/>

    <!-- =========================================== -->
    <!-- page content                                -->
    <!-- =========================================== -->
    <fo:flow flow-name="body">

      <!-- heading -->
      <fo:block id="variables-description" font-size="18pt" font-weight="bold" space-after="2.5mm">
        <xsl:value-of select="$i18n-Variables_Description"/>
      </fo:block>

      <!-- number of variables in data set -->
      <!-- <fo:block font-weight="bold">
        <xsl:value-of select="$i18n-Dataset_contains" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="count(/codeBook/dataDscr/var)" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="$i18n-variables" />
      </fo:block> -->

      <fo:block font-weight="bold">
        <xsl:value-of select="string-join(($i18n-Dataset_contains, ' ', xs:string(count(/codeBook/dataDscr/var)), ' ', $i18n-variables), '') "/>       
      </fo:block>

    </fo:flow>
  </fo:page-sequence>

  <!-- fileDscr -->
  <xsl:apply-templates select="/codeBook/fileDscr" mode="variables-description"/>
</xsl:if>

  </fo:root>

</xsl:template>
  <!-- AuthEntry.xsl --><!-- ========================= --><!-- match: AuthEnty       --><!-- value: <fo:block>         --><!-- ========================= --><!-- functions: --><!-- util:trim() [local] --><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="AuthEnty" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="templates/match/ddi/AuthEnty.xsl">

  <fo:block>
    <xsl:value-of select="util:trim(.)"/>    
    <xsl:value-of select="if (@affiliation) then @affiliation else () "/>
  </fo:block>

</xsl:template>
  <!-- collDate.xsl --><!-- ============================ --><!-- match: collDate              --><!-- value: <fo:block>            --><!-- ============================ --><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="collDate" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="templates/match/ddi/collDate.xsl">

    <fo:block>

      <!-- cycle -->
      <!-- <xsl:if test="@cycle">
        <xsl:value-of select="@cycle"/>
        <xsl:text>: </xsl:text>
      </xsl:if> -->
      
      <xsl:value-of select="if (@cycle) then string-join((@cycle, ': '), '') else () "/>

      <!-- event -->
      <!-- <xsl:if test="@event">
        <xsl:value-of select="@event"/>
        <xsl:text> </xsl:text>
      </xsl:if> -->
      
      <xsl:value-of select="if (@event) then string-join((@event, ' '), '') else () "/>

      <!-- date -->
      <xsl:value-of select="@date"/>

    </fo:block>

</xsl:template>
  <!-- contact.xsl --><!-- ========================= --><!-- match: contact            --><!-- value: <fo:block>         --><!-- ========================= --><!-- functions: --><!-- url() [FO] --><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="contact" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="templates/match/ddi/contact.xsl">

    <fo:block>

      <xsl:value-of select="."/>

      <!-- affiliation -->
      <!-- <xsl:if test="@affiliation">
        <xsl:text>(</xsl:text>
        <xsl:value-of select="@affiliation"/>
        <xsl:text>)</xsl:text>
      </xsl:if> -->
      
      <xsl:value-of select="if (@affiliation) then                               string-join(('(', @affiliation, ')'), '')                             else () "/>

      <!-- URI -->
      <xsl:if test="@URI"> ,
        <fo:basic-link external-destination="url('{@URI}')" text-decoration="underline" color="blue">
          <xsl:value-of select="@URI"/>
        </fo:basic-link>
      </xsl:if>

      <!-- email -->
      <xsl:if test="@email"> ,
        <fo:basic-link external-destination="url('mailto:{@URI}')" text-decoration="underline" color="blue">
          <xsl:value-of select="@email"/>
        </fo:basic-link>
      </xsl:if>

    </fo:block>

</xsl:template>
  <!-- dataCollector.xsl --><!-- ============================== --><!-- match: dataCollector           --><!-- value: <fo:block>              --><!-- ============================== --><!-- functions: --><!-- util:trim() [local] --><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="dataCollector" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="templates/match/ddi/dataCollector.xsl">

  <fo:block>  
    <xsl:value-of select="util:trim(.)"/>

    <!-- abbr -->
    <!-- <xsl:if test="@abbr">
      <xsl:text>(</xsl:text>
      <xsl:value-of select="@abbr"/>
      <xsl:text>)</xsl:text>
    </xsl:if> -->

    <xsl:value-of select="if (@abbr) then                             string-join(('(', @abbr, ')'), '')                           else () "/>

    <!-- affiliation -->
    <!-- <xsl:if test="@affiliation"> ,
      <xsl:value-of select="@affiliation" />
    </xsl:if> -->

    <xsl:value-of select="if (@affiliation) then @affiliation else () "/>

  </fo:block>

</xsl:template>
  <!-- fileDscr.xsl --><!-- =========================== --><!-- match: fileDsrc             --><!-- value: <fo:table>           --><!-- =========================== --><!-- read: --><!-- $color-gray1, $default-border, $cell-padding --><!-- set: --><!-- $fileId, $list --><!-- functions: --><!-- concat(), contains(), normalize-space(), position() [Xpath 1.0] --><!-- proportional-column-width() [FO] --><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="fileDscr" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="templates/match/ddi/fileDscr.xsl"> 

    <!-- ===================== -->
    <!-- variables             -->
    <!-- ===================== -->
    <!-- <xsl:variable name="fileId">
      <xsl:choose>

        <xsl:when test="fileTxt/fileName/@ID">
          <xsl:value-of select="fileTxt/fileName/@ID"/>
        </xsl:when>

        <xsl:when test="@ID">
          <xsl:value-of select="@ID"/>
        </xsl:when>

      </xsl:choose>
    </xsl:variable> -->

    <xsl:variable name="fileId" select="if (fileTxt/fileName/@ID) then                 fileTxt/fileName/@ID               else if (@ID) then                 @ID               else () "/>

    <!-- =================== -->
    <!-- content             -->
    <!-- =================== -->
    <fo:table id="file-{$fileId}" table-layout="fixed" width="100%" space-before="5mm" space-after="5mm">
      <fo:table-column column-width="proportional-column-width(20)"/>
      <fo:table-column column-width="proportional-column-width(80)"/>

      <fo:table-body>

        <!-- Filename -->
        <fo:table-row background-color="{$color-gray1}" keep-with-next="always">
          <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
            <fo:block font-size="12pt" font-weight="bold">
              <xsl:apply-templates select="fileTxt/fileName"/>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>

        <!-- Cases -->
        <xsl:if test="fileTxt/dimensns/caseQnty">
          <fo:table-row>
            <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
              <fo:block>
                <xsl:value-of select="$i18n-Cases"/>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
              <xsl:apply-templates select="fileTxt/dimensns/caseQnty"/>
            </fo:table-cell>
          </fo:table-row>
        </xsl:if>

        <!-- Variables -->
        <xsl:if test="fileTxt/dimensns/varQnty">
          <fo:table-row>
            <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
              <fo:block>
                <xsl:value-of select="$i18n-Variables"/>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
              <xsl:apply-templates select="fileTxt/dimensns/varQnty"/>
            </fo:table-cell>
          </fo:table-row>
        </xsl:if>

        <!-- File structure -->
        <xsl:if test="fileTxt/fileStrc">
          <fo:table-row>

            <!-- 4.1) File_Structure -->
            <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
              <fo:block>
                <xsl:value-of select="$i18n-File_Structure"/>
              </fo:block>
            </fo:table-cell>

            <!-- 4.2) Type -->
            <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
              <xsl:if test="fileTxt/fileStrc/@type">
                <fo:block>
                  <xsl:value-of select="$i18n-Type"/>
                  <xsl:text>:</xsl:text>
                  <xsl:value-of select="fileTxt/fileStrc/@type"/>
                </fo:block>
              </xsl:if>

              <xsl:if test="fileTxt/fileStrc/recGrp/@keyvar">
                <fo:block>
                  <xsl:value-of select="$i18n-Keys"/>
                  <xsl:text>: </xsl:text>
                  <xsl:variable name="list" select="concat(fileTxt/fileStrc/recGrp/@keyvar,' ')"/>

                  <!-- add a space at the end of the list for matching puspose -->
                  <xsl:for-each select="/codeBook/dataDscr/var[contains($list, concat(@ID,' '))]">
                    <!-- add a space to the variable ID to avoid partial match -->
                    <xsl:if test="position() &gt; 1">
                      <xsl:text>, </xsl:text>
                    </xsl:if>
                    <xsl:value-of select="./@name"/>
                    <xsl:if test="normalize-space(./labl)">
											<xsl:text> (</xsl:text>
                      <xsl:value-of select="normalize-space(./labl)"/>
                      <xsl:text>)</xsl:text>
                    </xsl:if>
                  </xsl:for-each>
                </fo:block>
              </xsl:if>

            </fo:table-cell>
          </fo:table-row>
        </xsl:if>

        <!-- File Content -->
        <xsl:for-each select="fileTxt/fileCont">
          <fo:table-row>
            <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
              <fo:block font-weight="bold" text-decoration="underline">
                <xsl:value-of select="$i18n-File_Content"/>
              </fo:block>
              <xsl:apply-templates select="."/>
            </fo:table-cell>
          </fo:table-row>
        </xsl:for-each>

        <!-- Producer -->
        <xsl:for-each select="fileTxt/filePlac">
          <fo:table-row>
            <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
              <fo:block font-weight="bold" text-decoration="underline">
                <xsl:value-of select="$i18n-Producer"/>
              </fo:block>
              <xsl:apply-templates select="."/>
            </fo:table-cell>
          </fo:table-row>
        </xsl:for-each>

        <!-- Version -->
        <xsl:for-each select="fileTxt/verStmt">
          <fo:table-row>
            <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
              <fo:block font-weight="bold" text-decoration="underline">
                 <xsl:value-of select="$i18n-Version"/>
              </fo:block>
              <xsl:apply-templates select="."/>
            </fo:table-cell>
          </fo:table-row>
        </xsl:for-each>

        <!-- Processing Checks -->
        <xsl:for-each select="fileTxt/dataChck">
          <fo:table-row>
            <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
              <fo:block font-weight="bold" text-decoration="underline">
                <xsl:value-of select="$i18n-Processing_Checks"/>
              </fo:block>
              <xsl:apply-templates select="."/>
            </fo:table-cell>
          </fo:table-row>
        </xsl:for-each>

        <!-- Missing Data -->
        <xsl:for-each select="fileTxt/dataMsng">
          <fo:table-row>
            <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
              <fo:block font-weight="bold" text-decoration="underline">
                <xsl:value-of select="$i18n-Missing_Data"/>
              </fo:block>
              <xsl:apply-templates select="."/>
            </fo:table-cell>
          </fo:table-row>
        </xsl:for-each>

        <!-- Notes -->
        <xsl:for-each select="notes">
          <fo:table-row>
            <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
              <fo:block font-weight="bold" text-decoration="underline">
                <xsl:value-of select="$i18n-Notes"/>
              </fo:block>
              <xsl:apply-templates select="."/>
            </fo:table-cell>
          </fo:table-row>
        </xsl:for-each>

      </fo:table-body>
    </fo:table>

</xsl:template>
  <!-- fileDscr-variables_description.xsl --><!-- =========================================== --><!-- match: fileDsrc (variables-description)     --><!-- value: <xsl:for-each> <fo:page-sequence>    --><!-- =========================================== --><!-- read: --><!-- $strings, $chunk-size, $font-family, $default-border --><!-- set: --><!-- $fileId, $fileName --><!-- functions: --><!-- position() [xpath 1.0] --><!-- proportional-column-width() [fo] --><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="fileDscr" mode="variables-description" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="templates/match/ddi/fileDscr_variables-description.xsl">
  
  <!-- ================== -->
  <!-- variables          -->
  <!-- ================== -->
  
  <!-- fileName ID attribute / ID attribute -->
  <!-- <xsl:variable name="fileId">
    <xsl:choose>
      <xsl:when test="fileTxt/fileName/@ID">
        <xsl:value-of select="fileTxt/fileName/@ID"/>
      </xsl:when>
      <xsl:when test="@ID">
        <xsl:value-of select="@ID"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable> -->
  
  <xsl:variable name="fileId" select="if (fileTxt/fileName/@ID) then               fileTxt/fileName/@ID             else if (@ID) then               @ID             else () "/>
  
  <xsl:variable name="fileName" select="fileTxt/fileName"/>
  
  <!-- ===================== -->
  <!-- content               -->
  <!-- ===================== -->
  
  <xsl:for-each select="/codeBook/dataDscr/var[@files=$fileId][position() mod $chunk-size = 1]">
    
    <fo:page-sequence master-reference="{$page-layout}" font-family="{$font-family}" font-size="{$font-size}">
      
      <!-- =========== -->
      <!-- page footer -->
      <!-- =========== -->
      <xsl:call-template name="page_footer"/>
      
      <!-- =========== -->
      <!-- page body   -->
      <!-- =========== -->
      <fo:flow flow-name="body">
        
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
                    <xsl:value-of select="$i18n-File"/>
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
              <xsl:apply-templates select=".|following-sibling::var[@files=$fileId][$chunk-size &gt; position()]"/>
            </fo:table-body>
            
          </fo:table>
        </xsl:if>
        
        <!-- [fo:table] Variables -->
        <xsl:if test="position() &gt; 1">
          <fo:table table-layout="fixed" width="100%" font-size="8pt">
            <fo:table-body>
              <!-- needed in case of subset -->
              <fo:table-row>
                <fo:table-cell>
                  <fo:block/>
                </fo:table-cell>
              </fo:table-row>
              <xsl:apply-templates select=".|following-sibling::var[@files=$fileId][$chunk-size &gt; position()]"/>
            </fo:table-body>
          </fo:table>
        </xsl:if>
        
      </fo:flow>
    </fo:page-sequence>
  </xsl:for-each>
  
</xsl:template>
  <!-- fileDscr_variables-list.xsl --><!-- ===================================== --><!-- match: fileDsrc (variables-list)      --><!-- Value: <fo:table>                     --><!-- ===================================== --><!-- read: --><!-- $strings, $default-border, $cell-padding --><!-- set: --><!-- $fileId --><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="fileDscr" mode="variables-list" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="templates/match/ddi/fileDscr_variables-list.xsl">

  <!-- variables -->
  <xsl:variable name="fileId" select="if (fileTxt/fileName/@ID) then               fileTxt/fileName/@ID             else if (@ID) then               @ID             else () "/>

  <!-- content -->
  <fo:table id="varlist-{fileTxt/fileName/@ID}" table-layout="fixed" width="100%" font-size="8pt" space-before="5mm" space-after="5mm">

    <fo:table-column column-width="proportional-column-width( 5)"/>
    <fo:table-column column-width="proportional-column-width(12)"/>
    <fo:table-column column-width="proportional-column-width(20)"/>
    <fo:table-column column-width="proportional-column-width(27)"/>
 
    <!-- =========================== -->
    <!-- variables list table header -->
    <!-- =========================== -->
    <fo:table-header>
      <fo:table-row text-align="center" vertical-align="top" keep-with-next="always">
        <fo:table-cell text-align="left" number-columns-spanned="4" border="{$default-border}" padding="{$cell-padding}">
          <fo:block font-size="12pt" font-weight="bold">
            <xsl:value-of select="$strings/*/entry[@key='File']"/>
            <xsl:text> </xsl:text>
            <xsl:apply-templates select="fileTxt/fileName"/>
          </fo:block>
        </fo:table-cell>
      </fo:table-row>

      <fo:table-row text-align="center" vertical-align="top" font-weight="bold" keep-with-next="always">

        <!-- #-character -->
        <fo:table-cell border="0.5pt solid black" padding="3pt">
          <fo:block>#</fo:block>
        </fo:table-cell>

        <!-- Name -->
        <fo:table-cell border="0.5pt solid black" padding="3pt">
          <fo:block>
            <xsl:value-of select="$strings/*/entry[@key='Name']"/>
          </fo:block>
        </fo:table-cell>

        <!-- Label -->
        <fo:table-cell border="0.5pt solid black" padding="3pt">
          <fo:block>
            <xsl:value-of select="$strings/*/entry[@key='Label']"/>
          </fo:block>
        </fo:table-cell>

        <!-- Question -->
        <fo:table-cell border="0.5pt solid black" padding="3pt">
          <fo:block>
            <xsl:value-of select="$strings/*/entry[@key='Question']"/>
          </fo:block>
        </fo:table-cell>
      
      </fo:table-row>
    </fo:table-header>

    <!-- ========================= -->
    <!-- variables list table body -->
    <!-- ========================= -->
    <fo:table-body>
      <xsl:apply-templates select="/codeBook/dataDscr/var[@files=$fileId]" mode="variables-list"/>
    </fo:table-body>

  </fo:table>

</xsl:template>
  <!-- fileName.xsl --><!-- ===================== --><!-- match: fileName       --><!-- value: string         --><!-- ===================== --><!-- set: --><!-- $filename --><!-- functions: --><!-- contains(), normalize-space(), string-length(), substring() [xpath 1.0] --><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="fileName" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="templates/match/ddi/fileName.xsl">

  <!-- variables -->
  <xsl:variable name="filename" select="normalize-space(.)"/>

  <!-- content -->
  <xsl:value-of select="if (contains($filename, '.NSDstat')) then                           (: filename contains string '.NSDstat' :)                           substring($filename, 1, string-length($filename) - 8)                         else                           (: filename does not contain '.NSDstat':)                           $filename "/>

</xsl:template>
  <!-- fundAg.xsl --><!-- ========================== --><!-- match: fundAg          --><!-- value: <fo:block>          --><!-- ========================== --><!-- functions: --><!-- util:trim() [local] --><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="fundAg" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="templates/match/ddi/fundAg.xsl">

  <fo:block>
    
    <xsl:value-of select="util:trim(.)"/>

    <!-- @abbr -->
    <xsl:if test="@abbr">
      <xsl:text>(</xsl:text>
      <xsl:value-of select="@abbr"/>
      <xsl:text>)</xsl:text>
    </xsl:if>

    <!-- @role -->
    <xsl:if test="@role">
      <xsl:text> ,</xsl:text>
      <xsl:value-of select="@role"/>
    </xsl:if>

  </fo:block>

</xsl:template>
  <!-- IDNo.xsl --><!-- ==================== --><!-- match: IDNo          --><!-- value: <fo:block>    --><!-- ==================== --><!-- functions: --><!-- util:trim() --><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="IDNo" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="templates/match/ddi/IDNo.xsl">
  
  <fo:block>
    
    <!-- agency -->    
    <xsl:value-of select="if (@agency) then                             @agency                           else () "/>
    
    <xsl:value-of select="util:trim(.)"/>
    
  </fo:block>
  
</xsl:template>
  <!-- othId.xsl --><!-- =================== --><!-- match: othId        --><!-- value: <fo:block>   --><!-- =================== --><!-- called: --><!-- trim --><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="othId" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="templates/match/ddi/othId.xsl">

  <fo:block>
    
    <xsl:value-of select="util:trim(ddi:p)"/>

    <!-- role -->
    <xsl:if test="@role"> ,
      <xsl:value-of select="@role"/>
    </xsl:if>

    <!-- affiliation -->
    <xsl:if test="@affiliation"> ,
      <xsl:value-of select="@affiliation"/>
    </xsl:if>

  </fo:block>

</xsl:template>
  <!-- producer.xsl --><!-- ========================== --><!-- match: producer            --><!-- value: <fo:block>          --><!-- ========================== --><!-- called: --><!-- trim --><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="producer" xml:base="templates/match/ddi/producer.xsl">

  <fo:block>
    
    <xsl:value-of select="util:trim(.)"/>

    <!-- abbreviation -->
    <xsl:if test="@abbr">
      (<xsl:value-of select="@abbr"/>)
    </xsl:if>

    <!-- affiliation -->
    <xsl:if test="@affiliation"> ,
      <xsl:value-of select="@affiliation"/>
    </xsl:if>

    <!-- role -->
    <xsl:if test="@role"> ,
      <xsl:value-of select="@role"/>
    </xsl:if>

  </fo:block>
</xsl:template>
  <!-- timePrd.xsl --><!-- ======================== --><!-- match: timePrd           --><!-- value: <fo:block>        --><!-- ======================== --><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="timePrd" xml:base="templates/match/ddi/timePrd.xsl">

  <fo:block>

      <!-- cycle -->
      <xsl:if test="@cycle">
        <xsl:value-of select="@cycle"/>
        <xsl:text>: </xsl:text>
      </xsl:if>

      <!-- event -->
      <xsl:if test="@event">
        <xsl:value-of select="@event"/>
        <xsl:text> </xsl:text>
      </xsl:if>

      <!-- date -->
      <xsl:value-of select="@date"/>

  </fo:block>
</xsl:template>
  <!-- var.xsl --><!-- ================================== --><!-- match: var                         --><!-- value: <xsl:if> <fo:table-row>     --><!-- ================================== --><!-- read: --><!-- $cell-padding, $color-gray1, $default-border, --><!-- $show-variables-description-categories-max --><!-- set: --><!-- $statistics, $type, $label, $category-count, $is-weighted,  --><!-- $catgry-freq-nodes, $catgry-sum-freq, $catgry-sum-freq-wgtd,--><!-- $catgry-max-freq, $catgry-max-freq-wgtd, --><!-- $bar-column-width, $catgry-freq --><!-- functions: --><!-- concat(), contains(), string-length(), normalize-space(), --><!-- number(), position(), string() [Xpath 1.0] --><!-- util:trim(), util:math_max() [local] --><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="var" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="templates/match/ddi/var.xsl">
  
  <fo:table-row text-align="center" vertical-align="top">
    <fo:table-cell>
      <fo:table id="var-{@ID}" table-layout="fixed" width="100%" font-size="8pt" space-after="7.5mm">
        <fo:table-column column-width="proportional-column-width(20)"/>
        <fo:table-column column-width="proportional-column-width(80)"/>
        
        <!-- ============ -->
        <!-- table Header -->
        <!-- ============ -->
        <fo:table-header>
          <fo:table-row background-color="{$color-gray1}" text-align="center" vertical-align="top">
            <fo:table-cell number-columns-spanned="2" font-size="10pt" font-weight="bold" text-align="left" border="{$default-border}" padding="{$cell-padding}">
              <fo:block>
                <fo:inline font-size="8pt" font-weight="normal" vertical-align="text-top">
                  <xsl:text>#</xsl:text>
                  <xsl:value-of select="./@id"/>
                  <xsl:text> </xsl:text>
                </fo:inline>
                
                <xsl:value-of select="./@name"/>
                
                <xsl:if test="normalize-space(./labl)">
                  <xsl:text>: </xsl:text>
                  <xsl:value-of select="normalize-space(./labl)"/>
                </xsl:if>
                
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-header>
        
        <!-- ================================================== -->
        <!-- Main table body - body of the variable description -->
        <!-- ================================================== -->
        <fo:table-body>
          
          <!-- Definition  -->
          <xsl:if test="normalize-space(./txt)">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold">
                  <xsl:value-of select="$i18n-Definition"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:apply-templates select="./txt"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Universe  -->
          <xsl:if test="normalize-space(./universe)">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold">
                  <xsl:value-of select="$i18n-Universe"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:apply-templates select="./universe"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Source -->
          <xsl:if test="normalize-space(./respUnit)">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold">
                  <xsl:value-of select="$i18n-Source"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:apply-templates select="./respUnit"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Pre-Question -->
          <xsl:if test="normalize-space(./qstn/preQTxt)">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold">
                  <xsl:value-of select="$i18n-Pre-question"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:apply-templates select="./qstn/preQTxt"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Literal_Question -->
          <xsl:if test="normalize-space(./qstn/qstnLit)">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold">
                  <xsl:value-of select="$i18n-Literal_question"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:apply-templates select="./qstn/qstnLit"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Post-question -->
          <xsl:if test="normalize-space(./qstn/postQTxt)">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold">
                  <xsl:value-of select="$i18n-Post-question"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:apply-templates select="./qstn/postQTxt"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Interviewer_instructions -->
          <xsl:if test="normalize-space(./qstn/ivuInstr)">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold">
                  <xsl:value-of select="$i18n-Interviewers_instructions"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:apply-templates select="./qstn/ivuInstr"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Imputation -->
          <xsl:if test="normalize-space(./imputation)">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold">
                  <xsl:value-of select="$i18n-Imputation"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:apply-templates select="./imputation"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Recoding_and_Derivation -->
          <xsl:if test="normalize-space(./codInstr)">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold">
                  <xsl:value-of select="$i18n-Recoding_and_Derivation"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:apply-templates select="./codInstr"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Security -->
          <xsl:if test="normalize-space(./security)">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold">
                  <xsl:value-of select="$i18n-Security"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:apply-templates select="./security"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Concepts -->
          <xsl:if test="normalize-space(./concept)">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold">
                  <xsl:value-of select="$i18n-Concepts"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:for-each select="./concept">
                    <xsl:if test="position() &gt; 1">
                      <xsl:text>, </xsl:text>
                    </xsl:if>
                    <xsl:value-of select="normalize-space(.)"/>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Notes -->
          <xsl:if test="normalize-space(./notes)">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold">
                  <xsl:value-of select="$i18n-Notes"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:apply-templates select="./notes"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- ========================== -->
          <!-- Variable contents and bars -->
          <!-- ========================== -->
                    
          <xsl:if test="$show-variables-description-categories = 'True'             and normalize-space(./catgry[1])">

            <xsl:variable name="category-count" select="count(catgry)"/>
            
            <fo:table-row text-align="center" vertical-align="top">
              <xsl:choose>
                
                <!-- ================== -->
                <!-- Case 1)            -->
                <!-- ================== -->
                <xsl:when test="number($show-variables-description-categories-max) &gt;= $category-count">
                  <fo:table-cell text-align="left" border="{$default-border}" number-columns-spanned="2" padding="{$cell-padding}">
                    
                    <!-- Variables -->
                    <xsl:variable name="is-weighted" select="count(catgry/catStat[@type='freq' and @wgtd='wgtd' ]) &gt; 0"/>
                    <xsl:variable name="catgry-freq-nodes" select="catgry[not(@missing='Y')]/catStat[@type='freq']"/>
                    <xsl:variable name="catgry-sum-freq" select="sum($catgry-freq-nodes[ not(@wgtd='wgtd') ])"/>
                    <xsl:variable name="catgry-sum-freq-wgtd" select="sum($catgry-freq-nodes[ @wgtd='wgtd'])"/>
                    
                    <xsl:variable name="catgry-max-freq">
                      <xsl:value-of select="util:math_max($catgry-freq-nodes[ not(@wgtd='wgtd') ])"/>
                    </xsl:variable>
                    
                    <xsl:variable name="catgry-max-freq-wgtd">
                      <xsl:value-of select="util:math_max($catgry-freq-nodes[@type='freq' and @wgtd='wgtd' ])"/>
                    </xsl:variable>
                    
                    <!-- Render table -->
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
                      
                      <!-- table header -->
                      <fo:table-header>
                        <fo:table-row background-color="{$color-gray1}" text-align="left" vertical-align="top">
                          <fo:table-cell border="0.5pt solid white" padding="{$cell-padding}">
                            <fo:block font-weight="bold">
                              <xsl:value-of select="$i18n-Value"/>
                            </fo:block>
                          </fo:table-cell>
                          <fo:table-cell border="0.5pt solid white" padding="{$cell-padding}">
                            <fo:block font-weight="bold">
                              <xsl:value-of select="$i18n-Label"/>
                            </fo:block>
                          </fo:table-cell>
                          <fo:table-cell border="0.4pt solid white" padding="{$cell-padding}" text-align="center">
                            <fo:block font-weight="bold">
                              <xsl:value-of select="$i18n-Cases_Abbreviation"/>
                            </fo:block>
                          </fo:table-cell>
                          <xsl:if test="$is-weighted">
                            <fo:table-cell border="0.4pt solid white" padding="{$cell-padding}" text-align="center">
                              <fo:block font-weight="bold">
                                <xsl:value-of select="$i18n-Weighted"/>
                              </fo:block>
                            </fo:table-cell>
                          </xsl:if>
                          <fo:table-cell border="0.4pt solid white" padding="{$cell-padding}" text-align="center">
                            <fo:block font-weight="bold">
                              <xsl:value-of select="$i18n-Percentage"/>
                              <xsl:if test="$is-weighted">
                                <xsl:text>(</xsl:text>
                                <xsl:value-of select="$i18n-Weighted"/>
                                <xsl:text>)</xsl:text>
                              </xsl:if>
                            </fo:block>
                          </fo:table-cell>
                        </fo:table-row>
                      </fo:table-header>
                      
                      <!-- table body -->
                      <fo:table-body>
                        <xsl:for-each select="catgry">
                          <fo:table-row background-color="{$color-gray2}" text-align="center" vertical-align="top">
                            
                            <!-- catValue -->
                            <fo:table-cell text-align="left" border="0.5pt solid white" padding="2pt">
                              <fo:block>                                  
                                <xsl:value-of select="util:trim(catValu)"/>
                              </fo:block>
                            </fo:table-cell>
                            
                            <!-- Label -->
                            <fo:table-cell text-align="left" border="0.5pt solid white" padding="2pt">
                              <fo:block>                                
                                <xsl:value-of select="util:trim(labl)"/>
                              </fo:block>
                            </fo:table-cell>
                            
                            <!-- Frequency -->
                            <xsl:variable name="catgry-freq" select="catStat[@type='freq' and not(@wgtd='wgtd') ]"/>
                            <fo:table-cell text-align="center" border="0.5pt solid white" padding="2pt">
                              <fo:block>                                
                                <xsl:value-of select="util:trim(catStat)"/>
                              </fo:block>
                            </fo:table-cell>
                            
                            <!-- Weighted frequency -->
                            <xsl:variable name="catgry-freq-wgtd" select="catStat[@type='freq' and @wgtd='wgtd' ]"/>
                            <xsl:if test="$is-weighted">
                              <fo:table-cell text-align="center" border="0.5pt solid white" padding="2pt">
                                <fo:block>
                                  <xsl:value-of select="util:trim(format-number($catgry-freq-wgtd, '0.0'))"/>
                                </fo:block>
                              </fo:table-cell>
                            </xsl:if>
                            
                            <!-- ============== -->
                            <!-- Percentage Bar -->
                            <!-- ============== -->
                            
                            <!-- compute percentage -->                            
                            <xsl:variable name="catgry-pct" select="if ($is-weighted) then                                          $catgry-freq-wgtd div $catgry-sum-freq-wgtd                                       else                                         $catgry-freq div $catgry-sum-freq "/>
                            
                            <!-- compute bar width (percentage of highest value minus --> 
                            <!-- some space to display the percentage value) -->                            
                            <xsl:variable name="tmp-col-width-1" select="if ($is-weighted) then                                         ($catgry-freq-wgtd div $catgry-max-freq-wgtd) * ($bar-column-width - 0.5)                                       else                                         ($catgry-freq div $catgry-max-freq) * ($bar-column-width - 0.5) "/>
                                                                                   
                            <xsl:variable name="col-width-1" select="if (string(number($tmp-col-width-1)) != 'NaN') then                                         $tmp-col-width-1                                       else                                         0 "/>

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
                      </fo:table-body>
                    </fo:table>
                    
                    <!-- Warning about summary of statistics? -->
                    <fo:block font-weight="bold" color="#400000" font-size="6pt" font-style="italic">
                      <xsl:value-of select="$i18n-SumStat_Warning"/>
                    </fo:block>
                    
                  </fo:table-cell>
                </xsl:when>
                
                <!-- =================================== -->
                <!-- Case 2) Frequence_table_not_shown   -->
                <!-- =================================== -->
                <xsl:otherwise>
                  <fo:table-cell background-color="{$color-gray1}" text-align="center" font-style="italic" border="{$default-border}" number-columns-spanned="2" padding="{$cell-padding}">
                    <fo:block>
                      <xsl:value-of select="$i18n-Frequency_table_not_shown"/>
                      <xsl:text> (</xsl:text>
                      <xsl:value-of select="$category-count"/>
                      <xsl:text> </xsl:text>
                      <xsl:value-of select="$i18n-Modalities"/>
                      <xsl:text>)</xsl:text>
                    </fo:block>
                  </fo:table-cell>
                </xsl:otherwise>
                
              </xsl:choose>
            </fo:table-row>
          </xsl:if>
                    
          <!-- ============================================= -->
          <!-- Variable related information and descriptions -->
          <!-- ============================================= -->
          
          <!-- Information -->
          <fo:table-row text-align="center" vertical-align="top">
            
            <fo:table-cell font-weight="bold" text-align="left" border="{$default-border}" padding="{$cell-padding}">
              <fo:block>
                <xsl:value-of select="$i18n-Information"/>
              </fo:block>
            </fo:table-cell>
            
            <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
              <fo:block>
                
                <!-- Information: Type -->
                <xsl:if test="normalize-space(@intrvl)">
                  <xsl:text> [</xsl:text>
                  <xsl:value-of select="$i18n-Type"/>
                  <xsl:text>: </xsl:text>

                  <xsl:value-of select="if (@intrvl='discrete') then                                           $i18n-discrete                                         else if (@intrvl='contin') then                                           $i18n-continuous                                          else () "/>

                  <xsl:text>] </xsl:text>
                </xsl:if>
                
                <!-- Information: Format -->
                <xsl:for-each select="varFormat">
                  <xsl:text> [</xsl:text>
                  <xsl:value-of select="$i18n-Format"/>
                  <xsl:text>: </xsl:text>
                  <xsl:value-of select="@type"/>
                  <xsl:if test="normalize-space(location/@width)">
                    <xsl:text>-</xsl:text>
                    <xsl:value-of select="location/@width"/>
                  </xsl:if>
                  <xsl:if test="normalize-space(@dcml)">
                    <xsl:text>.</xsl:text>
                    <xsl:value-of select="@dcml"/>
                  </xsl:if>
                  <xsl:text>] </xsl:text>
                </xsl:for-each>
                
                <!-- Information: Range -->
                <xsl:for-each select="valrng/range">
                  <xsl:text> [</xsl:text>
                  <xsl:value-of select="$i18n-Range"/>
                  <xsl:text>: </xsl:text>
                  <xsl:value-of select="@min"/>-
                  <xsl:value-of select="@max"/>
                  <xsl:text>] </xsl:text>
                </xsl:for-each>
                
                <!-- Information: Missing -->
                <xsl:text> [</xsl:text>
                <xsl:value-of select="$i18n-Missing"/>
                <xsl:text>: *</xsl:text>
                <xsl:for-each select="invalrng/item">
                  <xsl:text>/</xsl:text>
                  <xsl:value-of select="@VALUE"/>
                </xsl:for-each>
                <xsl:text>] </xsl:text>
                
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
          
          <!-- Statistics -->
          <xsl:variable name="statistics" select="sumStat[contains('vald invd mean stdev',@type)]"/>
          <xsl:if test="$statistics">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell font-weight="bold" text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$i18n-Statistics"/>
                  <xsl:text> [</xsl:text>
                  <xsl:value-of select="$i18n-Abbrev_NotWeighted"/>
                  <xsl:text>/ </xsl:text>
                  <xsl:value-of select="$i18n-Abbrev_Weighted"/>
                  <xsl:text>]</xsl:text>
                </fo:block>
              </fo:table-cell>
              
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  
                  <!-- Summary statistics -->
                  <xsl:for-each select="$statistics[not(@wgtd)]">
                    <xsl:variable name="type" select="@type"/>
                    
                    <xsl:variable name="label" select="if (@type = 'vald') then                                 $i18n-Valid                               else if (@type = 'invd') then                                 $i18n-Invalid                               else if (@type = 'mean') then                                 $i18n-Mean                               else if (@type = 'stdev') then                                 $i18n-StdDev                               else                                 @type "/>

                    <xsl:text> [</xsl:text>
                    <xsl:value-of select="$label"/>
                    <xsl:text>: </xsl:text>
                    <xsl:value-of select="normalize-space(.)"/>
                    
                    <!-- Weighted value -->
                    <xsl:text> /</xsl:text>

                    <xsl:value-of select="if (following-sibling::sumStat[1]/@type=$type and following-sibling::sumStat[1]/@wgtd) then                                             following-sibling::sumStat[1]                                           else '-' "/>

                    <xsl:text>] </xsl:text>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
              
            </fo:table-row>
          </xsl:if>
          
          <!-- separate the individual variable tables to improve readability -->
          <fo:table-row height="0.2in">
            <fo:table-cell number-columns-spanned="2">
              <fo:block/>
            </fo:table-cell>
          </fo:table-row>
          
        </fo:table-body>
      </fo:table> <!-- end of variable table -->
      
    </fo:table-cell>
  </fo:table-row>
  
</xsl:template>
  <!-- var-variables_list.xsl --><!-- ================================== --><!-- match: var (variables-list)        --><!-- value: <xsl:if> <fo:table-row>     --><!-- ================================== --><!-- read: --><!-- $color-white, $default-border, $cell-padding, --><!-- $show-variables-list, $variable-name-length --><!-- functions: --><!-- concat(), contains(), count(), position(), normalize-space(), --><!-- string-length(), substring() [xpath 1.0] --><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="var" mode="variables-list" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="templates/match/ddi/var_variablesList.xsl">

    <!-- content -->
    <fo:table-row text-align="center" vertical-align="top">

      <!-- Variable Position -->
      <fo:table-cell text-align="center" border="{$default-border}" padding="{$cell-padding}">
        <fo:block>
          <xsl:value-of select="position()"/>
        </fo:block>
      </fo:table-cell>

      <!-- Variable Name-->
      <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
        <fo:block>
          <xsl:choose>
            <xsl:when test="$show-variables-list = 'True'">
              <fo:basic-link internal-destination="var-{@ID}" text-decoration="underline" color="blue">
                <xsl:if test="string-length(@name) &gt; 10">
                  <xsl:value-of select="substring(./@name, 0, $variable-name-length)"/> ..
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

      <!-- Variable Label -->
      <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
        <fo:block>
          <xsl:value-of select="if (normalize-space(./labl)) then                                   normalize-space(./labl)                                 else '-' "/>          
        </fo:block>
      </fo:table-cell>

      <!-- Variable literal question -->
      <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
        <fo:block>
          <xsl:value-of select="if (normalize-space(./qstn/qstnLit)) then                                   normalize-space(./qstn/qstnLit)                                 else '-' "/>
        </fo:block>
      </fo:table-cell>
        
    </fo:table-row>

</xsl:template>
  <!-- varGrp.xsl --><!-- ================================================== --><!-- match: varGrp                                      --><!-- value: <fo:table> + [<xsl:if> <fo:table>] --><!-- ================================================== --><!-- read --><!-- $default-border, $cell-padding --><!-- set --><!-- $list --><!-- functions --><!-- contains(), concat(), position(), string-length(), --><!-- normalize-space() [Xpath 1.0]                      --><!-- proportional-column-width() [fo]                   --><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="varGrp" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="templates/match/ddi/varGrp.xsl">
  
  <fo:table id="vargrp-{@ID}" table-layout="fixed" width="100%" space-before="5mm">
    <fo:table-column column-width="proportional-column-width(20)"/>
    <fo:table-column column-width="proportional-column-width(80)"/>
    
    <fo:table-body>
      
      <!-- Group -->
      <fo:table-row>
        <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
          <fo:block font-size="12pt" font-weight="bold">
            <xsl:value-of select="normalize-space(labl)"/>
          </fo:block>
        </fo:table-cell>
      </fo:table-row>
      
      <!-- Text -->
      <xsl:for-each select="txt">
        <fo:table-row>
          <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
            <xsl:apply-templates select="."/>
          </fo:table-cell>
        </fo:table-row>
      </xsl:for-each>
      
      <!-- Definition -->
      <xsl:for-each select="defntn">
        <fo:table-row>
          <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
            <fo:block font-weight="bold" text-decoration="underline">
              <xsl:value-of select="$i18n-Definition"/>
            </fo:block>
            <xsl:apply-templates select="."/>
          </fo:table-cell>
        </fo:table-row>
      </xsl:for-each>
      
      <!-- Universe-->
      <xsl:for-each select="universe">
        <fo:table-row>
          <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
            <fo:block font-weight="bold" text-decoration="underline">
              <xsl:value-of select="$i18n-Universe"/>
            </fo:block>
            <xsl:apply-templates select="."/>
          </fo:table-cell>
        </fo:table-row>
      </xsl:for-each>
      
      <!-- Notes -->
      <xsl:for-each select="notes">
        <fo:table-row>
          <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
            <fo:block font-weight="bold" text-decoration="underline">
              <xsl:value-of select="$i18n-Notes"/>
            </fo:block>
            <xsl:apply-templates select="."/>
          </fo:table-cell>
        </fo:table-row>
      </xsl:for-each>
      
      <!-- Subgroups -->
      <xsl:if test="./@varGrp">
        <fo:table-row>
          <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
            <fo:block>
              <xsl:value-of select="$i18n-Subgroups"/>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
            <fo:block>
              <!-- loop over groups in codeBook that are in this sequence -->
              <xsl:variable name="list" select="concat(./@varGrp,' ')"/>
              <!-- add a space at the end of the list for matching purposes -->
              <xsl:for-each select="/codeBook/dataDscr/varGrp[contains($list, concat(@ID,' '))]">
                <!-- add a space to the ID to avoid partial match -->
                <xsl:if test="position() &gt; 1">
                  <xsl:text>,</xsl:text>
                </xsl:if>
                <xsl:value-of select="./labl"/>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </xsl:if>
    </fo:table-body>
  </fo:table>
  
  <!-- ======================= -->
  <!-- Variables table         -->
  <!-- ======================= -->
  <xsl:if test="./@var"> <!-- Look for variables in this group -->
    <fo:table id="varlist-{@ID}" table-layout="fixed" width="100%" font-size="8pt" space-after="0.0mm">
      
      <fo:table-column column-width="proportional-column-width( 5)"/>
      <fo:table-column column-width="proportional-column-width(12)"/>
      <fo:table-column column-width="proportional-column-width(20)"/>
      <fo:table-column column-width="proportional-column-width(27)"/>
      
      <!-- ============ -->
      <!-- table header -->
      <!-- ============ -->
      <fo:table-header>
        <fo:table-row text-align="center" vertical-align="top" font-weight="bold" keep-with-next="always">
          
          <!-- #-character -->
          <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
            <fo:block>
              <xsl:text>#</xsl:text>
            </fo:block>
          </fo:table-cell>
          
          <!-- Name -->
          <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
            <fo:block>
              <xsl:value-of select="$i18n-Name"/>
            </fo:block>
          </fo:table-cell>
          
          <!-- Label -->
          <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
            <fo:block>
              <xsl:value-of select="$i18n-Label"/>
            </fo:block>
          </fo:table-cell>
          
          <!-- Question -->
          <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
            <fo:block>
              <xsl:value-of select="$i18n-Question"/>
            </fo:block>
          </fo:table-cell>         
          
        </fo:table-row>
      </fo:table-header>
      
      <!-- ========== -->
      <!-- table body -->
      <!-- ========== -->
      <fo:table-body>
        <xsl:variable name="list" select="concat(./@var,' ')"/>
        <xsl:apply-templates select="/codeBook/dataDscr/var[ contains($list, concat(@ID,' ')) ]" mode="variables-list"/>
      </fo:table-body>
    </fo:table>
    
  </xsl:if>

</xsl:template>
  <!-- ddi_default_text.xsl --><!-- ============================== --><!-- match: ddi:*|text()            --><!-- value: <fo:block>              --><!-- ============================== --><!-- set: --><!-- $trimmed --><!-- functions: --><!-- util:trim() [local] --><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="*|text()" xml:base="templates/match/default_text.xsl">
  
  <!-- <xsl:variable name="trimmed" select="util:trim(.)" /> -->

  <!-- content -->
  <fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0mm">
    <!-- <xsl:value-of select="$trimmed"/> -->
    <xsl:value-of select="util:trim(.)"/>
  </fo:block>

</xsl:template>

  <!-- =============== -->
  <!-- named templates -->
  <!-- =============== -->
  <!-- page_header.xsl --><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fo="http://www.w3.org/1999/XSL/Format" name="page_header" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="templates/named/page_header.xsl">
  
  <!-- ====== -->
  <!-- params -->
  <!-- ====== -->
  <xsl:param name="section_name"/>
  
  <!-- ======= -->
  <!-- content -->
  <!-- ======= -->  
  <fo:static-content flow-name="before">
    <fo:block font-size="{$header-font-size}" text-align="center">
      <xsl:value-of select="string-join((/codeBook/stdyDscr/citation/titlStmt/titl, ' - ', $section_name), '') "/>   
    </fo:block>
  </fo:static-content>  

</xsl:template>
  <!-- page_footer.xsl --><!-- ==================================================== --><!-- name: page_footer                                    --><!-- value: <fo:static-content>                           --><!-- ==================================================== --><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" name="page_footer" xml:base="templates/named/page_footer.xsl">
  
  <fo:static-content flow-name="after">
    <fo:block font-size="7" text-align="center" space-before="7.5mm">
      <xsl:text>- </xsl:text>
      <fo:page-number/>
      <xsl:text> -</xsl:text>
    </fo:block>
  </fo:static-content>
  
</xsl:template>
    
  <!-- ========= -->
  <!-- functions -->
  <!-- ========= -->
  <!-- util-isodate_month_name.xsl --><!-- ===================================== --><!-- xs:string util:isodate_month_name()   --><!-- param: xs:string isodate              --><!-- ===================================== --><!-- returns month name from a ISO-format date string --><!-- read: --><!-- $isodate [param] --><!-- set: --><!-- $month, $month_string --><!-- functions: --><!-- number(), substring(), contains() [Xpath 1.0] --><xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="util:isodate_month_name" as="xs:string" xml:base="functions/util/isodate_month_name.xsl">

  <!-- ========= -->
  <!-- params    -->
  <!-- ========= -->
  <xsl:param name="isodate" as="xs:string"/> 
  
  <!-- ========= -->
  <!-- variables -->
  <!-- ========= -->
  <!-- extract month number from date string -->
  <xsl:variable name="month" select="number(substring($isodate, 6, 2))"/>
  
  <!-- determine month name -->
  <xsl:variable name="month_string">
    <xsl:choose>
      <xsl:when test="$month=1">
        <xsl:value-of select="$strings/*/entry[@key='January']"/>
      </xsl:when>
      <xsl:when test="$month=2">
        <xsl:value-of select="$strings/*/entry[@key='February']"/>
      </xsl:when>
      <xsl:when test="$month=3">
        <xsl:value-of select="$strings/*/entry[@key='March']"/>
      </xsl:when>
      <xsl:when test="$month=4">
        <xsl:value-of select="$strings/*/entry[@key='April']"/>
      </xsl:when>
      <xsl:when test="$month=5">
        <xsl:value-of select="$strings/*/entry[@key='May']"/>
      </xsl:when>
      <xsl:when test="$month=6">
        <xsl:value-of select="$strings/*/entry[@key='June']"/>
      </xsl:when>
      <xsl:when test="$month=7">
        <xsl:value-of select="$strings/*/entry[@key='July']"/>
      </xsl:when>
      <xsl:when test="$month=8">
        <xsl:value-of select="$strings/*/entry[@key='August']"/>
      </xsl:when>
      <xsl:when test="$month=9">
        <xsl:value-of select="$strings/*/entry[@key='September']"/>
      </xsl:when>
      <xsl:when test="$month=10">
        <xsl:value-of select="$strings/*/entry[@key='October']"/>
      </xsl:when>
      <xsl:when test="$month=11">
        <xsl:value-of select="$strings/*/entry[@key='November']"/>
      </xsl:when>
      <xsl:when test="$month=12">
        <xsl:value-of select="$strings/*/entry[@key='December']"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <!-- ======= -->
  <!-- content -->
  <!-- ======= -->
  <xsl:value-of select="$month_string"/>
  
</xsl:function>
  <!-- util-isodate_long.xsl --><!-- ================================ --><!-- xs:string util:isodate-long()    --><!-- param: isodate as xs:date        --><!-- ================================ --><!-- converts an ISO date string to a "prettier" format --><!-- read: --><!-- $isodate [param] --><!-- $language-code --><!-- set: --><!-- $date_string --><!-- functions: --><!-- number(), substring(), contains() [Xpath 1.0] --><!-- util:get_month_date() [local] --><xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="util:isodate_long" as="xs:string" xml:base="functions/util/isodate_long.xsl">

  <!-- ====== -->
  <!-- params -->
  <!-- ====== -->
  <xsl:param name="isodate" as="xs:string"/>

  <!-- ========= -->
  <!-- variables -->
  <!-- ========= -->

  <!-- get date in relevant format -->
  <xsl:variable name="date_string"> 
    <xsl:choose>

      <!-- european format -->
      <xsl:when test="contains('fr es', $language-code)">
        <xsl:value-of select="number(substring($isodate, 9, 2))"/>
        <xsl:text> </xsl:text>
        <!-- <xsl:value-of select="$month" /> -->
        <xsl:value-of select="util:isodate_month_name($isodate)"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="substring($isodate, 1, 4)"/>
      </xsl:when>

      <!-- japanese format -->
      <xsl:when test="contains('ja', $language-code)">
        <xsl:value-of select="$isodate"/>
      </xsl:when>

      <!-- english format -->
      <xsl:otherwise>
        <!-- <xsl:value-of select="$month"/> -->
        <xsl:value-of select="util:isodate_month_name($isodate)"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="number(substring($isodate, 9, 2))"/>
        <xsl:text>, </xsl:text>
        <xsl:value-of select="substring($isodate, 1, 4)"/>
      </xsl:otherwise>

    </xsl:choose>
  </xsl:variable>

  <!-- ======= -->
  <!-- content -->
  <!-- ======= -->
  <xsl:value-of select="$date_string"/>

</xsl:function>
  <!-- util-trim.xsl --><!-- =================== --><!-- xs:string trim()    --><!-- param: $s           --><!-- =================== --><!-- read: --><!-- $s [param] --><!-- functions: --><!-- concat(), substring(), translate(), substring-after() [Xpath 1.0] --><!-- util:rtrim() [local] --><xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="util:trim" as="xs:string" xml:base="functions/util/trim.xsl">

  <!-- ====== -->
  <!-- params -->
  <!-- ====== -->
  <xsl:param name="s"/>

  <!-- ========= -->
  <!-- variables -->
  <!-- ========= -->

  <!-- &#x9; TAB-character -->
  <!-- &#xA; LF-character -->
  <!-- &#xD; CR-character -->

  <!-- replace TAB, LF and CR and with '' -->
  <xsl:variable name="translated" select="translate($s, '&#9;&#10;&#13;', '')"/>
  <!-- extract all characters in string after the first one -->
  <xsl:variable name="tmp1" select="substring($translated, 1, 1)"/>
  <!-- extract all character in string after found string -->
  <xsl:variable name="tmp2" select="substring-after($s, $tmp1)"/>
  
  <xsl:variable name="tmp3" select="concat($tmp1, $tmp2)"/>

  <!-- ======= -->
  <!-- content -->
  <!-- ======= -->
  <xsl:value-of select="util:rtrim($tmp3, string-length($tmp3))"/>

</xsl:function>
  <!-- util-rtrim.xsl --><!-- ======================= --><!-- xs:string util:rtrim()  --><!-- params: $s, $i          --><!-- ======================= --><!-- perform right trim on text through recursion --><!-- read: --><!-- $s, $i [param] --><!-- functions: --><!-- substring(), string-length(), translate() [Xpath 1.0] --><!-- util:rtrim() [local] --><xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="util:rtrim" as="xs:string" xml:base="functions/util/rtrim.xsl">

  <!-- ====== -->
  <!-- params -->
  <!-- ====== -->
  <xsl:param name="s" as="xs:string"/>
  <xsl:param name="i" as="xs:integer"/>

  <!-- ========= -->
  <!-- variables -->
  <!-- ========= -->
  
  <!-- is further trimming needed?-->
  <xsl:variable name="tmp">
    <xsl:choose>

      <xsl:when test="translate(substring($s, $i, 1), ' &#9;&#10;&#13;', '')">
        <xsl:value-of select="substring($s, 1, $i)"/>
      </xsl:when>
      <!-- case: string less than 2 (do nothing) -->
      <xsl:when test="$i &lt; 2"/>
      <!-- recurse -->
      <xsl:otherwise>
        <xsl:value-of select="util:rtrim($s, $i - 1)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- <xsl:variable name="tmp"
    select="if (translate(substring($s, $i, 1), ' &#x9;&#xA;&#xD;', '')) then
              substring($s, 1, $i)
            (: case: string less than 2 (do nothing) :)
            else if ($1 &lt; 2) then ()
            (: recurse :)
            else util:rtrim($s, $i - 1) " /> -->

  <!-- ======= -->
  <!-- content -->
  <!-- ======= -->
  <xsl:value-of select="$tmp"/>

</xsl:function>
  <!-- util-math_max.xsl --><!-- ===================== --><!-- util:math_max()       --><!-- param: $nodes         --><!-- ===================== --><!-- read: --><!-- $nodes [param] --><!-- functions: --><!-- not(), number(), position() [Xpath 1.0] --><xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="util:math_max" xml:base="functions/util/math_max.xsl">

  <!-- ====== -->
  <!-- params -->
  <!-- ====== -->
  <xsl:param name="nodes"/>

  <!-- ========= -->
  <!-- variables -->
  <!-- ========= -->
  <!-- count number of nodes -->
  <xsl:variable name="tmp">
    <xsl:choose>

      <!-- Case: Not a Number -->
      <xsl:when test="not($nodes)">NaN</xsl:when>

      <!-- Actually a number -->
      <xsl:otherwise>
        <xsl:for-each select="$nodes">
          <xsl:sort data-type="number" order="descending"/>
          <xsl:if test="position() = 1">
            <xsl:value-of select="number(.)"/>
          </xsl:if>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- ======= -->
  <!-- content -->
  <!-- ======= -->
  <xsl:value-of select="$tmp"/>

</xsl:function>

</xsl:transform>