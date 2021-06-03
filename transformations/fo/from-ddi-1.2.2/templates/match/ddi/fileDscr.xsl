<?xml version='1.0' encoding='utf-8'?>
<!-- fileDscr.xsl -->
<!-- =========================== -->
<!-- match: fileDsrc             -->
<!-- value: <fo:table>           -->
<!-- =========================== -->

<!-- read: -->
<!-- $layout.color.gray1, $layout.tables.border, $layout.tables.cellpadding -->

<!-- set: -->
<!-- $fileId, $list -->

<!-- functions: -->
<!-- concat(), contains(), normalize-space(), position() [Xpath 1.0] -->
<!-- proportional-column-width() [FO] -->

<xsl:template match="fileDscr"
  xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"> 
  
  <!-- ===================== -->
  <!-- variables             -->
  <!-- ===================== -->
  <xsl:variable name="fileId"
    select="if (fileTxt/fileName/@ID) then fileTxt/fileName/@ID
            else if (@ID) then @ID
            else () "/>
  
  <!-- =================== -->
  <!-- content             -->
  <!-- =================== -->
  <fo:table id="file-{$fileId}" table-layout="fixed"
    width="100%" space-before="5mm" space-after="5mm">
    <fo:table-column column-width="proportional-column-width(20)" />
    <fo:table-column column-width="proportional-column-width(80)" />
    
    <fo:table-body>
      
      <!-- Filename -->
      <fo:table-row background-color="{$layout.color.gray1}" keep-with-next="always">
        <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
          <fo:block font-size="12pt" font-weight="bold">
            <xsl:apply-templates select="/codeBook/fileDscr/fileTxt/fileName" />
          </fo:block>
        </fo:table-cell>
      </fo:table-row>
      
      <!-- Cases -->
      <xsl:if test="/codeBook/fileDscr/fileTxt/dimensns/caseQnty">
        <fo:table-row>
          <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
            <fo:block>
              <xsl:value-of select="i18n:get('Cases')" />
            </fo:block>
          </fo:table-cell>
          <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">           
            <fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0mm">
              <xsl:value-of select="util:trim(/codeBook/fileDscr/fileTxt/dimensns/caseQnty)" />
            </fo:block>            
          </fo:table-cell>
        </fo:table-row>
      </xsl:if>
      
      <!-- Variables -->
      <xsl:if test="/codeBook/fileDscr/fileTxt/dimensns/varQnty">
        <fo:table-row>
          <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
            <fo:block>
              <xsl:value-of select="i18n:get('Variables')" />
            </fo:block>
          </fo:table-cell>
          <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
            <fo:block linefeed-treatment="preserve" white-space-collapse="false" space-after="0.0mm">
              <xsl:value-of select="util:trim(/codeBook/fileDscr/fileTxt/dimensns/varQnty)" />
            </fo:block>            
          </fo:table-cell>
        </fo:table-row>
      </xsl:if>
      
      <!-- File structure -->
      <xsl:if test="/codeBook/fileDscr/fileTxt/fileStrc">
        <fo:table-row>
          
          <!-- File_Structure -->
          <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
            <fo:block>
              <xsl:value-of select="i18n:get('File_Structure')" />
            </fo:block>
          </fo:table-cell>
          
          <!-- Type -->
          <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
            <xsl:if test="/codeBook/fileDscr/fileTxt/fileStrc/@type">
              <fo:block>
                <xsl:value-of select="i18n:get('Type')" />
                <xsl:text>:</xsl:text>
                <xsl:value-of select="/codeBook/fileDscr/fileTxt/fileStrc/@type" />
              </fo:block>
            </xsl:if>
            
            <xsl:if test="/codeBook/fileDscr/fileTxt/fileStrc/recGrp/@keyvar">
              <fo:block>
                <xsl:value-of select="i18n:get('Keys')" />
                <xsl:text>:&#160;</xsl:text>
                <xsl:variable name="list" select="concat(/codeBook/fileDscr/fileTxt/fileStrc/recGrp/@keyvar,' ')" />
                
                <!-- add a space at the end of the list for matching puspose -->
                <xsl:for-each select="/codeBook/dataDscr/var[contains($list, concat(@ID,' '))]">
                  <!-- add a space to the variable ID to avoid partial match -->
                  <xsl:if test="position() &gt; 1">
                    <xsl:text>,&#160;</xsl:text>
                  </xsl:if>
                  <xsl:value-of select="./@name"/>
                  <xsl:if test="normalize-space(./labl)">
                    <xsl:text>&#160;(</xsl:text>
                    <xsl:value-of select="normalize-space(./labl)" />
                    <xsl:text>)</xsl:text>
                  </xsl:if>
                </xsl:for-each>
              </fo:block>
            </xsl:if>
            
          </fo:table-cell>
        </fo:table-row>
      </xsl:if>
      
      <!-- File Content -->
      <xsl:for-each select="/codeBook/fileDscr/fileTxt/fileCont">
        <fo:table-row>
          <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
            <fo:block font-weight="bold" text-decoration="underline">
              <xsl:value-of select="i18n:get('File_Content')" />
            </fo:block>
            <xsl:apply-templates select="." />
          </fo:table-cell>
        </fo:table-row>
      </xsl:for-each>
      
      <!-- Producer -->
      <xsl:for-each select="/codeBook/fileDscr/fileTxt/filePlac">
        <fo:table-row>
          <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
            <fo:block font-weight="bold" text-decoration="underline">
              <xsl:value-of select="i18n:get('Producer')" />
            </fo:block>
            <xsl:apply-templates select="." />
          </fo:table-cell>
        </fo:table-row>
      </xsl:for-each>
      
      <!-- Version -->
      <xsl:for-each select="/codeBook/fileDscr/fileTxt/verStmt">
        <fo:table-row>
          <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
            <fo:block font-weight="bold" text-decoration="underline">
              <xsl:value-of select="i18n:get('Version')" />
            </fo:block>
            <xsl:apply-templates select="." />
          </fo:table-cell>
        </fo:table-row>
      </xsl:for-each>
      
      <!-- Processing Checks -->
      <xsl:for-each select="/codeBook/fileDscr/fileTxt/dataChck">
        <fo:table-row>
          <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
            <fo:block font-weight="bold" text-decoration="underline">
              <xsl:value-of select="i18n:get('Processing_Checks')" />
            </fo:block>
            <xsl:apply-templates select="." />
          </fo:table-cell>
        </fo:table-row>
      </xsl:for-each>
      
      <!-- Missing Data -->
      <xsl:for-each select="/codeBook/fileDscr/fileTxt/dataMsng">
        <fo:table-row>
          <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
            <fo:block font-weight="bold" text-decoration="underline">
              <xsl:value-of select="i18n:get('Missing_Data')" />
            </fo:block>
            <xsl:apply-templates select="." />
          </fo:table-cell>
        </fo:table-row>
      </xsl:for-each>
      
      <!-- Notes -->
      <xsl:for-each select="notes">
        <fo:table-row>
          <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
            <fo:block font-weight="bold" text-decoration="underline">
              <xsl:value-of select="i18n:get('Notes')" />
            </fo:block>
            <xsl:apply-templates select="." />
          </fo:table-cell>
        </fo:table-row>
      </xsl:for-each>
      
    </fo:table-body>
  </fo:table>
  
</xsl:template>
