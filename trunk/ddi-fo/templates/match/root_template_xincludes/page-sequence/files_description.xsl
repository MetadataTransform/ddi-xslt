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

<xsl:if test="$page.files_description.show = 'True'"
        xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <fo:page-sequence master-reference="{$layout.page_master}"
                    font-family="{$layout.font_family}"
                    font-size="{$layout.font_size}">

    <!-- =========================================== -->
    <!-- page header and footer                      -->
    <!-- =========================================== -->
    <xsl:call-template name="page_header">
      <xsl:with-param name="section_name" select="i18n:get('Files_Description')" />
    </xsl:call-template>

    <xsl:call-template name="page_footer" />

    <!-- =========================================== -->
    <!-- page content                                -->
    <!-- =========================================== -->
    <fo:flow flow-name="body">

      <!-- heading -->
      <fo:block id="files-description" font-size="18pt" font-weight="bold" space-after="2.5mm">
        <xsl:value-of select="i18n:get('Files_Description')"/>
      </fo:block>

      <!-- number of files in data set -->
      <fo:block font-weight="bold">        
        <xsl:value-of select="concat(i18n:get('Dataset_contains'), ' ', xs:string(count(/codeBook/fileDscr)), ' ', i18n:get('files')) "/>        
      </fo:block>

      <!-- fileDscr -->
      <xsl:apply-templates select="/codeBook/fileDscr" />

    </fo:flow>
  </fo:page-sequence>
</xsl:if>
