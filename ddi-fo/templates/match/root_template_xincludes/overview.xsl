<?xml version='1.0' encoding='UTF-8'?>

<!-- ================================================ -->
<!-- Overview                                         -->
<!-- [page-sequence] with [table]                     -->
<!-- ================================================ -->

<!--
  Variables read:
  msg, report-start-page-number, font-family, color-gray3
  default-border, cell-padding, survey-title, color-gray1, time

  Functions/templates called:
  nomalize-space(), position() [Xpath]
  proportional-column-width() [FO]
-->

<xsl:if test="$show-overview = 1"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <fo:page-sequence master-reference="{$page-layout}"
                    initial-page-number="{$report-start-page-number}"
                    font-family="{$font-family}"
                    font-size="{$font-size}">

    <!-- =========================================== -->
    <!-- page header                                 -->
    <!-- =========================================== -->

    <fo:static-content flow-name="before">
      <fo:block font-size="{$header-font-size}" text-align="center">
        <xsl:value-of select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:titlStmt/ddi:titl" /> -
        <xsl:value-of select="$strings/*/entry[@key='Overview']" />
      </fo:block>
    </fo:static-content>

    <!-- =========================================== -->
    <!-- page footer                                 -->
    <!-- =========================================== -->
    
    <fo:static-content flow-name="after">
      <fo:block font-size="{$footer-font-size}" text-align="center" space-before="0.3in">
        - <fo:page-number /> -
      </fo:block>
    </fo:static-content>

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
              <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:titlStmt/ddi:parTitl">
                <fo:block font-size="12pt" font-weight="bold" font-style="italic">
                  <xsl:value-of select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:titlStmt/ddi:parTitl" />
                </fo:block>
              </xsl:if>

            </fo:table-cell>
          </fo:table-row>

          <!-- ================== -->
          <!-- blank space        -->
          <!-- ================== -->
          <fo:table-row height="0.2in">
            <fo:table-cell number-columns-spanned="2">
              <fo:block />
            </fo:table-cell>
          </fo:table-row>

          <!-- ========================= -->
          <!-- $strings Overview             -->
          <!-- ========================= -->
          <fo:table-row background-color="{$color-gray1}" keep-with-next="always">
            <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
              <fo:block id="overview" font-size="12pt" font-weight="bold">
                <xsl:value-of select="$strings/*/entry[@key='Overview']" />
              </fo:block>
            </fo:table-cell>
          </fo:table-row>

          <!-- [$strings Type][ddi:serName]  -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:serStmt/ddi:serName">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$strings/*/entry[@key='Type']" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:serStmt/ddi:serName" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- [$strings Identification][ddi:IDNo] -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:titlStmt/ddi:IDNo">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$strings/*/entry[@key='Identification']" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:titlStmt/ddi:IDNo" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- [$strings Version][ddi] -->
          <xsl:for-each select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:verStmt/ddi:version">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$strings/*/entry[@key='Version']" />
                </fo:block>
              </fo:table-cell>

              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">

                <!-- 5.1) Production_Date -->
                <xsl:for-each select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:verStmt/ddi:version">
                  <xsl:if test="@date">
                    <fo:block>
                      <xsl:value-of select="$strings/*/entry[@key='Production_Date']" />:
                      <xsl:value-of select="@date" />
                    </fo:block>
                  </xsl:if>
                  <xsl:apply-templates select="." />
                </xsl:for-each>

                <!-- 5.2) Notes -->
                <xsl:for-each select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:verStmt/ddi:notes">
                  <fo:block text-decoration="underline">
                    <xsl:value-of select="$strings/*/entry[@key='Notes']" />
                  </fo:block>
                  <xsl:apply-templates select="." />
                </xsl:for-each>

              </fo:table-cell>
            </fo:table-row>
          </xsl:for-each>

          <!-- 6) Series -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:serStmt/ddi:serInfo">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$strings/*/entry[@key='Series']" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:serStmt/ddi:serInfo" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 7) Abstract -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:abstract">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$strings/*/entry[@key='Abstract']" />
                </fo:block>
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:abstract" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 8) Kind_of_Data -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:dataKind">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$strings/*/entry[@key='Kind_of_Data']" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:dataKind" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 9) Unit_of_Analysis  -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:anlyUnit">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$strings/*/entry[@key='Unit_of_Analysis']" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:anlyUnit" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- ================== -->
          <!-- blank space        -->
          <!-- ================== -->
          <fo:table-row height="0.2in">
            <fo:table-cell number-columns-spanned="2">
              <fo:block/>
            </fo:table-cell>
          </fo:table-row>

          <!-- =========================== -->
          <!-- Scope_and_Coverage          -->
          <!-- =========================== -->
                           
          <xsl:if test="$show-scope-and-coverage = 1">
            <fo:table-row background-color="{$color-gray1}" keep-with-next="always">
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block id="scope-and-coverage" font-size="12pt" font-weight="bold">
                  <xsl:value-of select="$strings/*/entry[@key='Scope_and_Coverage']" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 11) Scope -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:notes">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$strings/*/entry[@key='Scope']" />
                </fo:block>
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:notes" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 12) Keywords -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:subject/ddi:keyword">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$strings/*/entry[@key='Keywords']" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:for-each select="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:subject/ddi:keyword">
                    <xsl:if test="position()&gt;1">, </xsl:if>
                    <xsl:value-of select="normalize-space(.)" />
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 13) Topics -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:subject/ddi:topcClas">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$strings/*/entry[@key='Topics']" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:for-each select="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:subject/ddi:topcClas">
                    <xsl:if test="position()&gt;1">, </xsl:if>
                    <xsl:value-of select="normalize-space(.)" />
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 14) Time_Periods -->
          <xsl:if test="string-length($time)&gt;3 or string-length($time-produced)&gt;3">
            <fo:table-row>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$strings/*/entry[@key='Time_Periods']" />
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

          <!-- 15) Countries -->
          <fo:table-row>
            <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
              <fo:block font-weight="bold" text-decoration="underline">
                <xsl:value-of select="$strings/*/entry[@key='Countries']" />
              </fo:block>
            </fo:table-cell>
            <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
              <fo:block>
                <xsl:value-of select="$geography" />
              </fo:block>
            </fo:table-cell>
          </fo:table-row>

          <!-- 16) Geographic_Coverage -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:geogCover">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$strings/*/entry[@key='Geographic_Coverage']" />
                </fo:block>
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:geogCover" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 17) Universe -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:universe">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$strings/*/entry[@key='Universe']" />
                </fo:block>
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:universe" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- ============================= -->
          <fo:table-row height="0.2in">
            <fo:table-cell number-columns-spanned="2">
              <fo:block/>
            </fo:table-cell>
          </fo:table-row>

          <!-- 18) Producers_and_Sponsors -->
          <xsl:if test="$show-producers-and-sponsors = 1">
            <fo:table-row background-color="{$color-gray1}" keep-with-next="always">
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block id="producers-and-sponsors" font-size="12pt" font-weight="bold">
                  <xsl:value-of select="$strings/*/entry[@key='Producers_and_Sponsors']" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 19) Primary Investigator(s) -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:rspStmt/ddi:AuthEnty">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$strings/*/entry[@key='Primary_Investigators']" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:rspStmt/ddi:AuthEnty" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 20) [fo:table-row] Other Producer(s) -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:prodStmt/ddi:producer">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$strings/*/entry[@key='Other_Producers']" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:prodStmt/ddi:producer" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 21) [fo:table-row] Funding -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:prodStmt/ddi:fundAg">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$strings/*/entry[@key='Funding_Agencies']" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:prodStmt/ddi:fundAg" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 22) [fo:table-row] Other Acknowledgements -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:rspStmt/ddi:othId">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$strings/*/entry[@key='Other_Acknowledgments']" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:rspStmt/ddi:othId" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- ===[separator]=== -->
          <fo:table-row height="0.2in">
            <fo:table-cell number-columns-spanned="2">
              <fo:block/>
            </fo:table-cell>
          </fo:table-row>

          <!-- 23) [fo:table-row] Sampling -->
          <xsl:if test="$show-sampling = 1">
            <fo:table-row background-color="{$color-gray1}">
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block id="sampling" font-size="12pt" font-weight="bold">
                  <xsl:value-of select="$strings/*/entry[@key='Sampling']" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 24) Sampling Procedure -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:sampProc">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$strings/*/entry[@key='Sampling_Procedure']" />
                </fo:block>
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:sampProc" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 25) [fo:table-row] Deviations from Sample -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:deviat">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$strings/*/entry[@key='Deviations_from_Sample_Design']" />
                </fo:block>
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:deviat" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 26) [fo:table-row] Response Rate -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:anlyInfo/ddi:respRate">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$strings/*/entry[@key='Response_Rate']" />
                </fo:block>
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:anlyInfo/ddi:respRate" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 27) [fo:table-row] Weighting -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:weight">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$strings/*/entry[@key='Weighting']" />
                </fo:block>
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:weight" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- =============================== -->
          <fo:table-row height="0.2in">
            <fo:table-cell number-columns-spanned="2">
              <fo:block/>
            </fo:table-cell>
          </fo:table-row>

          <!-- 28) Data Collection -->
          <xsl:if test="$show-data-collection = 1">
            <fo:table-row background-color="{$color-gray1}" keep-with-next="always">
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block id="data-collection" font-size="12pt" font-weight="bold">
                  <xsl:value-of select="$strings/*/entry[@key='Data_Collection']" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 29) Data Collection Dates -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:collDate">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$strings/*/entry[@key='Data_Collection_Dates']" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:collDate" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 30) Time Periods -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:timePrd">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$strings/*/entry[@key='Time_Periods']" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:stdyInfo/ddi:sumDscr/ddi:timePrd" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 31) Data Collection Mode -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:collMode">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$strings/*/entry[@key='Data_Collection_Mode']" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:collMode" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 32) Data Collection Notes -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:notes[@subject='collection']">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$strings/*/entry[@key='Data_Collection_Notes']" />
                </fo:block>
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:notes[@subject='collection']" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 33) DDP Data Processing Notes -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:notes[@subject='processing']">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$strings/*/entry[@key='Data_Processing_Notes']" />
                </fo:block>
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:notes[@subject='collection']" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 34) Data Cleaning Notes -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:notes[@subject='cleaning']">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$strings/*/entry[@key='Data_Cleaning_Notes']" />
                </fo:block>
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:notes[@subject='collection']" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 35) Data_Collection_Notes -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:collSitu">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$strings/*/entry[@key='Data_Collection_Notes']" />
                </fo:block>
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:collSitu" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 36) Questionnaires -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:resInstru">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$strings/*/entry[@key='Questionnaires']" />
                </fo:block>
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:resInstru" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 37) Data_Collectors -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:dataCollector">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$strings/*/entry[@key='Data_Collectors']" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:dataCollector" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 38) Supervision -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:actMin">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$strings/*/entry[@key='Supervision']" />
                </fo:block>
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:actMin" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- =============================== -->
          <fo:table-row height="0.2in">
            <fo:table-cell number-columns-spanned="2">
              <fo:block/>
            </fo:table-cell>
          </fo:table-row>

          <!-- 39) Data Processing and Appraisal -->
          <xsl:if test="$show-data-processing-and-appraisal = 1">
            <fo:table-row background-color="{$color-gray1}" keep-with-next="always">
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block id="data-processing-and-appraisal" font-size="12pt" font-weight="bold">
                  <xsl:value-of select="$strings/*/entry[@key='Data_Processing_and_Appraisal']" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 40) Data Editing -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:cleanOps">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$strings/*/entry[@key='Data_Editing']" />
                </fo:block>
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:dataColl/ddi:cleanOps" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 41) Other Processing -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:notes">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$strings/*/entry[@key='Other_Processing']" />
                </fo:block>
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:notes" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 42) Estimates of Sampling Error -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:anlyInfo/ddi:EstSmpErr">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$strings/*/entry[@key='Estimates_of_Sampling_Error']" />
                </fo:block>
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:anlyInfo/ddi:EstSmpErr" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 43) Other_Forms_of_Data_Appraisal -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:anlyInfo/ddi:dataAppr">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$strings/*/entry[@key='Other_Forms_of_Data_Appraisal']" />
                </fo:block>
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:method/ddi:anlyInfo/ddi:dataAppr" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- ============================= -->
          <fo:table-row height="0.2in">
            <fo:table-cell number-columns-spanned="2">
              <fo:block/>
            </fo:table-cell>
          </fo:table-row>

          <!-- 44) Accesibility -->
          <xsl:if test="$show-accessibility = 1">
            <fo:table-row background-color="{$color-gray1}" keep-with-next="always">
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block id="accessibility" font-size="12pt" font-weight="bold">
                  <xsl:value-of select="$strings/*/entry[@key='Accessibility']" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 45) Access Authority -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:dataAccs/ddi:useStmt/ddi:contact">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$strings/*/entry[@key='Access_Authority']" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:dataAccs/ddi:useStmt/ddi:contact" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 46) Contacts -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:distStmt/ddi:contact">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$strings/*/entry[@key='Contacts']" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:distStmt/ddi:contact" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 47) Distributor -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:distStmt/ddi:distrbtr">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$strings/*/entry[@key='Distributors']" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:distStmt/ddi:distrbtr" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 48) Depositors (DDP) -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:distStmt/ddi:depositr">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$strings/*/entry[@key='Depositors']" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:distStmt/ddi:depositr" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 49) Confidentiality -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:dataAccs/ddi:useStmt/ddi:confDec">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$strings/*/entry[@key='Confidentiality']" />
                </fo:block>
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:dataAccs/ddi:useStmt/ddi:confDec" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 50) Access Conditions -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:dataAccs/ddi:useStmt/ddi:conditions">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$strings/*/entry[@key='Access_Conditions']" />
                </fo:block>
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:dataAccs/ddi:useStmt/ddi:conditions" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 51) Citation Requierments -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:dataAccs/ddi:useStmt/ddi:citReq">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$strings/*/entry[@key='Citation_Requirements']" />
                </fo:block>
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:dataAccs/ddi:useStmt/ddi:citReq" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- ================================= -->
          <fo:table-row height="0.2in">
            <fo:table-cell number-columns-spanned="2">
              <fo:block/>
            </fo:table-cell>
          </fo:table-row>

          <!-- 52) Rights and Disclaimer -->
          <xsl:if test="$show-rights-and-disclaimer = 1">
            <fo:table-row background-color="{$color-gray1}" keep-with-next="always">
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block id="rights-and-disclaimer" font-size="12pt" font-weight="bold">
                  <xsl:value-of select="$strings/*/entry[@key='Rights_and_Disclaimer']" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 53) Disclaimer -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:dataAccs/ddi:useStmt/ddi:disclaimer">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$strings/*/entry[@key='Disclaimer']" />
                </fo:block>
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:dataAccs/ddi:useStmt/ddi:disclaimer" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 54) Copyright -->
          <xsl:if test="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:prodStmt/ddi:copyright">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$strings/*/entry[@key='Copyright']" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:prodStmt/ddi:copyright" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

        </fo:table-body>
      </fo:table>
    </fo:flow>
  </fo:page-sequence>
</xsl:if>
