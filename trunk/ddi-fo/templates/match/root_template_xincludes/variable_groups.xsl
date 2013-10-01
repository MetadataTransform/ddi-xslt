<?xml version='1.0' encoding='UTF-8'?>

<!-- ================================================ -->
<!-- Variable groups                                  -->
<!-- [page-sequence]                                  -->
<!-- ================================================ -->

<!-- Variables read:                    -->
<!-- msg, font-family, number-of-groups -->

<!-- Functions/templates called:        -->
<!-- string-length(), count()           -->


<xsl:if test="$show-variable-groups = 1"
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
        <xsl:value-of select="/ddi:codeBook/ddi:stdyDscr/ddi:citation/ddi:titlStmt/ddi:titl" /> -
        <xsl:value-of select="$strings/*/entry[@key='Variables_Groups']" />
      </fo:block>
    </fo:static-content>
          
    <!-- =========================================== -->
    <!-- page footer                                 -->
    <!-- =========================================== -->    
    <fo:static-content flow-name="after">
      <fo:block font-size="{$footer-font-size}" text-align="center" space-before="0.3in">
        - <fo:page-number /> -
      </fo:block>
    </fo:static-content>

    <!-- =========================================== -->
    <!-- page content                                 -->
    <!-- =========================================== -->    
    <fo:flow flow-name="body">

      <!-- heading -->
      <fo:block id="variables-groups" font-size="18pt" font-weight="bold" space-after="0.1in">
        <xsl:value-of select="$strings/*/entry[@key='Variables_Groups']" />
      </fo:block>

      <!-- number of variables in data set -->
      <fo:block font-weight="bold">
        <xsl:value-of select="$strings/*/entry[@key='Dataset_contains']" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="count(/ddi:codeBook/ddi:dataDscr/ddi:varGrp)" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="$strings/*/entry[@key='groups']" />
        <xsl:if test="string-length($subset-vars)&gt;0">
          <xsl:value-of select="$strings/*/entry[@key='ShowingSubset']" />
          <xsl:value-of select="$number-of-groups" />
        </xsl:if>
      </fo:block>

      <!-- the actual variable groups table -->
      <xsl:apply-templates select="/ddi:codeBook/ddi:dataDscr/ddi:varGrp" />

    </fo:flow>
  </fo:page-sequence>
</xsl:if>
