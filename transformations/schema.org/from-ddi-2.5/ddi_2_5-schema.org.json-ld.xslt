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

  <xsl:template match="/c:codeBook">

      <xsl:map>
        <xsl:map-entry key="'@context'">https://schema.org</xsl:map-entry>
        <xsl:map-entry key="'@type'">Dataset</xsl:map-entry>
        
        <xsl:copy-of select="meta:mapLiteral('name', 
          c:stdyDscr/c:citation/c:titlStmt/c:titl |
          c:stdyDscr/c:citation/c:titlStmt/c:parTitl
        )" />
        <xsl:copy-of select="meta:mapLiteral('alternateName', c:stdyDscr/c:citation/c:titlStmt/c:altTitl)" />
        <xsl:copy-of select="meta:mapLiteral('keywords', 
          c:stdyDscr/c:stdyInfo/c:subject/c:topcClas | 
          c:stdyDscr/c:stdyInfo/c:subject/c:keyword
        )" />
        <xsl:copy-of select="meta:mapLiteral('abstract', c:stdyDscr/c:stdyInfo/c:abstract)" />
        <xsl:copy-of select="meta:mapLiteral('measurementTechnique', c:stdyDscr/c:method/c:dataColl/c:collMode)" />
        <xsl:copy-of select="meta:mapLiteral('isBasedOn', c:stdyDscr/c:method/c:dataColl/c:sources/c:dataSrc)" />
        <xsl:copy-of select="meta:mapLiteral('version', c:stdyDscr/c:citation/c:verStmt/c:version)" />
        <xsl:copy-of select="meta:mapLiteral('hasPart', c:stdyDscr/c:citation/dc:hasPart)" />
        <xsl:copy-of select="meta:mapLiteral('audience', c:stdyDscr/c:citation/dc:audience)" />
        <xsl:copy-of select="meta:mapLiteral('temporalCoverage', c:stdyDscr/c:citation/dc:temporal)" />
        <xsl:copy-of select="meta:mapLiteral('inLanguage', c:stdyDscr/c:citation/dc:language)" />
        <xsl:copy-of select="meta:mapLiteral('publisher', c:stdyDscr/c:citation/dc:publisher)" />
        <xsl:copy-of select="meta:mapLiteral('conditionsOfAccess', 
          c:stdyDscr/c:dataAccs/c:setAvail/c:avlStatus | 
          c:stdyDscr/c:dataAccs/c:useStmt/c:conditions
        )" />
        <xsl:copy-of select="meta:mapLiteral('usageInfo', c:stdyDscr/c:dataAccs/c:useStmt/c:disclaimer)" />
        <xsl:copy-of select="meta:mapLiteral('creditText', c:stdyDscr/c:citation/c:biblCit)" />
        <xsl:copy-of select="meta:mapPersonOrOrganization('author', c:stdyDscr/c:citation/c:rspStmt/c:AuthEnty)" />
        <xsl:copy-of select="meta:mapPersonOrOrganization('contributor', 
          c:stdyDscr/c:citation/c:distStmt/c:depositr |
          c:stdyDscr/c:method/c:dataColl/c:dataCollector
        )" />
        <xsl:copy-of select="meta:mapPersonOrOrganization('provider', c:stdyDscr/c:citation/c:distStmt/c:distrbtr)" />
        <xsl:copy-of select="meta:mapPersonOrOrganization('producer', c:stdyDscr/c:citation/c:prodStmt/c:producer)" />
        <xsl:copy-of select="meta:mapSpatial('locationCreated', c:stdyDscr/c:citation/c:prodStmt/c:prodPlac)" />
        <xsl:copy-of select="meta:mapSpatial('spatialCoverage', 
          c:stdyDscr/c:stdyInfo/c:sumDscr/c:geogCover | 
          c:stdyDscr/c:stdyInfo/c:sumDscr/c:nation
        )" />
        <xsl:copy-of select="meta:mapDistinctValues('identifier', c:stdyDscr/c:citation/c:titlStmt/c:IDNo)" />
        <xsl:copy-of select="meta:mapDate('datePublished', c:stdyDscr/c:citation/c:distStmt/c:distDate)" />
      </xsl:map>
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
        <xsl:if test="@URI">
          <xsl:map-entry key="'url'">
            <xsl:value-of select="./@URI" />
          </xsl:map-entry>
        </xsl:if>
      </xsl:map>
    </xsl:for-each>
  </xsl:function>
  
  <xsl:function name="meta:mapPersonOrOrganization">
    <xsl:param name="element"/>
    <xsl:param name="content"/>
        <xsl:map-entry key="$element">
        <xsl:sequence select="array {meta:personOrOrganizationEntries($content)}"/>
    </xsl:map-entry>
  </xsl:function>
  
  <xsl:function name="meta:spatilEntries">
    <xsl:param name="element"/>
    
    <xsl:for-each select="$element">
      <xsl:map>
        <xsl:map-entry key="'@type'">Place</xsl:map-entry>
        <xsl:map-entry key="'name'">
          <xsl:sequence select="array {meta:literalList(.)}"/>
        </xsl:map-entry>
        <xsl:if test="@abbr">
          <xsl:map-entry key="'identifier'">
            <xsl:value-of select="./@abbr" />
          </xsl:map-entry>
        </xsl:if>
      </xsl:map>
    </xsl:for-each>
  </xsl:function>
  
  <xsl:function name="meta:mapSpatial">
    <xsl:param name="element"/>
    <xsl:param name="content"/>
        <xsl:map-entry key="$element">
        <xsl:sequence select="array {meta:spatilEntries($content)}"/>
    </xsl:map-entry>
  </xsl:function>
  
  <xsl:function name="meta:mapDistinctValues">
    <xsl:param name="element"/>
    <xsl:param name="content"/>
    <xsl:for-each select="$content">
    
    </xsl:for-each>
      <xsl:map-entry key="$element">
      <xsl:sequence select="array {distinct-values($content/text())}"/>
    </xsl:map-entry>
  </xsl:function>
  
  <xsl:function name="meta:mapDate">
    <xsl:param name="element"/>
    <xsl:param name="content"/>
    <xsl:for-each select="$content">
    
    </xsl:for-each>
        <xsl:map-entry key="$element">
        <xsl:sequence select="array {$content[0]/@date}"/>
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
  </xsl:function>

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
  </xsl:function>
  
  <xsl:character-map name="no-escape-slash">
    <xsl:output-character character="/" string="/"/>
  </xsl:character-map>
</xsl:stylesheet>