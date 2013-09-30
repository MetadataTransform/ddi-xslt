<?xml version='1.0' encoding='UTF-8'?>

<!-- ======================================================== -->
<!-- [6] Files description                                    -->
<!-- [page-sequence]                                          -->
<!-- ======================================================== -->

<!--
  Variables read:
  msg, font-family

  Functions/templates called:
  count()
-->

<xsl:if test="$show-files-description = 1"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <fo:page-sequence master-reference="default-page"
                    font-family="{$font-family}"
                    font-size="10pt">

    <!-- header -->
    <fo:static-content flow-name="xsl-region-before">
      <fo:block font-size="6" text-align="center">
        <xsl:value-of select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:titlStmt/ddi:titl"/> -
        <xsl:value-of select="$msg/*/entry[@key='Files_Description']"/>
      </fo:block>
    </fo:static-content>

    <!-- footer -->
    <fo:static-content flow-name="xsl-region-after">
      <fo:block font-size="6" text-align="center" space-before="0.3in">
        - <fo:page-number /> -
      </fo:block>
    </fo:static-content>

    <!-- main [flow] -->
    <fo:flow flow-name="xsl-region-body">

      <!-- Files_Description -->
      <fo:block id="files-description" font-size="18pt" font-weight="bold" space-after="0.1in">
        <xsl:value-of select="$msg/*/entry[@key='Files_Description']" />
      </fo:block>

      <!-- Dataset_Contains -->
      <fo:block font-weight="bold">
        <xsl:value-of select="$msg/*/entry[@key='Dataset_contains']" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="count(/ddi:codeBook/ddi:fileDscr)" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="$msg/*/entry[@key='files']" />
      </fo:block>

      <!-- fileDscr -->
      <xsl:apply-templates select="/ddi:codeBook/ddi:fileDscr" />

    </fo:flow>
  </fo:page-sequence>
</xsl:if>
