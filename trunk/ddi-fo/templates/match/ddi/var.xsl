<?xml version='1.0' encoding='utf-8'?>
<!-- var.xsl -->

<!-- ================================== -->
<!-- match: var                         -->
<!-- value: <fo:table-row>              -->
<!-- ================================== -->

<!-- read: -->
<!-- $layout.tables.cellpadding, $layout.color.gray1, $layout.tables.border, -->
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
  
  <xsl:variable name="statistics" select="sumStat[contains('vald invd mean stdev',@type)]" />
  
  <fo:table-row text-align="center" vertical-align="top">
    <fo:table-cell>
      <fo:table id="var-{@ID}" table-layout="fixed" width="100%" font-size="8pt" space-after="7.5mm">
        <fo:table-column column-width="proportional-column-width(20)" />
        <fo:table-column column-width="proportional-column-width(80)" />
        
        <!-- ============ -->
        <!-- table Header -->
        <!-- ============ -->
        <fo:table-header>
          <fo:table-row background-color="{$layout.color.gray1}" text-align="center" vertical-align="top">
            <fo:table-cell number-columns-spanned="2" font-size="10pt" font-weight="bold" text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
              <fo:block>
                <fo:inline font-size="8pt" font-weight="normal" vertical-align="text-top">                 
                  <xsl:value-of select="concat('#', ./@id, ' ')"  />                  
                </fo:inline>                
                <xsl:value-of select="./@name" />                                
                <xsl:value-of select="if (normalize-space(./labl)) then concat(': ', normalize-space(./labl)) else ()" />                
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
              <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-weight="bold">
                  <xsl:value-of select="i18n:get('Definition')" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:apply-templates select="./txt" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Universe  -->
          <xsl:if test="normalize-space(./universe)">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-weight="bold">
                  <xsl:value-of select="i18n:get('Universe')" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:apply-templates select="./universe" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Source -->
          <xsl:if test="normalize-space(./respUnit)">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-weight="bold">
                  <xsl:value-of select="i18n:get('Source')"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:apply-templates select="./respUnit" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Pre-Question -->
          <xsl:if test="normalize-space(./qstn/preQTxt)">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-weight="bold">
                  <xsl:value-of select="i18n:get('Pre-question')" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:apply-templates select="./qstn/preQTxt" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Literal_Question -->
          <xsl:if test="normalize-space(./qstn/qstnLit)">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-weight="bold">
                  <xsl:value-of select="i18n:get('Literal_question')" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:apply-templates select="./qstn/qstnLit" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Post-question -->
          <xsl:if test="normalize-space(./qstn/postQTxt)">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-weight="bold">
                  <xsl:value-of select="i18n:get('Post-question')"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:apply-templates select="./qstn/postQTxt" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Interviewer_instructions -->
          <xsl:if test="normalize-space(./qstn/ivuInstr)">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-weight="bold">
                  <xsl:value-of select="i18n:get('Interviewers_instructions')" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:apply-templates select="./qstn/ivuInstr" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Imputation -->
          <xsl:if test="normalize-space(./imputation)">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-weight="bold">
                  <xsl:value-of select="i18n:get('Imputation')" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:apply-templates select="./imputation" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Recoding_and_Derivation -->
          <xsl:if test="normalize-space(./codInstr)">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-weight="bold">
                  <xsl:value-of select="i18n:get('Recoding_and_Derivation')" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:apply-templates select="./codInstr" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Security -->
          <xsl:if test="normalize-space(./security)">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-weight="bold">
                  <xsl:value-of select="i18n:get('Security')" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:apply-templates select="./security" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Concepts -->
          <xsl:if test="normalize-space(./concept)">
            <fo:table-row text-align="center" vertical-align="top">
              <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-weight="bold">
                  <xsl:value-of select="i18n:get('Concepts')" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
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
              <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-weight="bold">
                  <xsl:value-of select="i18n:get('Notes')" />
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:apply-templates select="./notes" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- ========================== -->
          <!-- Variable contents and bars -->
          <!-- ========================== -->
                    
          <xsl:if test="$section.variables_description_categories.show = 'True' and normalize-space(./catgry[1])">

            <xsl:variable name="category-count" select="count(catgry)" />
            
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
                  <xsl:variable name="catgry-freq-nodes" select="catgry[not(@missing = 'Y')]/catStat[@type='freq']" />
                  <xsl:variable name="catgry-sum-freq" select="sum($catgry-freq-nodes[ not(@wgtd = 'wgtd') ])" />
                  <xsl:variable name="catgry-sum-freq-wgtd" select="sum($catgry-freq-nodes[ @wgtd = 'wgtd'])" />                 
                  <xsl:variable name="catgry-max-freq" select="util:math_max($catgry-freq-nodes[ not(@wgtd = 'wgtd') ])" />       
                  <xsl:variable name="catgry-max-freq-wgtd" select="util:math_max($catgry-freq-nodes[@type='freq' and @wgtd ='wgtd' ])" />                  
                  <xsl:variable name="bar-column-width" select="2.5" />

                  <!-- ========= -->
                  <!-- Content   -->
                  <!-- ========= -->
                  <fo:table-cell text-align="left" border="{$layout.tables.border}" number-columns-spanned="2" padding="{$layout.tables.cellpadding}">                                      
                    <fo:table id="var-{@ID}-cat" table-layout="fixed" width="100%" font-size="8pt">
                      
                      <!-- table colums -->
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
                      <fo:table-column column-width="{$bar-column-width}in" />
                      
                      <!-- table header -->
                      <fo:table-header>
                        <fo:table-row background-color="{$layout.color.gray1}" text-align="left" vertical-align="top">
                          <fo:table-cell border="0.5pt solid white" padding="{$layout.tables.cellpadding}">
                            <fo:block font-weight="bold">
                              <xsl:value-of select="i18n:get('Value')" />
                            </fo:block>
                          </fo:table-cell>
                          <fo:table-cell border="0.5pt solid white" padding="{$layout.tables.cellpadding}">
                            <fo:block font-weight="bold">
                              <xsl:value-of select="i18n:get('Label')" />
                            </fo:block>
                          </fo:table-cell>
                          <fo:table-cell border="0.4pt solid white" padding="{$layout.tables.cellpadding}" text-align="center">
                            <fo:block font-weight="bold">
                              <xsl:value-of select="i18n:get('Cases_Abbreviation')" />
                            </fo:block>
                          </fo:table-cell>
                          <xsl:if test="$is-weighted">
                            <fo:table-cell border="0.4pt solid white" padding="{$layout.tables.cellpadding}" text-align="center">
                              <fo:block font-weight="bold">
                                <xsl:value-of select="i18n:get('Weighted')" />
                              </fo:block>
                            </fo:table-cell>
                          </xsl:if>
                          <fo:table-cell border="0.4pt solid white" padding="{$layout.tables.cellpadding}" text-align="center">
                            <fo:block font-weight="bold">
                              <xsl:value-of select="i18n:get('Percentage')" />
                              <xsl:if test="$is-weighted">                                
                                <xsl:value-of select="concat('(', i18n:get('Weighted'), ')')" />
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
                          <xsl:variable name="catgry-freq-wgtd" select="catStat[@type ='freq' and @wgtd ='wgtd' ]" />

                          <!-- percentage -->                            
                          <xsl:variable name="catgry-pct"
                            select="if ($is-weighted) then $catgry-freq-wgtd div $catgry-sum-freq-wgtd
                            else $catgry-freq div $catgry-sum-freq "/>
                          
                          <!-- bar width (percentage of highest value minus --> 
                          <!-- some space to display the percentage value) -->                            
                          <xsl:variable name="tmp-col-width-1"
                            select="if ($is-weighted) then ($catgry-freq-wgtd div $catgry-max-freq-wgtd) * ($bar-column-width - 0.5)
                            else ($catgry-freq div $catgry-max-freq) * ($bar-column-width - 0.5) " />
                          
                          <xsl:variable name="col-width-1"
                            select="if (string(number($tmp-col-width-1)) != 'NaN') then $tmp-col-width-1
                            else 0 "/>
                          
                          <!-- remaining space for second column -->
                          <xsl:variable name="col-width-2" select="$bar-column-width - $col-width-1" />

                          <!-- ========= -->
                          <!-- Content   -->
                          <!-- ========= -->
                          <fo:table-row background-color="{$layout.color.gray2}" text-align="center" vertical-align="top">
                            
                            <!-- catValue -->
                            <fo:table-cell text-align="left" border="0.5pt solid white" padding="2pt">
                              <fo:block>                                  
                                <xsl:value-of select="util:trim(catValu)" />
                              </fo:block>
                            </fo:table-cell>
                            
                            <!-- Label -->
                            <fo:table-cell text-align="left" border="0.5pt solid white" padding="2pt">
                              <fo:block>                                
                                <xsl:value-of select="util:trim(labl)" />
                              </fo:block>
                            </fo:table-cell>
                            
                            <!-- Frequency -->                            
                            <fo:table-cell text-align="center" border="0.5pt solid white" padding="2pt">
                              <fo:block>                                
                                <xsl:value-of select="util:trim(catStat)" />
                              </fo:block>
                            </fo:table-cell>
                            
                            <!-- Weighted frequency -->                            
                            <xsl:if test="$is-weighted">
                              <fo:table-cell text-align="center" border="0.5pt solid white" padding="2pt">
                                <fo:block>
                                  <xsl:value-of select="util:trim(format-number($catgry-freq-wgtd, '0.0'))" />
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
                                  <fo:table-column column-width="{$col-width-1}in" />
                                  <fo:table-column column-width="{$col-width-2}in" />
                                  <fo:table-body>
                                    <fo:table-row>
                                      <fo:table-cell background-color="{$layout.color.gray4}">
                                        <fo:block> </fo:block>
                                      </fo:table-cell>
                                      <fo:table-cell margin-left="1.5mm">
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
                      <xsl:value-of select="i18n:get('SumStat_Warning')" />
                    </fo:block>
                    
                  </fo:table-cell>
                </xsl:when>
                
                <!-- =================================== -->
                <!-- Case 2) Frequence_table_not_shown   -->
                <!-- =================================== -->
                <xsl:otherwise>
                  <fo:table-cell background-color="{$layout.color.gray1}" text-align="center" font-style="italic"
                                 border="{$layout.tables.border}" number-columns-spanned="2" padding="{$layout.tables.cellpadding}">
                    <fo:block>                      
                      <xsl:value-of select="concat(i18n:get('Frequency_table_not_shown'), ' (', $category-count, ' ', i18n:get('Modalities'), ')')"  />
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
            
            <fo:table-cell font-weight="bold" text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
              <fo:block>
                <xsl:value-of select="i18n:get('Information')" />
              </fo:block>
            </fo:table-cell>
            
            <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
              <fo:block>
                
                <!-- Information: Type -->
                <xsl:if test="normalize-space(@intrvl)">
                  <xsl:value-of select="concat(' [', i18n:get('Type'), ': ')"  />
                  <xsl:value-of select="if (@intrvl = 'discrete') then i18n:get('discrete')
                                        else if (@intrvl = 'contin') then i18n:get('continuous') 
                                        else () "/>
                  <xsl:text>] </xsl:text>
                </xsl:if>
                
                <!-- Information: Format -->
                <xsl:for-each select="varFormat">                  
                  <xsl:value-of select="concat(' [', i18n:get('Format'), ': ', @type)" />                   
                  <xsl:value-of select="if (normalize-space(location/@width)) then concat('-', location/@width) else ()" />
                  <xsl:value-of select="if (normalize-space(@dcml)) then concat('.', @dcml) else ()" />
                  <xsl:text>] </xsl:text>
                </xsl:for-each>
                
                <!-- Information: Range -->
                <xsl:for-each select="valrng/range">                  
                  <xsl:value-of select="concat(' [', i18n:get('Range'), ': ', @min, '-', @max, '] ') "/>               
                </xsl:for-each>
                
                <!-- Information: Missing -->
                <xsl:value-of select="concat(' [', i18n:get('Missing'), ': *')" />
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
                  <xsl:value-of select="concat(i18n:get('Statistics'), ' [', i18n:get('Abbrev_NotWeighted'), '/ ', i18n:get('Abbrev_Weighted'), ']')" />                 
                </fo:block>
              </fo:table-cell>
              
              <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  
                  <!-- Summary statistics -->
                  <xsl:for-each select="$statistics[not(@wgtd)]">

                    <!-- ========= -->
                    <!-- Variables -->
                    <!-- ========= -->
                    <xsl:variable name="type" select="@type" />                    
                    <xsl:variable name="label"
                      select="if (@type = 'vald') then i18n:get('Valid')
                              else if (@type = 'invd') then i18n:get('Invalid')
                              else if (@type = 'mean') then i18n:get('Mean')
                              else if (@type = 'stdev') then i18n:get('StdDev')
                              else @type "/>

                    <!-- ========= -->
                    <!-- Content   -->
                    <!-- ========= -->                    
                    <xsl:value-of select="concat(' [', $label, ': ', normalize-space(.), ' /')"  />
                    <xsl:value-of select="if (following-sibling::sumStat[1]/@type = $type and following-sibling::sumStat[1]/@wgtd) then
                                            following-sibling::sumStat[1]
                                          else '-' "/>
                    <xsl:text>] </xsl:text>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
              
            </fo:table-row>
          </xsl:if>
          
          <!-- separate the individual variable tables to improve readability -->
          <fo:table-row height="5mm">
            <fo:table-cell number-columns-spanned="2">
              <fo:block />
            </fo:table-cell>
          </fo:table-row>
          
        </fo:table-body>
      </fo:table> <!-- end of variable table -->
      
    </fo:table-cell>
  </fo:table-row>
  
</xsl:template>
