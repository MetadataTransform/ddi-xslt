<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:jn="http://www.json.org"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:meta="transformation:metadata"
    xmlns:c="ddi:codebook:2_5"
    xmlns:dc="http://purl.org/dc/terms/" 
    version="3.0">

  <xsl:output method="json" indent="yes" use-character-maps="no-escape-slash" />

  <meta:metadata>
    <identifier>ddi-2.5-to-schema.org-json-ld</identifier>
    <title>DDI 2.5 to schema.org (JSON-LD)</title>
    <description>Convert DDI Codebook (2.5) to Schema.org in JSON-LD format</description>
    <outputFormat>JSON</outputFormat>
    <parameters/>
  </meta:metadata>

  <xsl:param name="main-root" select="/c:codeBook/c:stdyDscr"/>

  <xsl:template match="/">

      <xsl:map>
        <xsl:map-entry key="'@context'">https://schema.org</xsl:map-entry>
        <xsl:map-entry key="'@type'">Dataset</xsl:map-entry>
        
        <xsl:copy-of select="meta:mapLiteral('keywords', (
          $main-root/c:stdyInfo/c:subject/c:topcClas | 
          $main-root/c:stdyInfo/c:subject/c:keyword
        ))" />

        <xsl:copy-of select="meta:mapLiteral('name', (
          $main-root/c:citation/c:titlStmt/c:titl |
          $main-root/c:citation/c:titlStmt/c:parTitl
        ))" />
        
        <xsl:copy-of select="meta:mapLiteral('alternateName', $main-root/c:citation/c:titlStmt/c:altTitl)" />
        <xsl:copy-of select="meta:mapLiteral('producer', $main-root/c:citation/c:prodStmt/c:producer)" />
        <xsl:copy-of select="meta:mapLiteral('locationCreated', $main-root/c:citation/c:prodStmt/c:prodPlac)" />
        <xsl:copy-of select="meta:mapLiteral('provider', $main-root/c:citation/c:distStmt/c:distrbtr)" />
        <xsl:copy-of select="meta:mapLiteral('description', $main-root/c:stdyInfo/c:abstract)" />
        <xsl:copy-of select="meta:mapLiteral('measurementTechnique', $main-root/c:method/c:dataColl/c:collMode)" />
        <xsl:copy-of select="meta:mapLiteral('measurementTechnique', $main-root/c:method/c:dataColl/c:instrumentDevelopment)" />
        <xsl:copy-of select="meta:mapLiteral('repeatFrequency', $main-root/c:method/c:dataColl/c:frequenc)" />
        <xsl:copy-of select="meta:mapLiteral('isBasedOn', $main-root/c:method/c:dataColl/c:sources/c:dataSrc)" />
        <xsl:copy-of select="meta:mapLiteral('datePublished', $main-root/c:citation/c:distStmt/c:distDate)" />
        <xsl:copy-of select="meta:mapLiteral('identifier', $main-root/c:citation/c:titlStmt/c:IDNo)" />
        <xsl:copy-of select="meta:mapLiteral('version', $main-root/c:citation/c:verStmt/c:version)" />
        <xsl:copy-of select="meta:mapLiteral('hasPart', $main-root/c:citation/dc:hasPart)" />
        <xsl:copy-of select="meta:mapLiteral('hasPart', $main-root/c:citation/dc:hasPart)" />
        <xsl:copy-of select="meta:mapLiteral('audience', $main-root/c:citation/dc:audience)" />
        <xsl:copy-of select="meta:mapLiteral('temporalCoverage', $main-root/c:citation/dc:temporal)" />
        <xsl:copy-of select="meta:mapLiteral('inLanguage', $main-root/c:citation/dc:language)" />
        <xsl:copy-of select="meta:mapLiteral('publisher', $main-root/c:citation/dc:publisher)" />
        <xsl:copy-of select="meta:mapLiteral('conditionsOfAccess', $main-root/c:dataAccs/c:setAvail/c:avlStatus)" />
        <xsl:copy-of select="meta:mapLiteral('conditionsOfAccess', $main-root/c:dataAccs/c:useStmt/c:conditions)" />
        <xsl:copy-of select="meta:mapLiteral('usageInfo', $main-root/c:dataAccs/c:useStmt/c:disclaimer)" />
        <xsl:copy-of select="meta:mapLiteral('spatialCoverage', $main-root/c:sumDscr/c:geogCover)" />
        
        <xsl:copy-of select="meta:personOrOrganizationList('author', $main-root/c:citation/c:rspStmt/c:AuthEnty)" />
        <xsl:copy-of select="meta:personOrOrganizationList('contributor', $main-root/c:citation/c:distStmt/c:depositr)" />
      </xsl:map>
  </xsl:template>
  
  <xsl:template match="c:AuthEnty">

  </xsl:template>
  <xsl:function name="meta:personOrOrganizationEntries">
    <xsl:param name="element"/>
    <xsl:for-each select="$element">
      <xsl:map>
        <xsl:choose>
            <xsl:when test="not(./@affiliation)">
              <xsl:map-entry key="'@type'">Organization</xsl:map-entry>
            </xsl:when>
            <xsl:otherwise>
              <xsl:map-entry key="'@type'">Person</xsl:map-entry>
              <xsl:map-entry key="'affiliation'">
                <xsl:map>
                  <xsl:map-entry key="'@type'">Organization</xsl:map-entry>
                  <xsl:map-entry key="'name'">
                    <xsl:value-of select="./@affiliation" />
                  </xsl:map-entry>
                </xsl:map>
              </xsl:map-entry>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:map-entry key="'name'">
          <xsl:sequence select="array {meta:literalList(.)}"/>
        </xsl:map-entry>
        <xsl:if test="@email">
          <xsl:map-entry key="'email'">
            <xsl:value-of select="./@email" />
          </xsl:map-entry>
        </xsl:if>
      </xsl:map>
    </xsl:for-each>
  </xsl:function>
  
  
  <xsl:function name="meta:personOrOrganizationList">
    <xsl:param name="element"/>
    <xsl:param name="content"/>
        <xsl:map-entry key="$element">
        <xsl:sequence select="array {meta:personOrOrganizationEntries($content)}"/>
    </xsl:map-entry>
  </xsl:function>

  <xsl:function name="meta:mapLiteral">
    <xsl:param name="element"/>
    <xsl:param name="content"/>

    <xsl:choose>
      <xsl:when test="not($content/@xml:lang) and count($content) = 1">
        <xsl:map-entry key="$element">
          <xsl:value-of select ="$content" />
        </xsl:map-entry>
      </xsl:when>
      <xsl:when test="not($content/@xml:lang) and count($content) > 0">
        <xsl:map-entry key="$element">
          <xsl:sequence select="array {$content/text()}"/>
        </xsl:map-entry>
      </xsl:when>
      <xsl:when test="count($content) > 0">
        <xsl:map-entry key="$element">
          <xsl:sequence select="array {meta:literalList($content)}"/>
        </xsl:map-entry>
      </xsl:when>
    </xsl:choose>
  </xsl:function >

  <xsl:function name="meta:literalList">
    <xsl:param name="content"/>
    <xsl:for-each select="$content">
        <xsl:map>
          <xsl:map-entry key="'@value'"><xsl:value-of select ="." /></xsl:map-entry>
          <xsl:if test="@xml:lang">
            <xsl:map-entry key="'@language'"><xsl:value-of select ="lower-case(@xml:lang)" /></xsl:map-entry>
          </xsl:if>
        </xsl:map>
    </xsl:for-each>
  </xsl:function >

  <xsl:character-map name="no-escape-slash">
    <xsl:output-character character="/" string="/"/>
  </xsl:character-map>
</xsl:stylesheet>