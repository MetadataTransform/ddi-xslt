<?xml version='1.0' encoding='utf-8'?>
<!-- ddi-var_variables_list.xsl -->
<!-- ================================== -->
<!-- match: ddi:var (variables-list)    -->
<!-- value: <xsl:if> <fo:table-row>     -->
<!-- ================================== -->

<!-- read: -->
<!-- $color-white, $default-border, $cell-padding, -->
<!-- $show-variables-list, $variable-name-length -->

<!-- functions: -->
<!-- concat(), contains(), count(), position(), normalize-space(), -->
<!-- string-length(), substring() [xpath 1.0] -->

<xsl:template match="ddi:var" mode="variables-list"
              xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:fo="http://www.w3.org/1999/XSL/Format">

    <!-- content -->
      <fo:table-row text-align="center" vertical-align="top">

        <!-- Variable Position -->
        <fo:table-cell text-align="center" border="{$default-border}" padding="{$cell-padding}">
          <fo:block>
            <xsl:value-of select="position()" />
          </fo:block>
        </fo:table-cell>

        <!-- Variable Name-->
        <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
          <fo:block>
            <xsl:choose>
              <xsl:when test="$show-variables-list = 'True'">
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

        <!-- Variable Label -->
        <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
          <fo:block>
            <xsl:choose>
              <xsl:when test="normalize-space(./labl)">
                <xsl:value-of select="normalize-space(./labl)" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>-</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </fo:block>
        </fo:table-cell>

        <!-- Variable literal question -->
        <fo:table-cell text-align="left" border="{$default-border}" padding="{$cell-padding}">
            <fo:block>
              <xsl:choose>
                <xsl:when test="normalize-space(./qstn/qstnLit)">
                  <xsl:value-of select="normalize-space(./qstn/qstnLit)" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>-</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </fo:block>
          </fo:table-cell>
        

      </fo:table-row>
    

</xsl:template>
