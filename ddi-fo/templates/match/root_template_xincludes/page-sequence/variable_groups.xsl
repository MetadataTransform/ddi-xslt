<?xml version='1.0' encoding='UTF-8'?>
<!-- variable_groups.xsl -->
<!-- ================================================ -->
<!-- <xsl:if> variable groups                         -->
<!-- value: <fo:page-sequence>                        -->
<!-- ================================================ -->

<!-- read: -->
<!-- $font-family, $number-of-groups -->

<!-- functions: -->
<!-- string-length(), count() [xpath 1.0] -->

<xsl:if test="$page.variable_groups.show = 'True'"
        xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <fo:page-sequence master-reference="{$layout.page_master}"
                    font-family="{$layout.font_family}"
                    font-size="{$layout.font_size}">
    
    <!-- =========================================== -->
    <!-- page header and footer                      -->
    <!-- =========================================== -->
    <xsl:call-template name="page_header">
      <xsl:with-param name="section_name" select="i18n:get('Variables_Groups')" />
    </xsl:call-template>
  
    <xsl:call-template name="page_footer" />

    <!-- =========================================== -->
    <!-- page content                                 -->
    <!-- =========================================== -->    
    <fo:flow flow-name="body">

      <!-- heading -->
      <fo:block id="variables-groups" font-size="18pt" font-weight="bold" space-after="2.5mm">
        <xsl:value-of select="i18n:get('Variables_Groups')" />
      </fo:block>

      <!-- number of variable groups in data set -->      
      <fo:block font-weight="bold">
        <xsl:value-of select="concat(i18n:get('Dataset_contains'), ' ', xs:string(count(/codeBook/dataDscr/varGrp)), ' ', i18n:get('groups')) "/>       
      </fo:block>
      
      
      <!-- ================================ -->
      <!-- the actual variable groups table -->
      <!-- ================================ -->
      <!-- <xsl:apply-templates select="/codeBook/dataDscr/varGrp" /> -->
      
      <xsl:for-each select="/codeBook/dataDscr/varGrp">
        <fo:table id="vargrp-{@ID}" table-layout="fixed" width="100%" space-before="5mm">
          <fo:table-column column-width="proportional-column-width(20)"/>
          <fo:table-column column-width="proportional-column-width(80)"/>
          
          <fo:table-body>
            
            <!-- Group -->
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-size="12pt" font-weight="bold">
                  <xsl:value-of select="normalize-space(labl)" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
            
            <!-- Text -->
            <xsl:for-each select="txt">
              <fo:table-row>
                <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <xsl:apply-templates select="." />
                </fo:table-cell>
              </fo:table-row>
            </xsl:for-each>
            
            <!-- Definition -->
            <xsl:for-each select="defntn">
              <fo:table-row>
                <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block font-weight="bold" text-decoration="underline">
                    <xsl:value-of select="i18n:get('Definition')" />
                  </fo:block>
                  <xsl:apply-templates select="." />
                </fo:table-cell>
              </fo:table-row>
            </xsl:for-each>
            
            <!-- Universe-->
            <xsl:for-each select="universe">
              <fo:table-row>
                <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block font-weight="bold" text-decoration="underline">
                    <xsl:value-of select="i18n:get('Universe')" />
                  </fo:block>
                  <xsl:apply-templates select="." />
                </fo:table-cell>
              </fo:table-row>
            </xsl:for-each>
            
            <!-- Notes -->
            <xsl:for-each select="notes">
              <fo:table-row>
                <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block font-weight="bold" text-decoration="underline">
                    <xsl:value-of select="i18n:get('Notes')" />
                  </fo:block>
                  <xsl:apply-templates select="." />
                </fo:table-cell>
              </fo:table-row>
            </xsl:for-each>
            
            <!-- Subgroups -->
            <xsl:if test="./@varGrp">
              <fo:table-row>
                <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:value-of select="i18n:get('Subgroups')" />
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:variable name="list" select="concat(./@varGrp,' ')" />
                    <xsl:for-each select="/codeBook/dataDscr/varGrp[contains($list, concat(@ID,' '))]">
                      <!-- add a space to the ID to avoid partial match -->
                      <xsl:if test="position() &gt; 1">
                        <xsl:text>,</xsl:text>
                      </xsl:if>
                      <xsl:value-of select="./labl" />
                    </xsl:for-each>
                  </fo:block>
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>
          </fo:table-body>
        </fo:table>
        
        <!-- ======================= -->
        <!-- Variables table         -->
        <!-- ======================= -->
        <xsl:if test="./@var"> <!-- Look for variables in this group -->
          <fo:table id="varlist-{@ID}" table-layout="fixed" width="100%" font-size="10pt" space-after="0.0mm">
            
            <!-- <fo:table-column column-width="proportional-column-width( 5)" /> -->
            <fo:table-column column-width="proportional-column-width(12)" />
            <fo:table-column column-width="proportional-column-width(20)" />
            <fo:table-column column-width="proportional-column-width(27)" />
            
            <!-- ============ -->
            <!-- table header -->
            <!-- ============ -->
            <fo:table-header>
              <fo:table-row text-align="left" vertical-align="top" font-weight="bold" keep-with-next="always" background-color="{$layout.color.gray1}">
                
                <!-- blank character -->
