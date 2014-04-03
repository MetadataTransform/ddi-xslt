<?xml version='1.0' encoding='utf-8'?>
<!-- var.xsl -->
<!-- ================================== -->
<!-- match: var                         -->
<!-- value: <xsl:if> <fo:table-row>     -->
<!-- ================================== -->

<!-- read: -->
<!-- $cell-padding, $color-gray1, $default-border, -->
<!-- $show-variables-description-categories-max -->

<!-- set: -->
<!-- $statistics, $type, $label, $category-count, $is-weighted,  -->
<!-- $catgry-freq-nodes, $catgry-sum-freq, $catgry-sum-freq-wgtd,-->
<!-- $catgry-max-freq, $catgry-max-freq-wgtd, -->
<!-- $bar-column-width, $catgry-freq -->

<!-- functions: -->
<!-- concat(), contains(), string-length(), normalize-space(), -->
<!-- number(), position(), string() [Xpath 1.0] -->
<!-- util:trim(), util:math_max() [local] -->

<xsl:template match="var"
  xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format">
  
  <fo:table-row text-align="center" vertical-align="top">
    <fo:table-cell>
      <fo:table id="var-{@ID}" table-layout="fixed" width="100%" font-size="8pt" space-after="7.5mm">
        <fo:table-column column-width="proportional-column-width(20)" />
        <fo:table-column column-width="proportional-column-width(80)" />
        
        <!-- ============ -->
        <!-- table Header -->
        <!-- ============ -->
        <fo:table-header>
          <fo:table-row background-color="{$color-gray1}" text-align="center" vertical-align="top">
            <fo:table-cell number-columns-spanned="2" font-size="10pt" font-weight="bold"
              text-align="left" border="{$default-border}" padding="{$cell-padding}">
              <fo:block>
                <fo:inline font-size="8pt" font-weight="normal" vertical-align="text-top">
                  <xsl:text>#</xsl:text>
                  <xsl:value-of select="./@id" />
                  <xsl:text> </xsl:text>
                </fo:inline>
                
                <xsl:value-of select="./@name" />
                
                <xsl:if test="normalize-space(./labl)">
                  <xsl:text>: </xsl:text>
                  <xsl:value-of select="normalize-space(./labl)" />
                </xsl:if>
                
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-header>
        
        <!-- ================================================== -->
        <!-- Main table body - body of the variable description -->
        <!-- ================================================== -->
        <fo:table-body>
          
          <!-- Definition  -->
          <xsl:if test="normalize-space(./txt)">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold">
                  <xsl:value-of select="$i18n-Definition" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:apply-templates select="./txt" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Universe  -->
          <xsl:if test="normalize-space(./universe)">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold">
                  <xsl:value-of select="$i18n-Universe" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:apply-templates select="./universe" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Source -->
          <xsl:if test="normalize-space(./respUnit)">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold">
                  <xsl:value-of select="$i18n-Source"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:apply-templates select="./respUnit" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Pre-Question -->
          <xsl:if test="normalize-space(./qstn/preQTxt)">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold">
                  <xsl:value-of select="$i18n-Pre-question" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:apply-templates select="./qstn/preQTxt" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Literal_Question -->
          <xsl:if test="normalize-space(./qstn/qstnLit)">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold">
                  <xsl:value-of select="$i18n-Literal_question"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:apply-templates select="./qstn/qstnLit" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Post-question -->
          <xsl:if test="normalize-space(./qstn/postQTxt)">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold">
                  <xsl:value-of select="$i18n-Post-question"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:apply-templates select="./qstn/postQTxt" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Interviewer_instructions -->
          <xsl:if test="normalize-space(./qstn/ivuInstr)">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold">
                  <xsl:value-of select="$i18n-Interviewers_instructions" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:apply-templates select="./qstn/ivuInstr" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Imputation -->
          <xsl:if test="normalize-space(./imputation)">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold">
                  <xsl:value-of select="$i18n-Imputation" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:apply-templates select="./imputation" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Recoding_and_Derivation -->
          <xsl:if test="normalize-space(./codInstr)">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold">
                  <xsl:value-of select="$i18n-Recoding_and_Derivation" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:apply-templates select="./codInstr" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Security -->
          <xsl:if test="normalize-space(./security)">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold">
                  <xsl:value-of select="$i18n-Security" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:apply-templates select="./security" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Concepts -->
          <xsl:if test="normalize-space(./concept)">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold">
                  <xsl:value-of select="$i18n-Concepts" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:for-each select="./concept">
                    <xsl:if test="position() &gt; 1">
                      <xsl:text>, </xsl:text>
                    </xsl:if>
                    <xsl:value-of select="normalize-space(.)" />
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Notes -->
          <xsl:if test="normalize-space(./notes)">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold">
                  <xsl:value-of select="$i18n-Notes" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:apply-templates select="./notes" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- ========================== -->
          <!-- Variable contents and bars -->
          <!-- ========================== -->
                    
          <xsl:if test="$show-variables-description-categories = 'True'
            and normalize-space(./catgry[1])">

            <xsl:variable name="category-count" select="count(catgry)" />
            
            <fo:table-row text-align="center" vertical-align="top">
              <xsl:choose>
                
                <!-- ================== -->
                <!-- Case 1)            -->
                <!-- ================== -->
                <xsl:when test="number($show-variables-description-categories-max) &gt;= $category-count">
                  <fo:table-cell text-align="left" border="{$default-border}" number-columns-spanned="2" padding="{$cell-padding}">
                    
                    <!-- Variables -->
                    <xsl:variable name="is-weighted" select="count(catgry/catStat[@type='freq' and @wgtd='wgtd' ]) &gt; 0"/>
                    <xsl:variable name="catgry-freq-nodes" select="catgry[not(@missing='Y')]/catStat[@type='freq']" />
                    <xsl:variable name="catgry-sum-freq" select="sum($catgry-freq-nodes[ not(@wgtd='wgtd') ])" />
                    <xsl:variable name="catgry-sum-freq-wgtd" select="sum($catgry-freq-nodes[ @wgtd='wgtd'])" />
                    
                    <xsl:variable name="catgry-max-freq">
                      <xsl:value-of select="util:math_max($catgry-freq-nodes[ not(@wgtd='wgtd') ])" />
                    </xsl:variable>
                    
                    <xsl:variable name="catgry-max-freq-wgtd">
                      <xsl:value-of select="util:math_max($catgry-freq-nodes[@type='freq' and @wgtd='wgtd' ])"/>
                    </xsl:variable>
                    
                    <!-- Render table -->
                    <fo:table id="var-{@ID}-cat" table-layout="fixed" width="100%" font-size="8pt">
                      <fo:table-column column-width="proportional-column-width(12)" />
                      <xsl:choose>
                        <xsl:when test="$is-weighted">
                          <fo:table-column column-width="proportional-column-width(33)" />
                          <fo:table-column column-width="proportional-column-width(8)" />
                          <fo:table-column column-width="proportional-column-width(12)" />
                        </xsl:when>
                        <xsl:otherwise>
                          <fo:table-column column-width="proportional-column-width(45)" />
                          <fo:table-column column-width="proportional-column-width(8)" />
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:variable name="bar-column-width" select="2.5" />
                      
                      <fo:table-column column-width="{$bar-column-width}in" />
                      
                      <!-- table header -->
                      <fo:table-header>
                        <fo:table-row background-color="{$color-gray1}" text-align="left" vertical-align="top">
                          <fo:table-cell border="0.5pt solid white" padding="{$cell-padding}">
                            <fo:block font-weight="bold">
                              <xsl:value-of select="$i18n-Value" />
                            </fo:block>
                          </fo:table-cell>
                          <fo:table-cell border="0.5pt solid white" padding="{$cell-padding}">
                            <fo:block font-weight="bold">
                              <xsl:value-of select="$i18n-Label" />
                            </fo:block>
                          </fo:table-cell>
                          <fo:table-cell border="0.4pt solid white" padding="{$cell-padding}" text-align="center">
                            <fo:block font-weight="bold">
                              <xsl:value-of select="$i18n-Cases_Abbreviation" />
                            </fo:block>
                          </fo:table-cell>
                          <xsl:if test="$is-weighted">
                            <fo:table-cell border="0.4pt solid white" padding="{$cell-padding}" text-align="center">
                              <fo:block font-weight="bold">
                                <xsl:value-of select="$i18n-Weighted" />
                              </fo:block>
                            </fo:table-cell>
                          </xsl:if>
                          <fo:table-cell border="0.4pt solid white" padding="{$cell-padding}" text-align="center">
                            <fo:block font-weight="bold">
                              <xsl:value-of select="$i18n-Percentage" />
                              <xsl:if test="$is-weighted">
                                <xsl:text>(</xsl:text>
                                <xsl:value-of select="$i18n-Weighted" />
                                <xsl:text>)</xsl:text>
                              </xsl:if>
                            </fo:block>
                          </fo:table-cell>
                        </fo:table-row>
                      </fo:table-header>
                      
                      <!-- table body -->
                      <fo:table-body>
                        <xsl:for-each select="catgry">
                          <fo:table-row background-color="{$color-gray2}" text-align="center" vertical-align="top">
                            
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
                            <xsl:variable name="catgry-freq" select="catStat[@type='freq' and not(@wgtd='wgtd') ]"/>
                            <fo:table-cell text-align="center" border="0.5pt solid white" padding="2pt">
                              <fo:block>                                
                                <xsl:value-of select="util:trim(catStat)"/>
                              </fo:block>
                            </fo:table-cell>
                            
                            <!-- Weighted frequency -->
                            <xsl:variable name="catgry-freq-wgtd" select="catStat[@type='freq' and @wgtd='wgtd' ]" />
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
                            
                            <!-- compute percentage -->                            
                            <xsl:variable name="catgry-pct"
                              select="if ($is-weighted) then 
                                        $catgry-freq-wgtd div $catgry-sum-freq-wgtd
                                      else
                                        $catgry-freq div $catgry-sum-freq "/>
                            
                            <!-- compute bar width (percentage of highest value minus --> 
                            <!-- some space to display the percentage value) -->                            
                            <xsl:variable name="tmp-col-width-1"
                              select="if ($is-weighted) then
                                        ($catgry-freq-wgtd div $catgry-max-freq-wgtd) * ($bar-column-width - 0.5)
                                      else
                                        ($catgry-freq div $catgry-max-freq) * ($bar-column-width - 0.5) "/>
                                                                                   
                            <xsl:variable name="col-width-1"
                              select="if (string(number($tmp-col-width-1)) != 'NaN') then
                                        $tmp-col-width-1
                                      else
                                        0 "/>

                            <!-- compute remaining space for second column -->
                            <xsl:variable name="col-width-2" select="$bar-column-width - $col-width-1" />
                            
                            <!-- display the bar but not for missing values or if there was a problem computing the width -->
                            <xsl:if test="not(@missing='Y') and $col-width-1 &gt; 0">
                              <fo:table-cell text-align="left" border="0.5pt solid white" padding="2pt">
                                <fo:table table-layout="fixed" width="100%">
                                  <fo:table-column column-width="{$col-width-1}in" />
                                  <fo:table-column column-width="{$col-width-2}in" />
                                  <fo:table-body>
                                    <fo:table-row>
                                      <fo:table-cell background-color="{$color-gray4}">
                                        <fo:block> </fo:block>
                                      </fo:table-cell>
                                      <fo:table-cell margin-left="0.05in">
                                        <fo:block>
                                          <xsl:value-of select="format-number($catgry-pct , '#0.0%')" />
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
                    <fo:block font-weight="bold" color="#400000" font-size="6pt" font-style="italic">
                      <xsl:value-of select="$i18n-SumStat_Warning" />
                    </fo:block>
                    
                  </fo:table-cell>
                </xsl:when>
                
                <!-- =================================== -->
                <!-- Case 2) Frequence_table_not_shown   -->
                <!-- =================================== -->
                <xsl:otherwise>
                  <fo:table-cell background-color="{$color-gray1}" text-align="center" font-style="italic"
                    border="{$default-border}" number-columns-spanned="2" padding="{$cell-padding}">
                    <fo:block>
                      <xsl:value-of select="$i18n-Frequency_table_not_shown" />
                      <xsl:text> (</xsl:text>
                      <xsl:value-of select="$category-count"/>
                      <xsl:text> </xsl:text>
                      <xsl:value-of select="$i18n-Modalities" />
                      <xsl:text>)</xsl:text>
                    </fo:block>
                  </fo:table-cell>
                </xsl:otherwise>
                
              </xsl:choose>
            </fo:table-row>
          </xsl:if>
                    
          <!-- ============================================= -->
          <!-- Variable related information and descriptions -->
          <!-- ============================================= -->
          
          <!-- Information -->
          <fo:table-row text-align="center" vertical-align="top">
            
            <fo:table-cell font-weight="bold" text-align="left" border="{$default-border}" padding="{$cell-padding}">
              <fo:block>
                <xsl:value-of select="$i18n-Information" />
              </fo:block>
            </fo:table-cell>
            
            <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
              <fo:block>
                
                <!-- Information: Type -->
                <xsl:if test="normalize-space(@intrvl)">
                  <xsl:text> [</xsl:text>
                  <xsl:value-of select="$i18n-Type" />
                  <xsl:text>: </xsl:text>

                  <xsl:value-of select="if (@intrvl='discrete') then
                                          $i18n-discrete
                                        else if (@intrvl='contin') then
                                          $i18n-continuous 
                                        else () "/>

                  <xsl:text>] </xsl:text>
                </xsl:if>
                
                <!-- Information: Format -->
                <xsl:for-each select="varFormat">
                  <xsl:text> [</xsl:text>
                  <xsl:value-of select="$i18n-Format" />
                  <xsl:text>: </xsl:text>
                  <xsl:value-of select="@type" />
                  <xsl:if test="normalize-space(location/@width)">
                    <xsl:text>-</xsl:text>
                    <xsl:value-of select="location/@width" />
                  </xsl:if>
                  <xsl:if test="normalize-space(@dcml)">
                    <xsl:text>.</xsl:text>
                    <xsl:value-of select="@dcml" />
                  </xsl:if>
                  <xsl:text>] </xsl:text>
                </xsl:for-each>
                
                <!-- Information: Range -->
                <xsl:for-each select="valrng/range">
                  <xsl:text> [</xsl:text>
                  <xsl:value-of select="$i18n-Range" />
                  <xsl:text>: </xsl:text>
                  <xsl:value-of select="@min" />-
                  <xsl:value-of select="@max" />
                  <xsl:text>] </xsl:text>
                </xsl:for-each>
                
                <!-- Information: Missing -->
                <xsl:text> [</xsl:text>
                <xsl:value-of select="$i18n-Missing" />
                <xsl:text>: *</xsl:text>
                <xsl:for-each select="invalrng/item">
                  <xsl:text>/</xsl:text>
                  <xsl:value-of select="@VALUE" />
                </xsl:for-each>
                <xsl:text>] </xsl:text>
                
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
          
          <!-- Statistics -->
          <xsl:variable name="statistics" select="sumStat[contains('vald invd mean stdev',@type)]" />
          <xsl:if test="$statistics">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell font-weight="bold" text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$i18n-Statistics" />
                  <xsl:text> [</xsl:text>
                  <xsl:value-of select="$i18n-Abbrev_NotWeighted" />
                  <xsl:text>/ </xsl:text>
                  <xsl:value-of select="$i18n-Abbrev_Weighted" />
                  <xsl:text>]</xsl:text>
                </fo:block>
              </fo:table-cell>
              
              <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  
                  <!-- Summary statistics -->
                  <xsl:for-each select="$statistics[not(@wgtd)]">
                    <xsl:variable name="type" select="@type" />
                    
                    <xsl:variable name="label"
                      select="if (@type = 'vald') then
                                $i18n-Valid
                              else if (@type = 'invd') then
                                $i18n-Invalid
                              else if (@type = 'mean') then
                                $i18n-Mean
                              else if (@type = 'stdev') then
                                $i18n-StdDev
                              else
                                @type "/>

                    <xsl:text> [</xsl:text>
                    <xsl:value-of select="$label" />
                    <xsl:text>: </xsl:text>
                    <xsl:value-of select="normalize-space(.)" />
                    
                    <!-- Weighted value -->
                    <xsl:text> /</xsl:text>

                    <xsl:value-of select="if (following-sibling::sumStat[1]/@type=$type and following-sibling::sumStat[1]/@wgtd) then
                                            following-sibling::sumStat[1]
                                          else '-' "/>

                    <xsl:text>] </xsl:text>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
              
            </fo:table-row>
          </xsl:if>
          
          <!-- separate the individual variable tables to improve readability -->
          <fo:table-row height="0.2in">
            <fo:table-cell number-columns-spanned="2">
              <fo:block />
            </fo:table-cell>
          </fo:table-row>
          
        </fo:table-body>
      </fo:table> <!-- end of variable table -->
      
    </fo:table-cell>
  </fo:table-row>
  
</xsl:template>
