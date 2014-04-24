<?xml version='1.0' encoding='UTF-8'?>
<!-- variable_groups.xsl -->
<!-- ================================================ -->
<!-- <xsl:if> variable groups                         -->
<!-- value: <fo:page-sequence>                        -->
<!-- ================================================ -->

<!-- read: -->
<!-- $font-family, $number-of-groups -->

<!-- functions: -->
<!-- string-length(), count() [xpath 1.0] -->

<xsl:if test="$show-variable-groups = 'True'"
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
      <xsl:with-param name="section_name" select="i18n:get('Variables_Groups')" />
    </xsl:call-template>
  
    <xsl:call-template name="page_footer" />

    <!-- =========================================== -->
    <!-- page content                                 -->
    <!-- =========================================== -->    
    <fo:flow flow-name="body">

      <!-- heading -->
      <fo:block id="variables-groups" font-size="18pt" font-weight="bold" space-after="2.5mm">
        <xsl:value-of select="i18n:get('Variables_Groups')" />
      </fo:block>

      <!-- number of variable groups in data set -->      
      <fo:block font-weight="bold">
        <xsl:value-of select="string-join((i18n:get('Dataset_contains'), ' ', xs:string(count(/codeBook/dataDscr/varGrp)), ' ', i18n:get('groups')), '') "/>       
      </fo:block>
      
      <!-- the actual variable groups table -->
      <xsl:apply-templates select="/codeBook/dataDscr/varGrp" />

    </fo:flow>
  </fo:page-sequence>
</xsl:if>
