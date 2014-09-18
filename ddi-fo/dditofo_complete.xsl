<?xml version='1.0' encoding='UTF-8'?>
<!-- Overview --><!-- =================================================================================== --><!-- Transforms DDI-XML into XSL-FO to produce study documentation in PDF format         --><!-- Developed for DDI documents produced by the International Household Survey Network  --><!-- Microdata Managemenet Toolkit (http://www.surveynetwork.org/toolkit) and            --><!-- Central Survey Catalog (http://www.surveynetwork.org/surveys)                       --><!-- =================================================================================== --><!-- Authors --><!-- ==================================================== --><!-- Pascal Heus (pascal.heus@gmail.com)                  --><!-- Version: July 2006                                   --><!-- Platform: XSLT 1.0, Apache FOP 0.20.5                --><!--                                                      --><!-- Oistein Kristiansen (oistein.kristiansen@nsd.uib.no) --><!-- Version: 2010                                        --><!-- Platform: updated for FOP 0.93 2010                  --><!--                                                      --><!-- Akira Olsbänning (akira.olsbanning@snd.gu.se)        --><!-- Current version 2012-                                --><!-- Platform: updated to XSLT 2.0                        --><!-- ==================================================== --><!-- License --><!-- ================================================================================================ --><!-- Copyright 2006 Pascal Heus (pascal.heus@gmail.com)                                               --><!--                                                                                                  --><!-- This program is free software; you can redistribute it and/or modify it under the terms of the   --><!-- GNU Lesser General Public License as published by the Free Software Foundation; either version   --><!-- 2.1 of the License, or (at your option) any later version.                                       --><!--                                                                                                  --><!-- This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;        --><!-- without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.        --><!-- See the GNU Lesser General Public License for more details.                                      --><!--                                                                                                  --><!-- The full text of the license is available at http://www.gnu.org/copyleft/lesser.html             --><!-- ================================================================================================ --><!-- References --><!-- ========================================================= --><!-- XSL-FO:                                                   --><!--   http://www.w3.org/Style/XSL/                            --><!--   http://www.w3schools.com/xslfo/xslfo_reference.asp      --><!--   http://www.xslfo.info/                                  --><!-- Apache FOP:                                               --><!--   http://xmlgraphics.apache.org/fop/                      --><!-- XSL-FO Tutorials:                                         --><!--   http://www.renderx.com/tutorial.html                    --><!--   http://www.antennahouse.com/XSLsample/XSLsample.htm     --><!-- String trimming:                                          --><!--  http://skew.org/xml                                      --><!-- ========================================================= --><!-- Changelog: --><!-- 2006-04: Added multilingual support and French translation --><!-- 2006-06: Added Spanish and new elements to match IHSN Template v1.2 --><!-- 2006-07: Minor fixes and typos --><!-- 2006-07: Added option parameters to hide producers in cover page and questions in variables list page --><!-- 2010-03: Made FOP 0.93 compatible --><!-- 2012-11-01: Broken up into parts using xsl:include --><!-- 2013-01-22: Changing the file names to match template names better --><!-- 2013-05-28: Using xincludes instead of xsl:includes --><!-- 2013-05-29: Including config in main file --><!-- Future changelogs can be read from the SVN repo at googlecode --><xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:ddi="http://www.icpsr.umich.edu/DDI" xmlns:n1="http://www.icpsr.umich.edu/DDI" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:date="http://exslt.org/dates-and-times" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:exsl="http://exslt.org/common" xmlns:math="http://exslt.org/math" xmlns:str="http://exslt.org/strings" xmlns:doc="http://www.icpsr.umich.edu/doc" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:xdt="http://www.w3.org/2005/xpath-datatypes" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:util="https://code.google.com/p/ddixslt/#util" xmlns:i18n="https://code.google.com/p/ddixslt/#i18n" version="2.0" extension-element-prefixes="date exsl str" exclude-result-prefixes="util">

  <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>

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
  <xsl:param name="i18n.language_code" select="'en'"/>

  <!-- translation file path-->
  <xsl:param name="i18n.translation_file"/>

  <xsl:param name="layout.start_page_number" select="4"/>
  
  <xsl:param name="limits.variables_description_categories_max" select="1000"/>
  <xsl:param name="limits.variable_name_length" select="14"/>

  <!-- path to front page logo -->
  <!-- <xsl:param name="layout.logo_file" select="'http://xml.snd.gu.se/xsl/ddi2/ddi-fo/images/snd_logo_sv.png'" /> -->
  <xsl:param name="layout.logo_file" select="'../images/placeholder_logo.png'"/>

  <!-- Style and page layout -->
  <xsl:param name="layout.page_master" select="'A4-page'"/> 
  <xsl:param name="layout.font_family" select="'Times'"/>
  <xsl:param name="layout.font_size" select="10"/>
  <xsl:param name="layout.header_font_size" select="6"/>
 
  <!-- toggle main sections of root template -->
  <xsl:param name="bookmarks.show" select="'True'"/>
  <xsl:param name="page.cover.show" select="'True'"/>
  <xsl:param name="page.metadata_info.show" select="'True'"/>
  <xsl:param name="page.table_of_contents.show" select="'True'"/>
  <xsl:param name="page.overview.show" select="'True'"/>
  <xsl:param name="page.files_description.show" select="'True'"/>
    
  <!-- misc -->
  <xsl:param name="section.variables_description_categories.show" select="'True'"/>


  <!-- #################################################### -->
  <!-- ### layout and style                             ### -->
  <!-- #################################################### -->

  <!-- To avoid empty pages; use a huge chunksize for subsets -->
  <xsl:variable name="layout.chunk_size" select="50"/>
  
  <!-- table cells -->
  <xsl:variable name="layout.tables.cellpadding" select="'3pt'"/>
  <xsl:variable name="layout.tables.border" select="'0.5pt'"/>
    
  <!-- colors -->  
  <xsl:variable name="layout.color.gray1" select="'#f0f0f0'"/>
  <xsl:variable name="layout.color.gray2" select="'#e0e0e0'"/>
  <xsl:variable name="layout.color.gray3" select="'#d0d0d0'"/>
  <xsl:variable name="layout.color.gray4" select="'#c0c0c0'"/>

  
  <!-- #################################################### -->
  <!-- ### i18n strings                                 ### -->
  <!-- #################################################### -->

  <!-- read strings from selected translations file-->
  <xsl:variable name="i18n.strings" select="document($i18n.translation_file)"/>


  <!-- #################################################### -->
  <!-- ### gather some info                             ### -->
  <!-- #################################################### -->
  
  <!-- survey title -->
  <xsl:variable name="study.title" xpath-default-namespace="http://www.icpsr.umich.edu/DDI">
    <xsl:value-of select="normalize-space(/codeBook/stdyDscr/citation/titlStmt/titl)"/>
    <xsl:value-of select="if (/codeBook/stdyDscr/citation/titlStmt/altTitl) then                             concat('(', /codeBook/stdyDscr/citation/titlStmt/altTitl, ')')                           else () "/>
  </xsl:variable>

  <!-- geography -->
  <xsl:variable name="study.geography" xpath-default-namespace="http://www.icpsr.umich.edu/DDI">
    <xsl:for-each select="/codeBook/stdyDscr/stdyInfo/sumDscr/nation">
      <xsl:value-of select="if (position() &gt; 1) then ', ' else ()"/>
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:for-each>
  </xsl:variable>

  <!-- time period -->  
  <xsl:variable name="study.time_produced" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" select="/codeBook/stdyDscr/stdyInfo/sumDscr/timePrd/@date"/>

  <!-- ================================================== -->
  <!-- time and date related                              -->
  <!-- ================================================== -->
  
  <!-- year-from - the first data collection mode element with a 'start' event -->
  <xsl:variable name="time.year_from" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" select="substring(/codeBook/stdyDscr/stdyInfo/sumDscr/collDate[@event = 'start'][1]/@date, 1, 4)"/>
  
  <!-- year to is the last data collection mode element with an 'end' event -->
  <xsl:variable name="time.year_to_count" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" select="count(/codeBook/stdyDscr/stdyInfo/sumDscr/collDate[@event = 'end'])"/>

  <xsl:variable name="time.year_to" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" select="substring(/codeBook/stdyDscr/stdyInfo/sumDscr/collDate[@event = 'end'][$time.year_to_count]/@date, 1, 4)"/>
  
  <xsl:variable name="time">
    <xsl:if test="$time.year_from">
      <xsl:value-of select="$time.year_from"/>
      <xsl:value-of select="if ($time.year_to &gt; $time.year_from)                             then concat('-', $time.year_from)                             else () "/>
    </xsl:if>
  </xsl:variable>
  

  <!-- #################################################### -->
  <!-- ### toggle parts of document                     ### -->
  <!-- #################################################### -->

  <!-- ======================================= -->
  <!-- Show variable groups or variables list? -->
  <!-- ======================================= -->

  <!-- if there are any variable groups, render the variable groups page-sequence -->
  <xsl:variable name="page.variable_groups.show" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" select="if (count(/codeBook/dataDscr/varGrp) &gt; 0) then 'True' else 'False' "/>

  <!-- if rendering variable groups page-sequence is enabled -->
  <!-- do not also render variable list page-sequence -->
  <xsl:variable name="page.variables_list.show" select="if ($page.variable_groups.show = 'True') then 'False' else 'True' "/>

  <!-- =========================== -->
  <!-- Show variables description? -->
  <!-- =========================== -->

  <!-- If there are no variables, don't render the variable description page-sequence -->
  <xsl:variable name="page.variables_description.show" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" select="if (count(/codeBook/dataDscr/var) = 0) then 'False' else 'True' "/>
    
  <!-- =============================== -->
  <!-- Show specific page subsections? -->  
  <!-- =============================== -->
  
  <xsl:variable name="section.scope_and_coverage.show" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" select="if (/codeBook/stdyDscr/stdyInfo/notes) then 'True'             else if (/codeBook/stdyDscr/stdyInfo/subject/keyword) then 'True'             else if (/codeBook/stdyDscr/stdyInfo/sumDscr/geogCover) then 'True'             else if (/codeBook/stdyDscr/stdyInfo/sumDscr/universe) then 'True'             else 'False' "/>

  <xsl:variable name="section.producers_and_sponsors.show" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" select="if (/codeBook/stdyDscr/citation/rspStmt/AuthEnty) then 'True'             else if (/codeBook/stdyDscr/citation/prodStmt/producer) then 'True'             else if (/codeBook/stdyDscr/citation/prodStmt/fundAg) then 'True'             else if (/codeBook/stdyDscr/citation/rspStmt/othId) then 'True'             else 'False' "/>

  <xsl:variable name="section.sampling.show" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" select="if (/codeBook/stdyDscr/method/notes[@subject='sampling']) then 'True'             else if (/codeBook/stdyDscr/method/dataColl/sampProc) then 'True'             else if (/codeBook/stdyDscr/method/dataColl/deviat) then 'True'             else if (/codeBook/stdyDscr/method/anlyInfo/respRate) then 'True'             else if (/codeBook/stdyDscr/method/dataColl/weight) then 'True'             else 'False' "/>    

  <xsl:variable name="section.data_collection.show" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" select="if (/codeBook/stdyDscr/stdyInfo/sumDscr/collDate) then 'True'             else if (/codeBook/stdyDscr/stdyInfo/sumDscr/timePrd) then 'True'             else if (/codeBook/stdyDscr/method/dataColl/collMode) then 'True'             else if (/codeBook/stdyDscr/method/notes[@subject = 'collection']) then 'True'             else if (/codeBook/stdyDscr/method/notes[@subject = 'processing']) then 'True'             else if (/codeBook/stdyDscr/method/notes[@subject = 'cleaning']) then 'True'             else if (/codeBook/stdyDscr/method/dataColl/collSitu) then 'True'             else if (/codeBook/stdyDscr/method/dataColl/resInstru) then 'True'             else if (/codeBook/stdyDscr/method/dataColl/dataCollector) then 'True'             else if (/codeBook/stdyDscr/method/dataColl/actMin) then 'True'             else 'False' "/>
    
  <xsl:variable name="section.data_processing_and_appraisal.show" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" select="if (/codeBook/stdyDscr/method/dataColl/cleanOps) then 'True'             else if (/codeBook/stdyDscr/method/anlyInfo/EstSmpErr) then 'True'             else if (/codeBook/stdyDscr/method/anlyInfo/dataAppr) then 'True'             else 'False' "/>
    
  <xsl:variable name="section.accessibility.show" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" select="if (/codeBook/stdyDscr/dataAccs/useStmt/contact) then 'True'             else if (/codeBook/stdyDscr/citation/distStmt/distrbtr) then 'True'             else if (/codeBook/stdyDscr/citation/distStmt/contact) then 'True'             else if (/codeBook/stdyDscr/dataAccs/useStmt/confDec) then 'True'             else if (/codeBook/stdyDscr/dataAccs/useStmt/conditions) then 'True'             else if (/codeBook/stdyDscr/dataAccs/useStmt/citReq) then 'True'             else 'False' "/>

  <xsl:variable name="section.rights_and_disclaimer.show" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" select="if (/codeBook/stdyDscr/dataAccs/useStmt/disclaimer) then 'True'             else if (/codeBook/stdyDscr/citation/prodStmt/copyright) then 'True'             else 'False' "/>
  
  
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
    <!-- bookmarks.xsl --><!-- =========================================== --><!-- <xls:if> bookmarks                          --><!-- value: <fo:bookmark-tree>                   --><!-- =========================================== --><!-- read: --><!-- show-cover-page, show-metadata-info, show-toc, show-overview             --><!-- show-scope-and-coverage, show-producers-and-sponsors,                    --><!-- show-sampling, show-data-collection, show-data-processing-and-appraisal, --><!-- show-accessibility, show-rights-and-disclaimer, show-files-description,  --><!-- show-variable-groups, show-variables-list, show-variables-description    --><!-- functions: --><!-- nomalize-space(), contains(), concat(), string-length() [xpath 1.0] --><!-- called: --><!-- trim --><xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" test="$bookmarks.show = 'True'" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="root_template_xincludes/bookmark-tree.xsl">

  <fo:bookmark-tree>

    <!-- ============= -->
    <!-- 1) Intro      -->
    <!-- ============= -->

    <!-- Cover_Page -->
    <xsl:if test="$page.cover.show ='True'">
      <fo:bookmark internal-destination="cover-page">
        <fo:bookmark-title>
          <xsl:value-of select="i18n:get('Cover_Page')"/>
        </fo:bookmark-title>
      </fo:bookmark>
    </xsl:if>

    <!-- Document_Information -->
    <xsl:if test="$page.metadata_info.show = 'True'">
      <fo:bookmark internal-destination="metadata-info">
        <fo:bookmark-title>
          <xsl:value-of select="i18n:get('Document_Information')"/>
        </fo:bookmark-title>
      </fo:bookmark>
    </xsl:if>

    <!-- Table_of_Contents -->
    <xsl:if test="$page.table_of_contents.show = 'True'">
      <fo:bookmark internal-destination="toc">
        <fo:bookmark-title>
          <xsl:value-of select="i18n:get('Table_of_Contents')"/>
        </fo:bookmark-title>
      </fo:bookmark>
    </xsl:if>

    <!-- ============= -->
    <!-- 2) Overview   -->
    <!-- ============= -->

    <xsl:if test="$page.overview.show = 'True'">

      <fo:bookmark internal-destination="overview">
        <fo:bookmark-title>
          <xsl:value-of select="i18n:get('Overview')"/>
        </fo:bookmark-title>

        <!-- Scope_and_Coverage -->
        <xsl:if test="$section.scope_and_coverage.show = 'True'">
          <fo:bookmark internal-destination="scope-and-coverage">
            <fo:bookmark-title>
              <xsl:value-of select="i18n:get('Scope_and_Coverage')"/>
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:if>

        <!-- Producers_and_Sponsors -->
        <xsl:if test="$section.producers_and_sponsors.show = 'True'">
          <fo:bookmark internal-destination="producers-and-sponsors">
            <fo:bookmark-title>
              <xsl:value-of select="i18n:get('Producers_and_Sponsors')"/>
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:if>

        <!-- Sampling -->
        <xsl:if test="$section.sampling.show = 'True'">
          <fo:bookmark internal-destination="sampling">
            <fo:bookmark-title>
              <xsl:value-of select="i18n:get('Sampling')"/>
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:if>

        <!-- Data_Collection -->
        <xsl:if test="$section.data_collection.show = 'True'">
          <fo:bookmark internal-destination="data-collection">
            <fo:bookmark-title>
              <xsl:value-of select="i18n:get('Data_Collection')"/>
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:if>

        <!-- Data_Processing_and_Appraisal -->
        <xsl:if test="$section.data_processing_and_appraisal.show = 'True'">
          <fo:bookmark internal-destination="data-processing-and-appraisal">
            <fo:bookmark-title>
              <xsl:value-of select="i18n:get('Data_Processing_and_Appraisal')"/>
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:if>

        <!-- Accessibility -->
        <xsl:if test="$section.accessibility.show = 'True'">
          <fo:bookmark internal-destination="accessibility">
            <fo:bookmark-title>
              <xsl:value-of select="i18n:get('Accessibility')"/>
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:if>

        <!-- Rights_and_Disclaimer -->
        <xsl:if test="$section.rights_and_disclaimer.show = 'True'">
          <fo:bookmark internal-destination="rights-and-disclaimer">
            <fo:bookmark-title>
              <xsl:value-of select="i18n:get('Rights_and_Disclaimer')"/>
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:if>

      </fo:bookmark>
    </xsl:if>

    <!-- ============= -->
    <!-- 3) Details    -->
    <!-- ============= -->

    <!-- Files_Description -->
    <xsl:if test="$page.files_description.show = 'True'">
      <fo:bookmark internal-destination="files-description">

        <fo:bookmark-title>
          <xsl:value-of select="i18n:get('Files_Description')"/>
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
    <xsl:if test="$page.variable_groups.show = 'True'">
      <fo:bookmark internal-destination="variables-groups">
        <fo:bookmark-title>
          <xsl:value-of select="i18n:get('Variables_Groups')"/>
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
    <xsl:if test="$page.variables_list.show = 'True'">
      <fo:bookmark internal-destination="variables-list">
        <fo:bookmark-title>
          <xsl:value-of select="i18n:get('Variables_List')"/>
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
    <xsl:if test="$page.variables_description.show = 'True'">
      <fo:bookmark internal-destination="variables-description">
        <fo:bookmark-title>
          <xsl:value-of select="i18n:get('Variables_Description')"/>
        </fo:bookmark-title>

        <xsl:for-each select="/codeBook/fileDscr">
          <fo:bookmark internal-destination="vardesc-{fileTxt/fileName/@ID}">
            <fo:bookmark-title>
              <xsl:apply-templates select="fileTxt/fileName"/>
            </fo:bookmark-title>

            <xsl:variable name="fileId" select="if (fileTxt/fileName/@ID) then fileTxt/fileName/@ID                       else if (@ID) then @ID                       else () "/>

            <xsl:for-each select="/codeBook/dataDscr/var[@files = $fileId]">
                <fo:bookmark internal-destination="var-{@ID}">
                  <fo:bookmark-title>
                    <xsl:apply-templates select="@name"/>
                    <xsl:value-of select="if (normalize-space(labl)) then concat(': ', util:trim(labl)) else () "/>
                  </fo:bookmark-title>
                </fo:bookmark>            
            </xsl:for-each>

          </fo:bookmark>
        </xsl:for-each>
      </fo:bookmark>
    </xsl:if>

  </fo:bookmark-tree>
