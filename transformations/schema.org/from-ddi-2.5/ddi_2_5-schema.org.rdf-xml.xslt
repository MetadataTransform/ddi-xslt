<?xml version="1.0" encoding="UTF-8"?>
<!--
Description:
XSLT Stylesheet for conversion between DDI-C version 2.5 and dc/schema.org

This file is free software: you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation, either
version 3 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library.  If not, see <http://www.gnu.org/licenses/>.

-->
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:meta="transformation:metadata"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
  xmlns:schema="http://schema.org/"
  xmlns:c="ddi:codebook:2_5"
  xmlns:dc="http://purl.org/dc/terms/" 
  xsi:schemaLocation="ddi:codebook:2_5 http://www.ddialliance.org/Specification/DDI-Codebook/2.5/XMLSchema/codebook.xsd"
  exclude-result-prefixes="#all"
  version="2.0">

  <meta:metadata>
    <identifier>ddi-2.5-to-schema.org-xml</identifier>
    <title>DDI 2.5 to schema.org (RDF/XML)</title>
    <description>Convert DDI Codebook (2.5) to Schema.org in RDF/XML format</description>
    <outputFormat>XML</outputFormat>
    <parameters/>
  </meta:metadata>

  <xsl:output method="xml" indent="yes" />
  <xsl:param name="main-root" select="/c:codeBook/c:stdyDscr"/>
  
  <xsl:template match="/">
    <rdf:RDF>
      <xsl:namespace name="rdf">http://www.w3.org/1999/02/22-rdf-syntax-ns#</xsl:namespace>
      <xsl:namespace name="schema">http://schema.org/</xsl:namespace>
      
      <schema:Dataset rdf:about="{meta:getRootIdentifier()}">
        <xsl:copy-of select="meta:mapLiteral('schema:name', $main-root/c:citation/c:titlStmt/c:titl)" />
        <xsl:copy-of select="meta:mapLiteral('schema:name', $main-root/c:citation/c:titlStmt/c:parTitl)" />
        <xsl:copy-of select="meta:mapLiteral('schema:alternateName', $main-root/c:citation/c:titlStmt/c:altTitl)" />
        <xsl:copy-of select="meta:mapLiteral('schema:producer', $main-root/c:citation/c:prodStmt/c:producer)" />
        <xsl:copy-of select="meta:mapLiteral('schema:locationCreated', $main-root/c:citation/c:prodStmt/c:prodPlac)" />
        <xsl:copy-of select="meta:mapLiteral('schema:provider', $main-root/c:citation/c:distStmt/c:distrbtr)" />
        <xsl:copy-of select="meta:mapLiteral('schema:description', $main-root/c:stdyInfo/c:abstract)" />
        <xsl:copy-of select="meta:mapLiteral('schema:keywords', $main-root/c:stdyInfo/c:subject/c:keyword)" />
        <xsl:copy-of select="meta:mapLiteral('schema:keywords', $main-root/c:stdyInfo/c:subject/c:topcClas)" />
        <xsl:copy-of select="meta:mapLiteral('schema:measurementTechnique', $main-root/c:method/c:dataColl/c:collMode)" />
        <xsl:copy-of select="meta:mapLiteral('schema:measurementTechnique', $main-root/c:method/c:dataColl/c:instrumentDevelopment)" />
        <xsl:copy-of select="meta:mapLiteral('schema:repeatFrequency', $main-root/c:method/c:dataColl/c:frequenc)" />
        <xsl:copy-of select="meta:mapLiteral('schema:isBasedOn', $main-root/c:method/c:dataColl/c:sources/c:dataSrc)" />
        <xsl:copy-of select="meta:mapLiteral('schema:datePublished', $main-root/c:citation/c:distStmt/c:distDate)" />
        <xsl:copy-of select="meta:mapLiteral('schema:identifier', $main-root/c:citation/c:titlStmt/c:IDNo)" />
        <xsl:copy-of select="meta:mapLiteral('schema:version', $main-root/c:citation/c:verStmt/c:version)" />
        <xsl:copy-of select="meta:mapLiteral('schema:hasPart', $main-root/c:citation/dc:hasPart)" />
        <xsl:copy-of select="meta:mapLiteral('schema:hasPart', $main-root/c:citation/dc:hasPart)" />
        <xsl:copy-of select="meta:mapLiteral('schema:audience', $main-root/c:citation/dc:audience)" />
        <xsl:copy-of select="meta:mapLiteral('schema:temporalCoverage', $main-root/c:citation/dc:temporal)" />
        <xsl:copy-of select="meta:mapLiteral('schema:inLanguage', $main-root/c:citation/dc:language)" />
        <xsl:copy-of select="meta:mapLiteral('schema:publisher', $main-root/c:citation/dc:publisher)" />
        <xsl:copy-of select="meta:mapLiteral('schema:conditionsOfAccess', $main-root/c:dataAccs/c:setAvail/c:avlStatus)" />
        <xsl:copy-of select="meta:mapLiteral('schema:conditionsOfAccess', $main-root/c:dataAccs/c:useStmt/c:conditions)" />
        <xsl:copy-of select="meta:mapLiteral('schema:usageInfo', $main-root/c:dataAccs/c:useStmt/c:disclaimer)" />
        <xsl:copy-of select="meta:mapLiteral('schema:spatialCoverage', $main-root/c:sumDscr/c:geogCover)" />

        <xsl:apply-templates select="$main-root/c:citation/c:prodStmt/c:fundAg" />
        <xsl:apply-templates select="$main-root/c:stdyInfo/c:sumDscr/c:nation" />
        <xsl:apply-templates select="/c:codeBook/c:dataDscr/c:var" />
      </schema:Dataset>
    </rdf:RDF> 
  </xsl:template>
  
  <xsl:template match="c:fundAg">
    <schema:funder>
      <schema:Organization>
        <xsl:copy-of select="meta:mapLiteral('schema:name', .)" />
      </schema:Organization>
    </schema:funder>
  </xsl:template>

  <xsl:template match="c:nation">
    <schema:spatialCoverage>
      <schema:Place>
        <xsl:copy-of select="meta:mapLiteral('schema:name', .)" />
      </schema:Place>
    </schema:spatialCoverage>
  </xsl:template>

  <xsl:template match="c:var">
    <schema:variableMeasured>
      <schema:PropertyValue>
        <schema:identifier><xsl:value-of select="@name" /></schema:identifier>
        <schema:description>
          <xsl:copy-of select="@xml:lang" />
          <xsl:value-of select="c:labl" />
        </schema:description>
      </schema:PropertyValue>
    </schema:variableMeasured>
  </xsl:template>
  
  <xsl:function name="meta:getRootIdentifier">
    <xsl:choose>
      <xsl:when test="$main-root/c:citation/c:titlStmt/c:IDNo[@agency='DataCite']">
        <xsl:value-of select="$main-root/c:citation/c:titlStmt/c:IDNo[@agency='DataCite']" />
      </xsl:when>
      <xsl:when test="$main-root/c:citation/c:titlStmt/c:IDNo[@agency='DOI']">
        <xsl:value-of select="$main-root/c:citation/c:titlStmt/c:IDNo[@agency='DOI']" />
      </xsl:when>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="meta:mapLiteral">
    <xsl:param name="element" />
    <xsl:param name="content" />

    <xsl:for-each select="$content">
      <xsl:element name="{$element}">
        <xsl:copy-of select="@xml:lang" />
        <xsl:value-of select ="." />
      </xsl:element>
    </xsl:for-each>
  </xsl:function >
</xsl:stylesheet>