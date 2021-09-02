<?xml version='1.0' encoding='UTF-8'?>
<!-- variables_list.xsl -->
<!-- ===================================== -->
<!-- <xsl:if> variables list               -->
<!-- value: <fo:page-sequence>             -->
<!-- ===================================== -->

<!-- read: -->
<!-- $layout.page_master -->
<!-- $layout.font_family, $layout.font_size, -->
<!-- $layout.tables.cellpadding, $layout.tables.border -->
<!-- $limits.variable_name_length -->

<!-- $fileId -->

<!-- functions: -->
<!-- count() [Xpath 1.0] -->

<xsl:if test="$page.variables_list.show = 'True'"
        xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <fo:page-sequence master-reference="{$layout.page_master}"
                    font-family="{$layout.font_family}"
                    font-size="{$layout.font_size}">

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
<!--  <xsl:apply-templates select="/codeBook/fileDscr" mode="variables-list" />-->
      
      <xsl:for-each select="/codeBook/fileDscr">
        <!-- variables -->
        <xsl:variable name="fileId"
          select="if (fileTxt/fileName/@ID) then fileTxt/fileName/@ID
          else if (@ID) then @ID
          else () "/>
        
        <!-- content -->
        <fo:table id="varlist-{fileTxt/fileName/@ID}" table-layout="fixed"
          width="100%" font-size="8pt"
          space-before="5mm" space-after="5mm">
          
          <fo:table-column column-width="proportional-column-width( 5)" />
          <fo:table-column column-width="proportional-column-width(12)" />
          <fo:table-column column-width="proportional-column-width(20)" />
          <fo:table-column column-width="proportional-column-width(27)" />
          
          <!-- ============ -->
          <!-- table header -->
          <!-- ============ -->
          <fo:table-header>
            <fo:table-row text-align="center" vertical-align="top" keep-with-next="always">
              <fo:table-cell text-align="left" number-columns-spanned="4"
                border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                <fo:block font-size="12pt" font-weight="bold">
                  <xsl:value-of select="i18n:get('File')"/>
                  <xsl:text> </xsl:text>
                  <xsl:apply-templates select="fileTxt/fileName" />
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
            
            <fo:table-row text-align="center" vertical-align="top"
              font-weight="bold" keep-with-next="always">
              
              <!-- Col 1: blank character -->
              <fo:table-cell border="{$layout.tables.border}" padding="3pt">
                <fo:block />
              </fo:table-cell>
              
              <!-- Col 2: Name -->
              <fo:table-cell border="{$layout.tables.border}" padding="3pt">
                <fo:block>
                  <xsl:value-of select="i18n:get('Name')" />
                </fo:block>
              </fo:table-cell>
              
              <!-- Col 3: Label -->
              <fo:table-cell border="{$layout.tables.border}" padding="3pt">
                <fo:block>
                  <xsl:value-of select="i18n:get('Label')" />
                </fo:block>
              </fo:table-cell>
              
              <!-- Col 4: Question -->
              <fo:table-cell border="{$layout.tables.border}" padding="3pt">
                <fo:block>
                  <xsl:value-of select="i18n:get('Question')" />
                </fo:block>
              </fo:table-cell>
              
            </fo:table-row>
          </fo:table-header>
          
          <!-- =============================== -->
          <!-- table rows (the actual content) -->
          <!-- =============================== -->
          <fo:table-body>
<!--        <xsl:apply-templates select="/codeBook/dataDscr/var[@files = $fileId]" mode="variables-list"/>-->
            
            <xsl:for-each select="/codeBook/dataDscr/var[@files = $fileId]">
              
              <fo:table-row text-align="center" vertical-align="top">
                
                <!-- Col 1: Variable Position -->
                <fo:table-cell text-align="center" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:value-of select="position()" />
                  </fo:block>
                </fo:table-cell>
                
                <!-- Col 2: Variable Name-->
                <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:choose>
                      <xsl:when test="$page.variables_list.show = 'True'">
                        <fo:basic-link internal-destination="var-{@ID}" text-decoration="underline" color="blue">
                          <xsl:if test="string-length(@name) &gt; 10">
                            <xsl:value-of select="substring(./@name, 0, $limits.variable_name_length)" /> ..
                          </xsl:if>
                          <xsl:if test="11 &gt; string-length(@name)">
                            <xsl:value-of select="./@name" />
                          </xsl:if>
                        </fo:basic-link>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="./@name" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </fo:block>
                </fo:table-cell>
                
                <!-- Col 3: Variable Label -->
                <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:value-of select="if (./labl) then normalize-space(./labl) else '-' "/>          
                  </fo:block>
                </fo:table-cell>
                
                <!-- Col 4: Variable literal question -->
                <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
                  <fo:block>
                    <xsl:value-of select="if (./qstn/qstnLit) then normalize-space(./qstn/qstnLit) else '-' "/>
                  </fo:block>
                </fo:table-cell>
                
              </fo:table-row>                
            </xsl:for-each>
            
          </fo:table-body>
        </fo:table>                
      </xsl:for-each>
            
    </fo:flow>
  </fo:page-sequence>
</xsl:if>
