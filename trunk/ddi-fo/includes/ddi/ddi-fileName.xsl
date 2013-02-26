<?xml version='1.0' encoding='utf-8'?>

<!-- ddi_fileName.xsl -->

<xsl:stylesheet xmlns:n1="http://www.icpsr.umich.edu/DDI" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ddi="http://www.icpsr.umich.edu/DDI" xmlns:date="http://exslt.org/dates-and-times" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:exsl="http://exslt.org/common" xmlns:math="http://exslt.org/math" xmlns:str="http://exslt.org/strings" xmlns:doc="http://www.icpsr.umich.edu/doc" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:xdt="http://www.w3.org/2005/xpath-datatypes" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:fn="http://www.w3.org/2005/xpath-functions" version="1.0" extension-element-prefixes="date exsl str">
  <xsl:output version="1.0" encoding="UTF-8" indent="no" omit-xml-declaration="no" media-type="text/html"/>

  <!-- ======================================== -->
  <!-- match: ddi:fileName                      -->
  <!-- [-]                                      -->
  <!-- return filename minus .NSDstat extension -->
  <!-- ======================================== -->

  <!--
    local vars set:
    $filename

    XPath 1.0 functions called:
    contains(), normalize-space(), string-length(), substring()
  -->

  <xsl:template match="ddi:fileName">

    <!-- ========= -->
    <!-- Variables -->
    <!-- ========= -->
    <xsl:variable name="filename" select="normalize-space(.)"/>

    <!-- =============================================== -->
    <!-- r) [-] Check if filename has .NSDstat extension -->
    <!-- =============================================== -->
    <xsl:choose>

      <!-- Case 1) [-] Filename contains .NSDstat-->
      <xsl:when test=" contains( $filename , '.NSDstat' )">
        <xsl:value-of select="substring($filename,1,string-length($filename)-8)"/>
      </xsl:when>

      <!-- Case 2) [-] Does not contain .NSDstat -->
      <xsl:otherwise>
        <xsl:value-of select="$filename"/>
      </xsl:otherwise>

    </xsl:choose>

  </xsl:template>
</xsl:stylesheet>