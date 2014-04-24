<?xml version='1.0' encoding='UTF-8'?>
<!-- variables_description.xsl -->
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
      <xsl:with-param name="section_name" select="i18n:get('Variables_Description')" />
    </xsl:call-template>

    <xsl:call-template name="page_footer" />

    <!-- =========================================== -->
    <!-- page content                                -->
    <!-- =========================================== -->
    <fo:flow flow-name="body">

      <!-- heading -->
      <fo:block id="variables-description" font-size="18pt"
                font-weight="bold" space-after="2.5mm">
        <xsl:value-of select="i18n:get('Variables_Description')" />
      </fo:block>

      <!-- number of variables in data set -->
      <!-- <fo:block font-weight="bold">
        <xsl:value-of select="$i18n-Dataset_contains" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="count(/codeBook/dataDscr/var)" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="$i18n-variables" />
      </fo:block> -->

      <fo:block font-weight="bold">
        <xsl:value-of select="string-join((i18n:get('Dataset_contains'), ' ', xs:string(count(/codeBook/dataDscr/var)), ' ', i18n:get('variables')), '') "/>       
      </fo:block>

    </fo:flow>
  </fo:page-sequence>

  <!-- fileDscr -->
  <xsl:apply-templates select="/codeBook/fileDscr" mode="variables-description" />
</xsl:if>
