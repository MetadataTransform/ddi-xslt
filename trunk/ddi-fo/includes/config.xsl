<?xml version='1.0' encoding='utf-8'?>

<!-- config.xsl -->

<xsl:stylesheet xmlns:n1="http://www.icpsr.umich.edu/DDI" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ddi="http://www.icpsr.umich.edu/DDI" xmlns:date="http://exslt.org/dates-and-times" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:exsl="http://exslt.org/common" xmlns:math="http://exslt.org/math" xmlns:str="http://exslt.org/strings" xmlns:doc="http://www.icpsr.umich.edu/doc" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:xdt="http://www.w3.org/2005/xpath-datatypes" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:fn="http://www.w3.org/2005/xpath-functions" version="1.0" extension-element-prefixes="date exsl str">
  <xsl:output version="1.0" encoding="UTF-8" indent="no" omit-xml-declaration="no" media-type="text/html"/>

    <!--
    XPath 1.0 function called:
    count(), normalize-space(), position(), substring()

    XSLT 1.0 functions called:
    document()

    templates called:
    [date:date]
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
  <!-- Set: manual or parameter                                   -->
  <!-- Type: strings or numbers, mostly                           -->
  <!-- ========================================================== -->

  <!--
    global vars read:
    $translations, $exslt-date
  -->

  <!-- Full path to RDF file -->
  <xsl:param name="rdf-file" />

  <!-- Multilingual strings -->
  <xsl:param name="language-code"                               select="en"/>
  <xsl:param name="translations"/>
  <xsl:variable name="msg" select="document($translations)"/>

  <!-- Optional text -->
  <xsl:param name="report-title" select=" 'Study Documentation' "/>
  <xsl:param name="report-acknowledgments" />
  <xsl:param name="report-notes" />

  <!-- Page related -->
  <xsl:param name="page-format" select="us-letter"/>
  <xsl:param name="show-variables-list-layout">default-page</xsl:param>

  <!-- Style Settings -->
  <xsl:param name="font-family">Times</xsl:param>
  <xsl:variable name="cell-padding"                       select=" '3pt' "/>
  <xsl:variable name="default-border"       select=" '0.5pt solid black' "/>
  <xsl:variable name="color-white"                    select=" '#ffffff' "/>
  <xsl:variable name="color-gray0"                    select=" '#f8f8f8' "/>
  <xsl:variable name="color-gray1"                    select=" '#f0f0f0' "/>
  <xsl:variable name="color-gray2"                    select=" '#e0e0e0' "/>
  <xsl:variable name="color-gray3"                    select=" '#d0d0d0' "/>
  <xsl:variable name="color-gray4"                    select=" '#c0c0c0' "/>

  <!-- Start page number, used by Overview (useful if running multi-survey reports) -->
  <xsl:param name="report-start-page-number" select="4"/>

  <xsl:param name="show-variables-description-categories-max" select="1000"/>
  <xsl:param name="variable-name-length"                      select="14"/>

  <!-- Params from OutputServlet.java (supposedly?) -->
  <!-- Not used, will be removed soon -->

  <xsl:param name="numberOfVars"/>
  <xsl:param name="numberOfGroups"/>
  <xsl:param name="subsetGroups"/>
  <xsl:param name="subsetVars"/>
  <xsl:param name="maxVars"/>
  

  <!-- Required by EXSLT date function -->
  <xsl:variable name="date:date-time"       select="'2000-01-01T00:00:00Z'"/>

  <!-- Report date -->
  <xsl:variable name="exslt-date">
    <xsl:call-template name="date:date"/>
  </xsl:variable>
  <xsl:param name="report-date" select="$exslt-date"/>

  <!-- from OutputServlet.java, supposedly? -->
  <xsl:param name="allowHTML"                                     select="0"/>


  <!-- ========================================================== -->
  <!-- [2] Show/hide sections (main/sub) in root template         -->
  <!-- Set: Manual or parameter                                   -->
  <!-- Type: bools                                                -->
  <!-- ========================================================== -->

  <!-- Main sections in root template -->
  <xsl:param name="show-bookmarks"                                select="1"/>
  <xsl:param name="show-cover-page"                               select="1"/>
  <xsl:param name="show-metadata-info"                            select="1"/>
  <xsl:param name="show-toc"                                      select="1"/>
  <xsl:param name="show-overview"                                 select="1"/>
  <xsl:param name="show-files-description"                        select="1"/>
  <xsl:param name="show-documentation"                            select="0"/>
  <!-- Parts in the Cover page -->
  <xsl:param name="show-logo"                                     select="0"/>
  <xsl:param name="show-geography"                                select="0"/>
  <xsl:param name="show-cover-page-producer"                      select="1"/>
  <xsl:param name="show-report-subtitle"                          select="0"/>
  <xsl:param name="show-date"                                     select="0"/>
  <!-- Misc -->
  <xsl:param name="show-metadata-production"                      select="1"/>
  <xsl:param name="show-variables-list-question"                  select="1"/>
  <xsl:param name="show-variables-description-categories"         select="1"/>
  <!-- documentation refer to a rdf file given as parameter which we dont have -->
  <xsl:param name="show-documentation-description"                select="0"/>
  <xsl:param name="show-documentation-abstract"                   select="0"/>
  <xsl:param name="show-documentation-toc"                        select="0"/>
  <xsl:param name="show-documentation-subjects"                   select="0"/>
  <!-- from OutputServlet.java, supposedly? -->
  <xsl:param name="showVariableGroupsParam"                       select="1"/>


  <!-- ============================================================= -->
  <!-- [3] Show/hide sections (main/sub) in root template            -->
  <!-- Set: Determined from content of DDI file                      -->
  <!-- Type: bools                                                   -->
  <!-- ============================================================= -->

  <!--
    global vars read:
    $showVariableGroupsParam, $numberOfVars, $maxVars
  -->

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
  <!-- Set: determined from content of DDI file                      -->
  <!-- Type: strings, numeric                                        -->
  <!-- ============================================================= -->

  <!--
    global vars read:
    $yearFrom, $yearTo, $numberOfVars
  -->

  <!-- toolkit: Microdata Management Toolkit or Nesstar Publishser 3.x -->
  <!-- ddp:     World Bank Data Development Platform                   -->
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
      (
      <xsl:value-of select="normalize-space(/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:titlStmt/ddi:altTitl)"/>)
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

  <!-- yearFrom - the first data collection mode element with a 'start' event               -->
  <!-- ToDO: collDate isnt always present, should test and possibly use /ddi:timePrd[@date] -->
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

  <!--	 To avoid empty pages; use a huge chunksize for subsets -->
  <xsl:variable name="chunkSize">
    <xsl:choose>
      <xsl:when test="($numberOfVars &gt; 0 )">
        <xsl:value-of select="1000"/>
      </xsl:when>
      <xsl:otherwise>50</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

</xsl:stylesheet>