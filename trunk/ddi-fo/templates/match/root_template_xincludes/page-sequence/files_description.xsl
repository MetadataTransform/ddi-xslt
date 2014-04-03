<?xml version='1.0' encoding='UTF-8'?>
<!-- files_description.xsl -->
<!-- ============================= -->
<!-- <xsl:if> files description    -->
<!-- value: <fo:page-sequence>     -->
<!-- ============================= -->

<!-- read: -->
<!-- $page-layout, $strings, $font-family, $font-size, $header-font-size -->

<!-- functions -->
<!-- count() [xpath 1.0] -->

<xsl:if test="$show-files-description = 'True'"
        xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <fo:page-sequence master-reference="{$page-layout}"
                    font-family="{$font-family}"
                    font-size="{$font-size}">

    <!-- =========================================== -->
    <!-- page header and footer                      -->
    <!-- =========================================== -->
    <xsl:call-template name="page_header">
      <xsl:with-param name="section_name" select="$i18n-Files_Description" />
    </xsl:call-template>

    <xsl:call-template name="page_footer" />

    <!-- =========================================== -->
    <!-- page content                                -->
    <!-- =========================================== -->
    <fo:flow flow-name="body">

      <!-- heading -->
      <fo:block id="files-description" font-size="18pt" font-weight="bold" space-after="2.5mm">
        <xsl:value-of select="$i18n-Files_Description" />
      </fo:block>

      <!-- number of files in data set -->
      <fo:block font-weight="bold">
        <xsl:value-of select="$i18n-Dataset_contains" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="count(/codeBook/fileDscr)" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="$i18n-files" />
      </fo:block>

      <!-- fileDscr -->
      <xsl:apply-templates select="/codeBook/fileDscr" />

    </fo:flow>
  </fo:page-sequence>
</xsl:if>
