<?xml version="1.0" encoding="UTF-8"?>
<!--
Description:
XSLT Stylesheet for conversion between DDI-C version 2.5 and DCAT-AP-SE 2.0

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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:dcat="http://www.w3.org/ns/dcat#"
  xmlns:foaf="http://xmlns.com/foaf/0.1"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:adms="http://www.w3.org/ns/adms#"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:locn="http://www.w3.org/ns/locn#"
  xmlns:prov="http://www.w3.org/ns/prov#"
  xmlns:schema="http://schema.org"
  xmlns:odrs="http://schema.theodi.org/odrs"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:vcard="http://www.w3.org/2006/vcard/ns#"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:dct="http://purl.org/dc/terms/"
  xmlns:c="ddi:codebook:2_5"
  xmlns:meta="transformation:metadata"
  xmlns:ddi="http://www.ddialliance.org/Specification/DDI-Codebook/2.5/XMLSchema/codebook.xsd"
  xsi:schemaLocation="ddi:codebook:2_5 http://www.ddialliance.org/Specification/DDI-Codebook/2.5/XMLSchema/codebook.xsd"

  exclude-result-prefixes="#all"
  version="2.0">
    <meta:metadata>
      <identifier>ddi-2.5-to-dcatap</identifier>
      <title>DDI 2.5 to DCAT-AP-SE 2.0</title>
      <description>Convert DDI Codebook (2.5) to DCAT-AP-SE 2.0</description>
      <outputFormat>XML</outputFormat>
      <parameters>
        <parameter name="root-element" format="xs:string" description="Root element"/>
      </parameters>
    </meta:metadata>
 
    <xsl:output method="xml" indent="yes" />

