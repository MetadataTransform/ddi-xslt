<?xml version='1.0' encoding='utf-8'?>
<!-- ddi_match.xsl -->

<!-- =============================== -->
<!-- match: ddi:var / variables-list -->
<!-- fo:table-row                    -->
<!-- =============================== -->

<!--
  parameters:
  ($fileId)

  global vars read:
  subserVars, color-white, default-border, cell-padding,
  show-variables-list, variable-name-length

  XPath 1.0 functions called:
  concat(), contains(), count(), position(), normalize-space(),
  string-length(), substring()
-->

<!--
    1: Variable Position          table-cell
    2: Variable Name              table-cell
    3: Variable Label             table-cell
    4: Variable Type              table-cell
    5: Variable Format            table-cell
    6: Variable Valid             table-cell
    7: Variable Invalid           table-cell
    8: Variable Literal Question  table-cell
-->

<xsl:template match="ddi:var" mode="variables-list"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:fo="http://www.w3.org/1999/XSL/Format">
    <!-- params -->
    <xsl:param name="fileId" select="./@files" /> <!-- (use first file in @files if not specified) -->

    <!-- content -->
    <xsl:if test="contains($subset-vars, concat(',' ,@ID, ',')) or string-length($subset-vars) = 0 ">
      <fo:table-row text-align="center" vertical-align="top">

        <!-- Set background colour for this row -->
        <!-- (choosing between two of the same?)-->
        <xsl:choose>
          <xsl:when test="position() mod 2 = 0">
            <xsl:attribute name="background-color">
              <xsl:value-of select="$color-white" />
            </xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="background-color">
              <xsl:value-of select="$color-white" />
            </xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>

        <!-- 1) [fo:table-cell] Variable Position -->
        <fo:table-cell text-align="center" border="{$default-border}" padding="{$cell-padding}">
          <fo:block>
            <xsl:value-of select="position()" />
          </fo:block>
        </fo:table-cell>

        <!-- 2) [fo:table-cell] Variable Name-->
        <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
          <fo:block>
            <xsl:choose>
              <xsl:when test="$show-variables-list = 1">
                <fo:basic-link internal-destination="var-{@ID}" text-decoration="underline" color="blue">
                  <xsl:if test="string-length(@name) &gt; 10">
                    <xsl:value-of select="substring(./@name, 0, $variable-name-length)" /> ..
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

        <!-- 3) Variable Label -->
        <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
          <fo:block>
            <xsl:choose>
              <xsl:when test="normalize-space(./ddi:labl)">
                <xsl:value-of select="normalize-space(./ddi:labl)" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>-</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </fo:block>
        </fo:table-cell>



        <!-- 8) [fo:table-cell] Variable literal question -->
        <xsl:if test="$show-variables-list-question">
          <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
            <fo:block>
              <xsl:choose>
                <xsl:when test="normalize-space(./ddi:qstn/ddi:qstnLit)">
                  <xsl:value-of select="normalize-space(./ddi:qstn/ddi:qstnLit)" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>-</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </fo:block>
          </fo:table-cell>
        </xsl:if>

      </fo:table-row>
    </xsl:if>

</xsl:template>
