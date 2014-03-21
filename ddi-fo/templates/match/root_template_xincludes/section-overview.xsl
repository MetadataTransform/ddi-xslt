<?xml version='1.0' encoding='UTF-8'?>
<!-- overview.xsl -->
<!-- =========================================== -->
<!-- <xsl:if> overview                           -->
<!-- value: <fo:page-sequence>                   -->
<!-- =========================================== -->

<!-- read: -->
<!-- $strings, $report-start-page-number, $font-family, $color-gray3   -->
<!-- $default-border, $cell-padding, $survey-title, $color-gray1, $time -->

<!-- functions: -->
<!-- nomalize-space(), position() [Xpath] -->
<!-- proportional-column-width() [FO] -->

<xsl:if test="$show-overview = 'True'"
        xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <fo:page-sequence master-reference="{$page-layout}"
                    initial-page-number="{$report-start-page-number}"
                    font-family="{$font-family}"
                    font-size="{$font-size}">

    <!-- =========================================== -->
    <!-- page header and footer                      -->
    <!-- =========================================== -->

    <xsl:call-template name="page_header">
      <xsl:with-param name="section_name" select="$i18n-Overview" />
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
          <fo:table-row background-color="{$color-gray3}">
            <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">

              <fo:block font-size="14pt" font-weight="bold">
                <xsl:value-of select="$survey-title" />
              </fo:block>

              <!-- parTitl -->
              <xsl:if test="/codeBook/stdyDscr/citation/titlStmt/parTitl">
                <fo:block font-size="12pt" font-weight="bold" font-style="italic">
                  <xsl:value-of select="/codeBook/stdyDscr/citation/titlStmt/parTitl" />
                </fo:block>
              </xsl:if>

            </fo:table-cell>
          </fo:table-row>

          <!-- ============================= -->
          <!-- Space                         -->
          <!-- ============================= -->
          <fo:table-row height="0.2in">
            <fo:table-cell number-columns-spanned="2">
              <fo:block />
            </fo:table-cell>
          </fo:table-row>

          <!-- ========================= -->
          <!-- Overview                  -->
          <!-- ========================= -->
          <fo:table-row background-color="{$color-gray1}" keep-with-next="always">
            <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
              <fo:block id="overview" font-size="12pt" font-weight="bold">
                <xsl:value-of select="$i18n-Overview" />
              </fo:block>
            </fo:table-cell>
          </fo:table-row>

          <!-- Type  -->
          <xsl:if test="/codeBook/stdyDscr/citation/serStmt/serName">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$i18n-Type" />                 
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/citation/serStmt/serName" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Identification -->
          <xsl:if test="/codeBook/stdyDscr/citation/titlStmt/IDNo">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$i18n-Identification" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/citation/titlStmt/IDNo" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Version -->
          <xsl:for-each select="/codeBook/stdyDscr/citation/verStmt/version">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$i18n-Version" />
                </fo:block>
              </fo:table-cell>

              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">

                <!-- 5.1) Production_Date -->
                <xsl:for-each select="/codeBook/stdyDscr/citation/verStmt/version">
                  <xsl:if test="@date">
                    <fo:block>
                      <xsl:value-of select="$i18n-Production_Date" />:
                      <xsl:value-of select="@date" />
                    </fo:block>
                  </xsl:if>
                  <xsl:apply-templates select="." />
                </xsl:for-each>

                <!-- 5.2) Notes -->
                <xsl:for-each select="/codeBook/stdyDscr/citation/verStmt/notes">
                  <fo:block text-decoration="underline">
                    <xsl:value-of select="$i18n-Notes" />
                  </fo:block>
                  <xsl:apply-templates select="." />
                </xsl:for-each>

              </fo:table-cell>
            </fo:table-row>
          </xsl:for-each>

          <!-- Series -->
          <xsl:if test="/codeBook/stdyDscr/citation/serStmt/serInfo">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                   <xsl:value-of select="$i18n-Series" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/citation/serStmt/serInfo" />
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
                <xsl:apply-templates select="/codeBook/stdyDscr/stdyInfo/abstract" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Kind_of_Data -->
          <xsl:if test="/codeBook/stdyDscr/stdyInfo/sumDscr/dataKind">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$i18n-Kind_of_Data" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/stdyInfo/sumDscr/dataKind" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Unit_of_Analysis  -->
          <xsl:if test="/codeBook/stdyDscr/stdyInfo/sumDscr/anlyUnit">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$i18n-Unit_of_Analysis" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/stdyInfo/sumDscr/anlyUnit" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- ============================= -->
          <!-- Space                         -->
          <!-- ============================= -->
          <fo:table-row height="0.2in">
            <fo:table-cell number-columns-spanned="2">
              <fo:block/>
            </fo:table-cell>
          </fo:table-row>

          <!-- =========================== -->
          <!-- Scope_and_Coverage          -->
          <!-- =========================== -->               
          <xsl:if test="$show-scope-and-coverage = 'True'">
            <fo:table-row background-color="{$color-gray1}" keep-with-next="always">
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block id="scope-and-coverage" font-size="12pt" font-weight="bold">
                  <xsl:value-of select="$i18n-Scope_and_Coverage" />
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
                <xsl:apply-templates select="/codeBook/stdyDscr/stdyInfo/notes" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Keywords -->
          <xsl:if test="/codeBook/stdyDscr/stdyInfo/subject/keyword">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                   <xsl:value-of select="$i18n-Keywords" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:for-each select="/codeBook/stdyDscr/stdyInfo/subject/keyword">
                    <xsl:if test="position()&gt;1">, </xsl:if>
                    <xsl:value-of select="normalize-space(.)" />
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
                    <xsl:if test="position()&gt;1">, </xsl:if>
                    <xsl:value-of select="normalize-space(.)" />
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
                  <xsl:value-of select="$i18n-Time_Periods" />
                </fo:block>
              </fo:table-cell>

              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:choose>
                  <xsl:when test="string-length($time) &gt; 3">
                    <fo:block>
                      <xsl:value-of select="$time" />
                    </fo:block>
                  </xsl:when>
                  <xsl:when test="string-length($time-produced) &gt; 3">
                    <fo:block>
                      <xsl:value-of select="$time-produced" />
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
                <xsl:value-of select="$i18n-Countries" />
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
              <fo:block>
                <xsl:value-of select="$geography" />
              </fo:block>
            </fo:table-cell>
          </fo:table-row>

          <!-- Geographic_Coverage -->
          <xsl:if test="/codeBook/stdyDscr/stdyInfo/sumDscr/geogCover">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$i18n-Geographic_Coverage" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/stdyInfo/sumDscr/geogCover" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Universe -->
          <xsl:if test="/codeBook/stdyDscr/stdyInfo/sumDscr/universe">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$i18n-Universe" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/stdyInfo/sumDscr/universe" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- ============================= -->
          <!-- Space                         -->
          <!-- ============================= -->
          <fo:table-row height="0.2in">
            <fo:table-cell number-columns-spanned="2">
              <fo:block/>
            </fo:table-cell>
          </fo:table-row>

          <!-- ====================== -->
          <!-- Producers_and_Sponsors -->
          <!-- ====================== -->
          <xsl:if test="$show-producers-and-sponsors = 'True'">
            <fo:table-row background-color="{$color-gray1}" keep-with-next="always">
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block id="producers-and-sponsors" font-size="12pt" font-weight="bold">
                  <xsl:value-of select="$i18n-Producers_and_Sponsors" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Primary Investigator(s) -->
          <xsl:if test="/codeBook/stdyDscr/citation/rspStmt/AuthEnty">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$i18n-Primary_Investigators" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/citation/rspStmt/AuthEnty" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Other_Producers -->
          <xsl:if test="/codeBook/stdyDscr/citation/prodStmt/producer">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$i18n-Other_Producers" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/citation/prodStmt/producer" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Funding_Agencies -->
          <xsl:if test="/codeBook/stdyDscr/citation/prodStmt/fundAg">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$i18n-Funding_Agencies" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/citation/prodStmt/fundAg" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Other Acknowledgements -->
          <xsl:if test="/codeBook/stdyDscr/citation/rspStmt/othId">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$i18n-Other_Acknowledgements" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/citation/rspStmt/othId" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- ============================= -->
          <!-- Space                         -->
          <!-- ============================= -->
          <fo:table-row height="0.2in">
            <fo:table-cell number-columns-spanned="2">
              <fo:block/>
            </fo:table-cell>
          </fo:table-row>

          <!-- ======== -->
          <!-- Sampling -->
          <!-- ======== -->
          <xsl:if test="$show-sampling = 'True'">
            <fo:table-row background-color="{$color-gray1}">
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block id="sampling" font-size="12pt" font-weight="bold">
                  <xsl:value-of select="$i18n-Sampling" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Sampling_Procedure -->
          <xsl:if test="/codeBook/stdyDscr/method/dataColl/sampProc">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$i18n-Sampling_Procedure" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/dataColl/sampProc" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Deviations_from_Sample_Design -->
          <xsl:if test="/codeBook/stdyDscr/method/dataColl/deviat">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$i18n-Deviations_from_Sample_Design" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/dataColl/deviat" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Response_Rate -->
          <xsl:if test="/codeBook/stdyDscr/method/anlyInfo/respRate">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$i18n-Response_Rate" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/anlyInfo/respRate" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Weighting -->
          <xsl:if test="/codeBook/stdyDscr/method/dataColl/weight">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$i18n-Weighting" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/dataColl/weight" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- ============================= -->
          <!-- Space                         -->
          <!-- ============================= -->
          <fo:table-row height="0.2in">
            <fo:table-cell number-columns-spanned="2">
              <fo:block/>
            </fo:table-cell>
          </fo:table-row>

          <!-- =============== -->
          <!-- Data Collection -->
          <!-- =============== -->
          <xsl:if test="$show-data-collection = 'True'">
            <fo:table-row background-color="{$color-gray1}" keep-with-next="always">
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block id="data-collection" font-size="12pt" font-weight="bold">
                   <xsl:value-of select="$i18n-Data_Collection" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Data Collection Dates -->
          <xsl:if test="/codeBook/stdyDscr/stdyInfo/sumDscr/collDate">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$i18n-Data_Collection_Dates" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/stdyInfo/sumDscr/collDate" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Time Periods -->
          <xsl:if test="/codeBook/stdyDscr/stdyInfo/sumDscr/timePrd">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$i18n-Time_Periods" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/stdyInfo/sumDscr/timePrd" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Data_Collection_Mode -->
          <xsl:if test="/codeBook/stdyDscr/method/dataColl/collMode">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                   <xsl:value-of select="$i18n-Data_Collection_Mode" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/method/dataColl/collMode" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Data_Collection_Notes -->
          <xsl:if test="/codeBook/stdyDscr/method/notes[@subject='collection']">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$i18n-Data_Collection_Notes" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/notes[@subject='collection']" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Data_Processing_Notes -->
          <xsl:if test="/codeBook/stdyDscr/method/notes[@subject='processing']">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                   <xsl:value-of select="$i18n-Data_Processing_Notes" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/notes[@subject='collection']" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Data_Cleaning_Notes -->
          <xsl:if test="/codeBook/stdyDscr/method/notes[@subject='cleaning']">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$i18n-Data_Cleaning_Notes" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/notes[@subject='collection']" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Data_Collection_Notes -->
          <xsl:if test="/codeBook/stdyDscr/method/dataColl/collSitu">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                   <xsl:value-of select="$i18n-Data_Collection_Notes" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/dataColl/collSitu" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Questionnaires -->
          <xsl:if test="/codeBook/stdyDscr/method/dataColl/resInstru">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$i18n-Questionnaires" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/dataColl/resInstru" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Data_Collectors -->
          <xsl:if test="/codeBook/stdyDscr/method/dataColl/dataCollector">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$i18n-Data_Collectors" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/method/dataColl/dataCollector" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Supervision -->
          <xsl:if test="/codeBook/stdyDscr/method/dataColl/actMin">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$i18n-Supervision" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/dataColl/actMin" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- ============================= -->
          <!-- Space                         -->
          <!-- ============================= -->
          <fo:table-row height="0.2in">
            <fo:table-cell number-columns-spanned="2">
              <fo:block/>
            </fo:table-cell>
          </fo:table-row>

          <!-- ============================= -->
          <!-- Data Processing and Appraisal -->
          <!-- ============================= -->
          <xsl:if test="$show-data-processing-and-appraisal = 'True'">
            <fo:table-row background-color="{$color-gray1}" keep-with-next="always">
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block id="data-processing-and-appraisal" font-size="12pt" font-weight="bold">
                  <xsl:value-of select="i18n-Data_Processing_and_Appraisal" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Data_Editing -->
          <xsl:if test="/codeBook/stdyDscr/method/dataColl/cleanOps">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$i18n-Data_Editing" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/dataColl/cleanOps" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Other_Processing -->
          <xsl:if test="/codeBook/stdyDscr/method/notes">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$i18n-Other_Processing" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/notes" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Estimates_of_Sampling_Error -->
          <xsl:if test="/codeBook/stdyDscr/method/anlyInfo/EstSmpErr">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$i18n-Estimates_of_Sampling_Error" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/anlyInfo/EstSmpErr" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Other_Forms_of_Data_Appraisal -->
          <xsl:if test="/codeBook/stdyDscr/method/anlyInfo/dataAppr">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                   <xsl:value-of select="$i18n-Other_Forms_of_Data_Appraisal" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/method/anlyInfo/dataAppr" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- ============================= -->
          <!-- Space                         -->
          <!-- ============================= -->
          <fo:table-row height="0.2in">
            <fo:table-cell number-columns-spanned="2">
              <fo:block/>
            </fo:table-cell>
          </fo:table-row>

          <!-- ============ -->
          <!-- Accesibility -->
          <!-- ============ -->
          <xsl:if test="$show-accessibility = 'True'">
            <fo:table-row background-color="{$color-gray1}" keep-with-next="always">
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block id="accessibility" font-size="12pt" font-weight="bold">
                  <xsl:value-of select="$i18n-Accessibility" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Access Authority -->
          <xsl:if test="/codeBook/stdyDscr/dataAccs/useStmt/contact">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$i18n-Access_Authority" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/dataAccs/useStmt/contact" />
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
                <xsl:apply-templates select="/codeBook/stdyDscr/citation/distStmt/contact" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Distributors -->
          <xsl:if test="/codeBook/stdyDscr/citation/distStmt/distrbtr">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$i18n-Distributors" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/citation/distStmt/distrbtr" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Depositors (DDP) -->
          <xsl:if test="/codeBook/stdyDscr/citation/distStmt/depositr">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$i18n-Depositors" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/citation/distStmt/depositr" />
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
                <xsl:apply-templates select="/codeBook/stdyDscr/dataAccs/useStmt/confDec" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Access Conditions -->
          <xsl:if test="/codeBook/stdyDscr/dataAccs/useStmt/conditions">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$i18n-Access_Conditions" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/dataAccs/useStmt/conditions" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Citation Requierments -->
          <xsl:if test="/codeBook/stdyDscr/dataAccs/useStmt/citReq">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                   <xsl:value-of select="$i18n-Citation_Requirements" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/dataAccs/useStmt/citReq" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- ============================= -->
          <!-- Space                         -->
          <!-- ============================= -->
          <fo:table-row height="0.2in">
            <fo:table-cell number-columns-spanned="2">
              <fo:block/>
            </fo:table-cell>
          </fo:table-row>

          <!-- ===================== -->
          <!-- Rights and Disclaimer -->
          <!-- ===================== -->
          <xsl:if test="$show-rights-and-disclaimer = 'True'">
            <fo:table-row background-color="{$color-gray1}" keep-with-next="always">
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block id="rights-and-disclaimer" font-size="12pt" font-weight="bold">
                  <xsl:value-of select="$i18n-Rights_and_Disclaimer" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Disclaimer -->
          <xsl:if test="/codeBook/stdyDscr/dataAccs/useStmt/disclaimer">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$i18n-Disclaimer" />
                </fo:block>
                <xsl:apply-templates select="/codeBook/stdyDscr/dataAccs/useStmt/disclaimer" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- Copyright -->
          <xsl:if test="/codeBook/stdyDscr/citation/prodStmt/copyright">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$i18n-Copyright" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/codeBook/stdyDscr/citation/prodStmt/copyright" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

        </fo:table-body>
      </fo:table>
    </fo:flow>
  </fo:page-sequence>
</xsl:if>
