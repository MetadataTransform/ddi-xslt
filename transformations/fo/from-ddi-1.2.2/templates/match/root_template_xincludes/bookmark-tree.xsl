<?xml version='1.0' encoding='UTF-8'?>
<!-- bookmarks.xsl -->
<!-- =========================================== -->
<!-- <xls:if> bookmarks                          -->
<!-- value: <fo:bookmark-tree>                   -->
<!-- =========================================== -->

<!-- read: -->
<!-- show-cover-page, show-metadata-info, show-toc, show-overview             -->
<!-- show-scope-and-coverage, show-producers-and-sponsors,                    -->
<!-- show-sampling, show-data-collection, show-data-processing-and-appraisal, -->
<!-- show-accessibility, show-rights-and-disclaimer, show-files-description,  -->
<!-- show-variable-groups, show-variables-list, show-variables-description    -->

<!-- functions: -->
<!-- nomalize-space(), contains(), concat(), string-length() [xpath 1.0] -->

<!-- called: -->
<!-- trim -->

<xsl:if test="$bookmarks.show = 'True'"
        xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <fo:bookmark-tree>

    <!-- ============= -->
    <!-- 1) Intro      -->
    <!-- ============= -->

    <!-- Cover_Page -->
    <xsl:if test="$page.cover.show ='True'">
      <fo:bookmark internal-destination="cover-page">
        <fo:bookmark-title>
          <xsl:value-of select="i18n:get('Cover_Page')" />
        </fo:bookmark-title>
      </fo:bookmark>
    </xsl:if>

    <!-- Document_Information -->
    <xsl:if test="$page.metadata_info.show = 'True'">
      <fo:bookmark internal-destination="metadata-info">
        <fo:bookmark-title>
          <xsl:value-of select="i18n:get('Document_Information')" />
        </fo:bookmark-title>
      </fo:bookmark>
    </xsl:if>

    <!-- Table_of_Contents -->
    <xsl:if test="$page.table_of_contents.show = 'True'">
      <fo:bookmark internal-destination="toc">
        <fo:bookmark-title>
          <xsl:value-of select="i18n:get('Table_of_Contents')" />
        </fo:bookmark-title>
      </fo:bookmark>
    </xsl:if>

    <!-- ============= -->
    <!-- 2) Overview   -->
    <!-- ============= -->

    <xsl:if test="$page.overview.show = 'True'">

      <fo:bookmark internal-destination="overview">
        <fo:bookmark-title>
          <xsl:value-of select="i18n:get('Overview')" />
        </fo:bookmark-title>

        <!-- Scope_and_Coverage -->
        <xsl:if test="$section.scope_and_coverage.show = 'True'">
          <fo:bookmark internal-destination="scope-and-coverage">
            <fo:bookmark-title>
              <xsl:value-of select="i18n:get('Scope_and_Coverage')" />
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:if>

        <!-- Producers_and_Sponsors -->
        <xsl:if test="$section.producers_and_sponsors.show = 'True'">
          <fo:bookmark internal-destination="producers-and-sponsors">
            <fo:bookmark-title>
              <xsl:value-of select="i18n:get('Producers_and_Sponsors')" />
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:if>

        <!-- Sampling -->
        <xsl:if test="$section.sampling.show = 'True'">
          <fo:bookmark internal-destination="sampling">
            <fo:bookmark-title>
              <xsl:value-of select="i18n:get('Sampling')" />
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:if>

        <!-- Data_Collection -->
        <xsl:if test="$section.data_collection.show = 'True'">
          <fo:bookmark internal-destination="data-collection">
            <fo:bookmark-title>
              <xsl:value-of select="i18n:get('Data_Collection')" />
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:if>

        <!-- Data_Processing_and_Appraisal -->
        <xsl:if test="$section.data_processing_and_appraisal.show = 'True'">
          <fo:bookmark internal-destination="data-processing-and-appraisal">
            <fo:bookmark-title>
              <xsl:value-of select="i18n:get('Data_Processing_and_Appraisal')" />
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:if>

        <!-- Accessibility -->
        <xsl:if test="$section.accessibility.show = 'True'">
          <fo:bookmark internal-destination="accessibility">
            <fo:bookmark-title>
              <xsl:value-of select="i18n:get('Accessibility')" />
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:if>

        <!-- Rights_and_Disclaimer -->
        <xsl:if test="$section.rights_and_disclaimer.show = 'True'">
          <fo:bookmark internal-destination="rights-and-disclaimer">
            <fo:bookmark-title>
              <xsl:value-of select="i18n:get('Rights_and_Disclaimer')" />
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:if>

      </fo:bookmark>
    </xsl:if>

    <!-- ============= -->
    <!-- 3) Details    -->
    <!-- ============= -->

    <!-- Files_Description -->
    <xsl:if test="$page.files_description.show = 'True'">
      <fo:bookmark internal-destination="files-description">

        <fo:bookmark-title>
          <xsl:value-of select="i18n:get('Files_Description')" />
        </fo:bookmark-title>

        <xsl:for-each select="/codeBook/fileDscr">
          <fo:bookmark internal-destination="file-{fileTxt/fileName/@ID}">
            <fo:bookmark-title>
              <xsl:apply-templates select="fileTxt/fileName" />
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:for-each>
      </fo:bookmark>
    </xsl:if>

    <!-- Variables_Groups -->
    <xsl:if test="$page.variable_groups.show = 'True'">
      <fo:bookmark internal-destination="variables-groups">
        <fo:bookmark-title>
          <xsl:value-of select="i18n:get('Variables_Groups')" />
        </fo:bookmark-title>

        <xsl:for-each select="/codeBook/dataDscr/varGrp">
            <fo:bookmark internal-destination="vargrp-{@ID}">
              <fo:bookmark-title>
                <xsl:value-of select="normalize-space(labl)" />
              </fo:bookmark-title>
            </fo:bookmark>          
        </xsl:for-each>
      </fo:bookmark>
    </xsl:if>

    <!-- Variables_List -->
    <xsl:if test="$page.variables_list.show = 'True'">
      <fo:bookmark internal-destination="variables-list">
        <fo:bookmark-title>
          <xsl:value-of select="i18n:get('Variables_List')" />
        </fo:bookmark-title>

        <xsl:for-each select="/codeBook/fileDscr">
          <fo:bookmark internal-destination="varlist-{fileTxt/fileName/@ID}">
            <fo:bookmark-title>
              <xsl:apply-templates select="fileTxt/fileName" />
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:for-each>
      </fo:bookmark>
    </xsl:if>

    <!-- Variables_Description -->
    <xsl:if test="$page.variables_description.show = 'True'">
      <fo:bookmark internal-destination="variables-description">
        <fo:bookmark-title>
          <xsl:value-of select="i18n:get('Variables_Description')" />
        </fo:bookmark-title>

        <xsl:for-each select="/codeBook/fileDscr">
          <fo:bookmark internal-destination="vardesc-{fileTxt/fileName/@ID}">
            <fo:bookmark-title>
              <xsl:apply-templates select="fileTxt/fileName" />
            </fo:bookmark-title>

            <xsl:variable name="fileId"
              select="if (fileTxt/fileName/@ID) then fileTxt/fileName/@ID
                      else if (@ID) then @ID
                      else () " />

            <xsl:for-each select="/codeBook/dataDscr/var[@files = $fileId]">
                <fo:bookmark internal-destination="var-{@ID}">
                  <fo:bookmark-title>
                    <xsl:apply-templates select="@name" />
                    <xsl:value-of select="if (normalize-space(labl)) then concat(': ', util:trim(labl)) else () "/>
                  </fo:bookmark-title>
                </fo:bookmark>            
            </xsl:for-each>

          </fo:bookmark>
        </xsl:for-each>
      </fo:bookmark>
    </xsl:if>

  </fo:bookmark-tree>
</xsl:if>
