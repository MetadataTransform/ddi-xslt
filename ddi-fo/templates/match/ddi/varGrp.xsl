<?xml version='1.0' encoding='utf-8'?>
<!-- varGrp.xsl -->
<!-- ================================================== -->
<!-- match: varGrp                                      -->
<!-- value: <fo:table> + [<xsl:if> <fo:table>] -->
<!-- ================================================== -->

<!-- read -->
<!-- $layout.tables.border, $layout.tables.cellpadding -->

<!-- set -->
<!-- $list -->

<!-- functions -->
<!-- contains(), concat(), position(), string-length(), -->
<!-- normalize-space() [Xpath 1.0]                      -->
<!-- proportional-column-width() [fo]                   -->

<xsl:template match="varGrp"
  xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format">
  
  <fo:table id="vargrp-{@ID}" table-layout="fixed" width="100%" space-before="5mm">
    <fo:table-column column-width="proportional-column-width(20)"/>
    <fo:table-column column-width="proportional-column-width(80)"/>
    
    <fo:table-body>
      
      <!-- Group -->
      <fo:table-row>
        <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
          <fo:block font-size="12pt" font-weight="bold">
            <xsl:value-of select="normalize-space(labl)" />
          </fo:block>
        </fo:table-cell>
      </fo:table-row>
      
      <!-- Text -->
      <xsl:for-each select="txt">
        <fo:table-row>
          <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
            <xsl:apply-templates select="." />
          </fo:table-cell>
        </fo:table-row>
      </xsl:for-each>
      
      <!-- Definition -->
      <xsl:for-each select="defntn">
        <fo:table-row>
          <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
            <fo:block font-weight="bold" text-decoration="underline">
              <xsl:value-of select="i18n:get('Definition')" />
            </fo:block>
            <xsl:apply-templates select="." />
          </fo:table-cell>
        </fo:table-row>
      </xsl:for-each>
      
      <!-- Universe-->
      <xsl:for-each select="universe">
        <fo:table-row>
          <fo:table-cell number-columns-spanned="2" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
            <fo:block font-weight="bold" text-decoration="underline">
              <xsl:value-of select="i18n:get('Universe')" />
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
      
      <!-- Subgroups -->
      <xsl:if test="./@varGrp">
        <fo:table-row>
          <fo:table-cell font-weight="bold" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
            <fo:block>
              <xsl:value-of select="i18n:get('Subgroups')" />
            </fo:block>
          </fo:table-cell>
          <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
            <fo:block>
              <!-- loop over groups in codeBook that are in this sequence -->
              <xsl:variable name="list" select="concat(./@varGrp,' ')" />
              <!-- add a space at the end of the list for matching purposes -->
              <xsl:for-each select="/codeBook/dataDscr/varGrp[contains($list, concat(@ID,' '))]">
                <!-- add a space to the ID to avoid partial match -->
                <xsl:if test="position() &gt; 1">
                  <xsl:text>,</xsl:text>
                </xsl:if>
                <xsl:value-of select="./labl" />
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </xsl:if>
    </fo:table-body>
  </fo:table>
  
  <!-- ======================= -->
  <!-- Variables table         -->
  <!-- ======================= -->
  <xsl:if test="./@var"> <!-- Look for variables in this group -->
    <fo:table id="varlist-{@ID}" table-layout="fixed"
      width="100%" font-size="8pt" space-after="0.0mm">
      
      <fo:table-column column-width="proportional-column-width( 5)"/>
      <fo:table-column column-width="proportional-column-width(12)"/>
      <fo:table-column column-width="proportional-column-width(20)"/>
      <fo:table-column column-width="proportional-column-width(27)"/>
      
      <!-- ============ -->
      <!-- table header -->
      <!-- ============ -->
      <fo:table-header>
        <fo:table-row text-align="center" vertical-align="top"
          font-weight="bold" keep-with-next="always">
          
          <!-- #-character -->
          <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
            <fo:block>
              <xsl:text>#</xsl:text>
            </fo:block>
          </fo:table-cell>
          
          <!-- Name -->
          <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
            <fo:block>
              <xsl:value-of select="i18n:get('Name')" />
            </fo:block>
          </fo:table-cell>
          
          <!-- Label -->
          <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
            <fo:block>
              <xsl:value-of select="i18n:get('Label')" />
            </fo:block>
          </fo:table-cell>
          
          <!-- Question -->
          <fo:table-cell border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
            <fo:block>
              <xsl:value-of select="i18n:get('Question')" />
            </fo:block>
          </fo:table-cell>         
          
        </fo:table-row>
      </fo:table-header>
      
      <!-- ========== -->
      <!-- table body -->
      <!-- ========== -->
      <fo:table-body>
        <xsl:variable name="list" select="concat(./@var,' ')" />
        <xsl:apply-templates select="/codeBook/dataDscr/var[ contains($list, concat(@ID,' ')) ]"
                             mode="variables-list"/>
      </fo:table-body>
    </fo:table>
    
  </xsl:if>

</xsl:template>