</xsl:if>    
    <!-- cover_page.xsl --><!-- ========================= --><!-- <xsl:if> cover page       --><!-- value: <fo:page-sequence> --><!-- ========================= --><!-- functions: --><!-- normalize-space() [Xpath 1.0] --><!-- util:trim() [local]           --><xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" test="$page.cover.show = 'True'" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="root_template_xincludes/page-sequence/cover_page.xsl">

  <fo:page-sequence master-reference="{$layout.page_master}" font-family="Helvetica" font-size="{$layout.font_size}">

    <!-- =========================================== -->
    <!-- page content                                -->
    <!-- =========================================== -->

    <fo:flow flow-name="body">

      <fo:block id="cover-page">

        <!-- logo graphic -->
        <fo:block text-align="center">
          <fo:external-graphic src="{$layout.logo_file}"/>
        </fo:block>      

        <!-- title -->
        <fo:block font-size="18pt" font-weight="bold" space-before="5mm" text-align="center" space-after="0.0mm">
          <xsl:value-of select="normalize-space(/codeBook/stdyDscr/citation/titlStmt/titl)"/>
        </fo:block>

        <!-- ID-number -->
        <!-- <fo:block font-size="15pt" text-align="center" space-before="5mm">
          <xsl:value-of select="/codeBook/docDscr/docSrc/titlStmt/IDNo" />
        </fo:block> -->

        <!-- blank line ('&#x00A0;' is the equivalent of HTML '&nbsp;') -->
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
    <!-- metadata_information.xsl --><!-- ================================================= --><!-- <xsl:if> metadata information                     --><!-- value: <fo:page-sequence>                         --><!-- ================================================= --><!-- read: --><!-- $font-family --><!-- $layout.tables.border, $layout.tables.cellpadding --><!-- functions: --><!-- boolean(), normalize-space() [Xpath 1.0] --><!-- proportional-column-width() [FO]         --><!-- util:isodate_long() [functions] --><!-- Metadata production        [table]      --><!--   Metadata producers       [table-row]  --><!--   Metadata Production Date [table-row]  --><!--   Metadata Version         [table-row]  --><!--   Metadata ID              [table-row]  --><!--   Spacer                   [table-row]  --><!-- Report Acknowledgements    [block]      --><!-- Report Notes               [block]      --><xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" test="$page.metadata_info.show = 'True'" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="root_template_xincludes/page-sequence/metadata_information.xsl">
  
  <fo:page-sequence master-reference="{$layout.page_master}" font-family="{$layout.font_family}" font-size="{$layout.font_size}">
    
    <!-- =========================================== -->
    <!-- page content                                -->
    <!-- =========================================== -->
    
    <fo:flow flow-name="body">
      <fo:block id="metadata-info"/>
      
      <!-- Title -->
      <fo:block id="metadata-production" font-size="18pt" font-weight="bold" space-after="2.5mm">
        <xsl:value-of select="i18n:get('Metadata_Production')"/>
      </fo:block>
      
      <fo:table table-layout="fixed" width="100%" space-before="0.0mm" space-after="5mm">
        <fo:table-column column-width="proportional-column-width(20)"/>
        <fo:table-column column-width="proportional-column-width(80)"/>
        
        <fo:table-body>
              
          <!-- Metadata Producers -->
          <xsl:if test="/codeBook/docDscr/citation/prodStmt/producer">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:value-of select="concat(i18n:get('Metadata_Producers'), ':')"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <xsl:apply-templates select="/codeBook/docDscr/citation/prodStmt/producer"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
    
    
          <!-- Production Date -->
          <xsl:if test="/codeBook/docDscr/citation/prodStmt/prodDate">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:value-of select="concat(i18n:get('Production_Date'), ':')"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>                  
                  <xsl:value-of select="util:isodate_long(normalize-space(/codeBook/docDscr/citation/prodStmt/prodDate))"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Version -->
          <!-- <xsl:if test="/codeBook/docDscr/citation/verStmt/version">
            <fo:table-row>
            <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
            <fo:block>
            <xsl:value-of select="$i18n-Version"/>
            </fo:block>
            </fo:table-cell>
            <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
            <xsl:apply-templates select="/codeBook/docDscr/citation/verStmt/version" />
            </fo:table-cell>
            </fo:table-row>
            </xsl:if> -->
                    
          <!-- Identification -->
          <xsl:if test="/codeBook/docDscr/citation/titlStmt/IDNo">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:value-of select="concat(i18n:get('Identification'), ':')"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <xsl:apply-templates select="/codeBook/docDscr/citation/titlStmt/IDNo"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          
        </fo:table-body>
      </fo:table>
      
    </fo:flow>
  </fo:page-sequence>
