<?xml version='1.0' encoding='UTF-8'?>
<!-- ================================================= -->
<!-- <xsl:if> metadata information                     -->
<!-- value: <fo:page-sequence>                         -->
<!-- ================================================= -->

<!-- read: -->
<!-- $strings, $font-family, $show-metadata-production, -->
<!-- $default-border, $cell-padding                     -->

<!-- functions: -->
<!-- boolean(), normalize-space() [Xpath 1.0] -->
<!-- proportional-column-width() [FO]         -->

<!-- called: -->
<!-- isodate-long -->

<!-- Metadata production        [table]      -->
<!--   Metadata producers       [table-row]  -->
<!--   Metadata Production Date [table-row]  -->
<!--   Metadata Version         [table-row]  -->
<!--   Metadata ID              [table-row]  -->
<!--   Spacer                   [table-row]  -->
<!-- Report Acknowledgements    [block]      -->
<!-- Report Notes               [block]      -->


<xsl:if test="$show-metadata-info = 1"
        version="2.0"
        xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <fo:page-sequence master-reference="{$page-layout}"
                    font-family="{$font-family}"
                    font-size="{$font-size}">

    <!-- =========================================== -->
    <!-- page content                                -->
    <!-- =========================================== -->

    <fo:flow flow-name="body">
      <fo:block id="metadata-info" />

      <!-- Metadata_Poduction -->
      <xsl:if test="boolean($show-metadata-production)">
        <fo:block id="metadata-production" font-size="18pt" font-weight="bold" space-after="0.1in">
          <xsl:value-of select="$i18n-Metadata_Production"/>
        </fo:block>

        <fo:table table-layout="fixed" width="100%" space-before="0.0in" space-after="0.2in">
          <fo:table-column column-width="proportional-column-width(20)" />
          <fo:table-column column-width="proportional-column-width(80)" />

          <fo:table-body>

            <!-- Metadata_Producers -->
            <xsl:if test="/codeBook/docDscr/citation/prodStmt/producer">
              <fo:table-row>
                <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                  <fo:block>
                    <xsl:value-of select="$i18n-Metadata_Producers"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                  <xsl:apply-templates select="/codeBook/docDscr/citation/prodStmt/producer" />
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>

            <!-- Production_Date -->
            <xsl:if test="/codeBook/docDscr/citation/prodStmt/prodDate">
              <fo:table-row>
                <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                  <fo:block>
                    <xsl:value-of select="$i18n-Production_Date"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                  <fo:block>
                    <xsl:call-template name="isodate-long">
                      <xsl:with-param name="isodate"
                                      select="normalize-space(/codeBook/docDscr/citation/prodStmt/prodDate)" />
                    </xsl:call-template>
                  </fo:block>
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>

            <!-- Version -->
            <xsl:if test="/codeBook/docDscr/citation/verStmt/version">
              <fo:table-row>
                <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                  <fo:block>
                    <xsl:value-of select="$i18n-Version"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                  <xsl:apply-templates select="/codeBook/docDscr/citation/verStmt/version" />
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>

            <!-- Identification -->
            <xsl:if test="/codeBook/docDscr/citation/titlStmt/IDNo">
              <fo:table-row>
                <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                  <fo:block>
                    <xsl:value-of select="$i18n-Identification"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                  <xsl:apply-templates select="/codeBook/docDscr/citation/titlStmt/IDNo" />
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>

          </fo:table-body>
        </fo:table>
      </xsl:if>

      <!-- Acknowledgements -->
      <xsl:if test="normalize-space($report-acknowledgments)">
        <fo:block font-size="18pt" font-weight="bold" space-after="0.1in">
          <xsl:value-of select="$i18n-Acknowledgments"/>
        </fo:block>
        <fo:block font-size="10pt" space-after="0.2in">
          <xsl:value-of select="$report-acknowledgments" />
        </fo:block>
      </xsl:if>

      <!-- Notes -->
      <xsl:if test="normalize-space($report-notes)">
        <fo:block font-size="18pt" font-weight="bold" space-after="0.1in">
          <xsl:value-of select="$i18n-Notes"/>
        </fo:block>
        <fo:block font-size="10pt" space-after="0.2in">
          <xsl:value-of select="$report-notes" />
        </fo:block>
      </xsl:if>

    </fo:flow>
  </fo:page-sequence>
</xsl:if>
