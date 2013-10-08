<?xml version='1.0' encoding='UTF-8'?>
<!-- ===================================== -->
<!-- <xsl:if> variables list               -->
<!-- value: <fo:page-sequence>             -->
<!-- ===================================== -->

<!-- read: -->
<!-- $strings, $show-variables-list-layout, $font-family -->

<!-- functions: -->
<!-- count() [Xpath 1.0] -->

<xsl:if test="$show-variables-list = 1"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <fo:page-sequence master-reference="{$page-layout}"
                    font-family="{$font-family}"
                    font-size="{$font-size}">

    <!-- =========================================== -->
    <!-- page header                                 -->
    <!-- =========================================== -->
    <fo:static-content flow-name="before">
      <fo:block font-size="{$header-font-size}" text-align="center">
        <xsl:value-of select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:titlStmt/ddi:titl" /> -
        <xsl:value-of select="$i18n-Variables_List" />
      </fo:block>
    </fo:static-content>

    <xsl:call-template name="page_footer" />

    <!-- =========================================== -->
    <!-- page content                                -->
    <!-- =========================================== -->
    <fo:flow flow-name="body">

      <!-- Heading -->
      <fo:block id="variables-list" font-size="18pt"
                font-weight="bold" space-after="0.1in">
        <xsl:value-of select="$i18n-Variables_List" />
      </fo:block>

      <!-- number of groups in data set -->
      <fo:block font-weight="bold">
        <xsl:value-of select="$i18n-Dataset_contains" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="count(/ddi:codeBook/ddi:dataDscr/ddi:var)" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="$i18n-variables" />
      </fo:block>

      <!-- the actual tables -->
      <xsl:apply-templates select="/ddi:codeBook/ddi:fileDscr"
                           mode="variables-list" />

    </fo:flow>
  </fo:page-sequence>
</xsl:if>
