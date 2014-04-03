<?xml version='1.0' encoding='utf-8'?>
<!-- fileDscr_variables-list.xsl -->
<!-- ===================================== -->
<!-- match: fileDsrc (variables-list)      -->
<!-- Value: <fo:table>                     -->
<!-- ===================================== -->

<!-- read: -->
<!-- $strings, $default-border, $cell-padding -->

<!-- set: -->
<!-- $fileId -->

<xsl:template match="fileDscr" mode="variables-list"
              xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <!-- variables -->
  <xsl:variable name="fileId">
    <xsl:choose>

      <xsl:when test="fileTxt/fileName/@ID">
        <xsl:value-of select="fileTxt/fileName/@ID" />
      </xsl:when>

      <xsl:when test="@ID">
        <xsl:value-of select="@ID"/>
      </xsl:when>

    </xsl:choose>
  </xsl:variable>

  <!-- content -->
  <fo:table id="varlist-{fileTxt/fileName/@ID}" table-layout="fixed"
            width="100%" font-size="8pt"
            space-before="0.2in" space-after="0.2in">

    <fo:table-column column-width="proportional-column-width( 5)"/>
    <fo:table-column column-width="proportional-column-width(12)"/>
    <fo:table-column column-width="proportional-column-width(20)"/>
    <fo:table-column column-width="proportional-column-width(27)"/>
 
    <!-- [fo:table-header] -->
    <fo:table-header>
      <fo:table-row text-align="center" vertical-align="top" keep-with-next="always">
        <fo:table-cell text-align="left" number-columns-spanned="4"
                       border="{$default-border}" padding="{$cell-padding}">
          <fo:block font-size="12pt" font-weight="bold">
            <xsl:value-of select="$strings/*/entry[@key='File']"/>
            <xsl:text> </xsl:text>
            <xsl:apply-templates select="fileTxt/fileName"/>
          </fo:block>
        </fo:table-cell>
      </fo:table-row>

      <fo:table-row text-align="center" vertical-align="top"
                    font-weight="bold" keep-with-next="always">

        <!-- #-character -->
        <fo:table-cell border="0.5pt solid black" padding="3pt">
          <fo:block>#</fo:block>
        </fo:table-cell>

        <!-- Name -->
        <fo:table-cell border="0.5pt solid black" padding="3pt">
          <fo:block>
            <xsl:value-of select="$strings/*/entry[@key='Name']" />
          </fo:block>
        </fo:table-cell>

        <!-- Label -->
        <fo:table-cell border="0.5pt solid black" padding="3pt">
          <fo:block>
            <xsl:value-of select="$strings/*/entry[@key='Label']" />
          </fo:block>
        </fo:table-cell>

        <!-- Question -->
        <fo:table-cell border="0.5pt solid black" padding="3pt">
          <fo:block>
            <xsl:value-of select="$strings/*/entry[@key='Question']" />
          </fo:block>
        </fo:table-cell>
      
      </fo:table-row>
    </fo:table-header>

    <!-- [fo:table-body] -->
    <fo:table-body>
      <xsl:apply-templates select="/codeBook/dataDscr/var[@files=$fileId]"
                           mode="variables-list"/>
    </fo:table-body>

  </fo:table>

</xsl:template>

