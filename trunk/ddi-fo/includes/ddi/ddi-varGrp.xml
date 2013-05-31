<?xml version='1.0' encoding='utf-8'?>
<!-- Match: ddi:varGrp -->
<!-- Value: <fo:table> -->

<!--
    Variables read:
    msg, subset-groups, default-border, cell-padding

    Variables set:
    list

    Functions and templates called:
    contains(), concat(), position(), string-length(),
    normalize-space() [Xpath 1.0]
    proportional-column-width() [FO]
    variables-table-column-width, variables-table-column-header
-->

<!--
    1: Group Name     [table-row]
    2: Text           [table-row]
    3: Definition     [table-row]
    4: Universe       [table-row]
    5: Notes          [table-row]
    6: Subgroups      [table-row]
-->

<xsl:template match="ddi:varGrp"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:fo="http://www.w3.org/1999/XSL/Format">

    <xsl:if test="contains($subset-groups,concat(',',@ID,',')) or string-length($subset-groups)=0">

      <fo:table id="vargrp-{@ID}" table-layout="fixed" width="100%" space-before="0.2in">
        <fo:table-column column-width="proportional-column-width(20)"/>
        <fo:table-column column-width="proportional-column-width(80)"/>

        <fo:table-body>

          <!-- 1) Group -->
          <fo:table-row>
            <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
              <fo:block font-size="12pt" font-weight="bold">
                <xsl:value-of select="$msg/*/entry[@key='Group']"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="normalize-space(ddi:labl)"/>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>

          <!-- 2) Text -->
          <xsl:for-each select="ddi:txt">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <xsl:apply-templates select="."/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:for-each>

          <!-- 3) Definition -->
          <xsl:for-each select="ddi:defntn">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$msg/*/entry[@key='Definition']"/>
                </fo:block>
                <xsl:apply-templates select="."/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:for-each>

          <!-- 4) Universe-->
          <xsl:for-each select="ddi:universe">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$msg/*/entry[@key='Universe']"/>
                </fo:block>
                <xsl:apply-templates select="."/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:for-each>

          <!-- 5) Notes -->
          <xsl:for-each select="ddi:notes">
            <fo:table-row>
              <fo:table-cell number-columns-spanned="2" border="{$default-border}" padding="{$cell-padding}">
                <fo:block font-weight="bold" text-decoration="underline">
                  <xsl:value-of select="$msg/*/entry[@key='Notes']"/>
                </fo:block>
                <xsl:apply-templates select="."/>
              </fo:table-cell>
            </fo:table-row>
          </xsl:for-each>

          <!-- 6) Subgroups -->
          <xsl:if test="./@varGrp">
            <fo:table-row>
              <fo:table-cell font-weight="bold" border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <xsl:value-of select="$msg/*/entry[@key='Subgroups']"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="{$default-border}" padding="{$cell-padding}">
                <fo:block>
                  <!-- loop over groups in codeBook that are in this sequence -->
                  <xsl:variable name="list" select="concat(./@varGrp,' ')"/>
                  <!-- add a space at the end of the list for matching purposes -->
                  <xsl:for-each select="/ddi:codeBook/ddi:dataDscr/ddi:varGrp[contains($list,concat(@ID,' '))]">
                    <!-- add a space to the ID to avoid partial match -->
                    <xsl:if test="position()&gt;1">,</xsl:if>
                    <xsl:value-of select="./ddi:labl"/>
                  </xsl:for-each>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>
        </fo:table-body>
      </fo:table>


      <!-- ======================= -->
      <!-- [table] Variables table -->
      <!-- ======================= -->
      <xsl:if test="./@var"> <!-- Look for variables in this group -->
        <fo:table id="varlist-{@ID}" table-layout="fixed"
                  width="100%" font-size="8pt" space-after="0.0in">

            <fo:table-column column-width="proportional-column-width( 5)"/>
            <fo:table-column column-width="proportional-column-width(12)"/>
            <fo:table-column column-width="proportional-column-width(20)"/>
            <fo:table-column column-width="proportional-column-width(10)"/>
            <fo:table-column column-width="proportional-column-width(10)"/>
            <fo:table-column column-width="proportional-column-width( 8)"/>
            <fo:table-column column-width="proportional-column-width( 8)"/>

            <xsl:if test="$show-variables-list-question">
                <fo:table-column column-width="proportional-column-width(27)"/>
            </xsl:if>

          <!-- table header -->
          <fo:table-header>
    <fo:table-row text-align="center" vertical-align="top"
                  font-weight="bold" keep-with-next="always">

      <!-- #-character -->
      <fo:table-cell border="0.5pt solid black" padding="3pt">
        <fo:block>#</fo:block>
      </fo:table-cell>

      <!-- Name -->
      <fo:table-cell border="0.5pt solid black" padding="3pt">
        <fo:block>
          <xsl:value-of select="$msg/*/entry[@key='Name']" />
        </fo:block>
      </fo:table-cell>

      <!-- Label -->
      <fo:table-cell border="0.5pt solid black" padding="3pt">
        <fo:block>
          <xsl:value-of select="$msg/*/entry[@key='Label']" />
        </fo:block>
      </fo:table-cell>

      <!-- Type -->
      <fo:table-cell border="0.5pt solid black" padding="3pt">
        <fo:block>
          <xsl:value-of select="$msg/*/entry[@key='Type']" />
        </fo:block>
      </fo:table-cell>

      <!-- Format -->
      <fo:table-cell border="0.5pt solid black" padding="3pt">
        <fo:block>
          <xsl:value-of select="$msg/*/entry[@key='Format']" />
        </fo:block>
      </fo:table-cell>

      <!-- Valid -->
      <fo:table-cell border="0.5pt solid black" padding="3pt">
        <fo:block>
          <xsl:value-of select="$msg/*/entry[@key='Valid']" />
        </fo:block>
      </fo:table-cell>

      <!-- Invalid -->
      <fo:table-cell border="0.5pt solid black" padding="3pt">
        <fo:block>
          <xsl:value-of select="$msg/*/entry[@key='Invalid']" />
        </fo:block>
      </fo:table-cell>

      <!-- Question -->
      <xsl:if test="$show-variables-list-question">
        <fo:table-cell border="0.5pt solid black" padding="3pt">
          <fo:block>
            <xsl:value-of select="$msg/*/entry[@key='Question']" />
          </fo:block>
        </fo:table-cell>
      </xsl:if>

    </fo:table-row>

          </fo:table-header>

          <!-- table body -->
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell>
                <fo:block>
                  <!-- ToDo: -->
                </fo:block>
              </fo:table-cell>
            </fo:table-row>

            <xsl:variable name="list" select="concat(./@var,' ')" />
            <!-- add a space at the end of the list for matching purposes -->
            <xsl:apply-templates select="/ddi:codeBook/ddi:dataDscr/ddi:var[ contains($list,concat(@ID,' ')) ]" mode="variables-list"/>
            <!-- add a space to the ID to avoid partial match -->
          </fo:table-body>
        </fo:table>
      </xsl:if>
    </xsl:if>
    
</xsl:template>