</xsl:if>
    <!-- table_of_contents.xsl --><!-- ============================================== --><!-- <xsl:if> table of contents                     --><!-- value: <fo:page-sequence>                      --><!-- ============================================== --><!-- read: --><!-- $font-family, $show-overview, $show-scope-and-coverage, --><!-- $show-producers-and-sponsors, $show-sampling, $show-data-collection --><!-- $show-data-processing-and-appraisal, $show-accessibility, --><!-- $show-rights-and-disclaimer, $show-files-description, --><!-- $show-variables-list, $show-variable-groups --><!-- functions: --><!-- normalize-space(), string-length(), contains(), concat() [xpath 1.0] --><xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" test="$page.table_of_contents.show = 'True'" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="root_template_xincludes/page-sequence/table_of_contents.xsl">
  
  <fo:page-sequence master-reference="{$layout.page_master}" font-family="{$layout.font_family}" font-size="{$layout.font_size}">
    
    <fo:flow flow-name="body">
      
      <!-- ====================================== -->
      <!-- TOC heading                            -->
      <!-- ====================================== -->
      
      <fo:block id="toc" font-size="18pt" font-weight="bold" space-before="12mm" text-align="center" space-after="2.5mm">
        <xsl:value-of select="i18n:get('Table_of_Contents')"/>
      </fo:block>
      
      <!-- ====================================== -->
      <!-- actual TOC lines                       -->
      <!-- ====================================== -->
      
      <fo:block margin-left="12mm" margin-right="12mm">
        
        <!-- ============ -->
        <!-- Static lines -->
        <!-- ============ -->
        
        <!-- Overview -->
        <xsl:if test="$page.overview.show = 'True'">
          <fo:block font-size="{$layout.font_size}" text-align-last="justify">
            <fo:basic-link internal-destination="overview" text-decoration="underline" color="blue">
              <xsl:value-of select="i18n:get('Overview')"/>
              <fo:leader leader-pattern="dots"/>
              <fo:page-number-citation ref-id="overview"/>
            </fo:basic-link>
          </fo:block>
        </xsl:if>
        
        <!-- Scope and Coverage -->
        <xsl:if test="$section.scope_and_coverage.show = 'True'">
          <fo:block font-size="{$layout.font_size}" text-align-last="justify">
            <fo:basic-link internal-destination="scope-and-coverage" text-decoration="underline" color="blue">
              <xsl:value-of select="i18n:get('Scope_and_Coverage')"/>
              <fo:leader leader-pattern="dots"/>
              <fo:page-number-citation ref-id="scope-and-coverage"/>
            </fo:basic-link>
          </fo:block>
        </xsl:if>
        
        <!-- Producers and Sponsors -->
        <xsl:if test="$section.producers_and_sponsors.show = 'True'">
          <fo:block font-size="{$layout.font_size}" text-align-last="justify">
            <fo:basic-link internal-destination="producers-and-sponsors" text-decoration="underline" color="blue">
              <xsl:value-of select="i18n:get('Producers_and_Sponsors')"/>
              <fo:leader leader-pattern="dots"/>
              <fo:page-number-citation ref-id="producers-and-sponsors"/>
            </fo:basic-link>
          </fo:block>
        </xsl:if>
        
        <!-- Sampling -->
        <xsl:if test="$section.sampling.show = 'True'">
          <fo:block font-size="{$layout.font_size}" text-align-last="justify">
            <fo:basic-link internal-destination="sampling" text-decoration="underline" color="blue">
              <xsl:value-of select="i18n:get('Sampling')"/>
              <fo:leader leader-pattern="dots"/>
              <fo:page-number-citation ref-id="sampling"/>
            </fo:basic-link>
          </fo:block>
        </xsl:if>
        
        <!-- Data Collection -->
        <xsl:if test="$section.data_collection.show = 'True'">
          <fo:block font-size="{$layout.font_size}" text-align-last="justify">
            <fo:basic-link internal-destination="data-collection" text-decoration="underline" color="blue">
              <xsl:value-of select="i18n:get('Data_Collection')"/>
              <fo:leader leader-pattern="dots"/>
              <fo:page-number-citation ref-id="data-collection"/>
            </fo:basic-link>
          </fo:block>
        </xsl:if>
        
        <!-- Data Processing and Appraisal -->
        <xsl:if test="$section.data_processing_and_appraisal.show = 'True'">
          <fo:block font-size="{$layout.font_size}" text-align-last="justify">
            <fo:basic-link internal-destination="data-processing-and-appraisal" text-decoration="underline" color="blue">
              <xsl:value-of select="i18n:get('Data_Processing_and_Appraisal')"/>
              <fo:leader leader-pattern="dots"/>
              <fo:page-number-citation ref-id="data-processing-and-appraisal"/>
            </fo:basic-link>
          </fo:block>
        </xsl:if>
        
        <!-- Accessibility -->
        <xsl:if test="$section.accessibility.show = 'True'">
          <fo:block font-size="{$layout.font_size}" text-align-last="justify">
            <fo:basic-link internal-destination="accessibility" text-decoration="underline" color="blue">
              <xsl:value-of select="i18n:get('Accessibility')"/>
              <fo:leader leader-pattern="dots"/>
              <fo:page-number-citation ref-id="accessibility"/>
            </fo:basic-link>
          </fo:block>
        </xsl:if>
        
        <!-- Rights and Disclaimer -->
        <xsl:if test="$section.rights_and_disclaimer.show = 'True'">
          <fo:block font-size="{$layout.font_size}" text-align-last="justify">
            <fo:basic-link internal-destination="rights-and-disclaimer" text-decoration="underline" color="blue">
              <xsl:value-of select="i18n:get('Rights_and_Disclaimer')"/>
              <fo:leader leader-pattern="dots"/>
              <fo:page-number-citation ref-id="rights-and-disclaimer"/>
            </fo:basic-link>
          </fo:block>
        </xsl:if>
        
        
        <!-- ============================================================== -->
        <!-- Dynamic lines                                                  -->
        <!-- only one of variable list and variable groups will be rendered -->
        <!-- ============================================================== -->
        
        <!-- Files Description -->
        <xsl:if test="$page.files_description.show = 'True'">
          <fo:block font-size="{$layout.font_size}" text-align-last="justify">
            
            <fo:basic-link internal-destination="files-description" text-decoration="underline" color="blue">
              <xsl:value-of select="i18n:get('Files_Description')"/>
              <fo:leader leader-pattern="dots"/>
              <fo:page-number-citation ref-id="files-description"/>
            </fo:basic-link>
            
            <xsl:for-each select="/codeBook/fileDscr">
              <fo:block margin-left="17mm" font-size="{$layout.font_size}" text-align-last="justify">
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
        <xsl:if test="$page.variables_list.show = 'True'">
          <fo:block font-size="{$layout.font_size}" text-align-last="justify">
            <fo:basic-link internal-destination="variables-list" text-decoration="underline" color="blue">
              <xsl:value-of select="i18n:get('Variables_List')"/>
              
              <fo:leader leader-pattern="dots"/>
              <fo:page-number-citation ref-id="variables-list"/>
            </fo:basic-link>
            <xsl:for-each select="/codeBook/fileDscr">
              <fo:block margin-left="17mm" font-size="{$layout.font_size}" text-align-last="justify">
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
        <xsl:if test="$page.variable_groups.show = 'True'">
          <fo:block font-size="{$layout.font_size}" text-align-last="justify">
            <fo:basic-link internal-destination="variables-groups" text-decoration="underline" color="blue">
              <xsl:value-of select="i18n:get('Variables_Groups')"/>
              <fo:leader leader-pattern="dots"/>
              <fo:page-number-citation ref-id="variables-groups"/>
            </fo:basic-link>
            
            <xsl:for-each select="/codeBook/dataDscr/varGrp">
              <fo:block margin-left="17mm" font-size="{$layout.font_size}" text-align-last="justify">
                <fo:basic-link internal-destination="vargrp-{@ID}" text-decoration="underline" color="blue">
                  <xsl:value-of select="normalize-space(labl)"/>
                  <fo:leader leader-pattern="dots"/>
                  <fo:page-number-citation ref-id="vargrp-{@ID}"/>
                </fo:basic-link>
              </fo:block>              
            </xsl:for-each>
          </fo:block>
        </xsl:if>
        
        <!-- Variables Description -->
        <xsl:if test="$page.variables_description.show = 'True'">
          <fo:block font-size="{$layout.font_size}" text-align-last="justify">
            
            <fo:basic-link internal-destination="variables-description" text-decoration="underline" color="blue">
              <xsl:value-of select="i18n:get('Variables_Description')"/>
              <fo:leader leader-pattern="dots"/>
              <fo:page-number-citation ref-id="variables-description"/>
            </fo:basic-link>
            
            <xsl:for-each select="/codeBook/fileDscr">
              <fo:block margin-left="17mm" font-size="{$layout.font_size}" text-align-last="justify">
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
    <!-- overview.xsl --><!-- =========================================== --><!-- <xsl:if> overview                           --><!-- value: <fo:page-sequence>                   --><!-- =========================================== --><!-- read: --><!-- $layout.start_page_number, $font-family, $color-gray3 --><!-- $layout.tables.border, $layout.tables.cellpadding, $survey-title, $layout.color.gray1, $time --><!-- functions: --><!-- nomalize-space(), position() [Xpath] --><!-- proportional-column-width() [FO] --><!-- i18n:get() [local] --><xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" test="$page.overview.show = 'True'" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="root_template_xincludes/page-sequence/overview.xsl">
  
  <fo:page-sequence master-reference="{$layout.page_master}" initial-page-number="{$layout.start_page_number}" font-family="{$layout.font_family}" font-size="{$layout.font_size}">
    
    <!-- =========================================== -->
    <!-- page header and footer                      -->
    <!-- =========================================== -->
    
    <xsl:call-template name="page_header">
      <xsl:with-param name="section_name" select="i18n:get('Overview')"/>
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
          <fo:table-row background-color="{$layout.color.gray3}">
            <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
              <fo:block font-size="14pt" font-weight="bold">
                <xsl:value-of select="$study.title"/>
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
          <fo:table-row background-color="{$layout.color.gray1}" keep-with-next="always">
            <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
              <fo:block id="overview" font-size="12pt" font-weight="bold">
                <xsl:value-of select="i18n:get('Overview')"/>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
          
          <!-- Type  -->
          <xsl:if test="/codeBook/stdyDscr/citation/serStmt/serName">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:value-of select="i18n:get('Type')"/>                 
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">              
                <fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0mm">
                  <xsl:value-of select="util:trim(/codeBook/stdyDscr/citation/serStmt/serName)"/>
                </fo:block>                
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Identification -->
          <xsl:if test="/codeBook/stdyDscr/citation/titlStmt/IDNo">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:value-of select="i18n:get('Identification')"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/citation/titlStmt/IDNo"/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Version -->
          <xsl:for-each select="/codeBook/stdyDscr/citation/verStmt/version">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:value-of select="i18n:get('Version')"/>
                </fo:block>
              </fo:table-cell>
              
              <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                
                <!-- Production_Date -->
                <xsl:for-each select="/codeBook/stdyDscr/citation/verStmt/version">
                  <xsl:if test="@date">
                    <fo:block>                      
                      <xsl:value-of select="concat(i18n:get('Production_Date'), @date)"/>
                    </fo:block>
                  </xsl:if>
                  <fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0mm">
                    <xsl:value-of select="util:trim(.)"/>
                  </fo:block>                  
                </xsl:for-each>
                
                <!-- Notes -->
                <xsl:for-each select="/codeBook/stdyDscr/citation/verStmt/notes">
                  <fo:block text-decoration="underline">
                    <xsl:value-of select="i18n:get('Notes')"/>
                  </fo:block>
                  <fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0mm">
                    <xsl:value-of select="util:trim(.)"/>
                  </fo:block>
                </xsl:for-each>                
              </fo:table-cell>
            </fo:table-row>
          </xsl:for-each>
          
          <!-- Series -->
          <xsl:if test="/codeBook/stdyDscr/citation/serStmt/serInfo">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:value-of select="i18n:get('Series')"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">       
                <fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0mm">
                  <xsl:value-of select="util:trim(/codeBook/stdyDscr/citation/serStmt/serInfo)"/>
                </fo:block>                
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Abstract -->
          <xsl:if test="/codeBook/stdyDscr/stdyInfo/abstract">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="i18n:get('Abstract')"/>
                </fo:block>              
                <fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0mm">
                  <xsl:value-of select="util:trim(/codeBook/stdyDscr/stdyInfo/abstract)"/>
                </fo:block>                                
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Kind of Data -->
          <xsl:if test="/codeBook/stdyDscr/stdyInfo/sumDscr/dataKind">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:value-of select="i18n:get('Kind_of_Data')"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                
                <xsl:for-each select="/codeBook/stdyDscr/stdyInfo/sumDscr/dataKind">
                
                <!--<fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0mm">
                  <xsl:value-of select="util:trim(/codeBook/stdyDscr/stdyInfo/sumDscr/dataKind)" />
                </fo:block>-->
                
                <fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0mm">
                  <xsl:value-of select="util:trim(.)"/>
                </fo:block>
                
                </xsl:for-each>
                
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Unit of Analysis  -->
          <xsl:if test="/codeBook/stdyDscr/stdyInfo/sumDscr/anlyUnit">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:value-of select="i18n:get('Unit_of_Analysis')"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0mm">
                  <xsl:value-of select="util:trim(/codeBook/stdyDscr/stdyInfo/sumDscr/anlyUnit)"/>
                </fo:block>                                
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
          <!-- Scope and Coverage          -->
          <!-- =========================== -->    
          <!-- heading (two col) -->
          <xsl:if test="$section.scope_and_coverage.show = 'True'">
            <fo:table-row background-color="{$layout.color.gray1}" keep-with-next="always">
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block id="scope-and-coverage" font-size="12pt" font-weight="bold">
                  <xsl:value-of select="i18n:get('Scope_and_Coverage')"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
            
            
            <!-- Scope -->
            <xsl:if test="/codeBook/stdyDscr/stdyInfo/notes">
              <fo:table-row>
                <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block font-weight="bold" text-decoration="underline">
                    <xsl:value-of select="i18n:get('Scope')"/>
                  </fo:block>               
                  <fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0mm">
                    <xsl:value-of select="util:trim(/codeBook/stdyDscr/stdyInfo/notes)"/>
                  </fo:block>
                  
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
            
            <!-- Keywords -->
            <xsl:if test="/codeBook/stdyDscr/stdyInfo/subject/keyword">
              <fo:table-row>
                <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:value-of select="i18n:get('Keywords')"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:for-each select="/codeBook/stdyDscr/stdyInfo/subject/keyword">
                      <xsl:if test="position() &gt; 1">, </xsl:if>
                      <xsl:value-of select="normalize-space(.)"/>
                    </xsl:for-each>
                  </fo:block>
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
            
            <!-- Topics -->
            <xsl:if test="/codeBook/stdyDscr/stdyInfo/subject/topcClas">
              <fo:table-row>
                <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:value-of select="i18n:get('Topics')"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:for-each select="/codeBook/stdyDscr/stdyInfo/subject/topcClas">
                      <xsl:value-of select="if (position() &gt; 1) then ', ' else ()"/>                    
                      <xsl:value-of select="normalize-space(.)"/>
                    </xsl:for-each>
                  </fo:block>
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
            
            <!-- Time_Periods -->
            <xsl:if version="2.0" test="string-length($time) &gt; 3 or string-length($study.time_produced) &gt; 3">
              <fo:table-row>
                <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block font-weight="bold" text-decoration="underline">
                    <xsl:value-of select="i18n:get('Time_Periods')"/>
                  </fo:block>
                </fo:table-cell>
                
                <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <xsl:choose>
                    <xsl:when test="string-length($time) &gt; 3">
                      <fo:block>
                        <xsl:value-of select="$time"/>
                      </fo:block>
                    </xsl:when>
                    <xsl:when test="string-length($study.time_produced) &gt; 3">
                      <fo:block>
                        <xsl:value-of select="$study.time_produced"/>
                      </fo:block>
                    </xsl:when>
                  </xsl:choose>
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
            
            <!-- Countries -->
            <fo:table-row>
              <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="i18n:get('Countries')"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:value-of select="$study.geography"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
            
            <!-- Geographic_Coverage -->
            <xsl:if test="/codeBook/stdyDscr/stdyInfo/sumDscr/geogCover">
              <fo:table-row>
                <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block font-weight="bold" text-decoration="underline">
                    <xsl:value-of select="i18n:get('Geographic_Coverage')"/>
                  </fo:block>              
                  <fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0mm">
                    <xsl:value-of select="util:trim(/codeBook/stdyDscr/stdyInfo/sumDscr/geogCover)"/>
                  </fo:block>                
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
            
            <!-- Universe -->
            <xsl:if test="/codeBook/stdyDscr/stdyInfo/sumDscr/universe">
              <fo:table-row>
                <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block font-weight="bold" text-decoration="underline">
                    <xsl:value-of select="i18n:get('Universe')"/>
                  </fo:block>             
                  <fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0mm">
                    <xsl:value-of select="util:trim(/codeBook/stdyDscr/stdyInfo/sumDscr/universe)"/>
                  </fo:block>                
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
            
            <!-- Space -->
            <fo:table-row height="5mm">
              <fo:table-cell number-columns-spanned="2">
                <fo:block/>
              </fo:table-cell>
            </fo:table-row>
            
          </xsl:if>
          
          <!-- ====================== -->
          <!-- Producers and Sponsors -->
          <!-- ====================== -->
          <!-- heading (two col) -->
          <xsl:if test="$section.producers_and_sponsors.show = 'True'">
            <fo:table-row background-color="{$layout.color.gray1}" keep-with-next="always">
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block id="producers-and-sponsors" font-size="12pt" font-weight="bold">
                  <xsl:value-of select="i18n:get('Producers_and_Sponsors')"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
            
            
            <!-- Primary Investigator(s) -->
            <xsl:if test="/codeBook/stdyDscr/citation/rspStmt/AuthEnty">
              <fo:table-row>
                <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:value-of select="i18n:get('Primary_Investigators')"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <xsl:apply-templates select="/codeBook/stdyDscr/citation/rspStmt/AuthEnty"/>
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
            
            <!-- Other_Producers -->
            <xsl:if test="/codeBook/stdyDscr/citation/prodStmt/producer">
              <fo:table-row>
                <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:value-of select="i18n:get('Other_Producers')"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <xsl:apply-templates select="/codeBook/stdyDscr/citation/prodStmt/producer"/>
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
            
            <!-- Funding_Agencies -->
            <xsl:if test="/codeBook/stdyDscr/citation/prodStmt/fundAg">
              <fo:table-row>
                <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:value-of select="i18n:get('Funding_Agencies')"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <xsl:apply-templates select="/codeBook/stdyDscr/citation/prodStmt/fundAg"/> 
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
            
            <!-- Other Acknowledgements -->
            <xsl:if test="/codeBook/stdyDscr/citation/rspStmt/othId">
              <fo:table-row>
                <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:value-of select="i18n:get('Other_Acknowledgements')"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
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
            
          </xsl:if>
          
          <!-- ======== -->
          <!-- Sampling -->
          <!-- ======== -->
          <!-- heading (two col) -->
          <xsl:if test="$section.sampling.show = 'True'">
            <fo:table-row background-color="{$layout.color.gray1}">
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block id="sampling" font-size="12pt" font-weight="bold">
                  <xsl:value-of select="i18n:get('Sampling')"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
            
            
            <!-- Sampling Procedure -->
            <xsl:if test="/codeBook/stdyDscr/method/dataColl/sampProc">
              <fo:table-row>
                <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block font-weight="bold" text-decoration="underline">
                    <xsl:value-of select="i18n:get('Sampling_Procedure')"/>
                  </fo:block>              
                  <fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0mm">
                    <xsl:value-of select="util:trim(/codeBook/stdyDscr/method/dataColl/sampProc)"/>
                  </fo:block>                
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
            
            <!-- Deviations_from_Sample_Design -->
            <xsl:if test="/codeBook/stdyDscr/method/dataColl/deviat">
              <fo:table-row>
                <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block font-weight="bold" text-decoration="underline">
                    <xsl:value-of select="i18n:get('Deviations_from_Sample_Design')"/>
                  </fo:block>               
                  <fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0mm">
                    <xsl:value-of select="util:trim(/codeBook/stdyDscr/method/dataColl/deviat)"/>
                  </fo:block>                                
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
            
            <!-- Response_Rate -->
            <xsl:if test="/codeBook/stdyDscr/method/anlyInfo/respRate">
              <fo:table-row>
                <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block font-weight="bold" text-decoration="underline">
                    <xsl:value-of select="i18n:get('Response_Rate')"/>
                  </fo:block>                
                  <fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0mm">
                    <xsl:value-of select="util:trim(/codeBook/stdyDscr/method/anlyInfo/respRate)"/>
                  </fo:block>                  
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
            
            <!-- Weighting -->
            <xsl:if test="/codeBook/stdyDscr/method/dataColl/weight">
              <fo:table-row>
                <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block font-weight="bold" text-decoration="underline">
                    <xsl:value-of select="i18n:get('Weighting')"/>
                  </fo:block>                
                  <fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0mm">
                    <xsl:value-of select="util:trim(/codeBook/stdyDscr/method/dataColl/weight)"/>
                  </fo:block>                  
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
            
            <!-- Space -->
            <fo:table-row height="5mm">
              <fo:table-cell number-columns-spanned="2">
                <fo:block/>
              </fo:table-cell>
            </fo:table-row>
            
          </xsl:if>
          
          <!-- =============== -->
          <!-- Data Collection -->
          <!-- =============== -->
          <!-- heading (two col) -->
          <xsl:if test="$section.data_collection.show = 'True'">
            <fo:table-row background-color="{$layout.color.gray1}" keep-with-next="always">
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block id="data-collection" font-size="12pt" font-weight="bold">
                  <xsl:value-of select="i18n:get('Data_Collection')"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
            
            
            <!-- Data Collection Dates -->
            <xsl:if test="/codeBook/stdyDscr/stdyInfo/sumDscr/collDate">
              <fo:table-row>
                <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:value-of select="i18n:get('Data_Collection_Dates')"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <xsl:apply-templates select="/codeBook/stdyDscr/stdyInfo/sumDscr/collDate"/>
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
            
            <!-- Time Periods -->
            <xsl:if test="/codeBook/stdyDscr/stdyInfo/sumDscr/timePrd">
              <fo:table-row>
                <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:value-of select="i18n:get('Time_Periods')"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <xsl:apply-templates select="/codeBook/stdyDscr/stdyInfo/sumDscr/timePrd"/>
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
            
            <!-- Data Collection Mode -->
            <xsl:if test="/codeBook/stdyDscr/method/dataColl/collMode">
              <fo:table-row>
                <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:value-of select="i18n:get('Data_Collection_Mode')"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">               
                  <fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0mm">
                    <xsl:value-of select="util:trim(/codeBook/stdyDscr/method/dataColl/collMode)"/>
                  </fo:block>                
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
            
            <!-- Data Collection Notes -->
            <xsl:if test="/codeBook/stdyDscr/method/notes[@subject = 'collection']">
              <fo:table-row>
                <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block font-weight="bold" text-decoration="underline">
                    <xsl:value-of select="i18n:get('Data_Collection_Notes')"/>
                  </fo:block>
                  <xsl:apply-templates select="/codeBook/stdyDscr/method/notes[@subject = 'collection']"/>
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
            
            <!-- Data Processing Notes -->
            <xsl:if test="/codeBook/stdyDscr/method/notes[@subject = 'processing']">
              <fo:table-row>
                <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block font-weight="bold" text-decoration="underline">
                    <xsl:value-of select="i18n:get('Data_Processing_Notes')"/>
                  </fo:block>
                  <xsl:apply-templates select="/codeBook/stdyDscr/method/notes[@subject = 'collection']"/>
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
            
            <!-- Data Cleaning Notes -->
            <xsl:if test="/codeBook/stdyDscr/method/notes[@subject = 'cleaning']">
              <fo:table-row>
                <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block font-weight="bold" text-decoration="underline">
                    <xsl:value-of select="i18n:get('Data_Cleaning_Notes')"/>
                  </fo:block>
                  <xsl:apply-templates select="/codeBook/stdyDscr/method/notes[@subject = 'collection']"/>
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
            
            <!-- Data Collection Notes -->
            <xsl:if test="/codeBook/stdyDscr/method/dataColl/collSitu">
              <fo:table-row>
                <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block font-weight="bold" text-decoration="underline">
                    <xsl:value-of select="i18n:get('Data_Collection_Notes')"/>
                  </fo:block>               
                  <fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0mm">
                    <xsl:value-of select="util:trim(/codeBook/stdyDscr/method/dataColl/collSitu)"/>
                  </fo:block>               
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
            
            <!-- Questionnaires -->
            <xsl:if test="/codeBook/stdyDscr/method/dataColl/resInstru">
              <fo:table-row>
                <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block font-weight="bold" text-decoration="underline">
                    <xsl:value-of select="i18n:get('Questionnaires')"/>
                  </fo:block>               
                  <fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0mm">
                    <xsl:value-of select="util:trim(/codeBook/stdyDscr/method/dataColl/resInstru)"/>
                  </fo:block>                
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
            
            <!-- Data Collectors -->
            <xsl:if test="/codeBook/stdyDscr/method/dataColl/dataCollector">
              <fo:table-row>
                <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:value-of select="i18n:get('Data_Collectors')"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <xsl:apply-templates select="/codeBook/stdyDscr/method/dataColl/dataCollector"/>
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
            
            <!-- Supervision -->
            <xsl:if test="/codeBook/stdyDscr/method/dataColl/actMin">
              <fo:table-row>
                <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block font-weight="bold" text-decoration="underline">
                    <xsl:value-of select="i18n:get('Supervision')"/>
                  </fo:block>               
                  <fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0mm">
                    <xsl:value-of select="util:trim(/codeBook/stdyDscr/method/dataColl/actMin)"/>
                  </fo:block>                
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
            
            <!-- Space -->
            <fo:table-row height="5mm">
              <fo:table-cell number-columns-spanned="2">
                <fo:block/>
              </fo:table-cell>
            </fo:table-row>
            
          </xsl:if>
          
          <!-- ============================= -->
          <!-- Data Processing and Appraisal -->
          <!-- ============================= -->
          <!-- heading (two col) -->
          <xsl:if test="$section.data_processing_and_appraisal.show = 'True'">
            <fo:table-row background-color="{$layout.color.gray1}" keep-with-next="always">
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block id="data-processing-and-appraisal" font-size="12pt" font-weight="bold">
                  <xsl:value-of select="i18n:get('Data_Processing_and_Appraisal')"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
            
            
            <!-- Data Editing -->
            <xsl:if test="/codeBook/stdyDscr/method/dataColl/cleanOps">
              <fo:table-row>
                <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block font-weight="bold" text-decoration="underline">
                    <xsl:value-of select="i18n:get('Data_Editing')"/>
                  </fo:block>              
                  <fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0mm">
                    <xsl:value-of select="util:trim(/codeBook/stdyDscr/method/dataColl/cleanOps)"/>
                  </fo:block>
                  
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
            
            <!-- Other Processing -->
            <xsl:if test="/codeBook/stdyDscr/method/notes">
              <fo:table-row>
                <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block font-weight="bold" text-decoration="underline">
                    <xsl:value-of select="i18n:get('Other_Processing')"/>
                  </fo:block>               
                  <fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0mm">
                    <xsl:value-of select="util:trim(/codeBook/stdyDscr/method/notes)"/>
                  </fo:block>                
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
            
            <!-- Estimates of Sampling Error -->
            <xsl:if test="/codeBook/stdyDscr/method/anlyInfo/EstSmpErr">
              <fo:table-row>
                <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block font-weight="bold" text-decoration="underline">
                    <xsl:value-of select="i18n:get('Estimates_of_Sampling_Error')"/>
                  </fo:block>
                  <fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0mm">
                    <xsl:value-of select="util:trim(/codeBook/stdyDscr/method/anlyInfo/EstSmpErr)"/>
                  </fo:block>                                                 
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
            
            <!-- Other Forms of Data Appraisal -->
            <xsl:if test="/codeBook/stdyDscr/method/anlyInfo/dataAppr">
              <fo:table-row>
                <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block font-weight="bold" text-decoration="underline">
                    <xsl:value-of select="i18n:get('Other_Forms_of_Data_Appraisal')"/>
                  </fo:block>                
                  <fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0mm">
                    <xsl:value-of select="util:trim(/codeBook/stdyDscr/method/anlyInfo/dataAppr)"/>
                  </fo:block>                 
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
            
            <!-- Space -->
            <fo:table-row height="5mm">
              <fo:table-cell number-columns-spanned="2">
                <fo:block/>
              </fo:table-cell>
            </fo:table-row>
            
          </xsl:if>
          
          <!-- ============ -->
          <!-- Accesibility -->
          <!-- ============ -->
          <!-- heading (2 col) -->
          <xsl:if test="$section.accessibility.show = 'True'">
            <fo:table-row background-color="{$layout.color.gray1}" keep-with-next="always">
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block id="accessibility" font-size="12pt" font-weight="bold">
                  <xsl:value-of select="i18n:get('Accessibility')"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
            
            
            <!-- Access Authority -->
            <xsl:if test="/codeBook/stdyDscr/dataAccs/useStmt/contact">
              <fo:table-row>
                <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:value-of select="i18n:get('Access_Authority')"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <xsl:apply-templates select="/codeBook/stdyDscr/dataAccs/useStmt/contact"/>
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
            
            <!-- Contacts -->
            <xsl:if test="/codeBook/stdyDscr/citation/distStmt/contact">
              <fo:table-row>
                <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:value-of select="i18n:get('Contacts')"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <xsl:apply-templates select="/codeBook/stdyDscr/citation/distStmt/contact"/>
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
            
            <!-- Distributors -->
            <xsl:if test="/codeBook/stdyDscr/citation/distStmt/distrbtr">
              <fo:table-row>
                <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:value-of select="i18n:get('Distributors')"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">                
                  <fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0mm">
                    <xsl:value-of select="util:trim(/codeBook/stdyDscr/citation/distStmt/distrbtr)"/>
                  </fo:block>                   
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
            
            <!-- Depositors (DDP) -->
            <xsl:if test="/codeBook/stdyDscr/citation/distStmt/depositr">
              <fo:table-row>
                <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:value-of select="i18n:get('Depositors')"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">                
                  <fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0mm">
                    <xsl:value-of select="util:trim(/codeBook/stdyDscr/citation/distStmt/depositr)"/>
                  </fo:block>                                                                                
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
            
            <!-- Confidentiality -->
            <xsl:if test="/codeBook/stdyDscr/dataAccs/useStmt/confDec">
              <fo:table-row>
                <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block font-weight="bold" text-decoration="underline">
                    <xsl:value-of select="i18n:get('Confidentiality')"/>
                  </fo:block>
                  <fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0mm">
                    <xsl:value-of select="util:trim(/codeBook/stdyDscr/dataAccs/useStmt/confDec)"/>
                  </fo:block>                                                                                
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
            
            <!-- Access Conditions -->
            <xsl:if test="/codeBook/stdyDscr/dataAccs/useStmt/conditions">
              <fo:table-row>
                <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block font-weight="bold" text-decoration="underline">
                    <xsl:value-of select="i18n:get('Access_Conditions')"/>
                  </fo:block>    
                  <fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0mm">
                    <xsl:value-of select="util:trim(/codeBook/stdyDscr/dataAccs/useStmt/conditions)"/>
                  </fo:block>                                                              
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
            
            <!-- Citation Requierments -->
            <xsl:if test="/codeBook/stdyDscr/dataAccs/useStmt/citReq">
              <fo:table-row>
                <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block font-weight="bold" text-decoration="underline">
                    <xsl:value-of select="i18n:get('Citation_Requirements')"/>
                  </fo:block>
                  <fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0mm">
                    <xsl:value-of select="util:trim(/codeBook/stdyDscr/dataAccs/useStmt/citReq)"/>
                  </fo:block>                                                
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
            
            <!-- Space -->
            <fo:table-row height="5mm">
              <fo:table-cell number-columns-spanned="2">
                <fo:block/>
              </fo:table-cell>
            </fo:table-row>
            
          </xsl:if>
          
          <!-- ===================== -->
          <!-- Rights and Disclaimer -->
          <!-- ===================== -->
          <!-- heading (2 col) -->
          <xsl:if test="$section.rights_and_disclaimer.show = 'True'">
            <fo:table-row background-color="{$layout.color.gray1}" keep-with-next="always">
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block id="rights-and-disclaimer" font-size="12pt" font-weight="bold">
                  <xsl:value-of select="i18n:get('Rights_and_Disclaimer')"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
            
            
            <!-- Disclaimer -->
            <xsl:if test="/codeBook/stdyDscr/dataAccs/useStmt/disclaimer">
              <fo:table-row>
                <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block font-weight="bold" text-decoration="underline">
                    <xsl:value-of select="i18n:get('Disclaimer')"/>
                  </fo:block>
                  <fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0mm">
                    <xsl:value-of select="util:trim(/codeBook/stdyDscr/dataAccs/useStmt/disclaimer)"/>
                  </fo:block>                                
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
            
            <!-- Copyright -->
            <xsl:if test="/codeBook/stdyDscr/citation/prodStmt/copyright">
              <fo:table-row>
                <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:value-of select="i18n:get('Copyright')"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">              
                  <fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0mm">
                    <xsl:value-of select="util:trim(/codeBook/stdyDscr/citation/prodStmt/copyright)"/>
                  </fo:block>                
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
            
          </xsl:if>
          
        </fo:table-body>
      </fo:table>
    </fo:flow>
  </fo:page-sequence>
