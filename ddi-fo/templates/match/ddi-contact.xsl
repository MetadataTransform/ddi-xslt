<?xml version='1.0' encoding='utf-8'?>
<!-- ========================= -->
<!-- match: ddi:contact        -->
<!-- value: <fo:block>         -->
<!-- ========================= -->

<!-- functions: -->
<!-- url() [FO] -->

<xsl:template match="ddi:contact"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:fo="http://www.w3.org/1999/XSL/Format">

    <fo:block>

      <xsl:value-of select="." />

      <!-- affiliation -->
      <xsl:if test="@affiliation">
        <xsl:text>(</xsl:text>
        <xsl:value-of select="@affiliation"/>
        <xsl:text>)</xsl:text>
      </xsl:if>

      <!-- URI -->
      <xsl:if test="@URI"> ,
        <fo:basic-link external-destination="url('{@URI}')" text-decoration="underline" color="blue">
          <xsl:value-of select="@URI"/>
        </fo:basic-link>
      </xsl:if>

      <!-- email -->
      <xsl:if test="@email"> ,
        <fo:basic-link external-destination="url('mailto:{@URI}')" text-decoration="underline" color="blue">
          <xsl:value-of select="@email"/>
        </fo:basic-link>
      </xsl:if>

    </fo:block>

</xsl:template>
