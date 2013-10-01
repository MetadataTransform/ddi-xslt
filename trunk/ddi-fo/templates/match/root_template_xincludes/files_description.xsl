<?xml version='1.0' encoding='UTF-8'?>

<!-- ======================================================== -->
<!-- Files description                                        -->
<!-- [page-sequence]                                          -->
<!-- ======================================================== -->

<!-- Variables read:             -->
<!-- msg, font-family            -->

<!-- Functions/templates called: -->
<!-- count()                     -->


<xsl:if test="$show-files-description = 1"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <fo:page-sequence master-reference="{$page-layout}"
                    font-family="{$font-family}"
                    font-size="{$font-size}">

    <!-- =========================================== -->
    <!-- page header                                 -->
    <!-- =========================================== -->
    <fo:static-content flow-name="before">
      <fo:block font-size="{$header-font-size}" text-align="center">
        <xsl:value-of select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:titlStmt/ddi:titl"/> -
        <xsl:value-of select="$strings/*/entry[@key='Files_Description']"/>
      </fo:block>
    </fo:static-content>

    <!-- =========================================== -->
    <!-- page footer                                 -->
    <!-- =========================================== -->
    <fo:static-content flow-name="after">
      <fo:block font-size="{$header-font-size}" text-align="center" space-before="0.3in">
        - <fo:page-number /> -
      </fo:block>
    </fo:static-content>

    <!-- =========================================== -->
    <!-- page content                                -->
    <!-- =========================================== -->
    <fo:flow flow-name="body">

      <!-- heading -->
      <fo:block id="files-description" font-size="18pt" font-weight="bold" space-after="0.1in">
        <xsl:value-of select="$strings/*/entry[@key='Files_Description']" />
      </fo:block>

      <!-- number of files in data set -->
      <fo:block font-weight="bold">
        <xsl:value-of select="$strings/*/entry[@key='Dataset_contains']" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="count(/ddi:codeBook/ddi:fileDscr)" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="$strings/*/entry[@key='files']" />
      </fo:block>

      <!-- fileDscr -->
      <xsl:apply-templates select="/ddi:codeBook/ddi:fileDscr" />

    </fo:flow>
  </fo:page-sequence>
</xsl:if>