</xsl:if>
    <!-- files_description.xsl --><!-- ============================= --><!-- <xsl:if> files description    --><!-- value: <fo:page-sequence>     --><!-- ============================= --><!-- read: --><!-- $page-layout, $strings, $font-family, $font-size, $header-font-size --><!-- functions --><!-- count() [xpath 1.0] --><xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" test="$page.files_description.show = 'True'" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="root_template_xincludes/page-sequence/files_description.xsl">

  <fo:page-sequence master-reference="{$layout.page_master}" font-family="{$layout.font_family}" font-size="{$layout.font_size}">

    <!-- =========================================== -->
    <!-- page header and footer                      -->
    <!-- =========================================== -->
    <xsl:call-template name="page_header">
      <xsl:with-param name="section_name" select="i18n:get('Files_Description')"/>
    </xsl:call-template>

    <xsl:call-template name="page_footer"/>

    <!-- =========================================== -->
    <!-- page content                                -->
    <!-- =========================================== -->
    <fo:flow flow-name="body">

      <!-- heading -->
      <fo:block id="files-description" font-size="18pt" font-weight="bold" space-after="2.5mm">
        <xsl:value-of select="i18n:get('Files_Description')"/>
      </fo:block>

      <!-- number of files in data set -->
      <fo:block font-weight="bold">        
        <xsl:value-of select="concat(i18n:get('Dataset_contains'), ' ', xs:string(count(/codeBook/fileDscr)), ' ', i18n:get('files')) "/>        
      </fo:block>

      <!-- fileDscr -->
