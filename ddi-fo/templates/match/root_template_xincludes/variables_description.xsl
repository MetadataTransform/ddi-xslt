<?xml version='1.0' encoding='UTF-8'?>

<!-- ==================================================== -->
<!-- [9] Variables description                            -->
<!-- [fo:page-sequence]                                   -->
<!-- ==================================================== -->

<!--
  Variables read:
  msg, font-family

  Functions/templates called
  count(), string-length()
-->

<xsl:if test="$show-variables-description = 1"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <fo:page-sequence master-reference="default-page"
                    font-family="{$font-family}" font-size="10pt">

    <!-- header -->
    <fo:static-content flow-name="xsl-region-before">
      <fo:block font-size="6" text-align="center">
        <xsl:value-of select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:titlStmt/ddi:titl" /> -
        <xsl:value-of select="$msg/*/entry[@key='Variables_Description']" />
      </fo:block>
    </fo:static-content>

    <!-- footer-->
    <fo:static-content flow-name="xsl-region-after">
      <fo:block font-size="6" text-align="center" space-before="0.3in">
        - <fo:page-number /> -
      </fo:block>
    </fo:static-content>

    <!-- page flow -->
    <fo:flow flow-name="xsl-region-body">

      <!-- Variables_Description -->
      <fo:block id="variables-description" font-size="18pt"
                font-weight="bold" space-after="0.1in">
        <xsl:value-of select="$msg/*/entry[@key='Variables_Description']" />
      </fo:block>

      <!-- Dataset_Contains -->
      <fo:block font-weight="bold">
        <xsl:value-of select="$msg/*/entry[@key='Dataset_contains']" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="count(/ddi:codeBook/ddi:dataDscr/ddi:var)" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="$msg/*/entry[@key='variables']" />
        <xsl:if test="string-length($subset-vars) &gt; 0">
          <xsl:value-of select="$msg/*/entry[@key='ShowingSubset']" />
        </xsl:if>
      </fo:block>

    </fo:flow>
  </fo:page-sequence>

  <!-- fileDscr -->
  <xsl:apply-templates select="/ddi:codeBook/ddi:fileDscr"
                       mode="variables-description" />
</xsl:if>