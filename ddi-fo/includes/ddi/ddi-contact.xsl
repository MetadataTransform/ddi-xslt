<?xml version='1.0' encoding='utf-8'?>

<!-- ddi-contact.xsl -->

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

  <!-- ================== -->
  <!-- match: ddi:contact -->
  <!-- [fo:block]         -->
  <!-- ================== -->

  <!--
    FO functions called:
    url()
  -->

  <xsl:template match="ddi:contact">

    <!-- ======================== -->
    <!-- r) [fo:block] Main block -->
    <!-- ======================== -->
    <fo:block>

      <!-- [-] Current Node -->
      <xsl:value-of select="."/>

      <!-- [-] Affiliation Attribute -->
      <xsl:if test="@affiliation"> (
        <xsl:value-of select="@affiliation"/>)
      </xsl:if>

      <!-- [fo:basic-link] URI Attribute -->
      <xsl:if test="@URI"> ,
        <fo:basic-link external-destination="url('{@URI}')" text-decoration="underline" color="blue">
          <xsl:value-of select="@URI"/>
        </fo:basic-link>
      </xsl:if>

      <!-- [fo:basic-link] Mail Address Attribute -->
      <xsl:if test="@email"> ,
        <fo:basic-link external-destination="url('mailto:{@URI}')" text-decoration="underline" color="blue">
          <xsl:value-of select="@email"/>
        </fo:basic-link>
      </xsl:if>

    </fo:block>

  </xsl:template>
</xsl:stylesheet>