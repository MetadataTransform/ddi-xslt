<?xml version='1.0' encoding='utf-8'?>

<!-- variables-table-col-header.xsl -->
<!-- Header for variable table -->

<xsl:stylesheet xmlns:n1="http://www.icpsr.umich.edu/DDI"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:ddi="http://www.icpsr.umich.edu/DDI"
                xmlns:date="http://exslt.org/dates-and-times"
                xmlns:dcterms="http://purl.org/dc/terms/"
                xmlns:exsl="http://exslt.org/common"
                xmlns:math="http://exslt.org/math"
                xmlns:str="http://exslt.org/strings"
                xmlns:doc="http://www.icpsr.umich.edu/doc"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:xdt="http://www.w3.org/2005/xpath-datatypes"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                version="1.0"
                extension-element-prefixes="date exsl str">
    
  <xsl:output version="1.0" encoding="UTF-8" indent="no"
              omit-xml-declaration="no" media-type="text/html"/>

  <!-- ============================ -->
  <!-- variables-table-col-header() -->
  <!-- [fo:table-row]               -->
  <!-- ============================ -->

  <!--
    global vars read:
    $show-variables-list-question, $msg
  -->

  <!--
    1: #-character    <fo:table-cell>
    2: Name           <fo:table-cell>
    3: Label          <fo:table-cell>
    4: Type           <fo:table-cell>
    5: Format         <fo:table-cell>
    6: Valid          <fo:table-cell>
    7: Invalid        <fo:table-cell>
    8: Question       <fo:table-cell>
  -->

  <xsl:template name="variables-table-col-header">

    <!-- ====================== -->
    <!-- r) [fo:table-row] Main -->
    <!-- ====================== -->
    <fo:table-row text-align="center" vertical-align="top"
                  font-weight="bold" keep-with-next="always">

      <!-- 1) [fo:table-cell] #-character -->
      <fo:table-cell border="0.5pt solid black" padding="3pt">
        <fo:block>#</fo:block>
      </fo:table-cell>

      <!-- 2) [fo:table-cell] Name -->
      <fo:table-cell border="0.5pt solid black" padding="3pt">
        <fo:block>
          <xsl:value-of select="$msg/*/entry[@key='Name']"/>
        </fo:block>
      </fo:table-cell>

      <!-- 3) [fo:table-cell] Label -->
      <fo:table-cell border="0.5pt solid black" padding="3pt">
        <fo:block>
          <xsl:value-of select="$msg/*/entry[@key='Label']"/>
        </fo:block>
      </fo:table-cell>

      <!-- 4) [fo:table-cell]Type -->
      <fo:table-cell border="0.5pt solid black" padding="3pt">
        <fo:block>
          <xsl:value-of select="$msg/*/entry[@key='Type']"/>
        </fo:block>
      </fo:table-cell>

      <!-- 5) [fo:table-cell] Format -->
      <fo:table-cell border="0.5pt solid black" padding="3pt">
        <fo:block>
          <xsl:value-of select="$msg/*/entry[@key='Format']"/>
        </fo:block>
      </fo:table-cell>

      <!-- 6) [fo:table-cell] Valid -->
      <fo:table-cell border="0.5pt solid black" padding="3pt">
        <fo:block>
          <xsl:value-of select="$msg/*/entry[@key='Valid']"/>
        </fo:block>
      </fo:table-cell>

      <!-- 7) [fo:table-cell] Invalid -->
      <fo:table-cell border="0.5pt solid black" padding="3pt">
        <fo:block>
          <xsl:value-of select="$msg/*/entry[@key='Invalid']"/>
        </fo:block>
      </fo:table-cell>

      <!-- 8) [fo:table-cell] Question -->
      <xsl:if test="$show-variables-list-question">
        <fo:table-cell border="0.5pt solid black" padding="3pt">
          <fo:block>
            <xsl:value-of select="$msg/*/entry[@key='Question']"/>
          </fo:block>
        </fo:table-cell>
      </xsl:if>

    </fo:table-row>

  </xsl:template>
</xsl:stylesheet>