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

<xsl:if test="$page.variables_description.show = 'True'"
        xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fo="http://www.w3.org/1999/XSL/Format">

<!--  <fo:page-sequence master-reference="{$layout.page_master}"
                    font-family="{$layout.font_family}"
                    font-size="{$layout.font_size}">

    <!-\- =========================================== -\->
    <!-\- page header                                 -\->
    <!-\- =========================================== -\->
    <xsl:call-template name="page_header">
      <xsl:with-param name="section_name" select="i18n:get('Variables_Description')" />
    </xsl:call-template>

    <xsl:call-template name="page_footer" />

    <!-\- =========================================== -\->
    <!-\- page content                                -\->
    <!-\- =========================================== -\->
    <fo:flow flow-name="body">

      <!-\- heading -\->
      <fo:block id="variables-description" font-size="18pt" font-weight="bold" space-after="2.5mm">
        <xsl:value-of select="i18n:get('Variables_Description')" />
      </fo:block>

      <!-\- number of variables in data set -\->
      <fo:block font-weight="bold">
        <xsl:value-of select="concat(i18n:get('Dataset_contains'), ' ', xs:string(count(/codeBook/dataDscr/var)), ' ', i18n:get('variables')) "/>       
      </fo:block>

    </fo:flow>
  </fo:page-sequence>-->

  <!-- fileDscr -->
<!--  <xsl:apply-templates select="/codeBook/fileDscr" mode="variables-description" />-->
  
  <xsl:for-each select="/codeBook/fileDscr">
    <!-- ================== -->
    <!-- variables          -->
    <!-- ================== -->
    
    <!-- fileName ID attribute / ID attribute -->  
    <xsl:variable name="fileId"
      select="if (fileTxt/fileName/@ID) then fileTxt/fileName/@ID
      else if (@ID) then @ID
      else () "/>
    
    <xsl:variable name="fileName" select="fileTxt/fileName"/>
    
    <!-- ===================== -->
    <!-- content               -->
    <!-- ===================== -->
    
    <xsl:for-each select="/codeBook/dataDscr/var[@files = $fileId][position() mod $layout.chunk_size = 1]">
      
      <fo:page-sequence master-reference="{$layout.page_master}"
        font-family="{$layout.font_family}"
        font-size="{$layout.font_size}">
        
        <!-- =========== -->
        <!-- page footer -->
        <!-- =========== -->
        
        <xsl:call-template name="page_header">
          <xsl:with-param name="section_name" select="i18n:get('Variables_Description')" />
        </xsl:call-template>
                
        <xsl:call-template name="page_footer" />
        
        <!-- =========== -->
        <!-- page body   -->
        <!-- =========== -->
        <fo:flow flow-name="body">
                    
          <fo:block font-size="18pt" font-weight="bold" space-after="2.5mm">
            <xsl:value-of select="i18n:get('Variables_Description')" />
          </fo:block>
          
          <!-- number of variables in data set -->
          <fo:block font-weight="bold" space-after="5mm">
            <xsl:value-of select="concat(i18n:get('Dataset_contains'), ' ', xs:string(count(/codeBook/dataDscr/var)), ' ', i18n:get('variables')) "/>       
          </fo:block>
          
          <!-- [fo:table] Header -->
          <!-- (only written if at the start of file) -->
          <xsl:if test="position() = 1">
            <fo:table id="vardesc-{$fileId}" table-layout="fixed" width="100%" font-size="8pt">
              <fo:table-column column-width="proportional-column-width(100)" /> <!-- column width -->
              
              <!-- [fo:table-header] -->
              <fo:table-header space-after="5mm">
                
                <!-- [fo:table-row] File identification -->
                <fo:table-row text-align="center" vertical-align="top">
                  <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                    <fo:block font-size="14pt" font-weight="bold">
                      <xsl:value-of select="i18n:get('File')" />
                      <xsl:text> : </xsl:text>
                      <xsl:apply-templates select="$fileName" />
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
                
              </fo:table-header>
              
              <!-- [fo:table-body] Variables -->
              <fo:table-body>
                <!-- needed in case of subset -->
                <fo:table-row>
                  <fo:table-cell>
                    <fo:block />
                  </fo:table-cell>
                </fo:table-row>
                <xsl:apply-templates select=".|following-sibling::var[@files=$fileId][$layout.chunk_size &gt; position()]"/>
              </fo:table-body>
              
            </fo:table>
          </xsl:if>
          
          <!-- [fo:table] Variables -->
          <xsl:if test="position() &gt; 1">
            <fo:table table-layout="fixed" width="100%" font-size="8pt">
              <fo:table-body>
                <!-- needed in case of subset -->
                <fo:table-row>
                  <fo:table-cell>
                    <fo:block/>
                  </fo:table-cell>
                </fo:table-row>
                <xsl:apply-templates select=".|following-sibling::var[@files=$fileId][$layout.chunk_size &gt; position()]"/>
              </fo:table-body>
            </fo:table>
          </xsl:if>
          
        </fo:flow>
      </fo:page-sequence>
    </xsl:for-each>
    
    
  </xsl:for-each>
  
  
</xsl:if>
