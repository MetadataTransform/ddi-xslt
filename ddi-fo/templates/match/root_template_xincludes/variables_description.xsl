<?xml version='1.0' encoding='UTF-8'?>
<!-- ==================================================== -->
<!-- <xsl:if> variables description                       -->
<!-- value: <fo:page-sequence>                            -->
<!-- ==================================================== -->

<!-- read: -->
<!-- $font-family -->

<!-- functions: -->
<!-- count(), string-length() [Xpath 1.0] -->

<xsl:if test="$show-variables-description = 'True'"
        xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <fo:page-sequence master-reference="{$page-layout}"
                    font-family="{$font-family}"
                    font-size="{$font-size}">

    <!-- =========================================== -->
    <!-- page header                                 -->
    <!-- =========================================== -->
    <xsl:call-template name="page_header">
      <xsl:with-param name="section_name" select="$i18n-Variables_Description" />
    </xsl:call-template>

    <xsl:call-template name="page_footer" />

    <!-- =========================================== -->
    <!-- page content                                -->
    <!-- =========================================== -->
    <fo:flow flow-name="body">

      <!-- heading -->
      <fo:block id="variables-description" font-size="18pt"
                font-weight="bold" space-after="0.1in">
        <xsl:value-of select="$i18n-Variables_Description" />
      </fo:block>

      <!-- number of variables in data set -->
      <fo:block font-weight="bold">
        <xsl:value-of select="$i18n-Dataset_contains" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="count(/codeBook/dataDscr/var)" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="$i18n-variables" />
        <xsl:if test="string-length($subset-vars) &gt; 0">
          <xsl:value-of select="$i18n-ShowingSubset" />
        </xsl:if>
      </fo:block>

    </fo:flow>
  </fo:page-sequence>

  <!-- fileDscr -->
  <xsl:apply-templates select="/codeBook/fileDscr"
                       mode="variables-description" />
</xsl:if>
