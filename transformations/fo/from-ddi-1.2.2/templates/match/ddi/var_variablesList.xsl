<?xml version='1.0' encoding='utf-8'?>
<!-- var-variables_list.xsl -->
<!-- ================================== -->
<!-- match: var (variables-list)        -->
<!-- value: <xsl:if> <fo:table-row>     -->
<!-- ================================== -->

<!-- read: -->
<!-- $layout.tables.border, $layout.tables.cellpadding, -->
<!-- $show-variables-list, $limits.variable_name_length -->

<!-- functions: -->
<!-- concat(), contains(), count(), position(), normalize-space(), -->
<!-- string-length(), substring() [xpath 1.0] -->

<xsl:template match="var" mode="variables-list"
              xpath-default-namespace="http://www.icpsr.umich.edu/DDI"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:fo="http://www.w3.org/1999/XSL/Format">

    <!-- content -->
    <fo:table-row text-align="center" vertical-align="top">

      <!-- Variable Position -->
      <fo:table-cell text-align="center" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
        <fo:block>
          <xsl:value-of select="position()" />
        </fo:block>
      </fo:table-cell>

      <!-- Variable Name-->
      <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
        <fo:block>
          <xsl:choose>
            <xsl:when test="$page.variables_list.show = 'True'">
              <fo:basic-link internal-destination="var-{@ID}" text-decoration="underline" color="blue">
                <xsl:if test="string-length(@name) &gt; 10">
                  <xsl:value-of select="substring(./@name, 0, $limits.variable_name_length)" />
                  <xsl:text> ..</xsl:text>
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
      <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
        <fo:block>
<!--          <xsl:value-of select="if (normalize-space(./labl)) then normalize-space(./labl) else '-' "/>-->
          <xsl:value-of select="if (./labl) then normalize-space(./labl) else '-' "/> 
        </fo:block>
      </fo:table-cell>

      <!-- Variable literal question -->
      <fo:table-cell text-align="left" border="{$layout.tables.border}" padding="{$layout.tables.cellpadding}">
        <fo:block>
          <xsl:value-of select="if (./qstn/qstnLit) then normalize-space(./qstn/qstnLit) else '-' "/>
        </fo:block>
      </fo:table-cell>
        
    </fo:table-row>

</xsl:template>