<!--  <xsl:apply-templates select="/codeBook/fileDscr" />-->
      
      <xsl:for-each select="/codeBook/fileDscr">
        <!-- ===================== -->
        <!-- variables             -->
        <!-- ===================== -->
        <xsl:variable name="fileId" select="if (fileTxt/fileName/@ID) then fileTxt/fileName/@ID           else if (@ID) then @ID           else () "/>
        
        <!-- =================== -->
        <!-- content             -->
        <!-- =================== -->
        <fo:table id="file-{$fileId}" table-layout="fixed" width="100%" space-before="5mm" space-after="5mm">
          <fo:table-column column-width="proportional-column-width(20)"/>
          <fo:table-column column-width="proportional-column-width(80)"/>
          
          <fo:table-body>
            
            <!-- Filename -->
            <fo:table-row background-color="{$layout.color.gray1}" keep-with-next="always">
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-size="12pt" font-weight="bold">
                  <xsl:apply-templates select="/codeBook/fileDscr/fileTxt/fileName"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
            
            <!-- Cases -->
            <xsl:if test="/codeBook/fileDscr/fileTxt/dimensns/caseQnty">
              <fo:table-row>
                <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:value-of select="i18n:get('Cases')"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">           
                  <fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0mm">
                    <xsl:value-of select="util:trim(/codeBook/fileDscr/fileTxt/dimensns/caseQnty)"/>
                  </fo:block>            
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
            
            <!-- Variables -->
            <xsl:if test="/codeBook/fileDscr/fileTxt/dimensns/varQnty">
              <fo:table-row>
                <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:value-of select="i18n:get('Variables')"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0mm">
                    <xsl:value-of select="util:trim(/codeBook/fileDscr/fileTxt/dimensns/varQnty)"/>
                  </fo:block>            
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
            
            <!-- File structure -->
            <xsl:if test="/codeBook/fileDscr/fileTxt/fileStrc">
              <fo:table-row>
                
                <!-- File_Structure -->
                <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:value-of select="i18n:get('File_Structure')"/>
                  </fo:block>
                </fo:table-cell>
                
                <!-- Type -->
                <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <xsl:if test="/codeBook/fileDscr/fileTxt/fileStrc/@type">
                    <fo:block>
                      <xsl:value-of select="i18n:get('Type')"/>
                      <xsl:text>:</xsl:text>
                      <xsl:value-of select="/codeBook/fileDscr/fileTxt/fileStrc/@type"/>
                    </fo:block>
                  </xsl:if>
                  
                  <xsl:if test="/codeBook/fileDscr/fileTxt/fileStrc/recGrp/@keyvar">
                    <fo:block>
                      <xsl:value-of select="i18n:get('Keys')"/>
                      <xsl:text>: </xsl:text>
                      <xsl:variable name="list" select="concat(/codeBook/fileDscr/fileTxt/fileStrc/recGrp/@keyvar,' ')"/>
                      
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
            <xsl:for-each select="/codeBook/fileDscr/fileTxt/fileCont">
              <fo:table-row>
                <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block font-weight="bold" text-decoration="underline">
                    <xsl:value-of select="i18n:get('File_Content')"/>
                  </fo:block>
                  <xsl:apply-templates select="."/>
                </fo:table-cell>
              </fo:table-row>
            </xsl:for-each>
            
            <!-- Producer -->
            <xsl:for-each select="/codeBook/fileDscr/fileTxt/filePlac">
              <fo:table-row>
                <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block font-weight="bold" text-decoration="underline">
                    <xsl:value-of select="i18n:get('Producer')"/>
                  </fo:block>
                  <xsl:apply-templates select="."/>
                </fo:table-cell>
              </fo:table-row>
            </xsl:for-each>
            
            <!-- Version -->
            <xsl:for-each select="/codeBook/fileDscr/fileTxt/verStmt">
              <fo:table-row>
                <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block font-weight="bold" text-decoration="underline">
                    <xsl:value-of select="i18n:get('Version')"/>
                  </fo:block>
                  <xsl:apply-templates select="."/>
                </fo:table-cell>
              </fo:table-row>
            </xsl:for-each>
            
            <!-- Processing Checks -->
            <xsl:for-each select="/codeBook/fileDscr/fileTxt/dataChck">
              <fo:table-row>
                <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block font-weight="bold" text-decoration="underline">
                    <xsl:value-of select="i18n:get('Processing_Checks')"/>
                  </fo:block>
                  <xsl:apply-templates select="."/>
                </fo:table-cell>
              </fo:table-row>
            </xsl:for-each>
            
            <!-- Missing Data -->
            <xsl:for-each select="/codeBook/fileDscr/fileTxt/dataMsng">
              <fo:table-row>
                <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block font-weight="bold" text-decoration="underline">
                    <xsl:value-of select="i18n:get('Missing_Data')"/>
                  </fo:block>
                  <xsl:apply-templates select="."/>
                </fo:table-cell>
              </fo:table-row>
            </xsl:for-each>
            
            <!-- Notes -->
            <xsl:for-each select="notes">
              <fo:table-row>
                <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block font-weight="bold" text-decoration="underline">
                    <xsl:value-of select="i18n:get('Notes')"/>
                  </fo:block>
                  <xsl:apply-templates select="."/>
                </fo:table-cell>
              </fo:table-row>
            </xsl:for-each>
            
          </fo:table-body>
        </fo:table>
                        
      </xsl:for-each>
      
      
    </fo:flow>
  </fo:page-sequence>
</xsl:if>
    <!-- variables_list.xsl --><!-- ===================================== --><!-- <xsl:if> variables list               --><!-- value: <fo:page-sequence>             --><!-- ===================================== --><!-- read: --><!-- $layout.page_master --><!-- $layout.font_family, $layout.font_size, --><!-- $layout.tables.cellpadding, $layout.tables.border --><!-- $limits.variable_name_length --><!-- $fileId --><!-- functions: --><!-- count() [Xpath 1.0] --><xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" test="$page.variables_list.show = 'True'" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="root_template_xincludes/page-sequence/variables_list.xsl">

  <fo:page-sequence master-reference="{$layout.page_master}" font-family="{$layout.font_family}" font-size="{$layout.font_size}">

    <!-- =========================================== -->
    <!-- page header                                 -->
    <!-- =========================================== -->
    <xsl:call-template name="page_header">
      <xsl:with-param name="section_name" select="i18n:get('Variables_List')"/>
    </xsl:call-template>

    <xsl:call-template name="page_footer"/>


    <!-- =========================================== -->
    <!-- page content                                -->
    <!-- =========================================== -->
    <fo:flow flow-name="body">

      <!-- Heading -->
      <fo:block id="variables-list" font-size="18pt" font-weight="bold" space-after="2.5mm">
        <xsl:value-of select="i18n:get('Variables_List')"/>        
      </fo:block>

      <!-- number of groups in data set -->      
      <fo:block font-weight="bold">
        <xsl:value-of select="concat(i18n:get('Dataset_contains'), ' ', xs:string(count(/codeBook/dataDscr/var)), ' ', i18n:get('variables')) "/>       
      </fo:block>

      <!-- the actual tables -->
<!--  <xsl:apply-templates select="/codeBook/fileDscr" mode="variables-list" />-->
      
      <xsl:for-each select="/codeBook/fileDscr">
        <!-- variables -->
        <xsl:variable name="fileId" select="if (fileTxt/fileName/@ID) then fileTxt/fileName/@ID           else if (@ID) then @ID           else () "/>
        
        <!-- content -->
        <fo:table id="varlist-{fileTxt/fileName/@ID}" table-layout="fixed" width="100%" font-size="8pt" space-before="5mm" space-after="5mm">
          
          <fo:table-column column-width="proportional-column-width( 5)"/>
          <fo:table-column column-width="proportional-column-width(12)"/>
          <fo:table-column column-width="proportional-column-width(20)"/>
          <fo:table-column column-width="proportional-column-width(27)"/>
          
          <!-- ============ -->
          <!-- table header -->
          <!-- ============ -->
          <fo:table-header>
            <fo:table-row text-align="center" vertical-align="top" keep-with-next="always">
              <fo:table-cell text-align="left" number-columns-spanned="4" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-size="12pt" font-weight="bold">
                  <xsl:value-of select="i18n:get('File')"/>
                  <xsl:text> </xsl:text>
                  <xsl:apply-templates select="fileTxt/fileName"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
            
            <fo:table-row text-align="center" vertical-align="top" font-weight="bold" keep-with-next="always">
              
              <!-- Col 1: blank character -->
              <fo:table-cell border="{$layout.tables.border}" padding="3pt">
                <fo:block/>
              </fo:table-cell>
              
              <!-- Col 2: Name -->
              <fo:table-cell border="{$layout.tables.border}" padding="3pt">
                <fo:block>
                  <xsl:value-of select="i18n:get('Name')"/>
                </fo:block>
              </fo:table-cell>
              
              <!-- Col 3: Label -->
              <fo:table-cell border="{$layout.tables.border}" padding="3pt">
                <fo:block>
                  <xsl:value-of select="i18n:get('Label')"/>
                </fo:block>
              </fo:table-cell>
              
              <!-- Col 4: Question -->
              <fo:table-cell border="{$layout.tables.border}" padding="3pt">
                <fo:block>
                  <xsl:value-of select="i18n:get('Question')"/>
                </fo:block>
              </fo:table-cell>
              
            </fo:table-row>
          </fo:table-header>
          
          <!-- =============================== -->
          <!-- table rows (the actual content) -->
          <!-- =============================== -->
          <fo:table-body>
<!--        <xsl:apply-templates select="/codeBook/dataDscr/var[@files = $fileId]" mode="variables-list"/>-->
            
            <xsl:for-each select="/codeBook/dataDscr/var[@files = $fileId]">
              
              <fo:table-row text-align="center" vertical-align="top">
                
                <!-- Col 1: Variable Position -->
                <fo:table-cell text-align="center" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:value-of select="position()"/>
                  </fo:block>
                </fo:table-cell>
                
                <!-- Col 2: Variable Name-->
                <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:choose>
                      <xsl:when test="$page.variables_list.show = 'True'">
                        <fo:basic-link internal-destination="var-{@ID}" text-decoration="underline" color="blue">
                          <xsl:if test="string-length(@name) &gt; 10">
                            <xsl:value-of select="substring(./@name, 0, $limits.variable_name_length)"/> ..
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
                
                <!-- Col 3: Variable Label -->
                <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:value-of select="if (./labl) then normalize-space(./labl) else '-' "/>          
                  </fo:block>
                </fo:table-cell>
                
                <!-- Col 4: Variable literal question -->
                <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:value-of select="if (./qstn/qstnLit) then normalize-space(./qstn/qstnLit) else '-' "/>
                  </fo:block>
                </fo:table-cell>
                
              </fo:table-row>                
            </xsl:for-each>
            
          </fo:table-body>
        </fo:table>                
      </xsl:for-each>
            
    </fo:flow>
  </fo:page-sequence>
