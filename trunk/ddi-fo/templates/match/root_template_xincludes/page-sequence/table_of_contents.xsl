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

<xsl:if test="$show-toc = 'True'"
  xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format">
  
  <fo:page-sequence master-reference="{$page-layout}"
    font-family="{$font-family}"
    font-size="{$font-size}">
    
    <fo:flow flow-name="body">
      
      <!-- ====================================== -->
      <!-- TOC heading                            -->
      <!-- ====================================== -->
      
      <fo:block id="toc" font-size="18pt" font-weight="bold" space-before="12mm" text-align="center" space-after="2.5mm">
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
        <xsl:if test="$show-overview = 'True'">
          <fo:block font-size="{$font-size}" text-align-last="justify">
            <fo:basic-link internal-destination="overview" text-decoration="underline" color="blue">
              <xsl:value-of select="i18n:get('Overview')" />
              <fo:leader leader-pattern="dots" />
              <fo:page-number-citation ref-id="overview" />
            </fo:basic-link>
          </fo:block>
        </xsl:if>
        
        <!-- Scope and Coverage -->
        <xsl:if test="$show-scope-and-coverage = 'True'">
          <fo:block font-size="{$font-size}" text-align-last="justify">
            <fo:basic-link internal-destination="scope-and-coverage" text-decoration="underline" color="blue">
              <xsl:value-of select="i18n:get('Scope_and_Coverage')" />
              <fo:leader leader-pattern="dots" />
              <fo:page-number-citation ref-id="scope-and-coverage" />
            </fo:basic-link>
          </fo:block>
        </xsl:if>
        
        <!-- Producers and Sponsors -->
        <xsl:if test="$show-producers-and-sponsors = 'True'">
          <fo:block font-size="{$font-size}" text-align-last="justify">
            <fo:basic-link internal-destination="producers-and-sponsors" text-decoration="underline" color="blue">
              <xsl:value-of select="i18n:get('Producers_and_Sponsors')" />
              <fo:leader leader-pattern="dots" />
              <fo:page-number-citation ref-id="producers-and-sponsors" />
            </fo:basic-link>
          </fo:block>
        </xsl:if>
        
        <!-- Sampling -->
        <xsl:if test="$show-sampling = 'True'">
          <fo:block font-size="{$font-size}" text-align-last="justify">
            <fo:basic-link internal-destination="sampling" text-decoration="underline" color="blue">
              <xsl:value-of select="i18n:get('Sampling')" />
              <fo:leader leader-pattern="dots" />
              <fo:page-number-citation ref-id="sampling" />
            </fo:basic-link>
          </fo:block>
        </xsl:if>
        
        <!-- Data Collection -->
        <xsl:if test="$show-data-collection = 'True'">
          <fo:block font-size="{$font-size}" text-align-last="justify">
            <fo:basic-link internal-destination="data-collection" text-decoration="underline" color="blue">
              <xsl:value-of select="i18n:get('Data_Collection')" />
              <fo:leader leader-pattern="dots" />
              <fo:page-number-citation ref-id="data-collection" />
            </fo:basic-link>
          </fo:block>
        </xsl:if>
        
        <!-- Data Processing and Appraisal -->
        <xsl:if test="$show-data-processing-and-appraisal = 'True'">
          <fo:block font-size="{$font-size}" text-align-last="justify">
            <fo:basic-link internal-destination="data-processing-and-appraisal" text-decoration="underline" color="blue">
              <xsl:value-of select="i18n:get('Data_Processing_and_Appraisal')" />
              <fo:leader leader-pattern="dots" />
              <fo:page-number-citation ref-id="data-processing-and-appraisal" />
            </fo:basic-link>
          </fo:block>
        </xsl:if>
        
        <!-- Accessibility -->
        <xsl:if test="$show-accessibility = 'True'">
          <fo:block font-size="{$font-size}" text-align-last="justify">
            <fo:basic-link internal-destination="accessibility" text-decoration="underline" color="blue">
              <xsl:value-of select="i18n:get('Accessibility')" />
              <fo:leader leader-pattern="dots" />
              <fo:page-number-citation ref-id="accessibility" />
            </fo:basic-link>
          </fo:block>
        </xsl:if>
        
        <!-- Rights and Disclaimer -->
        <xsl:if test="$show-rights-and-disclaimer = 'True'">
          <fo:block font-size="{$font-size}" text-align-last="justify">
            <fo:basic-link internal-destination="rights-and-disclaimer" text-decoration="underline" color="blue">
              <xsl:value-of select="i18n:get('Rights_and_Disclaimer')" />
              <fo:leader leader-pattern="dots" />
              <fo:page-number-citation ref-id="rights-and-disclaimer" />
            </fo:basic-link>
          </fo:block>
        </xsl:if>
        
        
        <!-- ============= -->
        <!-- Dynamic lines -->
        <!-- ============= -->
        
        <!-- Files Description -->
        <xsl:if test="$show-files-description = 'True'">
          <fo:block font-size="{$font-size}" text-align-last="justify">
            
            <fo:basic-link internal-destination="files-description" text-decoration="underline" color="blue">
              <xsl:value-of select="i18n:get('Files_Description')" />
              <fo:leader leader-pattern="dots" />
              <fo:page-number-citation ref-id="files-description" />
            </fo:basic-link>
            
            <xsl:for-each select="/codeBook/fileDscr">
              <fo:block margin-left="17mm" font-size="{$font-size}" text-align-last="justify">
                <fo:basic-link internal-destination="file-{fileTxt/fileName/@ID}" text-decoration="underline" color="blue">
                  <xsl:apply-templates select="fileTxt/fileName" />
                  <fo:leader leader-pattern="dots" />
                  <fo:page-number-citation ref-id="file-{fileTxt/fileName/@ID}" />
                </fo:basic-link>
              </fo:block>
            </xsl:for-each>
          </fo:block>
        </xsl:if>
        
        <!-- Variables List -->
        <xsl:if test="$show-variables-list = 'True'">
          <fo:block font-size="{$font-size}" text-align-last="justify">
            <fo:basic-link internal-destination="variables-list" text-decoration="underline" color="blue">
              <xsl:value-of select="i18n:get('Variables_List')" />
              
              <fo:leader leader-pattern="dots" />
              <fo:page-number-citation ref-id="variables-list" />
            </fo:basic-link>
            <xsl:for-each select="/codeBook/fileDscr">
              <fo:block margin-left="17mm" font-size="{$font-size}" text-align-last="justify">
                <fo:basic-link internal-destination="varlist-{fileTxt/fileName/@ID}" text-decoration="underline" color="blue">
                  <xsl:apply-templates select="fileTxt/fileName" />
                  <fo:leader leader-pattern="dots" />
                  <fo:page-number-citation ref-id="varlist-{fileTxt/fileName/@ID}" />
                </fo:basic-link>
              </fo:block>
            </xsl:for-each>
          </fo:block>
        </xsl:if>
        
        <!-- Variables Groups -->
        <xsl:if test="$show-variable-groups = 'True'">
          <fo:block font-size="{$font-size}" text-align-last="justify">
            <fo:basic-link internal-destination="variables-groups" text-decoration="underline" color="blue">
              <xsl:value-of select="i18n:get('Variables_Groups')" />
              <fo:leader leader-pattern="dots" />
              <fo:page-number-citation ref-id="variables-groups" />
            </fo:basic-link>
            
            <xsl:for-each select="/codeBook/dataDscr/varGrp">
              <fo:block margin-left="17mm" font-size="{$font-size}" text-align-last="justify">
                <fo:basic-link internal-destination="vargrp-{@ID}" text-decoration="underline" color="blue">
                  <xsl:value-of select="normalize-space(labl)" />
                  <fo:leader leader-pattern="dots" />
                  <fo:page-number-citation ref-id="vargrp-{@ID}" />
                </fo:basic-link>
              </fo:block>              
            </xsl:for-each>
          </fo:block>
        </xsl:if>
        
        <!-- Variables_Description -->
        <xsl:if test="$show-variables-description = 'True'">
          <fo:block font-size="{$font-size}" text-align-last="justify">
            
            <fo:basic-link internal-destination="variables-description" text-decoration="underline" color="blue">
              <xsl:value-of select="i18n:get('Variables_Description')" />
              <fo:leader leader-pattern="dots" />
              <fo:page-number-citation ref-id="variables-description" />
            </fo:basic-link>
            
            <xsl:for-each select="/codeBook/fileDscr">
              <fo:block margin-left="17mm" font-size="{$font-size}" text-align-last="justify">
                <fo:basic-link internal-destination="vardesc-{fileTxt/fileName/@ID}" text-decoration="underline" color="blue">
                  <xsl:apply-templates select="fileTxt/fileName" />
                  <fo:leader leader-pattern="dots" />
                  <fo:page-number-citation ref-id="vardesc-{fileTxt/fileName/@ID}" />
                </fo:basic-link>
              </fo:block>
            </xsl:for-each>
          </fo:block>
        </xsl:if>
        
      </fo:block>
    </fo:flow>
  </fo:page-sequence>
</xsl:if>
