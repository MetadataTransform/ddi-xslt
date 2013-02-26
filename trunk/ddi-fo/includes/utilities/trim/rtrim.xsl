<?xml version='1.0' encoding='utf-8'?>

<!-- rtrim.xsl -->

<xsl:stylesheet xmlns:n1="http://www.icpsr.umich.edu/DDI" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ddi="http://www.icpsr.umich.edu/DDI" xmlns:date="http://exslt.org/dates-and-times" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:exsl="http://exslt.org/common" xmlns:math="http://exslt.org/math" xmlns:str="http://exslt.org/strings" xmlns:doc="http://www.icpsr.umich.edu/doc" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:xdt="http://www.w3.org/2005/xpath-datatypes" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:fn="http://www.w3.org/2005/xpath-functions" version="1.0" extension-element-prefixes="date exsl str">
  <xsl:output version="1.0" encoding="UTF-8" indent="no" omit-xml-declaration="no" media-type="text/html"/>

  <!-- ========================== -->
  <!--	 rtrim(s, i)                -->
  <!-- string                     -->
  <!--                            -->
  <!-- perform right trim on text -->
  <!-- ========================== -->

  <!--
    params:
    -s, -i

    XPath 1.0 functions called:
    substring(), string-length(), translate()

    templates called:
    [rtrim]
  -->

  <xsl:template name="rtrim">

    <!-- Parameters -->
    <xsl:param name="s"/>
    <xsl:param name="i" select="string-length($s)"/>

    <!-- Is further trimming needed or not?-->
    <xsl:choose>

      <xsl:when test="translate(substring($s,$i,1),' &#x9;&#xA;&#xD;','')">
        <xsl:value-of select="substring($s,1,$i)"/>
      </xsl:when>

      <!-- Do nothing if string is less than 2 -->
      <xsl:when test="$i&lt;2"/>

      <!-- More trimming -->
      <xsl:otherwise>
        <xsl:call-template name="rtrim">
          <xsl:with-param name="s" select="$s"/>
          <xsl:with-param name="i" select="$i - 1"/>
        </xsl:call-template>
      </xsl:otherwise>

    </xsl:choose>

  </xsl:template>
</xsl:stylesheet>