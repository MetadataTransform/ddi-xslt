<?xml version='1.0' encoding='utf-8'?>

<!-- fix_html.xsl -->

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

  <!-- ============================================ -->
  <!-- FixHTML(InputString)                         -->
  <!-- creates FOP equivalent from a subset of HTML -->
  <!-- ============================================ -->

  <!--
    params:
    ($InputString)

    local vars set:
    headStart, headEnd, break, beforeEnd

    XPath 1.0 functions called:
    substring-after, substring-before(), contains(), string-length(), not()

    templates called:
    [FixHTML]
  -->

  <xsl:template name="FixHTML">

    <!-- ========== -->
    <!-- Parameters -->
    <!-- ========== -->
    <xsl:param name="InputString"/>

    <!-- ========= -->
    <!-- Variables -->
    <!-- ========= -->
    <xsl:variable name="headStart">
      <xsl:text>&lt;h2&gt;</xsl:text>
    </xsl:variable>

    <xsl:variable name="headEnd">
      <xsl:text>&lt;/h2&gt;</xsl:text>
    </xsl:variable>

    <xsl:variable name="break">
      <xsl:text>&lt;br/&gt;</xsl:text>
    </xsl:variable>

    <!-- ======================== -->
    <!-- r) [-] Main - What to do -->
    <!-- ======================== -->
    <xsl:choose>

      <!-- Case 1: Make a header -->
      <xsl:when test="(contains($InputString,$headEnd) and string-length(substring-before($InputString,$headEnd)) &lt; string-length(substring-before($InputString,$break))) or (not(contains($InputString,$break))and contains($InputString,$headEnd))">
        <xsl:variable name="beforeEnd" select="substring-before($InputString,$headEnd)"/>

        <fo:block font-weight="bold">
          <xsl:value-of select="substring-after($beforeEnd,$headStart)"/>
        </fo:block>

        <xsl:call-template name="FixHTML">
          <xsl:with-param name="InputString">
            <xsl:value-of select="substring-after($InputString,$headEnd)"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>

      <!-- Case 2: Make a newline -->
      <xsl:when test="contains($InputString,$break)">
        <xsl:if test="string-length(substring-before($InputString,$break))=0">
          <fo:block>&#160;</fo:block>
        </xsl:if>

        <fo:block>
          <xsl:value-of select="substring-before($InputString,$break)"/>
        </fo:block>

        <xsl:call-template name="FixHTML">
          <xsl:with-param name="InputString">
            <xsl:value-of select="substring-after($InputString,$break)"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>

      <!-- Case 3: If no headers or breaks left in string, display all -->
      <xsl:otherwise>
        <fo:block>
          <xsl:value-of select="$InputString"/>
        </fo:block>
      </xsl:otherwise>

    </xsl:choose>

  </xsl:template>
</xsl:stylesheet>