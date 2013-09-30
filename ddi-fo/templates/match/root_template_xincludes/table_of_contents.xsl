<?xml version='1.0' encoding='UTF-8'?>

<!-- ============================================== -->
<!-- [4] Table of contents                          -->
<!-- [page-sequence]                                -->
<!-- ============================================== -->

<!--
  Variables read:
  font-family, msg, show-overview, show-scope-and-coverage,
  show-producers-and-sponsors, show-sampling, show-data-collection
  show-data-processing-and-appraisal, show-accessibility,
  show-rights-and-disclaimer, show-files-description, show-variables-list
  show-variable-groups, subset-groups

  Functions called:
  normalize-space(), string-length(), contains(), concat()
-->

<!--
  1:  Overview                      [block]
  2:  Scope and Coverage            [block]
  3:  Producers and Sponsors        [block]
  4:  Sampling                      [block]
  5:  Data Collection               [block]
  6:  Data Processing and Appraisal [block]
  7:  Accessibility                 [block]
  8:  Rights and Disclaimer         [block]
  9:  Files and Description         [block]
  10: Variables List                [block]
  11: Variable Groups               [block]
  12: Variables Description         [block]
-->

<xsl:if test="$show-toc = 1"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <fo:page-sequence master-reference="default-page"
                    font-family="{$font-family}" font-size="10pt">

    <fo:flow flow-name="xsl-region-body">

      <!-- Table_of_Contents -->
      <fo:block id="toc" font-size="18pt" font-weight="bold" space-before="0.5in" text-align="center" space-after="0.1in">
        <xsl:value-of select="$msg/*/entry[@key='Table_of_Contents']" />
      </fo:block>

      <fo:block margin-left="0.5in" margin-right="0.5in">

        <!-- 1) Overview -->
        <xsl:if test="$show-overview = 1">
          <fo:block font-size="10pt" text-align-last="justify">
            <fo:basic-link internal-destination="overview" text-decoration="underline" color="blue">
              <xsl:value-of select="$msg/*/entry[@key='Overview']" />
              <fo:leader leader-pattern="dots" />
              <fo:page-number-citation ref-id="overview" />
            </fo:basic-link>
          </fo:block>
        </xsl:if>

        <!-- 2) Scope_and_Coverage -->
        <xsl:if test="$show-scope-and-coverage = 1">
          <fo:block font-size="10pt" text-align-last="justify">
            <fo:basic-link internal-destination="scope-and-coverage" text-decoration="underline" color="blue">
              <xsl:value-of select="$msg/*/entry[@key='Scope_and_Coverage']" />
              <fo:leader leader-pattern="dots" />
              <fo:page-number-citation ref-id="scope-and-coverage" />
            </fo:basic-link>
          </fo:block>
        </xsl:if>

        <!-- 3) Producers_and_Sponsors -->
        <xsl:if test="$show-producers-and-sponsors = 1">
          <fo:block font-size="10pt" text-align-last="justify">
            <fo:basic-link internal-destination="producers-and-sponsors" text-decoration="underline" color="blue">
              <xsl:value-of select="$msg/*/entry[@key='Producers_and_Sponsors']" />
              <fo:leader leader-pattern="dots" />
              <fo:page-number-citation ref-id="producers-and-sponsors" />
            </fo:basic-link>
          </fo:block>
        </xsl:if>

        <!-- 4) Sampling -->
        <xsl:if test="$show-sampling = 1">
          <fo:block font-size="10pt" text-align-last="justify">
            <fo:basic-link internal-destination="sampling" text-decoration="underline" color="blue">
              <xsl:value-of select="$msg/*/entry[@key='Sampling']" />
              <fo:leader leader-pattern="dots" />
              <fo:page-number-citation ref-id="sampling" />
            </fo:basic-link>
          </fo:block>
        </xsl:if>

        <!-- 5) Data_Collection -->
        <xsl:if test="$show-data-collection = 1">
          <fo:block font-size="10pt" text-align-last="justify">
            <fo:basic-link internal-destination="data-collection" text-decoration="underline" color="blue">
              <xsl:value-of select="$msg/*/entry[@key='Data_Collection']" />
              <fo:leader leader-pattern="dots" />
              <fo:page-number-citation ref-id="data-collection" />
            </fo:basic-link>
          </fo:block>
        </xsl:if>

        <!-- 6) Data_Processing_and_Appraisal -->
        <xsl:if test="$show-data-processing-and-appraisal = 1">
          <fo:block font-size="10pt" text-align-last="justify">
            <fo:basic-link internal-destination="data-processing-and-appraisal" text-decoration="underline" color="blue">
              <xsl:value-of select="$msg/*/entry[@key='Data_Processing_and_Appraisal']" />
              <fo:leader leader-pattern="dots" />
              <fo:page-number-citation ref-id="data-processing-and-appraisal" />
            </fo:basic-link>
          </fo:block>
        </xsl:if>

        <!-- 7) Accessibility -->
        <xsl:if test="$show-accessibility= 1">
          <fo:block font-size="10pt" text-align-last="justify">
            <fo:basic-link internal-destination="accessibility" text-decoration="underline" color="blue">
              <xsl:value-of select="$msg/*/entry[@key='Accessibility']" />
              <fo:leader leader-pattern="dots" />
              <fo:page-number-citation ref-id="accessibility" />
            </fo:basic-link>
          </fo:block>
        </xsl:if>

        <!-- 8) Rights_and_Disclaimer -->
        <xsl:if test="$show-rights-and-disclaimer = 1">
          <fo:block font-size="10pt" text-align-last="justify">
            <fo:basic-link internal-destination="rights-and-disclaimer" text-decoration="underline" color="blue">
              <xsl:value-of select="$msg/*/entry[@key='Rights_and_Disclaimer']" />
              <fo:leader leader-pattern="dots" />
              <fo:page-number-citation ref-id="rights-and-disclaimer" />
            </fo:basic-link>
          </fo:block>
        </xsl:if>

        <!-- 9) [block] msg Files_Description, fileName -->
        <xsl:if test="$show-files-description = 1">
          <fo:block font-size="10pt" text-align-last="justify">

            <fo:basic-link internal-destination="files-description" text-decoration="underline" color="blue">
              <xsl:value-of select="$msg/*/entry[@key='Files_Description']" />
              <fo:leader leader-pattern="dots" />
              <fo:page-number-citation ref-id="files-description" />
            </fo:basic-link>

            <xsl:for-each select="/ddi:codeBook/ddi:fileDscr">
              <fo:block margin-left="0.7in" font-size="10pt" text-align-last="justify">
                <fo:basic-link internal-destination="file-{ddi:fileTxt/ddi:fileName/@ID}" text-decoration="underline" color="blue">
                  <xsl:apply-templates select="ddi:fileTxt/ddi:fileName" />
                  <fo:leader leader-pattern="dots" />
                  <fo:page-number-citation ref-id="file-{ddi:fileTxt/ddi:fileName/@ID}" />
                </fo:basic-link>
              </fo:block>
            </xsl:for-each>

          </fo:block>
        </xsl:if>

        <!-- 10) [block] msg Variables_List, fileName -->
        <xsl:if test="$show-variables-list = 1">
          <fo:block font-size="10pt" text-align-last="justify">
            <fo:basic-link internal-destination="variables-list" text-decoration="underline" color="blue">
              <xsl:value-of select="$msg/*/entry[@key='Variables_List']" />
              <fo:leader leader-pattern="dots"/>
              <fo:page-number-citation ref-id="variables-list" />
            </fo:basic-link>
            <xsl:for-each select="/ddi:codeBook/ddi:fileDscr">
              <fo:block margin-left="0.7in" font-size="10pt" text-align-last="justify">
                <fo:basic-link internal-destination="varlist-{ddi:fileTxt/ddi:fileName/@ID}" text-decoration="underline" color="blue">
                  <xsl:apply-templates select="ddi:fileTxt/ddi:fileName" />
                  <fo:leader leader-pattern="dots" />
                  <fo:page-number-citation ref-id="varlist-{ddi:fileTxt/ddi:fileName/@ID}" />
                </fo:basic-link>
              </fo:block>
            </xsl:for-each>
          </fo:block>
        </xsl:if>

        <!-- 11) [block] msg Variable_Groups -->
        <xsl:if test="$show-variable-groups = 1">
          <fo:block font-size="10pt" text-align-last="justify">
            <fo:basic-link internal-destination="variables-groups" text-decoration="underline" color="blue">
              <xsl:value-of select="$msg/*/entry[@key='Variables_Groups']" />
              <fo:leader leader-pattern="dots" />
              <fo:page-number-citation ref-id="variables-groups" />
            </fo:basic-link>

            <xsl:for-each select="/ddi:codeBook/ddi:dataDscr/ddi:varGrp">
              <!-- Show group if its part of subset OR no subset is defined -->
              <xsl:if test="contains($subset-groups,concat(',',@ID,',')) or string-length($subset-groups)=0">
                <fo:block margin-left="0.7in" font-size="10pt" text-align-last="justify">
                  <fo:basic-link internal-destination="vargrp-{@ID}" text-decoration="underline" color="blue">
                    <xsl:value-of select="normalize-space(ddi:labl)" />
                    <fo:leader leader-pattern="dots" />
                    <fo:page-number-citation ref-id="vargrp-{@ID}" />
                  </fo:basic-link>
                </fo:block>
              </xsl:if>
            </xsl:for-each>
          </fo:block>
        </xsl:if>

        <!-- 12) [block] Variables_Description, fileDscr/fileName -->
        <xsl:if test="$show-variables-description = 1">
          <fo:block font-size="10pt" text-align-last="justify">

            <fo:basic-link internal-destination="variables-description" text-decoration="underline" color="blue">
              <xsl:value-of select="$msg/*/entry[@key='Variables_Description']" />
              <fo:leader leader-pattern="dots" />
              <fo:page-number-citation ref-id="variables-description" />
            </fo:basic-link>

            <xsl:for-each select="/ddi:codeBook/ddi:fileDscr">
              <fo:block margin-left="0.7in" font-size="10pt" text-align-last="justify">
                <fo:basic-link internal-destination="vardesc-{ddi:fileTxt/ddi:fileName/@ID}" text-decoration="underline" color="blue">
                  <xsl:apply-templates select="ddi:fileTxt/ddi:fileName" />
                  <fo:leader leader-pattern="dots" />
                  <fo:page-number-citation ref-id="vardesc-{ddi:fileTxt/ddi:fileName/@ID}" />
                </fo:basic-link>
              </fo:block>
            </xsl:for-each>

          </fo:block>
        </xsl:if>

      </fo:block>
    </fo:flow>
  </fo:page-sequence>
</xsl:if>