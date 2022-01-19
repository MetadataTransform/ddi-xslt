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

        <xsl:apply-templates select="//c:stdyDscr" />
      </rdf:RDF>
    </xsl:template>

    <xsl:template match="c:stdyDscr">
      <dcat:Dataset rdf:about="{meta:getRootIdentifier()}">
      <!-- 1       Title -->
        <xsl:for-each select="c:citation/c:titlStmt/c:titl">
          <dcterms:title>
            <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
            <xsl:value-of select="." />
          </dcterms:title>
        </xsl:for-each>
      <!-- 2       Identification Number -->
        <xsl:for-each select="c:citation/c:titlStmt/c:IDNo">
          <dcterms:identifier>
            <xsl:value-of select="." />
          </dcterms:identifier>
        </xsl:for-each>
      <!-- 3       Authoring Entity -->
        <xsl:if test="c:citation/c:rspStmt/c:AuthEnty">
          <dcterms:creator>
            <!-- DCAT-AP-SE accepts just one creator https://docs.dataportal.se/dcat/en/#dcat_Dataset-dcterms_creator -->
            <xsl:variable name="creator"><xsl:value-of select="c:citation/c:rspStmt/c:AuthEnty[1]" /></xsl:variable>
            <foaf:name><xsl:value-of select="$creator" /></foaf:name>
          </dcterms:creator>
        </xsl:if>
      <!-- 4       Other Identifications -->
        <xsl:for-each select="c:citation/c:rspStmt/c:othId">
          <prov:qualifiedAttribution>
            <xsl:variable name="priInvest">http://inspire.ec.europa.eu/metadata-codelist/ResponsiblePartyRole/principalInvestigator</xsl:variable>
            <prov:Attribution>
              <dcat:hadRole>
                <xsl:value-of select="$priInvest" />
              </dcat:hadRole>l
              <prov:agent>
                <xsl:value-of select="." />
              </prov:agent> 
              <xsl:value-of select="." />
            </prov:Attribution>
          </prov:qualifiedAttribution>
        </xsl:for-each>
      <!-- 5       Producer -->
        <xsl:if test="c:citation/c:prodStmt/c:producer">
          <dcterms:publisher>
            <dcterms:agent>
              <xsl:value-of select="c:citation/c:prodStmt/c:producer" />
            </dcterms:agent>
          </dcterms:publisher>
        </xsl:if>
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
        <xsl:for-each select="c:citation/c:distStmt/contact">
          <dcat:contactPoint>
            <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
            <xsl:value-of select="." />
          </dcat:contactPoint>
        </xsl:for-each>
      <!-- 11      Date of Distribution -->
        <xsl:if test="c:citation/c:distStmt/c:distDate">
          <dcterms:issued>
          <xsl:variable name="rdfdt">http://www.w3.org/2001/XMLSchema#dateTime</xsl:variable>
            <xsl:attribute name="rdf:datatype">
              <xsl:value-of select="$rdfdt"/>
            </xsl:attribute>
            <xsl:value-of select="c:citation/c:distStmt/c:distDate" />
          </dcterms:issued>
        </xsl:if>
      <!-- 12      Version -->
        <xsl:if test="c:citation/c:verStmt/c:version">
          <owl:versionInfo>
            <xsl:value-of select="c:citation/c:verStmt/c:version" />
          </owl:versionInfo>
        </xsl:if>
      <!-- 13      Version date -->
        <xsl:if test="c:citation/c:verStmt/c:version/@date">
          <dcterms:modified>
            <xsl:value-of select="c:citation/c:verStmt/c:version/@date" />
          </dcterms:modified>
        </xsl:if>
        <xsl:if test="c:citation/c:distStmt/c:distDate">
          <dcterms:modified>
            <xsl:variable name="rdfdt">http://www.w3.org/2001/XMLSchema#dateTime</xsl:variable>
            <xsl:attribute name="rdf:datatype">
              <xsl:value-of select="$rdfdt"/>
            </xsl:attribute>
            <xsl:value-of select="c:citation/c:distStmt/c:distDate" />
          </dcterms:modified>
        </xsl:if>
      <!-- 14      Version Notes and comments -->
        <xsl:for-each select="c:citation/c:verStmt/c:notes">
          <adms:versionNotes>
            <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
            <xsl:value-of select="." />
          </adms:versionNotes>
        </xsl:for-each>
      <!-- 15      URI -->
        <xsl:for-each select="c:dataAccs/c:holdings/@URI">
          <dcat:landingPage>
            <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
            <xsl:attribute name = "rdf:resource" select="." />
          </dcat:landingPage>
        </xsl:for-each>
      <!-- 16      Keywords -->
        <xsl:for-each select="c:stdyInfo/c:subject/c:keyword">
          <dcat:keyword>
            <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
            <xsl:value-of select="." />
          </dcat:keyword>
        </xsl:for-each>
      <!-- 17      Topic Classification (R) -->
        <xsl:for-each select="c:stdyInfo/c:subject/c:topcClas">
          <dcat:theme>
            <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
            <xsl:value-of select="." />
          </dcat:theme>
        </xsl:for-each>
      <!-- 18      Abstract (R) -->
        <xsl:for-each select="c:stdyInfo/c:abstract">
          <dcterms:description>
            <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
            <xsl:value-of select="." />        
          </dcterms:description>
        </xsl:for-each>
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
        <xsl:for-each select="c:stdyInfo/c:sumDscr/c:nation|c:stdyInfo/c:sumDscr/c:geogCover">
          <dcterms:spatial>
            <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
            <xsl:value-of select="." />
          </dcterms:spatial>
        </xsl:for-each>
      <!-- 22      Geographic Bounding Box -->
      <!-- 23      Geographic Bounding Polygon -->
        <xsl:if test="c:stdyInfo/c:sumDscr/c:geoBndBox|c:stdyInfo/c:sumDscr/c:boundPoly">
          <dcterms:Location>
            <xsl:for-each select="c:stdyInfo/c:sumDscr/c:geoBndBox/child::*">
              <dcat:bbox>
                <xsl:value-of select="." />
              </dcat:bbox>
            </xsl:for-each>          
            <xsl:for-each select="c:stdyInfo/c:sumDscr/c:boundPoly/c:polygon/c:point/child::*">
              <locn:geometry>
                <xsl:value-of select="." />
              </locn:geometry>
            </xsl:for-each>
          </dcterms:Location>
        </xsl:if>
      <!-- 24      Frequency of Data Collection -->
        <xsl:if test="c:method/c:dataColl/c:frequenc">
          <dcterms:accrualPeriodicity>
            <xsl:value-of select="c:method/c:dataColl/c:frequenc" />
          </dcterms:accrualPeriodicity>
        </xsl:if>
      <!-- 25      Sources Statement -->
        <xsl:for-each select="c:method/c:dataColl/c:sources/child::*">
          <dcterms:source>
            <xsl:attribute name = "rdf:resource" select="." />
          </dcterms:source>
        </xsl:for-each>
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
        <xsl:for-each select="c:othrStdyMat/c:relMat/descendant-or-self::*">
          <foaf:page>
            <xsl:value-of select="." />
          </foaf:page>
        </xsl:for-each>
      <!-- 34      Related Studies -->
        <xsl:for-each select="c:othrStdyMat/c:relStdy/descendant-or-self::*">
          <dcat:qualifiedRelation>
            <xsl:value-of select="." />
          </dcat:qualifiedRelation>
        </xsl:for-each>        
      </dcat:Dataset>

      <dcat:Distribution>
      <!-- 6       Copyright (R) -->
        <xsl:for-each select="c:citation/c:prodStmt/c:copyright">
          <dcterms:rights>
            <odrs:RightsStatement>
              <odrs:attributionText>
                <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
                <xsl:value-of select="." />  
              </odrs:attributionText>              
            </odrs:RightsStatement>
          </dcterms:rights>
        </xsl:for-each>
      <!-- 8       Distributor -->
        <!-- The following ensures that just one URL is selected according to DCAT-AP-SE 2.0 definition -->
        <xsl:for-each select="c:citation/c:distStmt/c:distrbtr[1]">
          <dcat:accessService>
            <xsl:attribute name = "rdf:resource" select= "." />
          </dcat:accessService> 
        </xsl:for-each>
      <!-- 9       URI -->
        <!-- The following ensures that just one URL is selected according to DCAT-AP-SE 2.0 definition -->
        <xsl:for-each select="c:citation/c:holdings/@URI">
          <dcat:accessURL>
            <xsl:attribute name = "rdf:resource" select= "." />
          </dcat:accessURL> 
        </xsl:for-each>
      </dcat:Distribution>
    <!-- 26      URI -->
      <xsl:if test="c:dataAccs/c:setAvail/c:accsPlac/@URI">
        <dcat:endPointURL>
          <xsl:value-of select= "c:dataAccs/c:setAvail/c:accsPlac/@URI"/>
        </dcat:endPointURL>
      </xsl:if>
    </xsl:template>

    <xsl:function name="meta:getRootIdentifier">
      <xsl:choose>
        <xsl:when test="$main-root/c:citation/c:titlStmt/c:IDNo[@agency='DataCite']">
          <xsl:value-of select="$main-root/c:citation/c:titlStmt/c:IDNo[@agency='DataCite']" />
        </xsl:when>
      </xsl:choose>
    </xsl:function>

</xsl:stylesheet>