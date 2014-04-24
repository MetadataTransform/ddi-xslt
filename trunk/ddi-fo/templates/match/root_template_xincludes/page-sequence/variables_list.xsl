<?xml version='1.0' encoding='UTF-8'?>
<!-- variables_list.xsl -->
<!-- ===================================== -->
<!-- <xsl:if> variables list               -->
<!-- value: <fo:page-sequence>             -->
<!-- ===================================== -->

<!-- read: -->
<!-- $strings, $show-variables-list-layout, $font-family -->

<!-- functions: -->
<!-- count() [Xpath 1.0] -->

<xsl:if test="$show-variables-list = 'True'"
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
      <xsl:with-param name="section_name" select="i18n:get('Variables_List')" />
    </xsl:call-template>

    <xsl:call-template name="page_footer" />


    <!-- =========================================== -->
    <!-- page content                                -->
    <!-- =========================================== -->
    <fo:flow flow-name="body">

      <!-- Heading -->
      <fo:block id="variables-list" font-size="18pt" font-weight="bold" space-after="2.5mm">
        <xsl:value-of select="i18n:get('Variables_List')" />        
      </fo:block>

      <!-- number of groups in data set -->      
      <fo:block font-weight="bold">
        <xsl:value-of select="concat(i18n:get('Dataset_contains'), ' ', xs:string(count(/codeBook/dataDscr/var)), ' ', i18n:get('variables')) "/>       
      </fo:block>

      <!-- the actual tables -->
      <xsl:apply-templates select="/codeBook/fileDscr" mode="variables-list" />

    </fo:flow>
  </fo:page-sequence>
</xsl:if>
