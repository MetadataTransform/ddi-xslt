<?xml version='1.0' encoding='UTF-8'?>
<!-- table_of_contents.xsl -->
<!-- ============================================== -->
<!-- <xsl:if> table of contents                     -->
<!-- value: <fo:page-sequence>                      -->
<!-- ============================================== -->

<!-- read: -->
<!-- $font-family, $show-overview, $show-scope-and-coverage, -->
<!-- $show-producers-and-sponsors, $show-sampling, $show-data-collection -->
<!-- $show-data-processing-and-appraisal, $show-accessibility, -->
<!-- $show-rights-and-disclaimer, $show-files-description, -->
<!-- $show-variables-list, $show-variable-groups -->

<!-- functions: -->
<!-- normalize-space(), string-length(), contains(), concat() [xpath 1.0] -->

<xsl:if test="$page.table_of_contents.show = 'True'"
  xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format">
  
  <fo:page-sequence master-reference="{$layout.page_master}"
                    font-family="{$layout.font_family}"
                    font-size="{$layout.font_size}">
    
    <fo:flow flow-name="body">
      
      <!-- ====================================== -->
      <!-- TOC heading                            -->
      <!-- ====================================== -->
      
      <fo:block id="toc" font-size="18pt" font-weight="bold" space-before="12mm" text-align="left" space-after="2.5mm" margin-left="12mm">
        <xsl:value-of select="i18n:get('Table_of_Contents')" />
      </fo:block>
      
      <!-- ====================================== -->
      <!-- actual TOC lines                       -->
      <!-- ====================================== -->
      
      <fo:block margin-left="12mm" margin-right="12mm">
        
        <!-- ============ -->
        <!-- Static lines -->
        <!-- ============ -->
        
        <!-- Overview -->
        <xsl:if test="$page.overview.show = 'True'">
          <fo:block font-size="{$layout.toc_font_size}" text-align-last="justify">
            <fo:basic-link internal-destination="overview" text-decoration="none" color="{$layout.toc_font_color}">            
              <xsl:value-of select="i18n:get('Overview')" />
              <fo:leader leader-pattern="dots" />
              <fo:page-number-citation ref-id="overview" />
            </fo:basic-link>
          </fo:block>
        </xsl:if>
        
        <!-- Scope and Coverage -->
        <xsl:if test="$section.scope_and_coverage.show = 'True'">
          <fo:block font-size="{$layout.toc_font_size}" text-align-last="justify">
            <fo:basic-link internal-destination="scope-and-coverage" text-decoration="none" color="{$layout.toc_font_color}">
              <xsl:value-of select="i18n:get('Scope_and_Coverage')" />
              <fo:leader leader-pattern="dots" />
              <fo:page-number-citation ref-id="scope-and-coverage" />
            </fo:basic-link>
          </fo:block>
        </xsl:if>
        
        <!-- Producers and Sponsors -->
        <xsl:if test="$section.producers_and_sponsors.show = 'True'">
          <fo:block font-size="{$layout.toc_font_size}" text-align-last="justify">
            <fo:basic-link internal-destination="producers-and-sponsors" text-decoration="none" color="{$layout.toc_font_color}">
              <xsl:value-of select="i18n:get('Producers_and_Sponsors')" />
              <fo:leader leader-pattern="dots" />
              <fo:page-number-citation ref-id="producers-and-sponsors" />
            </fo:basic-link>
          </fo:block>
        </xsl:if>
        
        <!-- Sampling -->
        <xsl:if test="$section.sampling.show = 'True'">
          <fo:block font-size="{$layout.toc_font_size}" text-align-last="justify">
            <fo:basic-link internal-destination="sampling" text-decoration="none" color="{$layout.toc_font_color}">
              <xsl:value-of select="i18n:get('Sampling')" />
              <fo:leader leader-pattern="dots" />
              <fo:page-number-citation ref-id="sampling" />
            </fo:basic-link>
          </fo:block>
        </xsl:if>
        
        <!-- Data Collection -->
        <xsl:if test="$section.data_collection.show = 'True'">
          <fo:block font-size="{$layout.toc_font_size}" text-align-last="justify">
            <fo:basic-link internal-destination="data-collection" text-decoration="none" color="{$layout.toc_font_color}">
              <xsl:value-of select="i18n:get('Data_Collection')" />
              <fo:leader leader-pattern="dots" />
              <fo:page-number-citation ref-id="data-collection" />
            </fo:basic-link>
          </fo:block>
        </xsl:if>
        
        <!-- Data Processing and Appraisal -->
        <xsl:if test="$section.data_processing_and_appraisal.show = 'True'">
          <fo:block font-size="{$layout.toc_font_size}" text-align-last="justify">
            <fo:basic-link internal-destination="data-processing-and-appraisal" text-decoration="none" color="{$layout.toc_font_color}">
              <xsl:value-of select="i18n:get('Data_Processing_and_Appraisal')" />
              <fo:leader leader-pattern="dots" />
              <fo:page-number-citation ref-id="data-processing-and-appraisal" />
            </fo:basic-link>
          </fo:block>
        </xsl:if>
        
        <!-- Accessibility -->
        <xsl:if test="$section.accessibility.show = 'True'">
          <fo:block font-size="{$layout.toc_font_size}" text-align-last="justify">
            <fo:basic-link internal-destination="accessibility" text-decoration="none" color="{$layout.toc_font_color}">
              <xsl:value-of select="i18n:get('Accessibility')" />
              <fo:leader leader-pattern="dots" />
              <fo:page-number-citation ref-id="accessibility" />
            </fo:basic-link>
          </fo:block>
        </xsl:if>
        
        <!-- Rights and Disclaimer -->
        <xsl:if test="$section.rights_and_disclaimer.show = 'True'">
          <fo:block font-size="{$layout.toc_font_size}" text-align-last="justify">
            <fo:basic-link internal-destination="rights-and-disclaimer" text-decoration="none" color="{$layout.toc_font_color}">
              <xsl:value-of select="i18n:get('Rights_and_Disclaimer')" />
              <fo:leader leader-pattern="dots" />
              <fo:page-number-citation ref-id="rights-and-disclaimer" />
            </fo:basic-link>
          </fo:block>
        </xsl:if>
        
        
        <!-- ============================================================== -->
        <!-- Dynamic lines                                                  -->
        <!-- only one of variable list and variable groups will be rendered -->
        <!-- ============================================================== -->
        
        <!-- Files Description -->
        <xsl:if test="$page.files_description.show = 'True'">
          <fo:block font-size="{$layout.toc_font_size}" text-align-last="justify">
            
            <fo:basic-link internal-destination="files-description" text-decoration="none" color="{$layout.toc_font_color}">
              <xsl:value-of select="i18n:get('Files_Description')" />
              <fo:leader leader-pattern="dots" />
              <fo:page-number-citation ref-id="files-description" />
            </fo:basic-link>
            