</xsl:if>
    <!-- variable_groups.xsl --><!-- ================================================ --><!-- <xsl:if> variable groups                         --><!-- value: <fo:page-sequence>                        --><!-- ================================================ --><!-- read: --><!-- $font-family, $number-of-groups --><!-- functions: --><!-- string-length(), count() [xpath 1.0] --><xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" test="$page.variable_groups.show = 'True'" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="root_template_xincludes/page-sequence/variable_groups.xsl">

  <fo:page-sequence master-reference="{$layout.page_master}" font-family="{$layout.font_family}" font-size="{$layout.font_size}">
    
    <!-- =========================================== -->
    <!-- page header and footer                      -->
    <!-- =========================================== -->
    <xsl:call-template name="page_header">
      <xsl:with-param name="section_name" select="i18n:get('Variables_Groups')"/>
    </xsl:call-template>
  
    <xsl:call-template name="page_footer"/>

    <!-- =========================================== -->
    <!-- page content                                 -->
    <!-- =========================================== -->    
    <fo:flow flow-name="body">

      <!-- heading -->
      <fo:block id="variables-groups" font-size="18pt" font-weight="bold" space-after="2.5mm">
        <xsl:value-of select="i18n:get('Variables_Groups')"/>
      </fo:block>

      <!-- number of variable groups in data set -->      
      <fo:block font-weight="bold">
        <xsl:value-of select="concat(i18n:get('Dataset_contains'), ' ', xs:string(count(/codeBook/dataDscr/varGrp)), ' ', i18n:get('groups')) "/>       
      </fo:block>
      
      
      <!-- ================================ -->
      <!-- the actual variable groups table -->
      <!-- ================================ -->
      <!-- <xsl:apply-templates select="/codeBook/dataDscr/varGrp" /> -->
      
      <xsl:for-each select="/codeBook/dataDscr/varGrp">
        <fo:table id="vargrp-{@ID}" table-layout="fixed" width="100%" space-before="5mm">
          <fo:table-column column-width="proportional-column-width(20)"/>
          <fo:table-column column-width="proportional-column-width(80)"/>
          
          <fo:table-body>
            
            <!-- Group -->
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-size="12pt" font-weight="bold">
                  <xsl:value-of select="normalize-space(labl)"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
            
            <!-- Text -->
            <xsl:for-each select="txt">
              <fo:table-row>
                <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <xsl:apply-templates select="."/>
                </fo:table-cell>
              </fo:table-row>
            </xsl:for-each>
            
            <!-- Definition -->
            <xsl:for-each select="defntn">
              <fo:table-row>
                <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block font-weight="bold" text-decoration="underline">
                    <xsl:value-of select="i18n:get('Definition')"/>
                  </fo:block>
                  <xsl:apply-templates select="."/>
                </fo:table-cell>
              </fo:table-row>
            </xsl:for-each>
            
            <!-- Universe-->
            <xsl:for-each select="universe">
              <fo:table-row>
                <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block font-weight="bold" text-decoration="underline">
                    <xsl:value-of select="i18n:get('Universe')"/>
                  </fo:block>
                  <xsl:apply-templates select="."/>
                </fo:table-cell>
              </fo:table-row>
            </xsl:for-each>
            
            <!-- Notes -->
            <xsl:for-each select="notes">
              <fo:table-row>
                <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block font-weight="bold" text-decoration="underline">
                    <xsl:value-of select="i18n:get('Notes')"/>
                  </fo:block>
                  <xsl:apply-templates select="."/>
                </fo:table-cell>
              </fo:table-row>
            </xsl:for-each>
            
            <!-- Subgroups -->
            <xsl:if test="./@varGrp">
              <fo:table-row>
                <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:value-of select="i18n:get('Subgroups')"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:variable name="list" select="concat(./@varGrp,' ')"/>
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
                
                <!-- blank character -->
                <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:text/>
                  </fo:block>
                </fo:table-cell>
                
                <!-- Name -->
                <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:value-of select="i18n:get('Name')"/>
                  </fo:block>
                </fo:table-cell>
                
                <!-- Label -->
                <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:value-of select="i18n:get('Label')"/>
                  </fo:block>
                </fo:table-cell>
                
                <!-- Question -->
                <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:value-of select="i18n:get('Question')"/>
                  </fo:block>
                </fo:table-cell>         
                
              </fo:table-row>
            </fo:table-header>
            
            <!-- ========== -->
            <!-- table body -->
            <!-- ========== -->
            <fo:table-body>
              <xsl:variable name="list" select="concat(./@var,' ')"/>
              <!--<xsl:apply-templates select="/codeBook/dataDscr/var[ contains($list, concat(@ID,' ')) ]"
                                   mode="variables-list"/>-->
              
              <xsl:for-each select="/codeBook/dataDscr/var[ contains($list, concat(@ID,' ')) ]">
                <!-- content -->
                <fo:table-row text-align="center" vertical-align="top">
                  
                  <!-- Row 1: Variable Position -->
                  <fo:table-cell text-align="center" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                    <fo:block>
                      <xsl:value-of select="position()"/>
                    </fo:block>
                  </fo:table-cell>
                  
                  <!-- Row 2: Variable Name-->
                  <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                    <fo:block>
                      <xsl:choose>
                        <xsl:when test="$page.variables_list.show = 'True'">
                          <fo:basic-link internal-destination="var-{@ID}" text-decoration="underline" color="blue">
                            <xsl:if test="string-length(@name) &gt; 10">
                              <xsl:value-of select="substring(./@name, 0, $limits.variable_name_length)"/>
                              <xsl:text> ..</xsl:text>
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
                  
                  <!-- Row 3: Variable Label -->
                  <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                    <fo:block>
                      <!--          <xsl:value-of select="if (normalize-space(./labl)) then normalize-space(./labl) else '-' "/>-->
                      <xsl:value-of select="if (./labl) then normalize-space(./labl) else '-' "/> 
                    </fo:block>
                  </fo:table-cell>
                  
                  <!-- Row 4: Variable literal question -->
                  <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                    <fo:block>
                      <xsl:value-of select="if (./qstn/qstnLit) then normalize-space(./qstn/qstnLit) else '-' "/>
                    </fo:block>
                  </fo:table-cell>
                  
                </fo:table-row>                                                
              </xsl:for-each>
              
              
            </fo:table-body>
          </fo:table>
          
        </xsl:if>                
      </xsl:for-each>
      

    </fo:flow>
  </fo:page-sequence>
</xsl:if>
    <!-- variables_description.xsl --><!-- ==================================================== --><!-- <xsl:if> variables description                       --><!-- value: <fo:page-sequence>                            --><!-- ==================================================== --><!-- read: --><!-- $font-family --><!-- functions: --><!-- count(), string-length() [Xpath 1.0] --><xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" test="$page.variables_description.show = 'True'" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="root_template_xincludes/page-sequence/variables_description.xsl">

  <fo:page-sequence master-reference="{$layout.page_master}" font-family="{$layout.font_family}" font-size="{$layout.font_size}">

    <!-- =========================================== -->
    <!-- page header                                 -->
    <!-- =========================================== -->
    <xsl:call-template name="page_header">
      <xsl:with-param name="section_name" select="i18n:get('Variables_Description')"/>
    </xsl:call-template>

    <xsl:call-template name="page_footer"/>

    <!-- =========================================== -->
    <!-- page content                                -->
    <!-- =========================================== -->
    <fo:flow flow-name="body">

      <!-- heading -->
      <fo:block id="variables-description" font-size="18pt" font-weight="bold" space-after="2.5mm">
        <xsl:value-of select="i18n:get('Variables_Description')"/>
      </fo:block>

      <!-- number of variables in data set -->
      <fo:block font-weight="bold">
        <xsl:value-of select="concat(i18n:get('Dataset_contains'), ' ', xs:string(count(/codeBook/dataDscr/var)), ' ', i18n:get('variables')) "/>       
      </fo:block>

    </fo:flow>
  </fo:page-sequence>

  <!-- fileDscr -->
<!--  <xsl:apply-templates select="/codeBook/fileDscr" mode="variables-description" />-->
  
  <xsl:for-each select="/codeBook/fileDscr">
    <!-- ================== -->
    <!-- variables          -->
    <!-- ================== -->
    
    <!-- fileName ID attribute / ID attribute -->  
    <xsl:variable name="fileId" select="if (fileTxt/fileName/@ID) then fileTxt/fileName/@ID       else if (@ID) then @ID       else () "/>
    
    <xsl:variable name="fileName" select="fileTxt/fileName"/>
    
    <!-- ===================== -->
    <!-- content               -->
    <!-- ===================== -->
    
    <xsl:for-each select="/codeBook/dataDscr/var[@files = $fileId][position() mod $layout.chunk_size = 1]">
      
      <fo:page-sequence master-reference="{$layout.page_master}" font-family="{$layout.font_family}" font-size="{$layout.font_size}">
        
        <!-- =========== -->
        <!-- page footer -->
        <!-- =========== -->
        <xsl:call-template name="page_footer"/>
        
        <!-- =========== -->
        <!-- page body   -->
        <!-- =========== -->
        <fo:flow flow-name="body">
          
          <!-- [fo:table] Header -->
          <!-- (only written if at the start of file) -->
          <xsl:if test="position() = 1">
            <fo:table id="vardesc-{$fileId}" table-layout="fixed" width="100%" font-size="8pt">
              <fo:table-column column-width="proportional-column-width(100)"/> <!-- column width -->
              
              <!-- [fo:table-header] -->
              <fo:table-header space-after="5mm">
                
                <!-- [fo:table-row] File identification -->
                <fo:table-row text-align="center" vertical-align="top">
                  <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                    <fo:block font-size="14pt" font-weight="bold">
                      <xsl:value-of select="i18n:get('File')"/>
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
                <xsl:apply-templates select=".|following-sibling::var[@files=$fileId][$layout.chunk_size &gt; position()]"/>
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
                <xsl:apply-templates select=".|following-sibling::var[@files=$fileId][$layout.chunk_size &gt; position()]"/>
              </fo:table-body>
            </fo:table>
          </xsl:if>
          
        </fo:flow>
      </fo:page-sequence>
    </xsl:for-each>
    
    
  </xsl:for-each>
  
  
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
      <xsl:value-of select="if (@cycle) then concat(@cycle, ': ') else () "/>      
      <xsl:value-of select="if (@event) then concat(@event, ' ') else () "/>
      <xsl:value-of select="@date"/>
    </fo:block>

</xsl:template>
  <!-- contact.xsl --><!-- ========================= --><!-- match: contact            --><!-- value: <fo:block>         --><!-- ========================= --><!-- functions: --><!-- url() [FO] --><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="contact" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="templates/match/ddi/contact.xsl">
  
  <fo:block>
    <xsl:value-of select="."/>      
    <xsl:value-of select="if (@affiliation) then concat( '(', @affiliation, ')' ) else () "/>
    
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
    <xsl:value-of select="if (@abbr) then concat('(', @abbr, ')') else () "/>
    <xsl:value-of select="if (@affiliation) then @affiliation else () "/>
  </fo:block>

</xsl:template>
<!--  <xi:include href="templates/match/ddi/fileDscr.xsl" />-->
  <!-- fileDscr-variables_description.xsl --><!-- =========================================== --><!-- match: fileDsrc (variables-description)     --><!-- value: <xsl:for-each> <fo:page-sequence>    --><!-- =========================================== --><!-- read: --><!-- $layout.chunk_size, $layout.font_family, $layout.tables.border --><!-- set: --><!-- $fileId, $fileName --><!-- functions: --><!-- position() [xpath 1.0] --><!-- proportional-column-width() [fo] --><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="fileDscr" mode="variables-description" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="templates/match/ddi/fileDscr_variables-description.xsl">
  
  <!-- ================== -->
  <!-- variables          -->
  <!-- ================== -->
  
  <!-- fileName ID attribute / ID attribute -->  
  <xsl:variable name="fileId" select="if (fileTxt/fileName/@ID) then fileTxt/fileName/@ID             else if (@ID) then @ID             else () "/>
  
  <xsl:variable name="fileName" select="fileTxt/fileName"/>
  
  <!-- ===================== -->
  <!-- content               -->
  <!-- ===================== -->
  
  <xsl:for-each select="/codeBook/dataDscr/var[@files = $fileId][position() mod $layout.chunk_size = 1]">
    
    <fo:page-sequence master-reference="{$layout.page_master}" font-family="{$layout.font_family}" font-size="{$layout.font_size}">
      
      <!-- =========== -->
      <!-- page footer -->
      <!-- =========== -->
      <xsl:call-template name="page_footer"/>
      
      <!-- =========== -->
      <!-- page body   -->
      <!-- =========== -->
      <fo:flow flow-name="body">
        
        <!-- [fo:table] Header -->
        <!-- (only written if at the start of file) -->
        <xsl:if test="position() = 1">
          <fo:table id="vardesc-{$fileId}" table-layout="fixed" width="100%" font-size="8pt">
            <fo:table-column column-width="proportional-column-width(100)"/> <!-- column width -->
            
            <!-- [fo:table-header] -->
            <fo:table-header space-after="5mm">
              
              <!-- [fo:table-row] File identification -->
              <fo:table-row text-align="center" vertical-align="top">
                <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block font-size="14pt" font-weight="bold">
                    <xsl:value-of select="i18n:get('File')"/>
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
              <xsl:apply-templates select=".|following-sibling::var[@files=$fileId][$layout.chunk_size &gt; position()]"/>
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
              <xsl:apply-templates select=".|following-sibling::var[@files=$fileId][$layout.chunk_size &gt; position()]"/>
            </fo:table-body>
          </fo:table>
        </xsl:if>
        
      </fo:flow>
    </fo:page-sequence>
  </xsl:for-each>
  
</xsl:template>
<!--  <xi:include href="templates/match/ddi/fileDscr_variables-list.xsl" />-->
  <!-- fileName.xsl --><!-- ===================== --><!-- match: fileName       --><!-- value: string         --><!-- ===================== --><!-- set: --><!-- $filename --><!-- functions: --><!-- contains(), normalize-space(), string-length(), substring() [xpath 1.0] --><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="fileName" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="templates/match/ddi/fileName.xsl">

  <!-- variables -->
  <xsl:variable name="filename" select="normalize-space(.)"/>

  <!-- content -->
  
  <!-- remove ".NSDstat" extension from filename -->  
  <xsl:value-of select="     if (contains($filename, '.NSDstat')) then substring($filename, 1, string-length($filename) - 8)     else $filename "/>

</xsl:template>
  <!-- fundAg.xsl --><!-- ========================== --><!-- match: fundAg          --><!-- value: <fo:block>          --><!-- ========================== --><!-- functions: --><!-- util:trim() [local] --><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="fundAg" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="templates/match/ddi/fundAg.xsl">

  <fo:block>    
    <xsl:value-of select="util:trim(.)"/>
    <xsl:value-of select="if (@abbr) then concat('(', @abbr, ')') else () "/> 
    <xsl:value-of select="if (@role) then concat(',', @role) else () "/>
  </fo:block>

</xsl:template>
  <!-- IDNo.xsl --><!-- ==================== --><!-- match: IDNo          --><!-- value: <fo:block>    --><!-- ==================== --><!-- functions: --><!-- util:trim() --><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="IDNo" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="templates/match/ddi/IDNo.xsl">
  
  <fo:block> 
    <xsl:value-of select="if (@agency) then @agency else () "/>    
    <xsl:value-of select="util:trim(.)"/>
  </fo:block>
  
</xsl:template>
  <!-- othId.xsl --><!-- =================== --><!-- match: othId        --><!-- value: <fo:block>   --><!-- =================== --><!-- called: --><!-- trim --><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="othId" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="templates/match/ddi/othId.xsl">

  <fo:block>  
    <xsl:value-of select="util:trim(ddi:p)"/>
    <xsl:value-of select="if (@role) then @role else () "/>  
    <xsl:value-of select="if (@affiliation) then @affiliation else () "/>  
  </fo:block>

</xsl:template>
  <!-- producer.xsl --><!-- ========================== --><!-- match: producer            --><!-- value: <fo:block>          --><!-- ========================== --><!-- called: --><!-- trim --><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="producer" xml:base="templates/match/ddi/producer.xsl">

  <fo:block>
    <xsl:value-of select="util:trim(.)"/>
    <xsl:value-of select="if (@abbr) then concat('(', @abbr, ')') else () "/>     
    <xsl:value-of select="if (@affiliation) then @affiliation else () "/> 
    <xsl:value-of select="if (@role) then @role else () "/> 
  </fo:block>
  
</xsl:template>
  <!-- timePrd.xsl --><!-- ======================== --><!-- match: timePrd           --><!-- value: <fo:block>        --><!-- ======================== --><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="timePrd" xml:base="templates/match/ddi/timePrd.xsl">
  
  <fo:block>    
    <xsl:value-of select="if (@cycle) then concat(@cycle, ': ') else ()"/>
    <xsl:value-of select="if (@event) then concat(@event, ' ') else ()"/>
    <xsl:value-of select="@date"/>
  </fo:block>
