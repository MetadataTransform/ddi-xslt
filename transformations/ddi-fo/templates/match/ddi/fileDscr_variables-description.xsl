<?xml version='1.0' encoding='utf-8'?>
<!-- fileDscr-variables_description.xsl -->
<!-- =========================================== -->
<!-- match: fileDsrc (variables-description)     -->
<!-- value: <xsl:for-each> <fo:page-sequence>    -->
<!-- =========================================== -->

<!-- read: -->
<!-- $layout.chunk_size, $layout.font_family, $layout.tables.border -->

<!-- set: -->
<!-- $fileId, $fileName -->

<!-- functions: -->
<!-- position() [xpath 1.0] -->
<!-- proportional-column-width() [fo] -->

<xsl:template match="fileDscr" mode="variables-description"
  xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format">
  
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
      <xsl:call-template name="page_footer" />
      
      <!-- =========== -->
      <!-- page body   -->
      <!-- =========== -->
      <fo:flow flow-name="body">
        
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
  
</xsl:template>
