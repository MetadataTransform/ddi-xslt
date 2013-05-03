<?xml version='1.0' encoding='utf-8'?>

<!-- documentation_toc_section.xsl -->

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

  <!-- ================================ -->
  <!-- documentation-toc-section(nodes) -->
  <!-- [fo:block]                       -->
  <!-- ================================ -->

  <!--
    params:
    ($nodes)

    global vars read:
    $msg,

    XPath 1.0 functions called:
    normalize-space()

    FO functions called:
    generate-id()
  -->

  <xsl:template name="documentation-toc-section">

    <!-- ========== -->
    <!-- Parameters -->
    <!-- ========== -->
    <xsl:param name="nodes"/>

    <!-- ==================================== -->
    <!-- r) [fo:block] Iterate through $nodes -->
    <!-- ==================================== -->
    <xsl:for-each select="$nodes">
      <fo:block margin-left="0.1in" font-size="8pt"
                text-align-last="justify" space-after="0.03in">

        <!-- [fo:basic-link] -->
        <fo:basic-link internal-destination="{generate-id()}"
                       text-decoration="underline" color="blue">
          <xsl:choose>
            <xsl:when test="normalize-space(dc:title)">
              <xsl:value-of select="normalize-space(dc:title)"/>
            </xsl:when>

            <xsl:otherwise>
              <xsl:text>*** </xsl:text>
              <xsl:value-of select="$msg/*/entry[@key='Untitled']"/>
              <xsl:text> ****</xsl:text>
            </xsl:otherwise>
          </xsl:choose>

          <fo:leader leader-pattern="dots"/>
          <fo:page-number-citation ref-id="{generate-id()}"/>
        </fo:basic-link>

      </fo:block>
    </xsl:for-each>

  </xsl:template>
</xsl:stylesheet>