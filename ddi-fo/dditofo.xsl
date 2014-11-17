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
<!-- Current version 2012-                                -->
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
               xmlns:util="https://code.google.com/p/ddixslt/#util"
               xmlns:i18n="https://code.google.com/p/ddixslt/#i18n">

  <xsl:output method="xml"
              encoding="UTF-8"
              indent="yes"
              omit-xml-declaration="no" />

  <!-- functions: -->
  <!-- count(), normalize-space(), position(), substring() [Xpath 1.0] -->
  <!-- document() [XSLT 1.0] -->
  
  <!-- ============================================================================================== -->
  <!-- Main "sections" of the root template and their show/hide vars                                  -->
  <!-- fo:bookmark-tree        bookmarks.show                  param 'True' bookmark.tree.xsl         -->
  <!-- Cover page:             page.cover_page.show            param 'True' cover_page.xsl            -->
  <!-- Metadata info:          page.metadata_info.show         param 'True' metadata_info.xsl         -->
  <!-- Table of Contents:      page.toc.show                   param 'True' table_of_contents.xsl     -->
  <!-- Overview:               page.overview.show              param 'True' overview.xsl              -->
  <!-- Files Description:      page.files_description.show     param 'True' files_description.xsl     -->
  <!-- Variable List:          page.variables_list.show        dependent*   variables_list.xsl        -->
  <!-- Variable Groups:        page.variable_groups.show       dependent**  variable_groups.xsl       -->
  <!-- Variables Description:  page.variables_description.show file         variables_description.xsl -->
  <!--                                                                                                -->
  <!-- *  If page.variable_groups.show is 'True', this gets set to 'False'                            -->
  <!-- ** Both parameter and DDI file                                                                 -->
  <!-- ============================================================================================== -->

  <!-- params supplied by XSLT engine -->
  <!-- language-code. report-title, font-family.                         -->
  <!-- translation-file (http://xml.snd.gu.se/xsl/ddi2/i18n/{$lang}.xml) -->
  <!-- show-variables-list-question, show-cover-page                     -->


  <!-- global variables/parameters and their purpose  -->
  <!-- i18n.*           translations                       -->
  <!-- layout.*         look and feel of the document      -->
  <!-- layout.color.*   useful color names                 -->
  <!-- layout.tables.*  table look and feel                -->
  <!-- study.*          misc. useful info from input file  -->
  <!-- time.*           creation dates, etc                -->
  <!-- bookmarks.*      <fo:bookmark-tree>                 -->
  <!-- limits.*         some useful max values             -->
  <!-- page.*           <fo:page-sequence>                 -->
  <!-- section.*        sections/areas of the document     -->


  <!-- ################################################### -->
  <!-- ### global parameters                           ### -->
  <!-- ################################################### -->

  <!-- used in util:isodate-long() -->  
  <xsl:param name="i18n.language_code" select="'en'" />

  <!-- translation file path-->
  <xsl:param name="i18n.translation_file" />

  <xsl:param name="layout.start_page_number" select="4" />
  
  <xsl:param name="limits.variables_description_categories_max" select="1000" />
  <xsl:param name="limits.variable_name_length" select="14" />

  <!-- path to front page logo -->
  <!-- <xsl:param name="layout.logo_file" select="'http://xml.snd.gu.se/xsl/ddi2/ddi-fo/images/snd_logo_sv.png'" /> -->
  <!-- <xsl:param name="layout.logo_file" select="'../images/placeholder_logo.png'" /> -->
  <xsl:param name="layout.logo_file" select="'../images/snd_logo_grayscale.png'" />

  <!-- Style and page layout -->
  <xsl:param name="layout.page_master" select="'A4-page'" /> 
  <xsl:param name="layout.font_family" select="'Times'" />
  <xsl:param name="layout.font_size" select="10" />
  <xsl:param name="layout.header_font_size" select="6" />
 
  <!-- toggle main sections of root template -->
  <xsl:param name="bookmarks.show" select="'True'" />
  <xsl:param name="page.cover.show" select="'True'" />
  <xsl:param name="page.metadata_info.show" select="'True'" />
  <xsl:param name="page.table_of_contents.show" select="'True'" />
  <xsl:param name="page.overview.show" select="'True'" />
  <xsl:param name="page.files_description.show" select="'True'" />
    
  <!-- misc -->
  <xsl:param name="section.variables_description_categories.show" select="'True'" />


  <!-- #################################################### -->
  <!-- ### layout and style                             ### -->
  <!-- #################################################### -->

  <!-- To avoid empty pages; use a huge chunksize for subsets -->
  <xsl:variable name="layout.chunk_size" select="50" />
  
  <!-- table cells -->
  <xsl:variable name="layout.tables.cellpadding" select="'3pt'"/>
  <xsl:variable name="layout.tables.border" select="'0.5pt'" />
    
  <!-- colors -->  
  <xsl:variable name="layout.color.gray1" select="'#f0f0f0'" />
  <xsl:variable name="layout.color.gray2" select="'#e0e0e0'" />
  <xsl:variable name="layout.color.gray3" select="'#d0d0d0'" />
  <xsl:variable name="layout.color.gray4" select="'#c0c0c0'" />

  
  <!-- #################################################### -->
  <!-- ### i18n strings                                 ### -->
  <!-- #################################################### -->

  <!-- read strings from selected translations file-->
  <xsl:variable name="i18n.strings" select="document($i18n.translation_file)" />


  <!-- #################################################### -->
  <!-- ### gather some info                             ### -->
  <!-- #################################################### -->
  
  <!-- survey title -->
  <xsl:variable name="study.title"
                xpath-default-namespace="http://www.icpsr.umich.edu/DDI">
    <xsl:value-of select="normalize-space(/codeBook/stdyDscr/citation/titlStmt/titl)" />
    <xsl:value-of select="if (/codeBook/stdyDscr/citation/titlStmt/altTitl) then
                            concat('(', /codeBook/stdyDscr/citation/titlStmt/altTitl, ')')
                          else () " />
  </xsl:variable>

  <!-- geography -->
  <xsl:variable name="study.geography"
                xpath-default-namespace="http://www.icpsr.umich.edu/DDI">
    <xsl:for-each select="/codeBook/stdyDscr/stdyInfo/sumDscr/nation">
      <xsl:value-of select="if (position() > 1) then ', ' else ()" />
      <xsl:value-of select="normalize-space(.)" />
    </xsl:for-each>
  </xsl:variable>

  <!-- time period -->  
  <xsl:variable name="study.time_produced"
    xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
    select="/codeBook/stdyDscr/stdyInfo/sumDscr/timePrd/@date" />

  <!-- ================================================== -->
  <!-- time and date related                              -->
  <!-- ================================================== -->
  
  <!-- year-from - the first data collection mode element with a 'start' event -->
  <xsl:variable name="time.year_from"
    xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
    select="substring(/codeBook/stdyDscr/stdyInfo/sumDscr/collDate[@event = 'start'][1]/@date, 1, 4)" />
  
  <!-- year to is the last data collection mode element with an 'end' event -->
  <xsl:variable name="time.year_to_count" 
    xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
    select="count(/codeBook/stdyDscr/stdyInfo/sumDscr/collDate[@event = 'end'])" />

  <xsl:variable name="time.year_to" 
    xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
    select="substring(/codeBook/stdyDscr/stdyInfo/sumDscr/collDate[@event = 'end'][$time.year_to_count]/@date, 1, 4)" />
  
  <xsl:variable name="time">
    <xsl:if test="$time.year_from">
      <xsl:value-of select="$time.year_from" />
      <xsl:value-of select="if ($time.year_to > $time.year_from)
                            then concat('-', $time.year_from)
                            else () " />
    </xsl:if>
  </xsl:variable>
  

  <!-- #################################################### -->
  <!-- ### toggle parts of document                     ### -->
  <!-- #################################################### -->

  <!-- ======================================= -->
  <!-- Show variable groups or variables list? -->
  <!-- ======================================= -->

  <!-- if there are any variable groups, render the variable groups page-sequence -->
  <xsl:variable name="page.variable_groups.show"
    xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
    select="if (count(/codeBook/dataDscr/varGrp) > 0) then 'True' else 'False' "/>

  <!-- if rendering variable groups page-sequence is enabled -->
  <!-- do not also render variable list page-sequence -->
  <xsl:variable name="page.variables_list.show"
    select="if ($page.variable_groups.show = 'True') then 'False' else 'True' "/>

  <!-- =========================== -->
  <!-- Show variables description? -->
  <!-- =========================== -->

  <!-- If there are no variables, don't render the variable description page-sequence -->
  <xsl:variable name="page.variables_description.show"
    xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
    select="if (count(/codeBook/dataDscr/var) = 0) then 'False' else 'True' "/>
    
  <!-- =============================== -->
  <!-- Show specific page subsections? -->  
  <!-- =============================== -->
  
  <xsl:variable name="section.scope_and_coverage.show"
    xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
    select="if (/codeBook/stdyDscr/stdyInfo/notes) then 'True'
            else if (/codeBook/stdyDscr/stdyInfo/subject/keyword) then 'True'
            else if (/codeBook/stdyDscr/stdyInfo/sumDscr/geogCover) then 'True'
            else if (/codeBook/stdyDscr/stdyInfo/sumDscr/universe) then 'True'
            else 'False' "/>

  <xsl:variable name="section.producers_and_sponsors.show"
    xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
    select="if (/codeBook/stdyDscr/citation/rspStmt/AuthEnty) then 'True'
            else if (/codeBook/stdyDscr/citation/prodStmt/producer) then 'True'
            else if (/codeBook/stdyDscr/citation/prodStmt/fundAg) then 'True'
            else if (/codeBook/stdyDscr/citation/rspStmt/othId) then 'True'
            else 'False' "/>

  <xsl:variable name="section.sampling.show"
    xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
    select="if (/codeBook/stdyDscr/method/notes[@subject='sampling']) then 'True'
            else if (/codeBook/stdyDscr/method/dataColl/sampProc) then 'True'
            else if (/codeBook/stdyDscr/method/dataColl/deviat) then 'True'
            else if (/codeBook/stdyDscr/method/anlyInfo/respRate) then 'True'
            else if (/codeBook/stdyDscr/method/dataColl/weight) then 'True'
            else 'False' "/>    

  <xsl:variable name="section.data_collection.show"
    xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
    select="if (/codeBook/stdyDscr/stdyInfo/sumDscr/collDate) then 'True'
            else if (/codeBook/stdyDscr/stdyInfo/sumDscr/timePrd) then 'True'
            else if (/codeBook/stdyDscr/method/dataColl/collMode) then 'True'
            else if (/codeBook/stdyDscr/method/notes[@subject = 'collection']) then 'True'
            else if (/codeBook/stdyDscr/method/notes[@subject = 'processing']) then 'True'
            else if (/codeBook/stdyDscr/method/notes[@subject = 'cleaning']) then 'True'
            else if (/codeBook/stdyDscr/method/dataColl/collSitu) then 'True'
            else if (/codeBook/stdyDscr/method/dataColl/resInstru) then 'True'
            else if (/codeBook/stdyDscr/method/dataColl/dataCollector) then 'True'
            else if (/codeBook/stdyDscr/method/dataColl/actMin) then 'True'
            else 'False' "/>
    
  <xsl:variable name="section.data_processing_and_appraisal.show"
    xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
    select="if (/codeBook/stdyDscr/method/dataColl/cleanOps) then 'True'
            else if (/codeBook/stdyDscr/method/anlyInfo/EstSmpErr) then 'True'
            else if (/codeBook/stdyDscr/method/anlyInfo/dataAppr) then 'True'
            else 'False' "/>
    
  <xsl:variable name="section.accessibility.show"
    xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
    select="if (/codeBook/stdyDscr/dataAccs/useStmt/contact) then 'True'
            else if (/codeBook/stdyDscr/citation/distStmt/distrbtr) then 'True'
            else if (/codeBook/stdyDscr/citation/distStmt/contact) then 'True'
            else if (/codeBook/stdyDscr/dataAccs/useStmt/confDec) then 'True'
            else if (/codeBook/stdyDscr/dataAccs/useStmt/conditions) then 'True'
            else if (/codeBook/stdyDscr/dataAccs/useStmt/citReq) then 'True'
            else 'False' "/>

  <xsl:variable name="section.rights_and_disclaimer.show"
    xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
    select="if (/codeBook/stdyDscr/dataAccs/useStmt/disclaimer) then 'True'
            else if (/codeBook/stdyDscr/citation/prodStmt/copyright) then 'True'
            else 'False' "/>
  
  
  <!-- #################################################### -->
  <!-- ### xinclude other files                         ### -->
  <!-- #################################################### -->
  
  <!-- ================== -->
  <!-- matching templates -->
  <!-- ================== -->
  <xi:include href="templates/match/root.xsl" />
  <xi:include href="templates/match/ddi/AuthEnty.xsl" />
  <xi:include href="templates/match/ddi/collDate.xsl" />
  <xi:include href="templates/match/ddi/contact.xsl" />
  <xi:include href="templates/match/ddi/dataCollector.xsl" />
<!--  <xi:include href="templates/match/ddi/fileDscr.xsl" />-->
  <xi:include href="templates/match/ddi/fileDscr_variables-description.xsl" />
<!--  <xi:include href="templates/match/ddi/fileDscr_variables-list.xsl" />-->
  <xi:include href="templates/match/ddi/fileName.xsl" />
  <xi:include href="templates/match/ddi/fundAg.xsl" />
  <xi:include href="templates/match/ddi/IDNo.xsl" />
  <xi:include href="templates/match/ddi/othId.xsl" />
  <xi:include href="templates/match/ddi/producer.xsl" />
  <xi:include href="templates/match/ddi/timePrd.xsl" />
  <xi:include href="templates/match/ddi/var.xsl" />
  <xi:include href="templates/match/ddi/var_variablesList.xsl" />
  <xi:include href="templates/match/ddi/varGrp.xsl" />
  <xi:include href="templates/match/default_text.xsl" />

  <!-- =============== -->
  <!-- named templates -->
  <!-- =============== -->
  <xi:include href="templates/named/page_header.xsl" />
  <xi:include href="templates/named/page_footer.xsl" />
    
  <!-- ========= -->
  <!-- functions -->
  <!-- ========= -->
  <xi:include href="functions/util/isodate_month_name.xsl" />
  <xi:include href="functions/util/isodate_long.xsl" />
  <xi:include href="functions/util/trim.xsl" />
  <xi:include href="functions/util/rtrim.xsl" />
  <xi:include href="functions/util/math_max.xsl" />
  <xi:include href="functions/i18n/get.xsl" />
    
</xsl:transform>
