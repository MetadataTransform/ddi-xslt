<?xml version='1.0' encoding='UTF-8'?>
<!-- metadata_information.xsl -->
<!-- ================================================= -->
<!-- <xsl:if> metadata information                     -->
<!-- value: <fo:page-sequence>                         -->
<!-- ================================================= -->

<!-- read: -->
<!-- $strings, $font-family -->
<!-- $default-border, $cell-padding -->

<!-- functions: -->
<!-- boolean(), normalize-space() [Xpath 1.0] -->
<!-- proportional-column-width() [FO]         -->
<!-- util:isodate_long() [functions] -->


<!-- Metadata production        [table]      -->
<!--   Metadata producers       [table-row]  -->
<!--   Metadata Production Date [table-row]  -->
<!--   Metadata Version         [table-row]  -->
<!--   Metadata ID              [table-row]  -->
<!--   Spacer                   [table-row]  -->
<!-- Report Acknowledgements    [block]      -->
<!-- Report Notes               [block]      -->


<xsl:if test="$show-metadata-info = 'True'"
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
      <fo:block id="metadata-production" font-size="18pt" font-weight="bold" space-after="0.1in">
        <xsl:value-of select="$i18n-Metadata_Production" />
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
                    <xsl:value-of select="util:isodate_long(normalize-space(/codeBook/docDscr/citation/prodStmt/prodDate))" />
                  </fo:block>
                </fo:table-cell>
              </fo:table-row>
            </xsl:if>

            <!-- Version -->
            <!-- <xsl:if test="/codeBook/docDscr/citation/verStmt/version">
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
            </xsl:if> -->

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
      

    </fo:flow>
  </fo:page-sequence>
</xsl:if>