<!--progress:
    id     | ddi2.5                     | dcat-ap-se
    ==================================================================
    0       Document (metadata) Producer  dcat:Dataset/dcterms:publisher
    1       Title                         dcat:Dataset/dcterms:title
    2       Identification Number         dcat:Dataset/dcterms:identifier
    3       Authoring Entity              dcat:Dataset/dcterms:creator
    4       Other Identifications         dcat:Dataset/prov:qualifiedAttribution
    5       Producer                      dcat:Dataset/dcterms:publisher
    6       Copyright                     dcat:Distribution/dcterms:rights
    7       Funding Agency                dcat:Dataset/prov:qualifiedAttribution
    8       Distributor                   dcat:Distribution/dcat:accessService
    9       URI                           dcat:Distribution/dcat:accessURL
    10      Contact Persons               dcat:Dataset/dcat:contactPoint
    11      Date of Distribution          dcat:Dataset/dcterms:issued
    12      Version                       dcat:Dataset/owl:versionInfo
    13      Version date                  dcat:Dataset/dcterms:issued
    14      Version Notes and comments    dcat:Dataset/adms:versionNotes
    15      URI                           dcat:Dataset/dcat:landingPage
    16      Keywords                      dcat:Dataset/dcat:keyword      
    17      Topic Classification          dcat:Dataset/dcat:theme
    18      Abstract                      dcat:Dataset/dcterms:description
    19      Time Period Covered           dcat:Dataset/dcterms:temporal/dcterms:PeriodOfTime
    20      Country                       dcat:Dataset/dcterms:spatial
    21      Geographic Coverage           dcat:Dataset/dcterms:spatial
    22      Geographic Bounding Box       dcterms:Location/dcat:bbox
    23      Geographic Bounding Polygon   dcterms:Location/locn:geometry
    24      Frequency of Data Collection  dcat:Dataset/dcterms:accrualPeriodicity
    25      Sources Statement             dcat:Dataset/dcterms:source
    26      URI                           dcat:endPointURL
    27      Availability Status           dcat:Dataset/dcterms:accessRights
    28      Confidentiality Declaration   dcat:Dataset/dcterms:accessRights
    29      Special Permissions           dcat:Dataset/dcterms:accessRights
    30      Restrictions                  dcat:Dataset/dcterms:accessRights
    31      Conditions                    dcat:Dataset/dcterms:accessRights
    32      Disclaimer                    dcat:Dataset/dcterms:accessRights
    33      Related Materials             dcat:Dataset/foaf:page
    34      Related Studies               dcat:Dataset/dcat:qualifiedRelation -->

    <xsl:param name="main-root" select="/c:codeBook/c:stdyDscr"/>
    <xsl:param name="language">
      <xsl:variable name="lng" select="$main-root/c:citation/dc:language" />
      <xsl:choose>
        <xsl:when test="starts-with(lower-case($lng), 'en')">
          <xsl:text>http://publications.europa.eu/resource/authority/language/ENG</xsl:text>
        </xsl:when>
        <xsl:when test="starts-with(lower-case($lng), 'sv') or starts-with(lower-case($lng), 'sw')">
          <xsl:text>http://publications.europa.eu/resource/authority/language/SWE</xsl:text>
        </xsl:when>
        <!-- Takes Swedish as default language -->
        <xsl:otherwise>
          <xsl:text>http://publications.europa.eu/resource/authority/language/SWE</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:param>

    <xsl:template match="/" > 
      <rdf:RDF>
        <xsl:namespace name="dcat">http://www.w3.org/ns/dcat#</xsl:namespace>
        <xsl:namespace name="foaf">http://xmlns.com/foaf/0.1</xsl:namespace>
        <xsl:namespace name="prov">http://www.w3.org/ns/prov#</xsl:namespace>
        <xsl:namespace name="owl">http://www.w3.org/2002/07/owl#</xsl:namespace>
        <xsl:namespace name="rdf">http://www.w3.org/1999/02/22-rdf-syntax-ns#</xsl:namespace>
        <xsl:namespace name="vcard">http://www.w3.org/2006/vcard/ns#</xsl:namespace>
        <xsl:namespace name="dcterms">http://purl.org/dc/terms/</xsl:namespace>
        <xsl:namespace name="odrs">http://schema.theodi.org/odrs</xsl:namespace>
        <xsl:namespace name="dc">http://purl.org/dc/elements/1.1</xsl:namespace>
        <xsl:namespace name="locn">http://www.w3.org/ns/locn#</xsl:namespace>

        <xsl:apply-templates select="//c:stdyDscr" />
      </rdf:RDF>
    </xsl:template>

    <xsl:template match="c:stdyDscr">
      <dcat:Dataset rdf:about="{meta:getRootIdentifier()}">
        <!-- 1       Title -->
        <xsl:copy-of select="meta:mapLiteral('dcterms:title', c:citation/c:titlStmt/c:titl, null, null)" />
        <!-- 2       Identification Number -->
        <xsl:copy-of select="meta:mapLiteral('dcterms:identifier', c:citation/c:titlStmt/c:IDNo, null, null)" />
        <!-- 3       Authoring Entity -->
        <!-- DCAT-AP-SE accepts just one creator https://docs.dataportal.se/dcat/en/#dcat_Dataset-dcterms_creator -->
        <xsl:copy-of select="meta:mapLiteral('dcterms:creator', c:citation/c:rspStmt/c:AuthEnty[1], null, null)" />
        <!-- 4       Other Identifications -->
        <xsl:for-each select="c:citation/c:rspStmt/c:othId">
          <prov:qualifiedAttribution>
            <xsl:variable name="priInvest">http://inspire.ec.europa.eu/metadata-codelist/ResponsiblePartyRole/principalInvestigator</xsl:variable>
            <prov:Attribution>
              <dcat:hadRole>
                <xsl:value-of select="$priInvest" />
              </dcat:hadRole>
              <prov:agent>
                <xsl:value-of select="." />
              </prov:agent> 
              <xsl:value-of select="." />
            </prov:Attribution>
          </prov:qualifiedAttribution>
        </xsl:for-each>
        <!-- 0       Document (metadata) Producer -->
        <!-- 5       Producer -->
        <dcterms:publisher>
          <xsl:copy-of select="meta:mapLiteral('dcterms:agent', c:citation/c:prodStmt/c:producer, null, null)" />
        </dcterms:publisher>
        <!-- 7       Funding Agency -->
        <xsl:for-each select="c:citation/c:prodStmt/c:fundAg">
          <xsl:variable name="priInvest">http://inspire.ec.europa.eu/metadata-codelist/ResponsiblePartyRole/principalInvestigator</xsl:variable> 
          <prov:qualifiedAttribution>
            <prov:Attribution>
              <prov:agent>
                <foaf:Agent>
                  <foaf:name><xsl:value-of select="." /></foaf:name>
                </foaf:Agent>
              </prov:agent>
              <dcat:hadRole>
                <xsl:attribute name="rdf:resource">
                  <xsl:value-of select="$priInvest" />
                </xsl:attribute>
              </dcat:hadRole>
            </prov:Attribution>
          </prov:qualifiedAttribution>
        </xsl:for-each>
        <!-- 10      Contact Persons -->
        <xsl:copy-of select="meta:mapLiteral('dcat:contactPoint', c:citation/c:distStmt/c:contact, null, null)" />
        <!-- 11      Date of Distribution -->
        <xsl:variable name="rdfdt">http://www.w3.org/2001/XMLSchema#dateTime</xsl:variable>
        <xsl:copy-of select="meta:mapLiteral('dcterms:issued', c:citation/c:distStmt/c:distDate, 'rdf:datatype', $rdfdt)" />
        <!-- 12      Version -->
        <xsl:copy-of select="meta:mapLiteral('owl:versionInfo', c:citation/c:verStmt/c:version, null, null)" />
        <!-- 13      Version date -->
        <xsl:copy-of select="meta:mapLiteral('dcterms:modified', c:citation/c:verStmt/c:version/@date, null, null)" />
        <xsl:copy-of select="meta:mapLiteral('dcterms:modified', c:citation/c:distStmt/c:distDate, 'rdf:datatype', $rdfdt)" />
        <!-- 14      Version Notes and comments -->
        <xsl:copy-of select="meta:mapLiteral('adms:versionNotes', c:citation/c:verStmt/c:notes, null, null)" />
        <!-- 15      URI -->
        <xsl:variable name="rdfres"><xsl:value-of select="c:citation/c:holdings/@URI" /></xsl:variable>
        <xsl:copy-of select="meta:mapLiteral('dcat:landingPage', c:citation/c:holdings/@URI, 'rdf:resource', $rdfres)" />
        <!-- 16      Keywords -->
        <xsl:copy-of select="meta:mapLiteral('dcat:keyword', c:stdyInfo/c:subject/c:keyword, null, null)" />
        <!-- 17      Topic Classification -->
        <xsl:copy-of select="meta:mapLiteral('dcat:theme', c:stdyInfo/c:subject/c:topcClas, null, null)" />
        <!-- 18      Abstract -->
        <xsl:copy-of select="meta:mapLiteral('dcterms:description', c:stdyInfo/c:abstract, null, null)" />
        <!-- 19      Time Period Covered -->
        <xsl:for-each select="c:stdyInfo/c:sumDscr/c:timePrd">
          <dcterms:temporal>
            <dcterms:PeriodOfTime>
              <xsl:variable name="singleDate" select="if (@event='single') then (.) else null"/>                      
              <xsl:variable name="startdate" select="if (@event='start') then (.) else null"/>
              <xsl:variable name="rdfdt">http://www.w3.org/2001/XMLSchema#dateTime</xsl:variable>
              <xsl:choose>
                <xsl:when test="@event='start'">
                  <dcat:startDate>
                    <xsl:attribute name="rdf:datatype">
                      <xsl:value-of select="$rdfdt"/>
                    </xsl:attribute>
                    <xsl:value-of select="$startdate" />
                  </dcat:startDate>
                  <dcat:endDate>
                    <xsl:attribute name="rdf:datatype">
                      <xsl:value-of select="$rdfdt"/>
                    </xsl:attribute>
                    <xsl:value-of select= "following-sibling::*[name() = name(current())][1]"/>
                  </dcat:endDate>
                </xsl:when>
                <xsl:when test="@event='single'">
                  <dcat:startDate>
                    <xsl:attribute name="rdf:datatype">
                      <xsl:value-of select="$rdfdt"/>
                    </xsl:attribute>
                    <xsl:value-of select="$singleDate" />
                  </dcat:startDate>
                  <dcat:endDate >
                    <xsl:attribute name="rdf:datatype">
                        <xsl:value-of select="$rdfdt"/>
                    </xsl:attribute>
                    <xsl:value-of select="$singleDate" />
                  </dcat:endDate>
                </xsl:when>
              </xsl:choose>
            </dcterms:PeriodOfTime>
          </dcterms:temporal>
        </xsl:for-each>
        <!-- 20      Country -->
        <!-- 21      Geographic Coverage -->
        <xsl:copy-of select="meta:mapLiteral('dcterms:spatial', c:stdyInfo/c:sumDscr/c:nation|c:stdyInfo/c:sumDscr/c:geogCover, null, null)" />
        <!-- 22      Geographic Bounding Box -->
        <!-- 23      Geographic Bounding Polygon -->
        <dcterms:Location>
          <xsl:copy-of select="meta:mapLiteral('dcat:bbox', c:stdyInfo/c:sumDscr/c:geoBndBox/child::*, null, null)" />
          <xsl:copy-of select="meta:mapLiteral('locn:geometry', c:stdyInfo/c:sumDscr/c:boundPoly/c:polygon/c:point/child::*, null, null)" />
        </dcterms:Location>
        <!-- 24      Frequency of Data Collection -->
        <xsl:copy-of select="meta:mapLiteral('dcterms:accrualPeriodicity', c:method/c:dataColl/c:frequenc, null, null)" />
        <!-- 25      Sources Statement -->
        <xsl:copy-of select="meta:mapLiteral('rdf:resource', c:method/c:dataColl/c:sources/child::*, null, null)" />
        <!-- 27      Availability Status -->
        <!-- 28      Confidentiality Declaration -->
        <!-- 29      Special Permissions -->
        <!-- 30      Restrictions -->
        <!-- 31      Conditions -->
        <!-- 32      Disclaimer -->
        <xsl:for-each select="$main-root/c:dataAccs/c:useStmt/c:restrctn|$main-root/c:dataAccs/c:useStmt/c:specPerm
                                              |$main-root/c:dataAccs/c:useStmt/c:confDec|c:dataAccs/c:setAvail/c:avlStatus
                                              |$main-root/c:dataAccs/c:useStmt/c:conditions|$main-root/c:dataAccs/c:useStmt/c:disclaimer" >
          <xsl:choose>
            <xsl:when test="contains(lower-case(.),'non public')">
              <dcterms:accessRights>
                <xsl:attribute name="rdf:resource">http://publications.europa.eu/resource/authority/access-right/NON-PUBLIC</xsl:attribute>
              </dcterms:accessRights>
            </xsl:when>
            <xsl:when test="contains(lower-case(.),'public') and not(contains(lower-case(.),'non public'))">
              <dcterms:accessRights>
                <xsl:attribute name="rdf:resource">http://publications.europa.eu/resource/authority/access-right/PUBLIC</xsl:attribute>
              </dcterms:accessRights>
            </xsl:when>
            <xsl:when test="contains(lower-case(.),'restricted')">
              <dcterms:accessRights>
                <xsl:attribute name="rdf:resource">http://publications.europa.eu/resource/authority/access-right/RESTRICTED</xsl:attribute>
              </dcterms:accessRights>
            </xsl:when>
            <xsl:otherwise>
              <dcterms:accessRights />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
        <!-- 33      Related Materials -->
        <xsl:copy-of select="meta:mapLiteral('foaf:page', c:othrStdyMat/c:relMat/descendant-or-self::*, null, null)" />
        <!-- 34      Related Studies -->
        <xsl:copy-of select="meta:mapLiteral('dcat:qualifiedRelation', c:othrStdyMat/c:relStdy/descendant-or-self::*, null, null)" />      
      </dcat:Dataset>
      <dcat:Distribution>
        <!-- 6       Copyright -->
        <dcterms:rights>
          <odrs:RightsStatement>
            <xsl:copy-of select="meta:mapLiteral('odrs:attributionText', c:citation/c:prodStmt/c:copyright, null, null)" />
          </odrs:RightsStatement>
        </dcterms:rights>
        <!-- 8       Distributor -->
        <!-- The following ensures that just one URL is selected according to DCAT-AP-SE 2.0 definition -->
        <xsl:copy-of select="meta:mapLiteral('dcat:accessService', c:citation/c:distStmt/c:distrbtr[1], 'rdf:resource', c:citation/c:distStmt/c:distrbtr[1])" />
        <!-- 9       URI -->
        <!-- The following ensures that just one URL is selected according to DCAT-AP-SE 2.0 definition -->
        <xsl:copy-of select="meta:mapLiteral('dcat:accessURL', c:citation/c:holdings/@URI, 'rdf:resource', c:citation/c:holdings/@URI)" />
      </dcat:Distribution>
      <!-- 26      URI -->
      <xsl:copy-of select="meta:mapLiteral('dcat:endPointURL', c:dataAccs/c:setAvail/c:accsPlac/@URI, null, null)" />
    </xsl:template>

    <xsl:function name="meta:getRootIdentifier">
      <xsl:choose>
        <xsl:when test="$main-root/c:citation/c:titlStmt/c:IDNo[@agency='DataCite']">
          <xsl:value-of select="$main-root/c:citation/c:titlStmt/c:IDNo[@agency='DataCite']" />
        </xsl:when>
      </xsl:choose>
    </xsl:function>
    <xsl:function name="meta:mapLiteral">
    <xsl:param name="element" />
    <xsl:param name="content" />
    <xsl:param name="attribute" />
    <xsl:param name="attribValue" />
      <xsl:for-each select="$content">
          <xsl:element name="{$element}">
          <xsl:copy-of select="@xml:lang" />
          <xsl:if test="$attribute!='null'">
          <xsl:attribute name="{$attribute}"><xsl:value-of select= "$attribValue" /></xsl:attribute>
          </xsl:if>
          <xsl:value-of select ="." />
          </xsl:element>
      </xsl:for-each> 
    </xsl:function>
</xsl:stylesheet>