</xsl:template>
  <!-- var.xsl --><!-- ================================== --><!-- match: var                         --><!-- value: <fo:table-row>              --><!-- ================================== --><!-- read: --><!-- $layout.tables.cellpadding, $layout.color.gray1, $layout.tables.border, --><!-- $show-variables-description-categories-max --><!-- set: --><!-- $statistics, $type, $label, $category-count, $is-weighted,  --><!-- $catgry-freq-nodes, $catgry-sum-freq, $catgry-sum-freq-wgtd,--><!-- $catgry-max-freq, $catgry-max-freq-wgtd, --><!-- $bar-column-width, $catgry-freq --><!-- functions: --><!-- concat(), contains(), string-length(), normalize-space(), --><!-- number(), position(), string() [Xpath 1.0] --><!-- util:trim(), util:math_max() [local] --><!--
  =========================================
  FO structure generated from this template
  =========================================
  
  <table-row>
  <table-cell>
  <table>
  <table-column />
  <table-column />
  <table-header></table-header>
  <table-body>
  
  == Meta-information ==
  <table-row> (multiple <if> dep)       
  
  == Variable content and bars ==
  Choice 1:
  <table-row>      
  
  Choice 2:
  <table-cell>
  
  == Variable related information and descriptions == 
  <table-row>
  <table-cell> x2
  
  dep: <table-row>
  <table-cell> x2
  
  </table-body>
  </table>
  </table-cell>
  </table-row>
--><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="var" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="templates/match/ddi/var.xsl">
  
  <xsl:variable name="statistics" select="sumStat[contains('vald invd mean stdev',@type)]"/>
  
  <fo:table-row text-align="center" vertical-align="top">
    <fo:table-cell>
      <fo:table id="var-{@ID}" table-layout="fixed" width="100%" font-size="8pt" space-after="7.5mm">
        <fo:table-column column-width="proportional-column-width(20)"/>
        <fo:table-column column-width="proportional-column-width(80)"/>
        
        <!-- ============ -->
        <!-- table Header -->
        <!-- ============ -->
        <fo:table-header>
          <fo:table-row text-align="center" vertical-align="top">
            <fo:table-cell number-columns-spanned="2" font-size="12pt" font-weight="bold" text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
              <fo:block>                
                <xsl:value-of select="concat(./@id, ' ')"/>                                  
                <xsl:value-of select="./@name"/>                                
                <xsl:value-of select="if (normalize-space(./labl)) then concat(': ', normalize-space(./labl)) else ()"/>                
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-header>
        
        <!-- ================================================== -->
        <!-- Main table body - body of the variable description -->
        <!-- ================================================== -->
        <fo:table-body>
          
          <!-- ========================= -->
          <!-- Part 1) Information       -->
          <!-- ========================= -->
          
          <!-- Definition  -->           
          <xsl:if test="./txt">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" number-columns-spanned="2" padding="{$layout.tables.cellpadding}">  
                <fo:block>
                  <fo:inline font-weight="bold">
                    <xsl:value-of select="concat(i18n:get('Definition'), ': ')"/>
                  </fo:inline>
                  <xsl:value-of select="util:trim(./txt)"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
                                          
          <!-- Source -->          
          <xsl:if test="./respUnit">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" number-columns-spanned="2" padding="{$layout.tables.cellpadding}">  
                <fo:block>
                  <fo:inline font-weight="bold">
                    <xsl:value-of select="concat(i18n:get('Source'), ': ')"/>
                  </fo:inline>
                  <xsl:value-of select="util:trim(./respUnit)"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
                    
          <!-- Pre-Question -->                   
          <xsl:if test="./qstn/preQTxt">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" number-columns-spanned="2" padding="{$layout.tables.cellpadding}">  
                <fo:block>
                  <fo:inline font-weight="bold">
                    <xsl:value-of select="concat(i18n:get('Pre-question'), ': ')"/>
                  </fo:inline>
                  <xsl:value-of select="util:trim(./qstn/preQTxt)"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
                    
          <!-- Literal_Question -->          
          <xsl:if test="./qstn/qstnLit">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" number-columns-spanned="2" padding="{$layout.tables.cellpadding}">  
                <fo:block>
                  <fo:inline font-weight="bold">
                    <xsl:value-of select="concat(i18n:get('Literal_question'), ': ')"/>
                  </fo:inline>
                  <xsl:value-of select="util:trim(./qstn/qstnLit)"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          
          <!-- Post-question -->          
          <xsl:if test="./qstn/postQTxt">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" number-columns-spanned="2" padding="{$layout.tables.cellpadding}">  
                <fo:block>
                  <fo:inline font-weight="bold">
                    <xsl:value-of select="concat(i18n:get('Post-question'), ': ')"/>
                  </fo:inline>
                  <xsl:value-of select="util:trim(./qstn/postQTxt)"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Interviewer_instructions -->          
          <xsl:if test="./qstn/ivuInstr">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" number-columns-spanned="2" padding="{$layout.tables.cellpadding}">  
                <fo:block>
                  <fo:inline font-weight="bold">
                    <xsl:value-of select="concat(i18n:get('Interviewers_instructions'), ': ')"/>
                  </fo:inline>
                  <xsl:value-of select="util:trim(./qstn/ivuInstr)"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Imputation -->          
          <xsl:if test="./qstn/imputation">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" number-columns-spanned="2" padding="{$layout.tables.cellpadding}">  
                <fo:block>
                  <fo:inline font-weight="bold">
                    <xsl:value-of select="concat(i18n:get('imputation'), ': ')"/>
                  </fo:inline>
                  <xsl:value-of select="util:trim(./qstn/imputation)"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Recoding_and_Derivation -->          
          <xsl:if test="./codInstr">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" number-columns-spanned="2" padding="{$layout.tables.cellpadding}">  
                <fo:block>
                  <fo:inline font-weight="bold">
                    <xsl:value-of select="concat(i18n:get('Recoding_and_Derivation'), ': ')"/>
                  </fo:inline>
                  <xsl:value-of select="util:trim(./codInstr)"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Security -->          
          <xsl:if test="./security">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" number-columns-spanned="2" padding="{$layout.tables.cellpadding}">  
                <fo:block>
                  <fo:inline font-weight="bold">
                    <xsl:value-of select="concat(i18n:get('Security'), ': ')"/>
                  </fo:inline>
                  <xsl:value-of select="util:trim(./security)"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Concepts -->
          <xsl:if test="./concept">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-weight="bold">
                  <xsl:value-of select="i18n:get('Concepts')"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
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
          <xsl:if test="./notes">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" number-columns-spanned="2" padding="{$layout.tables.cellpadding}">  
                <fo:block>
                  <fo:inline font-weight="bold">
                    <xsl:value-of select="concat(i18n:get('Notes'), ': ')"/>
                  </fo:inline>
                  <xsl:value-of select="util:trim(./notes)"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- ================================== -->
          <!-- Part 2) Variable contents and bars -->
          <!-- ================================== -->
          
          <xsl:if test="$section.variables_description_categories.show = 'True' and normalize-space(./catgry[1])">
            
            <xsl:variable name="category-count" select="count(catgry)"/>
            
            <fo:table-row text-align="center" vertical-align="top">
              <xsl:choose>
                
                <!-- ================== -->
                <!-- Case 1)            -->
                <!-- ================== -->
                <xsl:when test="number($limits.variables_description_categories_max) &gt;= $category-count">
                  
                  <!-- ========= -->
                  <!-- Variables -->
                  <!-- ========= -->
                  <xsl:variable name="is-weighted" select="count(catgry/catStat[@type ='freq' and @wgtd = 'wgtd' ]) &gt; 0"/>
                  <xsl:variable name="catgry-freq-nodes" select="catgry[not(@missing = 'Y')]/catStat[@type='freq']"/>
                  <xsl:variable name="catgry-sum-freq" select="sum($catgry-freq-nodes[ not(@wgtd = 'wgtd') ])"/>
                  <xsl:variable name="catgry-sum-freq-wgtd" select="sum($catgry-freq-nodes[ @wgtd = 'wgtd'])"/>                 
                  <xsl:variable name="catgry-max-freq" select="util:math_max($catgry-freq-nodes[ not(@wgtd = 'wgtd') ])"/>       
                  <xsl:variable name="catgry-max-freq-wgtd" select="util:math_max($catgry-freq-nodes[@type='freq' and @wgtd ='wgtd' ])"/>                  
                  <xsl:variable name="bar-column-width" select="2.5"/>
                  
                  <!-- ========= -->
                  <!-- Content   -->
                  <!-- ========= -->
                  <fo:table-cell text-align="left" border="0.2pt solid black" number-columns-spanned="2" padding="{$layout.tables.cellpadding}">  
                    <fo:table id="var-{@ID}-cat" table-layout="fixed" width="100%" font-size="8pt">
                      
                      <!-- table colums -->
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
                      <fo:table-column column-width="{$bar-column-width}in"/>
                      
                      <!-- table header -->
                      <fo:table-header>
                        <fo:table-row text-align="left" vertical-align="top">
                          <fo:table-cell border="0.5pt solid white" padding="{$layout.tables.cellpadding}">
                            <fo:block font-weight="bold">
                              <xsl:value-of select="i18n:get('Value')"/>
                            </fo:block>
                          </fo:table-cell>
                          <fo:table-cell border="0.5pt solid white" padding="{$layout.tables.cellpadding}">
                            <fo:block font-weight="bold">
                              <xsl:value-of select="i18n:get('Label')"/>
                            </fo:block>
                          </fo:table-cell>
                          <fo:table-cell border="0.4pt solid white" padding="{$layout.tables.cellpadding}" text-align="right">
                            <fo:block font-weight="bold">
                              <xsl:value-of select="i18n:get('Cases_Abbreviation')"/>
                            </fo:block>
                          </fo:table-cell>
                          <xsl:if test="$is-weighted">
                            <fo:table-cell border="0.4pt solid white" padding="{$layout.tables.cellpadding}" text-align="center">
                              <fo:block font-weight="bold">
                                <xsl:value-of select="i18n:get('Weighted')"/>
                              </fo:block>
                            </fo:table-cell>
                          </xsl:if>
                          <fo:table-cell border="0.4pt solid white" padding="{$layout.tables.cellpadding}" text-align="center">
                            <fo:block font-weight="bold">
                              <xsl:value-of select="i18n:get('Percentage')"/>
                              <xsl:if test="$is-weighted">                                
                                <xsl:value-of select="concat('(', i18n:get('Weighted'), ')')"/>
                              </xsl:if>
                            </fo:block>
                          </fo:table-cell>
                        </fo:table-row>
                      </fo:table-header>
                      
                      <!-- table body -->
                      <fo:table-body>
                        <xsl:for-each select="catgry">
                          
                          <!-- ========= -->
                          <!-- Variables -->
                          <!-- ========= -->
                          <xsl:variable name="catgry-freq" select="catStat[@type='freq' and not(@wgtd='wgtd') ]"/>
                          <xsl:variable name="catgry-freq-wgtd" select="catStat[@type ='freq' and @wgtd ='wgtd' ]"/>
                          
                          <!-- percentage -->                            
                          <xsl:variable name="catgry-pct" select="if ($is-weighted) then $catgry-freq-wgtd div $catgry-sum-freq-wgtd                             else $catgry-freq div $catgry-sum-freq "/>
                          
                          <!-- bar width (percentage of highest value minus --> 
                          <!-- some space to display the percentage value) -->                            
                          <xsl:variable name="tmp-col-width-1" select="if ($is-weighted) then ($catgry-freq-wgtd div $catgry-max-freq-wgtd) * ($bar-column-width - 0.5)                             else ($catgry-freq div $catgry-max-freq) * ($bar-column-width - 0.5) "/>
                          
                          <xsl:variable name="col-width-1" select="if (string(number($tmp-col-width-1)) != 'NaN') then $tmp-col-width-1                             else 0 "/>
                          
                          <!-- remaining space for second column -->
                          <xsl:variable name="col-width-2" select="$bar-column-width - $col-width-1"/>
                          
                          <!-- ========= -->
                          <!-- Content   -->
                          <!-- ========= -->                          
                          <fo:table-row text-align="center" vertical-align="top">
                            
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
                            <fo:table-cell text-align="right" border="0.5pt solid white" padding="2pt">
                              <fo:block>                                
                                <xsl:value-of select="util:trim(catStat)"/>
                              </fo:block>
                            </fo:table-cell>
                            
                            <!-- Weighted frequency -->                            
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
                            
                            <!-- display the bar but not for missing values or if there was a problem computing the width -->
                            <xsl:if test="not(@missing = 'Y') and $col-width-1 &gt; 0">
                              <fo:table-cell text-align="left" border="0.5pt solid white" padding="2pt">
                                <fo:table table-layout="fixed" width="100%">
                                  <fo:table-column column-width="{$col-width-1}in"/>
                                  <fo:table-column column-width="{$col-width-2}in"/>
                                  <fo:table-body>
                                    <fo:table-row>
                                      <fo:table-cell background-color="{$layout.color.gray4}">
                                        <fo:block> </fo:block>
                                      </fo:table-cell>
                                      <fo:table-cell margin-left="1.5mm">
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
                    <!--<fo:block font-weight="bold" color="#400000" font-size="6pt" font-style="italic">
                      <xsl:value-of select="i18n:get('SumStat_Warning')" />
                      </fo:block>-->
                    
                  </fo:table-cell>
                </xsl:when>
                
                <!-- =================================== -->
                <!-- Case 2) Frequence_table_not_shown   -->
                <!-- =================================== -->
                <xsl:otherwise>
                  <fo:table-cell background-color="{$layout.color.gray1}" text-align="center" font-style="italic" border="{$layout.tables.border}" number-columns-spanned="2" padding="{$layout.tables.cellpadding}">
                    <fo:block>                      
                      <xsl:value-of select="concat(i18n:get('Frequency_table_not_shown'), ' (', $category-count, ' ', i18n:get('Modalities'), ')')"/>
                    </fo:block>
                  </fo:table-cell>
                </xsl:otherwise>
                
              </xsl:choose>
            </fo:table-row>
          </xsl:if>
          
          <!-- ===================================================== -->
          <!-- Part 3) Variable related information and descriptions -->
          <!-- ===================================================== -->
          
          <!-- Information -->
          <fo:table-row text-align="center" vertical-align="top">
            
            <fo:table-cell font-weight="bold" text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
              <fo:block>
                <xsl:value-of select="concat(i18n:get('Information'), ':')"/>
              </fo:block>
            </fo:table-cell>
            
            <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
              <fo:block>
                
                <!-- Information: Type -->
                <xsl:if test="normalize-space(@intrvl)">
                  <xsl:value-of select="concat(' [', i18n:get('Type'), ': ')"/>
                  <xsl:value-of select="if (@intrvl = 'discrete') then i18n:get('discrete')                     else if (@intrvl = 'contin') then i18n:get('continuous')                      else () "/>
                  <xsl:text>] </xsl:text>
                </xsl:if>
                
                <!-- Information: Format -->
                <xsl:for-each select="varFormat">                  
                  <xsl:value-of select="concat(' [', i18n:get('Format'), ': ', @type)"/>                   
                  <xsl:value-of select="if (normalize-space(location/@width)) then concat('-', location/@width) else ()"/>
                  <xsl:value-of select="if (normalize-space(@dcml)) then concat('.', @dcml) else ()"/>
                  <xsl:text>] </xsl:text>
                </xsl:for-each>
                
                <!-- Information: Range -->
                <xsl:for-each select="valrng/range">                  
                  <xsl:value-of select="concat(' [', i18n:get('Range'), ': ', @min, '-', @max, '] ') "/>               
                </xsl:for-each>
                
                <!-- Information: Missing -->
                <xsl:value-of select="concat(' [', i18n:get('Missing'), ': *')"/>
                <xsl:for-each select="invalrng/item">
                  <xsl:value-of select="concat('/', @VALUE)"/>                 
                </xsl:for-each>
                <xsl:text>] </xsl:text>
                
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
          
          <!-- Statistics -->          
          <xsl:if test="$statistics">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell font-weight="bold" text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>                  
                  <xsl:value-of select="concat(i18n:get('Statistics'), ' [', i18n:get('Abbrev_NotWeighted'), '/ ', i18n:get('Abbrev_Weighted'), ']', ':')"/>                 
                </fo:block>
              </fo:table-cell>
              
              <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  
                  <!-- Summary statistics -->
                  <xsl:for-each select="$statistics[not(@wgtd)]">
                    
                    <!-- ========= -->
                    <!-- Variables -->
                    <!-- ========= -->
                    <xsl:variable name="type" select="@type"/>                    
                    <xsl:variable name="label" select="if (@type = 'vald') then i18n:get('Valid')                       else if (@type = 'invd') then i18n:get('Invalid')                       else if (@type = 'mean') then i18n:get('Mean')                       else if (@type = 'stdev') then i18n:get('StdDev')                       else @type "/>
                    
                    <!-- ========= -->
                    <!-- Content   -->
                    <!-- ========= -->                    
                    <xsl:value-of select="concat(' [', $label, ': ', normalize-space(.), ' /')"/>
                    <xsl:value-of select="if (following-sibling::sumStat[1]/@type = $type and following-sibling::sumStat[1]/@wgtd) then                       following-sibling::sumStat[1]                       else '-' "/>
                    <xsl:text>] </xsl:text>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
              
            </fo:table-row>
          </xsl:if>
          
          <!-- ========================== -->
          <!-- Part 4) misc layout things  -->
          <!-- ========================== -->
          
          <!-- separate the individual variable tables to improve readability -->
          <fo:table-row height="4mm">
            <fo:table-cell number-columns-spanned="2">
              <fo:block/>
            </fo:table-cell>
          </fo:table-row>
          
          <fo:table-row height="1mm">
            <fo:table-cell number-columns-spanned="2">
              <fo:block border-top-style="solid"/>
            </fo:table-cell>
          </fo:table-row>
          
          <fo:table-row height="4mm">
            <fo:table-cell number-columns-spanned="2">
              <fo:block/>
            </fo:table-cell>
          </fo:table-row>
          
          
          
        </fo:table-body>
      </fo:table>
      
    </fo:table-cell>
  </fo:table-row>
  
