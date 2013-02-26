<?xml version='1.0' encoding='utf-8'?>

<!-- ddi-var.xsl -->

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
                version="1.0" extension-element-prefixes="date exsl str">
  <xsl:output version="1.0" encoding="UTF-8" indent="no"
              omit-xml-declaration="no" media-type="text/html"/>

  <!-- ======================== -->
  <!-- match: ddi:var / default -->
  <!-- fo:table-row             -->
  <!-- ======================== -->

  <!--
    parameters used:
    ($fileId)

    global vars read:
    $cell-padding, $color-gray1, $default-border, $msg,
    $show-variables-description-categories-max, $subsetVars,

    local vars set:
    $statistics, $type, $label, $category-count, $is-weighted,
    $catgry-freq-nodes, $catgry-sum-freq, $catgry-sum-freq-wgtd,
    $catgry-max-freq, $catgry-max-freq-wgtd, $bar-column-width, $catgry-freq

    XPath 1.0 functions called:
    concat(), contains(), string-length(), normalize-space(), number(),
    position(), string()

    templates called:
    [math:max], [trim]
  -->

  <!--
    1: Information                <fo:table-row>
    2: Statistics                 <fo:table-row>
    3: Definition                 <fo:table-row>
    4: Universe                   <fo:table-row>
    5: Source                     <fo:table-row>
    6: Pre-Question               <fo:table-row>
    7: Question                   <fo:table-row>
    8: Post-Question              <fo:table-row>
    9: Interviewer Instructions   <fo:table-row>
   10: Imputation                 <fo:table-row>
   11: Recoding                   <fo:table-row>
   12: Security                   <fo:table-row>
   13: Concepts                   <fo:table-row>
   14: Notes                      <fo:table-row>
   15: Categories                 <fo:table-row>
  -->


  <xsl:template match="ddi:var">

    <!-- ========== -->
    <!-- Parameters -->
    <!-- ========== -->
    <xsl:param name="fileId" select="./@files"/> <!-- use first file in @files if not specified) -->

    <!-- ====================== -->
    <!-- r) [fo:table row] Main -->
    <!-- ====================== -->
    <xsl:if test="contains($subsetVars,concat(',',@ID,',')) or string-length($subsetVars)=0 ">
      <fo:table-row text-align="center" vertical-align="top">
        <fo:table-cell>
          <fo:table id="var-{@ID}" table-layout="fixed" width="100%" font-size="8pt" space-after="0.3in">
            <fo:table-column column-width="proportional-column-width(20)"/>
            <fo:table-column column-width="proportional-column-width(80)"/>

            <!-- =================================== -->
            <!-- [fo:table-header] Main table Header -->
            <!-- =================================== -->
            <fo:table-header>
              <fo:table-row background-color="{$color-gray1}" text-align="center" vertical-align="top">
                <fo:table-cell number-columns-spanned="2" font-size="10pt" font-weight="bold" text-align="left" border="{$default-border}" padding="{$cell-padding}">
                  <fo:block>
                    <fo:inline font-size="8pt" font-weight="normal" vertical-align="text-top">#
                      <xsl:value-of select="./@id"/>
                      <xsl:text> </xsl:text>
                    </fo:inline>

                    <xsl:value-of select="./@name"/>

                    <xsl:if test="normalize-space(./ddi:labl)">
                      <xsl:text>: </xsl:text>
                      <xsl:value-of select="normalize-space(./ddi:labl)"/>
                    </xsl:if>

                  </fo:block>
                </fo:table-cell>
              </fo:table-row>
            </fo:table-header>

            <!-- =============================== -->
            <!-- [fo:table-body] Main table body -->
            <!-- =============================== -->
            <fo:table-body>

              <!-- 1) [fo:table-row] Information -->
              <fo:table-row text-align="center" vertical-align="top">

                <fo:table-cell font-weight="bold" text-align="left" border="{$default-border}" padding="{$cell-padding}">
                  <fo:block>
                    <xsl:value-of select="$msg/*/entry[@key='Information']"/>
                  </fo:block>
                </fo:table-cell>

                <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                  <fo:block>

                    <!-- Information: Type -->
                    <xsl:if test="normalize-space(@intrvl)">
                      <xsl:text> [</xsl:text>
                      <xsl:value-of select="$msg/*/entry[@key='Type']"/>=
                      <xsl:choose>
                        <xsl:when test="@intrvl='discrete'">
                          <xsl:value-of select="$msg/*/entry[@key='discrete']"/>
                        </xsl:when>
                        <xsl:when test="@intrvl='contin'">
                          <xsl:value-of select="$msg/*/entry[@key='continuous']"/>
                        </xsl:when>
                      </xsl:choose>
                      <xsl:text>] </xsl:text>
                    </xsl:if>

                    <!-- Information: Format -->
                    <xsl:for-each select="ddi:varFormat">
                      <xsl:text> [</xsl:text>
                      <xsl:value-of select="$msg/*/entry[@key='Format']"/>=
                      <xsl:value-of select="@type"/>
                      <xsl:if test="normalize-space(ddi:location/@width)">
                        <xsl:text>-</xsl:text>
                        <xsl:value-of select="ddi:location/@width"/>
                      </xsl:if>
                      <xsl:if test="normalize-space(@dcml)">
                        <xsl:text>.</xsl:text>
                        <xsl:value-of select="@dcml"/>
                      </xsl:if>
                      <xsl:text>] </xsl:text>
                    </xsl:for-each>

                    <!-- Information: Range -->
                    <xsl:for-each select="ddi:valrng/ddi:range">
                      <xsl:text> [</xsl:text>
                      <xsl:value-of select="$msg/*/entry[@key='Range']"/>=
                      <xsl:value-of select="@min"/>-
                      <xsl:value-of select="@max"/>
                      <xsl:text>] </xsl:text>
                    </xsl:for-each>

                    <!-- Infotmation: Missing -->
                    <xsl:text> [</xsl:text>
                    <xsl:value-of select="$msg/*/entry[@key='Missing']"/>
                    <xsl:text>=*</xsl:text>
                    <xsl:for-each select="ddi:invalrng/ddi:item">
                      <xsl:text>/</xsl:text>
                      <xsl:value-of select="@VALUE"/>
                    </xsl:for-each>
                    <xsl:text>] </xsl:text>

                  </fo:block>
                </fo:table-cell>
              </fo:table-row>

              <!-- 2) [fo:table-row] Statistics -->
              <xsl:variable name="statistics" select="ddi:sumStat[contains('vald invd mean stdev',@type)]"/>

              <xsl:if test="$statistics">
                <fo:table-row text-align="center" vertical-align="top">
                  <fo:table-cell font-weight="bold" text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block>
                      <xsl:value-of select="$msg/*/entry[@key='Statistics']"/>
                      <xsl:text> [</xsl:text>
                      <xsl:value-of select="$msg/*/entry[@key='Abbrev_NotWeighted']"/>
                      <xsl:text>/ </xsl:text>
                      <xsl:value-of select="$msg/*/entry[@key='Abbrev_Weighted']"/>
                      <xsl:text>]</xsl:text>
                    </fo:block>
                  </fo:table-cell>

                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block>

                      <!-- Statistics: Summary statistics -->
                      <xsl:for-each select="$statistics[not(@wgtd)]">
                        <xsl:variable name="type" select="@type"/>

                        <xsl:variable name="label">
                          <xsl:choose>
                            <xsl:when test="@type='vald' ">
                              <xsl:value-of select="$msg/*/entry[@key='Valid']"/>
                            </xsl:when>
                            <xsl:when test="@type='invd' ">
                              <xsl:value-of select="$msg/*/entry[@key='Invalid']"/>
                            </xsl:when>
                            <xsl:when test="@type='mean' ">
                              <xsl:value-of select="$msg/*/entry[@key='Mean']"/>
                            </xsl:when>
                            <xsl:when test="@type='stdev' ">
                              <xsl:value-of select="$msg/*/entry[@key='StdDev']"/>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="@type"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:variable>

                        <xsl:text> [</xsl:text>
                        <xsl:value-of select="$label"/>
                        <xsl:text>=</xsl:text>
                        <xsl:value-of select="normalize-space(.)"/>

                        <!-- Statistics: Weighted value -->
                        <xsl:text> /</xsl:text>
                        <xsl:choose>
                          <xsl:when test="following-sibling::ddi:sumStat[1]/@type=$type and following-sibling::ddi:sumStat[1]/@wgtd">
                            <xsl:value-of select="following-sibling::ddi:sumStat[1]"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:text>-</xsl:text>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:text>] </xsl:text>
                      </xsl:for-each>
                    </fo:block>
                  </fo:table-cell>

                </fo:table-row>
              </xsl:if>

              <!-- 3) [fo:table-row] Definition  -->
              <xsl:if test="normalize-space(./ddi:txt)">
                <fo:table-row text-align="center" vertical-align="top">
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block font-weight="bold">
                      <xsl:value-of select="$msg/*/entry[@key='Definition']"/>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block>
                      <xsl:apply-templates select="./ddi:txt"/>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </xsl:if>

              <!-- 4) [fo:table-row] Universe  -->
              <xsl:if test="normalize-space(./ddi:universe)">
                <fo:table-row text-align="center" vertical-align="top">
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block font-weight="bold">
                      <xsl:value-of select="$msg/*/entry[@key='Universe']"/>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block>
                      <xsl:apply-templates select="./ddi:universe"/>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </xsl:if>

              <!-- 5) [fo:table-row] Source -->
              <xsl:if test="normalize-space(./ddi:respUnit)">
                <fo:table-row text-align="center" vertical-align="top">
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block font-weight="bold">
                      <xsl:value-of select="$msg/*/entry[@key='Source']"/>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block>
                      <xsl:apply-templates select="./ddi:respUnit"/>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </xsl:if>

              <!-- 6) [fo:table-row] Pre-Question -->
              <xsl:if test="normalize-space(./ddi:qstn/ddi:preQTxt)">
                <fo:table-row text-align="center" vertical-align="top">
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block font-weight="bold">
                      <xsl:value-of select="$msg/*/entry[@key='Pre-question']"/>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block>
                      <xsl:apply-templates select="./ddi:qstn/ddi:preQTxt"/>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </xsl:if>

              <!-- 7) [fo:table-row] Question -->
              <xsl:if test="normalize-space(./ddi:qstn/ddi:qstnLit)">
                <fo:table-row text-align="center" vertical-align="top">
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block font-weight="bold">
                      <xsl:value-of select="$msg/*/entry[@key='Literal_question']"/>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block>
                      <xsl:apply-templates select="./ddi:qstn/ddi:qstnLit"/>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </xsl:if>

              <!-- 8) [fo:table-row] Post-question -->
              <xsl:if test="normalize-space(./ddi:qstn/ddi:postQTxt)">
                <fo:table-row text-align="center" vertical-align="top">
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block font-weight="bold">
                      <xsl:value-of select="$msg/*/entry[@key='Post-question']"/>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block>
                      <xsl:apply-templates select="./ddi:qstn/ddi:postQTxt"/>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </xsl:if>

              <!-- 9) [fo:table-row] Interviewer instructions -->
              <xsl:if test="normalize-space(./ddi:qstn/ddi:ivuInstr)">
                <fo:table-row text-align="center" vertical-align="top">
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block font-weight="bold">
                      <xsl:value-of select="$msg/*/entry[@key='Interviewers_instructions']"/>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block>
                      <xsl:apply-templates select="./ddi:qstn/ddi:ivuInstr"/>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </xsl:if>

              <!-- 10) [fo:table-row] Imputation -->
              <xsl:if test="normalize-space(./ddi:imputation)">
                <fo:table-row text-align="center" vertical-align="top">
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block font-weight="bold">
                      <xsl:value-of select="$msg/*/entry[@key='Imputation']"/>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block>
                      <xsl:apply-templates select="./ddi:imputation"/>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </xsl:if>

              <!-- 11) [fo:table-row] Recoding -->
              <xsl:if test="normalize-space(./ddi:codInstr)">
                <fo:table-row text-align="center" vertical-align="top">
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block font-weight="bold">
                      <xsl:value-of select="$msg/*/entry[@key='Recoding_and_Derivation']"/>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block>
                      <xsl:apply-templates select="./ddi:codInstr"/>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </xsl:if>

              <!-- 12) [fo:table-row] Security -->
              <xsl:if test="normalize-space(./ddi:security)">
                <fo:table-row text-align="center" vertical-align="top">
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block font-weight="bold">
                      <xsl:value-of select="$msg/*/entry[@key='Security']"/>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block>
                      <xsl:apply-templates select="./ddi:security"/>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </xsl:if>

              <!-- 13) [fo:table-row] Concepts -->
              <xsl:if test="normalize-space(./ddi:concept)">
                <fo:table-row text-align="center" vertical-align="top">
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block font-weight="bold">
                      <xsl:value-of select="$msg/*/entry[@key='Concepts']"/>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block>
                      <xsl:for-each select="./ddi:concept">
                        <xsl:if test="position()&gt;1">, </xsl:if>
                        <xsl:value-of select="normalize-space(.)"/>
                      </xsl:for-each>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </xsl:if>

              <!-- 14) [fo:table-row] Notes -->
              <xsl:if test="normalize-space(./ddi:notes)">
                <fo:table-row text-align="center" vertical-align="top">
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block font-weight="bold">
                      <xsl:value-of select="$msg/*/entry[@key='Notes']"/>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                    <fo:block>
                      <xsl:apply-templates select="./ddi:notes"/>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </xsl:if>

              <!-- 15) [fo:table-row] Categories -->
              <xsl:if test="$show-variables-description-categories=1 and normalize-space(./ddi:catgry)">
                <xsl:variable name="category-count" select="count(ddi:catgry)"/>

                <fo:table-row text-align="center" vertical-align="top">
                  <xsl:choose>

                    <!-- ======================= -->
                    <!-- Case 1) [fo:table-cell] -->
                    <!-- ======================= -->
                    <xsl:when test="number($show-variables-description-categories-max) &gt;= $category-count">
                      <fo:table-cell text-align="left" border="{$default-border}" number-columns-spanned="2" padding="{$cell-padding}">


                        <!-- Variables -->
                        <xsl:variable name="is-weighted" select="count(ddi:catgry/ddi:catStat[@type='freq' and @wgtd='wgtd' ]) &gt; 0"/>
                        <xsl:variable name="catgry-freq-nodes" select="ddi:catgry[not(@missing='Y')]/ddi:catStat[@type='freq']"/>
                        <xsl:variable name="catgry-sum-freq" select="sum($catgry-freq-nodes[ not(@wgtd='wgtd') ])"/>
                        <xsl:variable name="catgry-sum-freq-wgtd" select="sum($catgry-freq-nodes[ @wgtd='wgtd'])"/>

                        <xsl:variable name="catgry-max-freq">
                          <xsl:call-template name="math:max">
                            <xsl:with-param name="nodes" select="$catgry-freq-nodes[ not(@wgtd='wgtd') ]"/>
                          </xsl:call-template>
                        </xsl:variable>

                        <xsl:variable name="catgry-max-freq-wgtd">
                          <xsl:call-template name="math:max">
                            <xsl:with-param name="nodes" select="$catgry-freq-nodes[@type='freq' and @wgtd='wgtd' ]"/>
                          </xsl:call-template>
                        </xsl:variable>

                        <!-- [fo:table] Render table -->
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

                          <!-- [fo:table-header] Table header -->
                          <fo:table-header>
                            <fo:table-row background-color="{$color-gray1}" text-align="left" vertical-align="top">
                              <fo:table-cell border="0.5pt solid white" padding="{$cell-padding}">
                                <fo:block font-weight="bold">
                                  <xsl:value-of select="$msg/*/entry[@key='Value']"/>
                                </fo:block>
                              </fo:table-cell>
                              <fo:table-cell border="0.5pt solid white" padding="{$cell-padding}">
                                <fo:block font-weight="bold">
                                  <xsl:value-of select="$msg/*/entry[@key='Label']"/>
                                </fo:block>
                              </fo:table-cell>
                              <fo:table-cell border="0.4pt solid white" padding="{$cell-padding}" text-align="center">
                                <fo:block font-weight="bold">
                                  <xsl:value-of select="$msg/*/entry[@key='Cases_Abbreviation']"/>
                                </fo:block>
                              </fo:table-cell>
                              <xsl:if test="$is-weighted">
                                <fo:table-cell border="0.4pt solid white" padding="{$cell-padding}" text-align="center">
                                  <fo:block font-weight="bold">
                                    <xsl:value-of select="$msg/*/entry[@key='Weighted']"/>
                                  </fo:block>
                                </fo:table-cell>
                              </xsl:if>
                              <fo:table-cell border="0.4pt solid white" padding="{$cell-padding}" text-align="center">
                                <fo:block font-weight="bold">
                                  <xsl:value-of select="$msg/*/entry[@key='Percentage']"/>
                                  <xsl:if test="$is-weighted"> (
                                    <xsl:value-of select="$msg/*/entry[@key='Weighted']"/>)
                                  </xsl:if>
                                </fo:block>
                              </fo:table-cell>
                            </fo:table-row>
                          </fo:table-header>

                          <!-- [fo:table-body] Table body -->
                          <fo:table-body>
                            <xsl:for-each select="ddi:catgry">
                              <fo:table-row background-color="{$color-gray2}" text-align="center" vertical-align="top">

                                <!-- [fo:table-cell] Value -->
                                <fo:table-cell text-align="left" border="0.5pt solid white" padding="2pt">
                                  <fo:block>
                                    <xsl:call-template name="trim">
                                      <xsl:with-param name="s" select="ddi:catValu"/>
                                    </xsl:call-template>
                                  </fo:block>
                                </fo:table-cell>

                                <!-- [fo:table-cell] Label -->
                                <fo:table-cell text-align="left" border="0.5pt solid white" padding="2pt">
                                  <fo:block>
                                    <xsl:call-template name="trim">
                                      <xsl:with-param name="s" select="ddi:labl"/>
                                    </xsl:call-template>
                                  </fo:block>
                                </fo:table-cell>

                                <!-- [fo:table-cell] Frequency -->
                                <xsl:variable name="catgry-freq" select="ddi:catStat[@type='freq' and not(@wgtd='wgtd') ]"/>
                                <fo:table-cell text-align="center" border="0.5pt solid white" padding="2pt">
                                  <fo:block>
                                    <xsl:call-template name="trim">
                                      <xsl:with-param name="s" select="$catgry-freq"/>
                                    </xsl:call-template>
                                  </fo:block>
                                </fo:table-cell>

                                <!-- [fo:table-cell] Weighted frequency -->
                                <xsl:variable name="catgry-freq-wgtd" select="ddi:catStat[@type='freq' and @wgtd='wgtd' ]"/>
                                <xsl:if test="$is-weighted">
                                  <fo:table-cell text-align="center" border="0.5pt solid white" padding="2pt">
                                    <fo:block>
                                      <xsl:call-template name="trim">
                                        <xsl:with-param name="s" select="format-number($catgry-freq-wgtd,'0.0')"/>
                                      </xsl:call-template>
                                    </fo:block>
                                  </fo:table-cell>
                                </xsl:if>

                                <!-- Percentage Bar-->
                                <!-- compute percentage -->
                                <xsl:variable name="catgry-pct">
                                  <xsl:choose>
                                    <xsl:when test="$is-weighted">
                                      <xsl:value-of select="$catgry-freq-wgtd div $catgry-sum-freq-wgtd"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      <xsl:value-of select="$catgry-freq div $catgry-sum-freq"/>
                                    </xsl:otherwise>
                                  </xsl:choose>
                                </xsl:variable>
                                <!-- compute bar width (percentage of highest value minus some space to display the percentage value) -->
                                <xsl:variable name="tmp-col-width-1">
                                  <xsl:choose>
                                    <xsl:when test="$is-weighted">
                                      <xsl:value-of select="($catgry-freq-wgtd div $catgry-max-freq-wgtd) * ($bar-column-width - 0.5)"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      <xsl:value-of select="($catgry-freq div $catgry-max-freq) * ($bar-column-width - 0.5)"/>
                                    </xsl:otherwise>
                                  </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="col-width-1">
                                  <!--	ToDO: handle exceptions regarding column-width	-->
                                  <xsl:choose>
                                    <xsl:when test="string(number($tmp-col-width-1)) != 'NaN'">
                                      <xsl:value-of select="$tmp-col-width-1"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      0
                                    </xsl:otherwise>
                                  </xsl:choose>
                                </xsl:variable>
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
                            <!-- category total -->
                            <!-- TODO -->
                          </fo:table-body>
                        </fo:table>

                        <!-- [fo:block] Warning about summary of statistics? -->
                        <fo:block font-weight="bold" color="#400000" font-size="6pt" font-style="italic">
                          <xsl:value-of select="$msg/*/entry[@key='SumStat_Warning']"/>
                        </fo:block>

                      </fo:table-cell>
                    </xsl:when>

                    <!-- ======================= -->
                    <!-- Case 2) [fo:table-cell] -->
                    <!-- ======================= -->
                    <xsl:otherwise>
                      <fo:table-cell background-color="{$color-gray1}" text-align="center" font-style="italic" border="{$default-border}" number-columns-spanned="2" padding="{$cell-padding}">
                        <fo:block>
                          <xsl:value-of select="$msg/*/entry[@key='Frequency_table_not_shown']"/>
                          <xsl:text> </xsl:text>(
                          <xsl:value-of select="$category-count"/>
                          <xsl:text> </xsl:text>
                          <xsl:value-of select="$msg/*/entry[@key='Modalities']"/>)
                        </fo:block>
                      </fo:table-cell>
                    </xsl:otherwise>

                  </xsl:choose>
                </fo:table-row>
              </xsl:if>

            </fo:table-body>
          </fo:table> <!-- end of variable table -->

        </fo:table-cell>
      </fo:table-row>

    </xsl:if>

  </xsl:template>
</xsl:stylesheet>