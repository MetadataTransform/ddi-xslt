<?xml version="1.0" encoding="UTF-8" ?>
<!--
Overview:
Transforms DDI-XML into XSL-FO to produce study documentation in PDF format
Developed for DDI documents produced by the International Household Survey Network 
Microdata Managemenet Toolkit (http://www.surveynetwork.org/toolkit) and 
Central Survey Catalog (http://www.surveynetwork.org/surveys)
-->

<!--
THIS VERSION ADAPTED BY ANDREAS PERRET

Author: Pascal Heus (pascal.heus@gmail.com)
Version: July 2006
Platform: XSL 1.0, Apache FOP 0.20.5 (http://xmlgraphics.apache.org/fop)

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
History:
2010 : Overhaul COMPASS by Andreas Perret
	Adatped to corporate design FORS
	Simplified general layout
	Added footers with logos
	Changed TOC structure
	Subdivision of Scope and Coverage in separate sections
	Rearranged DDI elements position in the Codebook
	Adapted some message entries to COMPASS denominations
	Created file for german messages	
	Defined numbers formats
	Implemented variable group section
	Added file reference and page index to group list
	Included an alphabetical list based on group design
	Forced keep-together in variable description

200907: Added geogUnit element
        Fixed issues with metadata documentation date (incorrect month and NaN when day not specifed)
200812: Added top/bottom border to table section separators
200811: Upgrade to fop 0.95
    upgrade changed fop config.xml file (use font auto detection)
        - added fop:table-cell and ampty fop:block to separators (empty table-row elements are illegal)
        - fop:continued-label not yet reimplemented in redesigned codeb (commented out)
                - bookmark based on xsl 1.1 (http://www.w3.org/TR/xsl11/#fo_bookmark-tree)
                        - added boomark-tree
                        - changed fox:outline to fo:bookmark, fox:label to bookmark-title
                        - move all i@id in fo:table-row to fo:block
                - See http://xmlgraphics.apache.org/fop/0.95/extensions.html
                - replace white-space-collacpse="false" with linefeed-treatment="preserve" white-space-treatment="preserve"
200604: Added multilingual support and French translation
200606: Added Spanish and new elements to match IHSN Template v1.2 
200607: Minor fixes and typos
200607: Added option parameters to hide producers in cover page and questions in variables list page
-->

<xsl:stylesheet version="1.0" 
                xmlns:date="http://exslt.org/dates-and-times" 
                xmlns:ddi="http://www.icpsr.umich.edu/DDI"
                xmlns:dc="http://purl.org/dc/elements/1.1/" 
                xmlns:dcterms="http://purl.org/dc/terms/"    
                xmlns:doc="http://www.icpsr.umich.edu/doc" 
                xmlns:exsl="http://exslt.org/common"
                xmlns:fn="http://www.w3.org/2005/xpath-functions" 
                xmlns:fo="http://www.w3.org/1999/XSL/Format" 
                xmlns:fox="http://xml.apache.org/fop/extensions"
                xmlns:math="http://exslt.org/math" 
                xmlns:n1="http://www.icpsr.umich.edu/DDI"
                xmlns:str="http://exslt.org/strings"
                xmlns:xdt="http://www.w3.org/2005/xpath-datatypes"
                xmlns:xs="http://www.w3.org/2001/XMLSchema" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xi="http://www.w3.org/2001/XInclude"
                extension-element-prefixes="date exsl str">

    <!-- (FK) Numeric format mask START -->
    <xsl:decimal-format name="de" decimal-separator="." grouping-separator="'" />
    <xsl:variable name="num_0d">#'##0</xsl:variable>
    <!-- (FK) Numeric format mask STOP -->

    <!-- (FK) Numeric format mask START -->
    <xsl:decimal-format name="de2" decimal-separator="." grouping-separator="'" />
    <xsl:variable name="num_0d2">#'##0.0</xsl:variable>
    <!-- (FK) Numeric format mask STOP -->

    <xsl:key name="listFich" match="/ddi:codeBook/ddi:fileDscr" use="@ID" />

    <xsl:output version="1.0" encoding="UTF-8" indent="no"
              omit-xml-declaration="no" media-type="text/html"/>

    <!-- Required by EXSLT date function -->
    <xsl:variable name="date:date-time" select="'2000-01-01T00:00:00Z'" />

    <!-- PARAMETERS -->
    <!-- Report optional text	-->
    <xsl:param name="report-acknowledgments" />
    <xsl:param name="report-notes" />

    <!-- Flag to display full header (AP)-->
    <xsl:param name="header-flag" select="0" />

    <!-- Report date -->
    <xsl:variable name="exslt-date">
        <xsl:call-template name="date:date"/>
    </xsl:variable>
    
    <xsl:param name="report-date" select="$exslt-date"/>

    <!-- Start page number, used by Overview (useful if running multi-survey reports) -->
    <xsl:param name="report-start-page-number" select="1"/>

    <!--The following parameters toggles page sequences on/off -->
    <xsl:param name="show-cover-page" select="1"/>
    <xsl:param name="show-cover-page-producer" select="1"/>
    <xsl:param name="show-metadata-info" select="1"/>
    <xsl:param name="show-metadata-production" select="1"/>
    <xsl:param name="show-toc" select="0"/>
    <xsl:param name="show-overview" select="1"/>
    <xsl:param name="show-files-description" select="1"/>
    <xsl:param name="show-variables-list" select="1"/> 
    <xsl:param name="show-variables-list-question" select="1"/>
    <xsl:param name="show-variables-list-layout">default-page</xsl:param>
    <xsl:param name="show-variables-groups" select="0"/>
    <xsl:param name="show-variables-description" select="0"/>
    <xsl:param name="show-variables-description-categories" select="0"/>
    <xsl:param name="show-variables-description-categories-max" select="20"/>
    <xsl:param name="show-documentation" select="0"/>
    <xsl:param name="show-documentation-description" select="0"/>
    <xsl:param name="show-documentation-abstract" select="0"/>
    <xsl:param name="show-documentation-toc" select="0"/>
    <xsl:param name="show-documentation-subjects" select="0"/>
    <xsl:param name="page-format" select="A4"/>

    <!-- Params from OutputServlet.java -->
    <xsl:param name="showVariableGroupsParam"/>
    <xsl:param name="numberOfVars"/>
    <xsl:param name="numberOfGroups"/>
    <xsl:param name="subsetGroups"/>
    <xsl:param name="subsetVars"/>
    <xsl:param name="maxVars"/>
    <xsl:param name="allowHTML" select="0"/>	
	
    <!-- Fonts (use MSGothic for non-latin character sets) -->
    <xsl:param name="font-family">Helvetica</xsl:param>
	
    <!-- LOAD MULTILINGUAL STRINGS -->
    <xsl:include href="i18n.inc.xslt" />
	
    <!-- Report title  -->
    <xsl:param name="report-title" select=" 'Study Documentation' " />

    <!-- STYLES -->
    <xsl:variable name="cell-padding" select=" '3pt' " />
    <xsl:variable name="default-border" select=" '0pt solid black' " />
    <xsl:variable name="color-white" select=" '#ffffff' " />
    <xsl:variable name="color-gray0" select=" '#f8f8f8' " />
    <xsl:variable name="color-gray1" select=" '#f0f0f0' " />
    <xsl:variable name="color-gray2" select=" '#e0e0e0' " />
    <xsl:variable name="color-gray3" select=" '#d0d0d0' " />
    <xsl:variable name="color-gray4" select=" '#c0c0c0' " />
    <xsl:variable name="forsblue" select=" '#0096C8' " />

    <!-- GLOBAL VARIABLES -->
    
    <!-- ddi-flavor
        The ddi-flavor variable is used to customize the stylesheet to different type of DDI document
        The default value is 'toolkit' which indicates a DDI document produced by the Microdata Management Toolkit or Nesstar Publichser 3.x
        Other supported values: ddp=World Bank Data Development Platform 
    -->
    <xsl:variable name="ddi-flavor">
        <xsl:choose>
            <xsl:when test="count(/ddi:codeBook/ddi:docDscr/ddi:citation/ddi:prodStmt/ddi:software[ contains( . , 'DDP' ) ])">ddp</xsl:when>
            <xsl:when test="count(/ddi:codeBook/ddi:docDscr/ddi:citation/ddi:prodStmt/ddi:software[ contains( . , 'Nesstar' ) ])">toolkit</xsl:when>
            <xsl:when test="count(/ddi:codeBook/ddi:docDscr/ddi:citation/ddi:prodStmt/ddi:software[ contains( . , 'Metadata Editor' ) ])">toolkit</xsl:when>
            <xsl:otherwise>toolkit</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <!-- title -->
    <xsl:variable name="survey-title">
        <xsl:value-of select="normalize-space(/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:titlStmt/ddi:titl)"/>
        <!-- abbreviation is stored in the altTitl element -->
        <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:titlStmt/ddi:altTitl"> (<xsl:value-of select="normalize-space(/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:titlStmt/ddi:altTitl)"/>)</xsl:if>
    </xsl:variable>
    
    <!-- geography-->
    <xsl:variable name="geography">
        <xsl:for-each select="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:nation">
            <xsl:if test="position()>1">
                <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:for-each>
    </xsl:variable>
    
    <!-- time -->
    <!-- year from is the first data collection mode element with a 'start' event -->
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
    
    <!-- variables for section existence -->
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
            <xsl:when test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:rspStmt/ddi:AuthEnty">0</xsl:when>
            <xsl:when test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:prodStmt/ddi:producer">0</xsl:when>
            <xsl:when test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:prodStmt/ddi:fundAg">0</xsl:when>
            <xsl:when test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:rspStmt/ddi:othId">0</xsl:when>
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
	
    <!-- count documents by category -->
    <xsl:variable name="adm-count" select="count(/ddi:codeBook/ddi:otherMat[ contains(@type,'[doc/adm]') ]) "/>
    <xsl:variable name="anl-count" select="count(/ddi:codeBook/ddi:otherMat[ contains(@type,'[doc/anl]') ]) "/>
    <xsl:variable name="qst-count" select="count(/ddi:codeBook/ddi:otherMat[ contains(@type,'[doc/qst]') ]) "/>
    <xsl:variable name="oth-count" select="count(/ddi:codeBook/ddi:otherMat[ contains(@type,'[doc/oth]') ]) "/>
    <xsl:variable name="ref-count" select="count(/ddi:codeBook/ddi:otherMat[ contains(@type,'[doc/ref]') ]) "/>
    <xsl:variable name="rep-count" select="count(/ddi:codeBook/ddi:otherMat[ contains(@type,'[doc/rep]') ]) "/>
    <xsl:variable name="tec-count" select="count(/ddi:codeBook/ddi:otherMat[ contains(@type,'[doc/tec]') ]) "/>
    <xsl:variable name="tbl-count" select="count(/ddi:codeBook/ddi:otherMat[ contains(@type,'[tbl') ]) "/>
    <xsl:variable name="prg-count" select="count(/ddi:codeBook/ddi:otherMat[ contains(@type,'[prg') ]) "/>
    <xsl:variable name="unc-count" select="count(/ddi:codeBook/ddi:otherMat[ not( contains(@type,'[doc') or contains(@type,'[tbl') or contains(@type,'[prg') ) ] )"/>

    <!-- ================== -->
    <!-- matching templates -->
    <!-- ================== -->
    <xi:include href='includes/match/root.xml' />
    <xi:include href='includes/match/ddi-AuthEnty.xml' />
    <xi:include href='includes/match/ddi-collDate.xml' />
    <xi:include href='includes/match/ddi-contact.xml' />
    <xi:include href='includes/match/ddi-dataCollector.xml' />
    <xi:include href='includes/match/ddi-fileDscr.xml' />
    <xi:include href='includes/match/ddi-fileDscr_variables-description.xml' />
    <xi:include href='includes/match/ddi-fileDscr_variables-list.xml' />
    <xi:include href='includes/match/ddi-fileDscr_variables-list_alpha.xml' />
    <xi:include href='includes/match/ddi-fileName.xml' />
    <xi:include href='includes/match/ddi-fundAg.xml' />
    <xi:include href='includes/match/ddi-IDNo.xml' />
    <xi:include href='includes/match/ddi-otherMat.xml' />
    <xi:include href='includes/match/ddi-othId.xml' />
    <xi:include href='includes/match/ddi-producer.xml' />
    <xi:include href='includes/match/ddi-text.xml' />
    <xi:include href='includes/match/ddi-timePrd.xml' />
    <xi:include href='includes/match/ddi-var.xml' />
    <xi:include href='includes/match/ddi-varGrp.xml' />
    <xi:include href='includes/match/ddi-var_variables-list.xml' />
    <xi:include href='includes/match/ddi-var_variables-list_grp.xml' />

    <!-- =============== -->
    <!-- named templates -->
    <!-- =============== -->
    <xi:include href='includes/named/date_date.xml' />
    <xi:include href='includes/named/documentation-toc-section.xml' />
    <xi:include href='includes/named/footer.xml' />
    <xi:include href='includes/named/footer_first.xml' />
    <xi:include href='includes/named/header.xml' />
    <xi:include href='includes/named/isodate-long.xml' />
    <xi:include href='includes/named/isodate-month.xml' />
    <xi:include href='includes/named/ltrim.xml' />
    <xi:include href='includes/named/math_max.xml' />
    <xi:include href='includes/named/NumFormat.xml' />
    <xi:include href='includes/named/NumFormat2.xml' />
    <xi:include href='includes/named/rtrim.xml' />
    <xi:include href='includes/named/trim.xml' />
    <xi:include href='includes/named/variables-table-col-header.xml' />
    <xi:include href='includes/named/variables-table-col-header_grp.xml' />
    <xi:include href='includes/named/variables-table-col-width.xml' />
    <xi:include href='includes/named/variables-table-col-width_grp.xml' />
</xsl:stylesheet>
