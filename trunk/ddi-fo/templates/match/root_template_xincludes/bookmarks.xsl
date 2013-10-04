<?xml version='1.0' encoding='UTF-8'?>
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

<xsl:if test="$show-bookmarks = 1"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <fo:bookmark-tree>

    <!-- Cover_Page -->
    <xsl:if test = "$show-cover-page = 1">
      <fo:bookmark internal-destination = "cover-page">
        <fo:bookmark-title>
          <xsl:value-of select="$strings/*/entry[@key='Cover_Page']" />
        </fo:bookmark-title>
      </fo:bookmark>
    </xsl:if>

    <!-- Document_Information -->
    <xsl:if test="$show-metadata-info = 1">
      <fo:bookmark internal-destination="metadata-info">
        <fo:bookmark-title>
          <xsl:value-of select="$strings/*/entry[@key='Document_Information']" />
        </fo:bookmark-title>
      </fo:bookmark>
    </xsl:if>

    <!-- Table_of_Contents -->
    <xsl:if test="$show-toc = 1">
      <fo:bookmark internal-destination="toc">
        <fo:bookmark-title>
          <xsl:value-of select="$strings/*/entry[@key = 'Table_of_Contents']" />
        </fo:bookmark-title>
      </fo:bookmark>
    </xsl:if>

    <!-- ============= -->
    <!-- Overview      -->
    <!-- ============= -->

    <xsl:if test="$show-overview = 1">

      <fo:bookmark internal-destination="overview">
        <fo:bookmark-title>
          <xsl:value-of select="$strings/*/entry[@key='Overview']" />
        </fo:bookmark-title>

        <!-- Scope_and_Coverage -->
        <xsl:if test="$show-scope-and-coverage = 1">
          <fo:bookmark internal-destination="scope-and-coverage">
            <fo:bookmark-title>
              <xsl:value-of select="$strings/*/entry[@key='Scope_and_Coverage']" />
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:if>

        <!-- Producers_and_Sponsors -->
        <xsl:if test="$show-producers-and-sponsors = 1">
          <fo:bookmark internal-destination="producers-and-sponsors">
            <fo:bookmark-title>
              <xsl:value-of select="$strings/*/entry[@key='Producers_and_Sponsors']" />
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:if>

        <!-- Sampling -->
        <xsl:if test="$show-sampling = 1">
          <fo:bookmark internal-destination="sampling">
            <fo:bookmark-title>
              <xsl:value-of select="$strings/*/entry[@key='Sampling']" />
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:if>

        <!-- Data_Collection -->
        <xsl:if test="$show-data-collection = 1">
          <fo:bookmark internal-destination="data-collection">
            <fo:bookmark-title>
              <xsl:value-of select="$strings/*/entry[@key='Data_Collection']" />
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:if>

        <!-- Data_Processing_and_Appraisal -->
        <xsl:if test="$show-data-processing-and-appraisal = 1">
          <fo:bookmark internal-destination="data-processing-and-appraisal">
            <fo:bookmark-title>
              <xsl:value-of select="$strings/*/entry[@key='Data_Processing_and_Appraisal']" />
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:if>

        <!-- Accessibility -->
        <xsl:if test="$show-accessibility= 1">
          <fo:bookmark internal-destination="accessibility">
            <fo:bookmark-title>
              <xsl:value-of select="$strings/*/entry[@key='Accessibility']" />
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:if>

        <!-- Rights_and_Disclaimer -->
        <xsl:if test="$show-rights-and-disclaimer = 1">
          <fo:bookmark internal-destination="rights-and-disclaimer">
            <fo:bookmark-title>
              <xsl:value-of select="$strings/*/entry[@key='Rights_and_Disclaimer']" />
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:if>

      </fo:bookmark>
    </xsl:if>

    <!-- Files_Description -->
    <xsl:if test="$show-files-description = 1">
      <fo:bookmark internal-destination="files-description">

        <fo:bookmark-title>
          <xsl:value-of select="$strings/*/entry[@key='Files_Description']" />
        </fo:bookmark-title>

        <xsl:for-each select="/ddi:codeBook/ddi:fileDscr">
          <fo:bookmark internal-destination="file-{ddi:fileTxt/ddi:fileName/@ID}">
            <fo:bookmark-title>
              <xsl:apply-templates select="ddi:fileTxt/ddi:fileName" />
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:for-each>
      </fo:bookmark>
    </xsl:if>

    <!-- Variables_Groups -->
    <xsl:if test="$show-variable-groups = 1">
      <fo:bookmark internal-destination="variables-groups">
        <fo:bookmark-title>
          <xsl:value-of select="$strings/*/entry[@key='Variables_Groups']" />
        </fo:bookmark-title>

        <xsl:for-each select="/ddi:codeBook/ddi:dataDscr/ddi:varGrp">
          <xsl:if test="contains($subset-groups, concat(',',@ID,',')) or string-length($subset-groups)=0">
            <fo:bookmark internal-destination="vargrp-{@ID}">
              <fo:bookmark-title>
                <xsl:value-of select="normalize-space(ddi:labl)" />
              </fo:bookmark-title>
            </fo:bookmark>
          </xsl:if>
        </xsl:for-each>
      </fo:bookmark>
    </xsl:if>

    <!-- Variables_List -->
    <xsl:if test="$show-variables-list = 1">
      <fo:bookmark internal-destination="variables-list">
        <fo:bookmark-title>
          <xsl:value-of select="$strings/*/entry[@key='Variables_List']" />
        </fo:bookmark-title>

        <xsl:for-each select="/ddi:codeBook/ddi:fileDscr">
          <fo:bookmark internal-destination="varlist-{ddi:fileTxt/ddi:fileName/@ID}">
            <fo:bookmark-title>
              <xsl:apply-templates select="ddi:fileTxt/ddi:fileName" />
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:for-each>
      </fo:bookmark>
    </xsl:if>

    <!-- Variables_Description -->
    <xsl:if test="$show-variables-description= 1">
      <fo:bookmark internal-destination="variables-description">
        <fo:bookmark-title>
          <xsl:value-of select="$strings/*/entry[@key='Variables_Description']" />
        </fo:bookmark-title>

        <xsl:for-each select="/ddi:codeBook/ddi:fileDscr">
          <fo:bookmark internal-destination="vardesc-{ddi:fileTxt/ddi:fileName/@ID}">
            <fo:bookmark-title>
              <xsl:apply-templates select="ddi:fileTxt/ddi:fileName" />
            </fo:bookmark-title>

            <xsl:variable name="fileId">
              <xsl:choose>
                <xsl:when test="ddi:fileTxt/ddi:fileName/@ID">
                  <xsl:value-of select="ddi:fileTxt/ddi:fileName/@ID" />
                </xsl:when>
                <xsl:when test="@ID">
                  <xsl:value-of select="@ID"/>
                </xsl:when>
              </xsl:choose>
            </xsl:variable>

            <xsl:for-each select="/ddi:codeBook/ddi:dataDscr/ddi:var[@files=$fileId]">
              <xsl:if test="contains($subset-vars, concat(',',@ID,',')) or string-length($subset-vars)=0 ">
                <fo:bookmark internal-destination="var-{@ID}">
                  <fo:bookmark-title>
                    <xsl:apply-templates select="@name" />
                    <xsl:if test="normalize-space(ddi:labl)">
                      <xsl:text>: </xsl:text>
                      <xsl:call-template name="trim">
                        <xsl:with-param name="s" select="ddi:labl" />
                      </xsl:call-template>
                    </xsl:if>
                  </fo:bookmark-title>
                </fo:bookmark>
              </xsl:if>
            </xsl:for-each>

          </fo:bookmark>
        </xsl:for-each>
      </fo:bookmark>
    </xsl:if>

  </fo:bookmark-tree>
</xsl:if>
