<?xml version='1.0' encoding='UTF-8'?>
<!-- overview.xsl -->
<!-- =========================================== -->
<!-- <xsl:if> overview                           -->
<!-- value: <fo:page-sequence>                   -->
<!-- =========================================== -->

<!-- read: -->
<!-- $layout.start_page_number, $font-family, $color-gray3 -->
<!-- $layout.tables.border, $layout.tables.cellpadding, $survey-title, $layout.color.gray1, $time -->

<!-- functions: -->
<!-- nomalize-space(), position() [Xpath] -->
<!-- proportional-column-width() [FO] -->
<!-- i18n:get() [local] -->

<xsl:if test="$page.overview.show = 'True'"
        xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <fo:page-sequence master-reference="{$layout.page_master}"
                    initial-page-number="{$layout.start_page_number}"
                    font-family="{$layout.font_family}"
                    font-size="{$layout.font_size}">

    <!-- =========================================== -->
    <!-- page header and footer                      -->
    <!-- =========================================== -->

    <xsl:call-template name="page_header">
      <xsl:with-param name="section_name" select="i18n:get('Overview')" />
    </xsl:call-template>

    <xsl:call-template name="page_footer" />

    <!-- =========================================== -->
    <!-- page content                                -->
    <!-- =========================================== -->
    
    <fo:flow flow-name="body">
 
      <fo:table table-layout="fixed" width="100%">
        <fo:table-column column-width="proportional-column-width(20)" />
        <fo:table-column column-width="proportional-column-width(80)" />

        <fo:table-body>

          <!-- ========================= -->
          <!-- title header              -->
          <!-- ========================= -->
          <fo:table-row background-color="{$layout.color.gray3}">
            <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
              <fo:block font-size="14pt" font-weight="bold">
                <xsl:value-of select="$study.title" />
              </fo:block>
              <xsl:if test="/codeBook/stdyDscr/citation/titlStmt/parTitl">
                <fo:block font-size="12pt" font-weight="bold" font-style="italic">
                  <xsl:value-of select="/codeBook/stdyDscr/citation/titlStmt/parTitl" />
                </fo:block>
              </xsl:if>
            </fo:table-cell>
          </fo:table-row>

          <!-- Space -->
          <fo:table-row height="5mm">
            <fo:table-cell number-columns-spanned="2">
              <fo:block />
            </fo:table-cell>
          </fo:table-row>

          <!-- ========================= -->
          <!-- Overview                  -->
          <!-- ========================= -->
          <!-- Heading (two col) -->
          <fo:table-row background-color="{$layout.color.gray1}" keep-with-next="always">
            <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
              <fo:block id="overview" font-size="12pt" font-weight="bold">
                <xsl:value-of select="i18n:get('Overview')" />
              </fo:block>
            </fo:table-cell>
          </fo:table-row>

          <!-- Type  -->
          <xsl:if test="/codeBook/stdyDscr/citation/serStmt/serName">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:value-of select="i18n:get('Type')" />                 
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/citation/serStmt/serName" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Identification -->
          <xsl:if test="/codeBook/stdyDscr/citation/titlStmt/IDNo">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:value-of select="i18n:get('Identification')" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/citation/titlStmt/IDNo" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Version -->
          <xsl:for-each select="/codeBook/stdyDscr/citation/verStmt/version">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:value-of select="i18n:get('Version')" />
                </fo:block>
              </fo:table-cell>

              <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">

                <!-- Production_Date -->
                <xsl:for-each select="/codeBook/stdyDscr/citation/verStmt/version">
                  <xsl:if test="@date">
                    <fo:block>                      
                      <xsl:value-of select="concat(i18n:get('Production_Date'), @date)" />
                    </fo:block>
                  </xsl:if>
                  <xsl:apply-templates select="." />
                </xsl:for-each>

                <!-- Notes -->
                <xsl:for-each select="/codeBook/stdyDscr/citation/verStmt/notes">
                  <fo:block text-decoration="underline">
                    <xsl:value-of select="i18n:get('Notes')" />
                  </fo:block>
                  <xsl:apply-templates select="." />
                </xsl:for-each>

              </fo:table-cell>
            </fo:table-row>
          </xsl:for-each>

          <!-- Series -->
          <xsl:if test="/codeBook/stdyDscr/citation/serStmt/serInfo">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                   <xsl:value-of select="i18n:get('Series')" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/citation/serStmt/serInfo" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Abstract -->
          <xsl:if test="/codeBook/stdyDscr/stdyInfo/abstract">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="i18n:get('Abstract')" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/stdyInfo/abstract" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Kind of Data -->
          <xsl:if test="/codeBook/stdyDscr/stdyInfo/sumDscr/dataKind">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:value-of select="i18n:get('Kind_of_Data')" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/stdyInfo/sumDscr/dataKind" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Unit of Analysis  -->
          <xsl:if test="/codeBook/stdyDscr/stdyInfo/sumDscr/anlyUnit">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:value-of select="i18n:get('Unit_of_Analysis')" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/stdyInfo/sumDscr/anlyUnit" />
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
          <xsl:if test="$section.scope_and_coverage.show = 'True'">
            <fo:table-row background-color="{$layout.color.gray1}" keep-with-next="always">
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block id="scope-and-coverage" font-size="12pt" font-weight="bold">
                  <xsl:value-of select="i18n:get('Scope_and_Coverage')" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Scope -->
          <xsl:if test="/codeBook/stdyDscr/stdyInfo/notes">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="i18n:get('Scope')"/>
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/stdyInfo/notes" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Keywords -->
          <xsl:if test="/codeBook/stdyDscr/stdyInfo/subject/keyword">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:value-of select="i18n:get('Keywords')" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:for-each select="/codeBook/stdyDscr/stdyInfo/subject/keyword">
                    <xsl:if test="position() &gt; 1">, </xsl:if>
                    <xsl:value-of select="normalize-space(.)" />
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
                    <xsl:value-of select="if (position() > 1) then ', ' else ()"  />                    
                    <xsl:value-of select="normalize-space(.)" />
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
                  <xsl:value-of select="i18n:get('Time_Periods')" />
                </fo:block>
              </fo:table-cell>

              <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <xsl:choose>
                  <xsl:when test="string-length($time) &gt; 3">
                    <fo:block>
                      <xsl:value-of select="$time" />
                    </fo:block>
                  </xsl:when>
                  <xsl:when test="string-length($study.time_produced) &gt; 3">
                    <fo:block>
                      <xsl:value-of select="$study.time_produced" />
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
                <xsl:value-of select="i18n:get('Countries')" />
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
              <fo:block>
                <xsl:value-of select="$study.geography" />
              </fo:block>
            </fo:table-cell>
          </fo:table-row>

          <!-- Geographic_Coverage -->
          <xsl:if test="/codeBook/stdyDscr/stdyInfo/sumDscr/geogCover">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="i18n:get('Geographic_Coverage')" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/stdyInfo/sumDscr/geogCover" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Universe -->
          <xsl:if test="/codeBook/stdyDscr/stdyInfo/sumDscr/universe">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-weight="bold" text-decoration="underline">
                   <xsl:value-of select="i18n:get('Universe')" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/stdyInfo/sumDscr/universe" />
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
          <xsl:if test="$section.producers_and_sponsors.show = 'True'">
            <fo:table-row background-color="{$layout.color.gray1}" keep-with-next="always">
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block id="producers-and-sponsors" font-size="12pt" font-weight="bold">
                  <xsl:value-of select="i18n:get('Producers_and_Sponsors')" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Primary Investigator(s) -->
          <xsl:if test="/codeBook/stdyDscr/citation/rspStmt/AuthEnty">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:value-of select="i18n:get('Primary_Investigators')" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/citation/rspStmt/AuthEnty" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Other_Producers -->
          <xsl:if test="/codeBook/stdyDscr/citation/prodStmt/producer">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:value-of select="i18n:get('Other_Producers')" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/citation/prodStmt/producer" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Funding_Agencies -->
          <xsl:if test="/codeBook/stdyDscr/citation/prodStmt/fundAg">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:value-of select="i18n:get('Funding_Agencies')" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/citation/prodStmt/fundAg" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Other Acknowledgements -->
          <xsl:if test="/codeBook/stdyDscr/citation/rspStmt/othId">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:value-of select="i18n:get('Other_Acknowledgements')" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/citation/rspStmt/othId" />
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
          <xsl:if test="$section.sampling.show = 'True'">
            <fo:table-row background-color="{$layout.color.gray1}">
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block id="sampling" font-size="12pt" font-weight="bold">
                  <xsl:value-of select="i18n:get('Sampling')" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Sampling Procedure -->
          <xsl:if test="/codeBook/stdyDscr/method/dataColl/sampProc">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="i18n:get('Sampling_Procedure')" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/dataColl/sampProc" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Deviations_from_Sample_Design -->
          <xsl:if test="/codeBook/stdyDscr/method/dataColl/deviat">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="i18n:get('Deviations_from_Sample_Design')" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/dataColl/deviat" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Response_Rate -->
          <xsl:if test="/codeBook/stdyDscr/method/anlyInfo/respRate">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="i18n:get('Response_Rate')" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/anlyInfo/respRate" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Weighting -->
          <xsl:if test="/codeBook/stdyDscr/method/dataColl/weight">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="i18n:get('Weighting')" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/dataColl/weight" />
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
          <xsl:if test="$section.data_collection.show = 'True'">
            <fo:table-row background-color="{$layout.color.gray1}" keep-with-next="always">
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block id="data-collection" font-size="12pt" font-weight="bold">
                  <xsl:value-of select="i18n:get('Data_Collection')" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Data Collection Dates -->
          <xsl:if test="/codeBook/stdyDscr/stdyInfo/sumDscr/collDate">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:value-of select="i18n:get('Data_Collection_Dates')" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/stdyInfo/sumDscr/collDate" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Time Periods -->
          <xsl:if test="/codeBook/stdyDscr/stdyInfo/sumDscr/timePrd">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:value-of select="i18n:get('Time_Periods')" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/stdyInfo/sumDscr/timePrd" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Data Collection Mode -->
          <xsl:if test="/codeBook/stdyDscr/method/dataColl/collMode">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:value-of select="i18n:get('Data_Collection_Mode')" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/method/dataColl/collMode" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Data Collection Notes -->
          <xsl:if test="/codeBook/stdyDscr/method/notes[@subject = 'collection']">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="i18n:get('Data_Collection_Notes')" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/notes[@subject = 'collection']" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Data Processing Notes -->
          <xsl:if test="/codeBook/stdyDscr/method/notes[@subject = 'processing']">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-weight="bold" text-decoration="underline">
                   <xsl:value-of select="i18n:get('Data_Processing_Notes')" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/notes[@subject = 'collection']" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Data Cleaning Notes -->
          <xsl:if test="/codeBook/stdyDscr/method/notes[@subject = 'cleaning']">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="i18n:get('Data_Cleaning_Notes')" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/notes[@subject = 'collection']" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Data Collection Notes -->
          <xsl:if test="/codeBook/stdyDscr/method/dataColl/collSitu">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-weight="bold" text-decoration="underline">
                   <xsl:value-of select="i18n:get('Data_Collection_Notes')" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/dataColl/collSitu" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Questionnaires -->
          <xsl:if test="/codeBook/stdyDscr/method/dataColl/resInstru">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="i18n:get('Questionnaires')" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/dataColl/resInstru" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Data Collectors -->
          <xsl:if test="/codeBook/stdyDscr/method/dataColl/dataCollector">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:value-of select="i18n:get('Data_Collectors')" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/method/dataColl/dataCollector" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Supervision -->
          <xsl:if test="/codeBook/stdyDscr/method/dataColl/actMin">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="i18n:get('Supervision')" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/dataColl/actMin" />
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
          <xsl:if test="$section.data_processing_and_appraisal.show = 'True'">
            <fo:table-row background-color="{$layout.color.gray1}" keep-with-next="always">
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block id="data-processing-and-appraisal" font-size="12pt" font-weight="bold">
                  <xsl:value-of select="i18n:get('Data_Processing_and_Appraisal')" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Data Editing -->
          <xsl:if test="/codeBook/stdyDscr/method/dataColl/cleanOps">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="i18n:get('Data_Editing')" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/dataColl/cleanOps" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Other Processing -->
          <xsl:if test="/codeBook/stdyDscr/method/notes">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="i18n:get('Other_Processing')" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/notes" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Estimates of Sampling Error -->
          <xsl:if test="/codeBook/stdyDscr/method/anlyInfo/EstSmpErr">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="i18n:get('Estimates_of_Sampling_Error')" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/anlyInfo/EstSmpErr" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Other Forms of Data Appraisal -->
          <xsl:if test="/codeBook/stdyDscr/method/anlyInfo/dataAppr">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-weight="bold" text-decoration="underline">
                   <xsl:value-of select="i18n:get('Other_Forms_of_Data_Appraisal')" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/anlyInfo/dataAppr" />
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
          <xsl:if test="$section.accessibility.show = 'True'">
            <fo:table-row background-color="{$layout.color.gray1}" keep-with-next="always">
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block id="accessibility" font-size="12pt" font-weight="bold">
                  <xsl:value-of select="i18n:get('Accessibility')" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Access Authority -->
          <xsl:if test="/codeBook/stdyDscr/dataAccs/useStmt/contact">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:value-of select="i18n:get('Access_Authority')" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/dataAccs/useStmt/contact" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Contacts -->
          <xsl:if test="/codeBook/stdyDscr/citation/distStmt/contact">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                   <xsl:value-of select="i18n:get('Contacts')" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/citation/distStmt/contact" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Distributors -->
          <xsl:if test="/codeBook/stdyDscr/citation/distStmt/distrbtr">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:value-of select="i18n:get('Distributors')" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/citation/distStmt/distrbtr" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Depositors (DDP) -->
          <xsl:if test="/codeBook/stdyDscr/citation/distStmt/depositr">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:value-of select="i18n:get('Depositors')" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/citation/distStmt/depositr" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Confidentiality -->
          <xsl:if test="/codeBook/stdyDscr/dataAccs/useStmt/confDec">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="i18n:get('Confidentiality')" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/dataAccs/useStmt/confDec" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Access Conditions -->
          <xsl:if test="/codeBook/stdyDscr/dataAccs/useStmt/conditions">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="i18n:get('Access_Conditions')" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/dataAccs/useStmt/conditions" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Citation Requierments -->
          <xsl:if test="/codeBook/stdyDscr/dataAccs/useStmt/citReq">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-weight="bold" text-decoration="underline">
                   <xsl:value-of select="i18n:get('Citation_Requirements')" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/dataAccs/useStmt/citReq" />
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
          <xsl:if test="$section.rights_and_disclaimer.show = 'True'">
            <fo:table-row background-color="{$layout.color.gray1}" keep-with-next="always">
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block id="rights-and-disclaimer" font-size="12pt" font-weight="bold">
                  <xsl:value-of select="i18n:get('Rights_and_Disclaimer')" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Disclaimer -->
          <xsl:if test="/codeBook/stdyDscr/dataAccs/useStmt/disclaimer">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="i18n:get('Disclaimer')" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/dataAccs/useStmt/disclaimer" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Copyright -->
          <xsl:if test="/codeBook/stdyDscr/citation/prodStmt/copyright">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:value-of select="i18n:get('Copyright')" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/citation/prodStmt/copyright" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

        </fo:table-body>
      </fo:table>
    </fo:flow>
  </fo:page-sequence>
</xsl:if>
