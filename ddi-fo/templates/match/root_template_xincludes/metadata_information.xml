<?xml version='1.0' encoding='UTF-8'?>

<!-- ==================================================== -->
<!-- [3] Metadata information                             -->
<!-- [page-sequence] with [table]                         -->
<!-- ==================================================== -->

<!--
  Variables read:
  msg, font-family, show-metadata-production,
  default-border, cell-padding

  Functions/templates called:
  boolean(), normalize-space() [Xpath 1.0]
  proportional-column-width() [FO]
  isodate-long
-->

<!--
  1:   Metadata production      [table]
  1.1: Metadata producers       [table-row]
  1.2: Metadata Production Date [table-row]
  1.3: Metadata Version         [table-row]
  1.5: Metadata ID              [table-row]
  1.6: Spacer                   [table-row]
  2:   Report Acknowledgements  [block]
  3:   Report Notes             [block]
-->

<xsl:if test="$show-metadata-info = 1"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <fo:page-sequence master-reference="default-page"
                    font-family="{$font-family}" font-size="10pt">

    <fo:flow flow-name="xsl-region-body">
      <fo:block id="metadata-info" />

      <!-- 1) metadata production -->
      <xsl:if test="boolean($show-metadata-production)">
        <fo:block id="metadata-production" font-size="18pt" font-weight="bold" space-after="0.1in">
          <xsl:value-of select="$msg/*/entry[@key='Metadata_Production']" />
        </fo:block>

        <fo:table table-layout="fixed" width="100%" space-before="0.0in" space-after="0.2in">
          <fo:table-column column-width="proportional-column-width(20)" />
          <fo:table-column column-width="proportional-column-width(80)" />

          <fo:table-body>

            <!-- 1.1) metadata producer -->
            <xsl:if test="/ddi:codeBook/ddi:docDscr/ddi:citation/ddi:prodStmt/ddi:producer">
              <fo:table-row>
                <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                  <fo:block>
                    <xsl:value-of select="$msg/*/entry[@key='Metadata_Producers']" />
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                  <xsl:apply-templates select="/ddi:codeBook/ddi:docDscr/ddi:citation/ddi:prodStmt/ddi:producer" />
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>

            <!-- 1.2) metadata production date -->
            <xsl:if test="/ddi:codeBook/ddi:docDscr/ddi:citation/ddi:prodStmt/ddi:prodDate">
              <fo:table-row>
                <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                  <fo:block>
                    <xsl:value-of select="$msg/*/entry[@key='Production_Date']" />
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                  <fo:block>
                    <xsl:call-template name="isodate-long">
                      <xsl:with-param name="isodate" select="normalize-space(/ddi:codeBook/ddi:docDscr/ddi:citation/ddi:prodStmt/ddi:prodDate)" />
                    </xsl:call-template>
                  </fo:block>
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>

            <!-- 1.3) metadata version -->
            <xsl:if test="/ddi:codeBook/ddi:docDscr/ddi:citation/ddi:verStmt/ddi:version">
              <fo:table-row>
                <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                  <fo:block>
                    <xsl:value-of select="$msg/*/entry[@key='Version']" />
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                  <xsl:apply-templates select="/ddi:codeBook/ddi:docDscr/ddi:citation/ddi:verStmt/ddi:version" />
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>

            <!-- 1.4) metadata id -->
            <xsl:if test="/ddi:codeBook/ddi:docDscr/ddi:citation/ddi:titlStmt/ddi:IDNo">
              <fo:table-row>
                <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                  <fo:block>
                    <xsl:value-of select="$msg/*/entry[@key='Identification']" />
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                  <xsl:apply-templates select="/ddi:codeBook/ddi:docDscr/ddi:citation/ddi:titlStmt/ddi:IDNo" />
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>

            <!-- =================== -->
            <fo:table-row>
              <fo:table-cell>
                <fo:block> </fo:block>
              </fo:table-cell>
            </fo:table-row>

          </fo:table-body>
        </fo:table>
      </xsl:if>

      <!-- 2) report acknowledgements -->
      <xsl:if test="normalize-space($report-acknowledgments)">
        <fo:block font-size="18pt" font-weight="bold" space-after="0.1in">
          <xsl:value-of select="$msg/*/entry[@key='Acknowledgments']" />
        </fo:block>
        <fo:block font-size="10pt" space-after="0.2in">
          <xsl:value-of select="$report-acknowledgments" />
        </fo:block>
      </xsl:if>

      <!-- 3) report notes -->
      <xsl:if test="normalize-space($report-notes)">
        <fo:block font-size="18pt" font-weight="bold" space-after="0.1in">
          <xsl:value-of select="$msg/*/entry[@key='Notes']" />
        </fo:block>
        <fo:block font-size="10pt" space-after="0.2in">
          <xsl:value-of select="$report-notes" />
        </fo:block>
      </xsl:if>

    </fo:flow>
  </fo:page-sequence>
</xsl:if>