</xsl:template>
  <!-- var-variables_list.xsl --><!-- ================================== --><!-- match: var (variables-list)        --><!-- value: <xsl:if> <fo:table-row>     --><!-- ================================== --><!-- read: --><!-- $layout.tables.border, $layout.tables.cellpadding, --><!-- $show-variables-list, $limits.variable_name_length --><!-- functions: --><!-- concat(), contains(), count(), position(), normalize-space(), --><!-- string-length(), substring() [xpath 1.0] --><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="var" mode="variables-list" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="templates/match/ddi/var_variablesList.xsl">

    <!-- content -->
    <fo:table-row text-align="center" vertical-align="top">

      <!-- Variable Position -->
      <fo:table-cell text-align="center" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
        <fo:block>
          <xsl:value-of select="position()"/>
        </fo:block>
      </fo:table-cell>

      <!-- Variable Name-->
      <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
        <fo:block>
          <xsl:choose>
            <xsl:when test="$page.variables_list.show = 'True'">
              <fo:basic-link internal-destination="var-{@ID}" text-decoration="underline" color="blue">
                <xsl:if test="string-length(@name) &gt; 10">
                  <xsl:value-of select="substring(./@name, 0, $limits.variable_name_length)"/>
                  <xsl:text> ..</xsl:text>
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
      <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
        <fo:block>
<!--          <xsl:value-of select="if (normalize-space(./labl)) then normalize-space(./labl) else '-' "/>-->
          <xsl:value-of select="if (./labl) then normalize-space(./labl) else '-' "/> 
        </fo:block>
      </fo:table-cell>

      <!-- Variable literal question -->
      <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
        <fo:block>
          <xsl:value-of select="if (./qstn/qstnLit) then normalize-space(./qstn/qstnLit) else '-' "/>
        </fo:block>
      </fo:table-cell>
        
    </fo:table-row>

</xsl:template>
  <!-- varGrp.xsl --><!-- ================================================== --><!-- match: varGrp                                      --><!-- value: <fo:table> + [<xsl:if> <fo:table>] --><!-- ================================================== --><!-- read --><!-- $layout.tables.border, $layout.tables.cellpadding --><!-- set --><!-- $list --><!-- functions --><!-- contains(), concat(), position(), string-length(), --><!-- normalize-space() [Xpath 1.0]                      --><!-- proportional-column-width() [fo]                   --><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" match="varGrp" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="templates/match/ddi/varGrp.xsl">
  
  <fo:table id="vargrp-{@ID}" table-layout="fixed" width="100%" space-before="5mm">
    <fo:table-column column-width="proportional-column-width(20)"/>
    <fo:table-column column-width="proportional-column-width(80)"/>
    
    <fo:table-body>
      
      <!-- Group -->
      <fo:table-row>
        <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
          <fo:block font-size="12pt" font-weight="bold">
            <xsl:value-of select="normalize-space(labl)"/>
          </fo:block>
        </fo:table-cell>
      </fo:table-row>
      
      <!-- Text -->
      <xsl:for-each select="txt">
        <fo:table-row>
          <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
            <xsl:apply-templates select="."/>
          </fo:table-cell>
        </fo:table-row>
      </xsl:for-each>
      
      <!-- Definition -->
      <xsl:for-each select="defntn">
        <fo:table-row>
          <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
            <fo:block font-weight="bold" text-decoration="underline">
              <xsl:value-of select="i18n:get('Definition')"/>
            </fo:block>
            <xsl:apply-templates select="."/>
          </fo:table-cell>
        </fo:table-row>
      </xsl:for-each>
      
      <!-- Universe-->
      <xsl:for-each select="universe">
        <fo:table-row>
          <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
            <fo:block font-weight="bold" text-decoration="underline">
              <xsl:value-of select="i18n:get('Universe')"/>
            </fo:block>
            <xsl:apply-templates select="."/>
          </fo:table-cell>
        </fo:table-row>
      </xsl:for-each>
      
      <!-- Notes -->
      <xsl:for-each select="notes">
        <fo:table-row>
          <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
            <fo:block font-weight="bold" text-decoration="underline">
              <xsl:value-of select="i18n:get('Notes')"/>
            </fo:block>
            <xsl:apply-templates select="."/>
          </fo:table-cell>
        </fo:table-row>
      </xsl:for-each>
      
      <!-- Subgroups -->
      <xsl:if test="./@varGrp">
        <fo:table-row>
          <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
            <fo:block>
              <xsl:value-of select="i18n:get('Subgroups')"/>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
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
          
          <!-- blank character -->
          <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
            <fo:block>
              <xsl:text/>
            </fo:block>
          </fo:table-cell>
          
          <!-- Name -->
          <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
            <fo:block>
              <xsl:value-of select="i18n:get('Name')"/>
            </fo:block>
          </fo:table-cell>
          
          <!-- Label -->
          <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
            <fo:block>
              <xsl:value-of select="i18n:get('Label')"/>
            </fo:block>
          </fo:table-cell>
          
          <!-- Question -->
          <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
            <fo:block>
              <xsl:value-of select="i18n:get('Question')"/>
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
  
  <fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0mm">
    <xsl:value-of select="util:trim(.)"/>
  </fo:block>

</xsl:template>

  <!-- =============== -->
  <!-- named templates -->
  <!-- =============== -->
  <!-- page_header.xsl --><xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fo="http://www.w3.org/1999/XSL/Format" name="page_header" xpath-default-namespace="http://www.icpsr.umich.edu/DDI" xml:base="templates/named/page_header.xsl">
  <xsl:param name="section_name"/>
  

  <!-- content -->
  <fo:static-content flow-name="before">
    <fo:block font-size="{$layout.header_font_size}" text-align="center">
      <xsl:value-of select="concat(/codeBook/stdyDscr/citation/titlStmt/titl, ' - ', $section_name)"/>   
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
  <!-- util-isodate_month_name.xsl --><!-- ========================================================= --><!-- xs:string util:isodate_month_name(xs:string isodate)      --><!-- ========================================================= --><!-- returns month name from a ISO-format date string --><!-- set: --><!-- $month, $month_string --><!-- functions: --><!-- number(), substring() [Xpath 1.0] --><xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="util:isodate_month_name" as="xs:string" xml:base="functions/util/isodate_month_name.xsl">
  <xsl:param name="isodate" as="xs:string"/> 
  

  <!-- extract month number from date string -->
  <xsl:variable name="month" select="number(substring($isodate, 6, 2))"/>
  
  <!-- determine month name -->
  <xsl:variable name="month_string" select="     if ($month = 1) then i18n:get('January')     else if ($month = 2) then i18n:get('February')     else if ($month = 3) then i18n:get('March')     else if ($month = 4) then i18n:get('April')     else if ($month = 5) then i18n:get('May')     else if ($month = 6) then i18n:get('June')     else if ($month = 7) then i18n:get('July')     else if ($month = 8) then i18n:get('August')     else if ($month = 9) then i18n:get('September')     else if ($month = 10) then i18n:get('October')     else if ($month = 11) then i18n:get('November')     else if ($month = 12) then i18n:get('December')     else ()  "/>


  <!-- return value -->
  <xsl:value-of select="$month_string"/>
  
</xsl:function>
  <!-- util-isodate_long.xsl --><!-- ============================================= --><!-- xs:string util:isodate-long(xs:date isodate)  --><!-- ============================================= --><!-- converts an ISO date string to a "prettier" format --><!-- read: --><!-- $language-code --><!-- called: --><!-- substring(), contains() [Xpath 1.0] --><!-- util:isodate_month_name() [local] --><xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="util:isodate_long" as="xs:string" xml:base="functions/util/isodate_long.xsl">
  <xsl:param name="isodate" as="xs:string"/>


  <!-- determine local date-format from $language-code string -->
  <xsl:value-of select="     (: european format :)     if (contains('fr es', $i18n.language_code)) then       concat(substring($isodate, 9, 2), ' ', util:isodate_month_name($isodate), ' ', substring($isodate, 1, 4))     (: japanese format :)     else if (contains('ja', $i18n.language_code)) then       $isodate     (: english format :)     else concat(util:isodate_month_name($isodate), ' ', substring($isodate, 9, 2), ' ', substring($isodate, 1, 4)) "/>

</xsl:function>
  <!-- util-trim.xsl --><!-- =================== --><!-- xs:string trim(s)    --><!-- =================== --><!-- functions: --><!-- concat(), substring(), translate(), substring-after() [Xpath 1.0] --><!-- util:rtrim() [local] --><xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="util:trim" as="xs:string" xml:base="functions/util/trim.xsl">
  <xsl:param name="s"/>


  <!-- perform trimming -->

  <!-- &#x9; TAB-character -->
  <!-- &#xA; LF-character -->
  <!-- &#xD; CR-character -->

<!--  <xsl:value-of select="normalize-space($s)" />-->

  <!-- replace TAB, LF and CR and with '' -->
  <xsl:variable name="translated" select="translate($s, '&#9;&#10;&#13;', '')"/>
  <!-- extract all characters in string after the first one -->
  <xsl:variable name="tmp1" select="substring($translated, 1, 1)"/>
  <!-- extract all character in string after found string -->
  <xsl:variable name="tmp2" select="substring-after($s, $tmp1)"/>
  
  <xsl:variable name="tmp3" select="concat($tmp1, $tmp2)"/>

  <xsl:variable name="tmp4" select="util:rtrim($tmp3, string-length($tmp3))"/>


  <!-- return value -->
  <xsl:value-of select="$tmp4"/>

</xsl:function>
  <!-- rtrim.xsl --><!-- ================================================ --><!-- xs:string util:rtrim(xs:string s, xs:integer i)  --><!-- ================================================ --><!-- perform right trim on text through recursion --><!-- called: --><!-- substring(), string-length(), translate() [Xpath 1.0] --><!-- self [local] --><xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="util:rtrim" as="xs:string" xml:base="functions/util/rtrim.xsl">
  <xsl:param name="input_string" as="xs:string"/>
  <xsl:param name="length" as="xs:integer"/>

  <xsl:variable name="tmp">
    <xsl:choose>

      <!-- 1) what? -->
      <xsl:when test="translate(substring($input_string, $length, 1), ' &#9;&#10;&#13;', '')">
        <xsl:value-of select="substring($input_string, 1, $length)"/>
      </xsl:when>

      <!-- 2) -->
      <xsl:when test="$length &lt; 2"/>

      <!-- 3) recurse -->
      <xsl:otherwise>
        <xsl:value-of select="util:rtrim($input_string, $length - 1)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- return value -->
  <xsl:value-of select="$tmp"/>

</xsl:function>
  <!-- util-math_max.xsl --><!-- ===================== --><!-- util:math_max()       --><!-- param: $nodes         --><!-- ===================== --><!-- read: --><!-- $nodes [param] --><!-- functions: --><!-- not(), number(), position() [Xpath 1.0] --><xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="util:math_max" xml:base="functions/util/math_max.xsl">
  <xsl:param name="nodes"/>


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


  <!-- return value -->
  <xsl:value-of select="$tmp"/>

</xsl:function>
  <!-- get.xsl --><!-- ====================================== --><!-- xs:string i18n:get(english_string)     --><!-- ====================================== --><!-- read: --><!-- $i18n_strings [global] --><xsl:function xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="i18n:get" as="xs:string" xml:base="functions/i18n/get.xsl">
  <xsl:param name="english_string"/>


  <!-- return value -->
  <!-- <xsl:value-of select="$i18n_strings/*/entry[@key = $english_string]" /> -->
  <xsl:value-of select="$i18n.strings/*/entry[@key = $english_string]"/>
  
  
</xsl:function>
    
</xsl:transform>