<!--            <xsl:for-each select="/codeBook/fileDscr">
              <fo:block margin-left="17mm" font-size="{$layout.font_size}" text-align-last="justify">
                <fo:basic-link internal-destination="file-{fileTxt/fileName/@ID}" text-decoration="underline" color="blue">
                  <xsl:apply-templates select="fileTxt/fileName" />
                  <fo:leader leader-pattern="dots" />
                  <fo:page-number-citation ref-id="file-{fileTxt/fileName/@ID}" />
                </fo:basic-link>
              </fo:block>
            </xsl:for-each>-->
          </fo:block>
        </xsl:if>
        
        <!-- Variables List -->
        <xsl:if test="$page.variables_list.show = 'True'">
          <fo:block font-size="{$layout.toc_font_size}" text-align-last="justify">
            <fo:basic-link internal-destination="variables-list" text-decoration="none" color="{$layout.toc_font_color}">
              <xsl:value-of select="i18n:get('Variables_List')" />
              
              <fo:leader leader-pattern="dots" />
              <fo:page-number-citation ref-id="variables-list" />
            </fo:basic-link>
            <xsl:for-each select="/codeBook/fileDscr">
              <fo:block margin-left="17mm" font-size="{$layout.toc_font_size}" text-align-last="justify">
                <fo:basic-link internal-destination="varlist-{fileTxt/fileName/@ID}" text-decoration="none" color="{$layout.toc_font_color}">
                  <xsl:apply-templates select="fileTxt/fileName" />
                  <fo:leader leader-pattern="dots" />
                  <fo:page-number-citation ref-id="varlist-{fileTxt/fileName/@ID}" />
                </fo:basic-link>
              </fo:block>
            </xsl:for-each>
          </fo:block>
        </xsl:if>
        
        <!-- Variables Groups -->
        <xsl:if test="$page.variable_groups.show = 'True'">
          <fo:block font-size="{$layout.toc_font_size}" text-align-last="justify">
            <fo:basic-link internal-destination="variables-groups" text-decoration="none" color="{$layout.toc_font_color}">
              <xsl:value-of select="i18n:get('Variables_Groups')" />
              <fo:leader leader-pattern="dots" />
              <fo:page-number-citation ref-id="variables-groups" />
            </fo:basic-link>
            
            <xsl:for-each select="/codeBook/dataDscr/varGrp">
              <fo:block margin-left="17mm" font-size="{$layout.toc_font_size}" text-align-last="justify">
                <fo:basic-link internal-destination="vargrp-{@ID}" text-decoration="none" color="{$layout.toc_font_color}">
                  <xsl:value-of select="normalize-space(labl)" />
                  <fo:leader leader-pattern="dots" />
                  <fo:page-number-citation ref-id="vargrp-{@ID}" />
                </fo:basic-link>
              </fo:block>              
            </xsl:for-each>
          </fo:block>
        </xsl:if>
        
        <!-- Variables Description -->
        <xsl:if test="$page.variables_description.show = 'True'">
          <fo:block font-size="{$layout.toc_font_size}" text-align-last="justify">
            
            <fo:basic-link internal-destination="variables-description" text-decoration="none" color="{$layout.toc_font_color}">
              <xsl:value-of select="i18n:get('Variables_Description')" />
              <fo:leader leader-pattern="dots" />
              <fo:page-number-citation ref-id="variables-description" />
            </fo:basic-link>
            
<!--            <xsl:for-each select="/codeBook/fileDscr">
              <fo:block margin-left="17mm" font-size="{$layout.font_size}" text-align-last="justify">
                <fo:basic-link internal-destination="vardesc-{fileTxt/fileName/@ID}" text-decoration="underline" color="blue">
                  <xsl:apply-templates select="fileTxt/fileName" />
                  <fo:leader leader-pattern="dots" />
                  <fo:page-number-citation ref-id="vardesc-{fileTxt/fileName/@ID}" />
                </fo:basic-link>
              </fo:block>
            </xsl:for-each>-->
          </fo:block>
        </xsl:if>
        
      </fo:block>
    </fo:flow>
  </fo:page-sequence>
</xsl:if>
