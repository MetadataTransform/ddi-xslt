<?xml version='1.0' encoding='utf-8'?>

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
-->

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
                xmlns:xi="http://www.w3.org/2001/XInclude"
                version="1.0"
                extension-element-prefixes="date exsl str">

  <xsl:output version="1.0" encoding="UTF-8" indent="no"
              omit-xml-declaration="no" media-type="text/html"/>

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
  <xsl:param name="rdf-file" />
  <xsl:param name="translations"/>
  
  <!-- Used for ISO-date template -->
  <xsl:param name="language-code" select="en"/>
  
  <!-- Optional text -->
  <xsl:param name="report-title" select=" 'Study Documentation' "/>
  <xsl:param name="report-acknowledgments" />
  <xsl:param name="report-notes" />

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
      <xsl:value-of select="$yearFrom" />
      <xsl:if test="$yearTo &gt; $yearFrom">
        <xsl:text>-</xsl:text>
        <xsl:value-of select="$yearTo" />
      </xsl:if>
    </xsl:if>
  </xsl:variable>

  <!-- If timeperiods returns empty, use timePrd instead -->
  <!-- ToDo: might not be needed -->
  <xsl:variable name="timeProduced" select="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:timePrd/@date" />

  <!-- To avoid empty pages; use a huge chunksize for subsets -->
  <xsl:variable name="chunkSize">
    <xsl:choose>
      <xsl:when test="($numberOfVars &gt; 0 )">
        <xsl:value-of select="1000" />
      </xsl:when>
      <xsl:otherwise>50</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- ================================= -->
  <!-- [5] Xincludes - include templates -->
  <!-- ================================= -->

  <xi:include href="includes/root_template.xml" />

  <!-- templates matching the ddi: namespace -->
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

  <!-- templates matching the rdf: namespace -->
  <xi:include href="includes/rdf/rdf-Description.xml" />

  <!-- Named/utility templates -->
  <xi:include href='includes/named/documentation-toc-section.xml' />
  <xi:include href='includes/named/variables-table-col-header.xml' />
  <xi:include href='includes/named/variables-table-col-width.xml' />
  <xi:include href="includes/named/header.xml" />
  <xi:include href="includes/named/footer.xml" />

  <xi:include href="includes/utilities/isodate-long.xml" />
  <xi:include href="includes/utilities/isodate-month.xml" />
  <xi:include href="includes/utilities/trim/ltrim.xml" />
  <xi:include href="includes/utilities/trim/rtrim.xml" />
  <xi:include href="includes/utilities/trim/trim.xml" />
  <xi:include href='includes/utilities/FixHTML.xml' />
  <xi:include href="includes/utilities/date-date.xml" />
  <xi:include href="includes/utilities/math-max.xml" />

</xsl:stylesheet>
