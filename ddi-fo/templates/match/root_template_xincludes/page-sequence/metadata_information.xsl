<?xml version='1.0' encoding='UTF-8'?>
<!-- metadata_information.xsl -->
<!-- ================================================= -->
<!-- <xsl:if> metadata information                     -->
<!-- value: <fo:page-sequence>                         -->
<!-- ================================================= -->

<!-- read: -->
<!-- $font-family -->
<!-- $layout.tables.border, $layout.tables.cellpadding -->

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


<xsl:if test="$page.metadata_info.show = 'True'"
  xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format">
  
  <fo:page-sequence master-reference="{$layout.page_master}"
    font-family="{$layout.font_family}"
    font-size="{$layout.font_size}">
    
    <!-- =========================================== -->
    <!-- page content                                -->
    <!-- =========================================== -->
    
    <fo:flow flow-name="body">
      <fo:block id="metadata-info" />
      
      <!-- Title -->
      <fo:block id="metadata-production" font-size="18pt" font-weight="bold" space-after="2.5mm">
        <xsl:value-of select="i18n:get('Metadata_Production')"/>
      </fo:block>
      
      <fo:table table-layout="fixed" width="100%" space-before="0.0mm" space-after="5mm" font-size="12">
        <fo:table-column column-width="proportional-column-width(25)" />
        <fo:table-column column-width="proportional-column-width(75)" />
        
        <fo:table-body>
          
          <!-- Metadata Producers -->
          <xsl:if test="/codeBook/docDscr/citation/prodStmt/producer">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:value-of select="concat(i18n:get('Metadata_Producers'), ':')"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <xsl:apply-templates select="/codeBook/docDscr/citation/prodStmt/producer" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          
          <!-- Production Date -->
          <xsl:if test="/codeBook/docDscr/citation/prodStmt/prodDate">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:value-of select="concat(i18n:get('Production_Date'), ':')"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>                  
                  <xsl:value-of select="util:isodate_long(normalize-space(/codeBook/docDscr/citation/prodStmt/prodDate))" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          <!-- Version -->
          <!-- <xsl:if test="/codeBook/docDscr/citation/verStmt/version">
            <fo:table-row>
            <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
            <fo:block>
            <xsl:value-of select="$i18n-Version"/>
            </fo:block>
            </fo:table-cell>
            <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
            <xsl:apply-templates select="/codeBook/docDscr/citation/verStmt/version" />
            </fo:table-cell>
            </fo:table-row>
            </xsl:if> -->
          
          <!-- Identification -->
          <xsl:if test="/codeBook/docDscr/citation/titlStmt/IDNo">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block>
                  <xsl:value-of select="concat(i18n:get('Identification'), ':')"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <xsl:apply-templates select="/codeBook/docDscr/citation/titlStmt/IDNo" />
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
          
          
        </fo:table-body>
      </fo:table>
      
    </fo:flow>
  </fo:page-sequence>
</xsl:if>
