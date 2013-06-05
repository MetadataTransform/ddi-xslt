<?xml version='1.0' encoding='utf-8'?>

<!--
  Overview:
    Transforms DDI-XML into XSL-FO to produce study documentation in PDF format
    Developed for DDI documents produced by the International Household Survey Network
    Microdata Managemenet Toolkit (http://www.surveynetwork.org/toolkit) and
    Central Survey Catalog (http://www.surveynetwork.org/surveys)
-->

<!--
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
-->

<!--
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
-->

<!--
  2006-04:    Added multilingual support and French translation
  2006-06:    Added Spanish and new elements to match IHSN Template v1.2
  2006-07:    Minor fixes and typos
  2006-07:    Added option parameters to hide producers in cover
              page and questions in variables list page
  2010-03:    Made FOP 0.93 compatible
  2012-11-01: Broken up into parts using xsl:include
  2013-01-22: Changing the file names to match template names better
  2013-05-28: Using xincludes instead of xsl:includes
  2013-05-29: Including config in main file
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:n1="http://www.icpsr.umich.edu/DDI"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
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
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                version="1.0"
                extension-element-prefixes="date exsl str">

  <xsl:output version="1.0" encoding="UTF-8" indent="no"
              omit-xml-declaration="no" media-type="text/html"/>

  <!--
    Functions and templates called:
    count(), normalize-space(), position(), substring() [Xpath 1.0]
    document() [XSLT 1.0]
    date
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
    8:  Variable Groups:        show-variable-groups          spec**
    9:  Variables Description:  show-variables-description    file

    *  If show-variable-groups is 1, this is set to 0
    ** Both parameter and DDI file
  -->

<!--
    Supplied by eXide server/webpage:
    language-code
    report-title
    font-family
    show-variables-list-question
    translations    http://xml.snd.gu.se/xsl/ddi2/i18n/{$lang}.xml
    show-cover-page
-->

  <!-- ========================================================= -->
  <!-- Misc                                                      -->
  <!-- ========================================================= -->

  <!-- used in isodate-long template -->
  <xsl:param name="language-code" select="en" />

  <!-- translation file (path)-->
  <xsl:param name="translations" />
  <xsl:variable name="msg" select="document($translations)" />

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
  <xsl:variable name='chunk-size'>50</xsl:variable>

  <!-- Style and page layout -->
  <xsl:param name="show-variables-list-layout">default-page</xsl:param>
  <xsl:param name="font-family">Times</xsl:param>

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
  <xsl:param name="show-bookmarks" select="1" />
  <xsl:param name="show-cover-page" select="1" />
  <xsl:param name="show-metadata-info" select="1" /> 
  <xsl:param name="show-toc" select="1" />
  <xsl:param name="show-overview" select="1" />
  <xsl:param name="show-files-description" select="1" />

  <!-- parts of cover page -->
  <xsl:param name="show-logo" select="0" />
  <xsl:param name="show-geography" select="0" />
  <xsl:param name="show-cover-page-producer" select="1" />
  <xsl:param name="show-report-subtitle" select="0" />

  <!-- misc -->
  <xsl:param name="show-metadata-production" select="1" />
  <xsl:param name="show-variables-list-question" select="1" />
  <xsl:param name="show-variables-description-categories" select="1" />

  <!-- ==================================== -->
  <!-- string vars                          -->
  <!-- ==================================== -->

  <!-- survey title -->
  <xsl:variable name="survey-title">
    <xsl:value-of select="normalize-space(/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:titlStmt/ddi:titl)"/>
    <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:titlStmt/ddi:altTitl">
      (<xsl:value-of select="normalize-space(/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:titlStmt/ddi:altTitl)"/>)
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
  <!-- templates                             -->
  <!-- ===================================== -->

  <xi:include href="includes/root_template.xml" />

  <!-- ===================================== -->
  <!-- matching templates                    -->
  <!-- ===================================== -->
  <xi:include href="includes/ddi/ddi-AuthEnty.xml" />
  <xi:include href="includes/ddi/ddi-collDate.xml" />
  <xi:include href="includes/ddi/ddi-contact.xml" />
  <xi:include href="includes/ddi/ddi-dataCollector.xml" />
  <xi:include href="includes/ddi/ddi-fileDscr.xml" />
  <xi:include href="includes/ddi/ddi-fileDscr_variables-description.xml" />
  <xi:include href="includes/ddi/ddi-fileDscr_variables-list.xml" />
  <xi:include href="includes/ddi/ddi-fileName.xml" />
  <xi:include href="includes/ddi/ddi-fundAg.xml" />
  <xi:include href="includes/ddi/ddi-IDNo.xml" />
  <xi:include href="includes/ddi/ddi-othId.xml" />
  <xi:include href="includes/ddi/ddi-producer.xml" />
  <xi:include href="includes/ddi/ddi-timePrd.xml" />
  <xi:include href="includes/ddi/ddi-var.xml" />
  <xi:include href="includes/ddi/ddi-var_variablesList.xml" />
  <xi:include href="includes/ddi/ddi-varGrp.xml" />
  <xi:include href="includes/ddi/ddi_default_text.xml" />

  <!-- ===================================== -->
  <!-- called templates                      -->
  <!-- ===================================== -->
  <xi:include href="includes/utilities/isodate-long.xml" />
  <xi:include href="includes/utilities/isodate-month.xml" />
  <xi:include href="includes/utilities/date.xml" />
  <xi:include href="includes/utilities/math-max.xml" />
  <xi:include href="includes/utilities/trim/rtrim.xml" />
  <xi:include href="includes/utilities/trim/trim.xml" />

</xsl:stylesheet>