<!--                <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:text/>
                  </fo:block>
                </fo:table-cell>-->
                
                <!-- Name -->
                <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:value-of select="i18n:get('Name')" />
                  </fo:block>
                </fo:table-cell>
                
                <!-- Label -->
                <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:value-of select="i18n:get('Label')" />
                  </fo:block>
                </fo:table-cell>
                
                <!-- Question -->
                <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:value-of select="i18n:get('Question')" />
                  </fo:block>
                </fo:table-cell>         
                
              </fo:table-row>
            </fo:table-header>
            
            <!-- ========== -->
            <!-- table body -->
            <!-- ========== -->
            <fo:table-body>
              <xsl:variable name="list" select="concat(./@var,' ')" />
              <!--<xsl:apply-templates select="/codeBook/dataDscr/var[ contains($list, concat(@ID,' ')) ]"
                                   mode="variables-list"/>-->
              
              <xsl:for-each select="/codeBook/dataDscr/var[ contains($list, concat(@ID,' ')) ]">
                <!-- content -->
                <fo:table-row text-align="center" vertical-align="top">
                  
                  <!-- Row 1: Variable Position -->
<!--                  <fo:table-cell text-align="center" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                    <fo:block>
                      <xsl:value-of select="position()" />
                    </fo:block>
                  </fo:table-cell>-->
                  
                  <!-- Row 2: Variable Name-->
                  <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                    <fo:block>
                      <xsl:choose>
                        <xsl:when test="$page.variables_list.show = 'True'">
                          <fo:basic-link internal-destination="var-{@ID}" text-decoration="underline" color="blue">
                            <xsl:if test="string-length(@name) &gt; 10">
                              <xsl:value-of select="substring(./@name, 0, $limits.variable_name_length)" />
                              <xsl:text> ..</xsl:text>
                            </xsl:if>
                            <xsl:if test="11 &gt; string-length(@name)">
                              <xsl:value-of select="./@name" />
                            </xsl:if>
                          </fo:basic-link>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="./@name" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </fo:block>
                  </fo:table-cell>
                  
                  <!-- Row 3: Variable Label -->
                  <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                    <fo:block>
                      <!--          <xsl:value-of select="if (normalize-space(./labl)) then normalize-space(./labl) else '-' "/>-->
                      <xsl:value-of select="if (./labl) then normalize-space(./labl) else '-' "/> 
                    </fo:block>
                  </fo:table-cell>
                  
                  <!-- Row 4: Variable literal question -->
                  <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                    <fo:block>
                      <xsl:value-of select="if (./qstn/qstnLit) then normalize-space(./qstn/qstnLit) else '-' "/>
                    </fo:block>
                  </fo:table-cell>
                  
                </fo:table-row>                                                
              </xsl:for-each>
              
              
            </fo:table-body>
          </fo:table>
          
        </xsl:if>                
      </xsl:for-each>
      

    </fo:flow>
  </fo:page-sequence>
</xsl:if>
