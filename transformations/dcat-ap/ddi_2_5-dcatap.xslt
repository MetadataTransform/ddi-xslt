<?xml version="1.0" encoding="UTF-8"?>
<!--
Description:
XSLT Stylesheet for conversion between DDI-L version 2.5 and DCAT-AP

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
    xmlns:prov="http://www.w3.org/ns/prov#"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:schema="http://schema.org"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:vcard="http://www.w3.org/2006/vcard/ns#"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:c="ddi:codebook:2_5"
    xmlns:meta="transformation:metadata"
    xmlns:ddi="http://www.ddialliance.org/Specification/DDI-Codebook/2.5/XMLSchema/codebook.xsd"
    xsi:schemaLocation="ddi:codebook:2_5 http://www.ddialliance.org/Specification/DDI-Codebook/2.5/XMLSchema/codebook.xsd"

    exclude-result-prefixes="#all"
    version="2.0">
    <meta:metadata>
        <identifier>ddi-2.5-to-dcatap</identifier>
        <title>DDI 2.5 to DCAT-AP</title>
        <description>Convert DDI Codebook (2.5) to DCAT-AP</description>
        <outputFormat>XML</outputFormat>
        <parameters>
            <parameter name="root-element" format="xs:string" description="Root element"/>
        </parameters>
    </meta:metadata>
 
    <xsl:output method="xml" indent="yes" />

    <xsl:param name="studyURI">
      <xsl:choose>
          <xsl:when test="//c:docDscr/c:citation/c:titlStmt/c:IDNo!=''">
              <xsl:value-of select="c:citation/c:titlStmt/c:IDNo[@agency='DataCite']"/>
          </xsl:when>
          <xsl:when test="//c:codeBook/@ID">
              <xsl:value-of select="//c:codeBook/@ID"/>
          </xsl:when>
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

            <xsl:apply-templates select="//c:stdyDscr" />
        </rdf:RDF>
    </xsl:template>

    <xsl:template match="c:stdyDscr">
        <dcat:Dataset>
            <xsl:attribute name="rdf:about">
                <xsl:value-of select="$studyURI" />
                <xsl:choose>
                    <xsl:when test="c:citation/c:titlStmt/c:IDNo!=''">
                        <xsl:value-of select="c:citation/c:titlStmt/c:IDNo[@agency='DataCite']" />
                    </xsl:when>
                    <xsl:otherwise><xsl:value-of select="../ID" /></xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>

            <xsl:for-each select="c:citation/c:titlStmt/c:titl|c:citation/c:titlStmt/c:parTitl">
                <dcterms:title>
                    <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
                    <xsl:value-of select="." />
                </dcterms:title>        
            </xsl:for-each>

            <xsl:for-each select="c:citation/c:titlStmt/c:IDNo">
                <dcterms:identifier>
                    <xsl:value-of select="." />
                </dcterms:identifier>
            </xsl:for-each>

            <xsl:if test="c:citation/c:rspStmt/c:AuthEnty">
                <dcterms:creator>
                    <foaf:Agent>
                    <xsl:variable name="creator"><xsl:value-of select="c:citation/c:rspStmt/c:AuthEnty[1]" /></xsl:variable>
                        <foaf:name><xsl:value-of select="$creator" /></foaf:name>
                    </foaf:Agent>
                </dcterms:creator>
            </xsl:if>

            <xsl:if test="c:citation/c:distStmt/c:distDate">
                <dcterms:issued>
                <xsl:variable name="rdfdt">http://www.w3.org/2001/XMLSchema#dateTime</xsl:variable>
                    <xsl:attribute name="rdf:datatype">
                        <xsl:value-of select="$rdfdt"/>
                    </xsl:attribute>
                    <xsl:value-of select="c:citation/c:distStmt/c:distDate" />
                </dcterms:issued>
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

            <xsl:for-each select="c:stdyInfo/c:sumDscr/c:timePrd">
                <dcterms:temporal>
                    <dcterms:PeriodOfTime>
                        <xsl:variable name="startdate" select="if (@event='start') then (@date) else null"/>
                        <xsl:variable name="enddate" select="if (@event='start') then following-sibling::c:timePrd[1]/@date else null"/>
                        <xsl:if test="@event='start'">
                            <dcat:startDate>
                                <xsl:variable name="rdfdt">http://www.w3.org/2001/XMLSchema#dateTime</xsl:variable>
                                <xsl:attribute name="rdf:datatype">
                                    <xsl:value-of select="$rdfdt"/>
                                </xsl:attribute>
                                <xsl:value-of select="$startdate" />
                            </dcat:startDate>
                        </xsl:if>
                        <xsl:if test="@event='start'">
                            <dcat:endDate >
                                <xsl:variable name="rdfdt">http://www.w3.org/2001/XMLSchema#dateTime</xsl:variable>
                                <xsl:attribute name="rdf:datatype">
                                    <xsl:value-of select="$rdfdt"/>
                                </xsl:attribute>
                                <xsl:value-of select="$enddate" />
                            </dcat:endDate>
                        </xsl:if> 
                    </dcterms:PeriodOfTime>
                </dcterms:temporal>
            </xsl:for-each>

            <xsl:for-each select="c:sumDscr/c:geogBndBox|c:sumDscr/c:geogCover|c:sumDscr/c:boundPoly">
                <dcterms:spatial>
                    <xsl:variable name="startdate" select="if (@event='start' and (@date!='')) then (@date) else (.)"/>
                    <xsl:variable name="enddate" select="if (@event='end' and (@date!='')) then (@date) else (.)"/>
                    <xsl:if test="@event">
                    <xsl:if test="@event='start'"><xsl:attribute name="start" select="$startdate"/>
                        <xsl:value-of select="$startdate" />
                    </xsl:if>
                    <xsl:if test="@event='end'"><xsl:attribute name="end" select="$enddate"/>
                        <xsl:value-of select="$enddate"/>
                    </xsl:if>
                    </xsl:if>
                </dcterms:spatial>
            </xsl:for-each>

            <xsl:for-each select="c:stdyInfo/c:subject/c:keyword|c:stdyInfo/c:subject/c:topcClas">
                <dcat:keyword>
                    <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
                    <xsl:value-of select="." />
                </dcat:keyword>
            </xsl:for-each>

            <xsl:for-each select="c:stdyInfo/c:abstract">
                <dcterms:description>
                    <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
                    <xsl:value-of select="." />        
                </dcterms:description>
            </xsl:for-each>

            <xsl:for-each select="c:citation/c:distStmt/c:depositr">
                <prov:qualifiedAttribution>
                    <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
                    <xsl:value-of select="." />
                </prov:qualifiedAttribution>
            </xsl:for-each>

            <xsl:for-each select="c:citation/c:rspStmt/c:AuthEnty">
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

            <xsl:for-each select="c:citation/c:distStmt/c:distrbtr">
                <dcterms:publisher>
                    <xsl:attribute name="rdf:resource">
                        <!-- <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if> -->
                        <xsl:value-of select="@URI" />
                    </xsl:attribute>
                </dcterms:publisher>
            </xsl:for-each>

            <xsl:for-each select="c:citation/c:rspStmt/c:othId">
                <prov:qualifiedAttribution>
                    <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
                    <xsl:value-of select="." />
                </prov:qualifiedAttribution>
            </xsl:for-each>

            <xsl:for-each select="c:citation/c:rspStmt/othId">
                <dcat:contactPoint>
                    <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
                    <xsl:value-of select="." />
                </dcat:contactPoint>
            </xsl:for-each>

            <xsl:for-each select="c:prodStmt/c:copyright">
                <dc:rights>
                    <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
                    <xsl:value-of select="." />
                </dc:rights>
            </xsl:for-each> 

        </dcat:Dataset>
    </xsl:template>
 
    <!-- Remove empty elements -->
    <xsl:template match=
    "*[not(node())]
    |
    *[not(node()[2])
    and
        node()/self::text()
    and
        not(normalize-space())
        ]
    "/>

</xsl:stylesheet>