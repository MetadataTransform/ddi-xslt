<?xml version="1.0" encoding="UTF-8"?>
<!--
Description:
XSLT Stylesheet for conversion between DDI-L version 2.5 and dc/dcterms

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
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:c="ddi:codebook:2_5"
    xmlns:meta="transformation:metadata"
    xmlns:ddi="http://www.ddialliance.org/Specification/DDI-Codebook/2.5/XMLSchema/codebook.xsd"
    xsi:schemaLocation="ddi:codebook:2_5 http://www.ddialliance.org/Specification/DDI-Codebook/2.5/XMLSchema/codebook.xsd"

    exclude-result-prefixes="#all"
    version="2.0">
    <meta:metadata>
        <identifier>ddi-2.5-to-dcterms</identifier>
        <title>DDI 2.5 to DCterms</title>
        <description>Convert DDI Codebook (2.5) to Dcterms</description>
        <outputFormat>XML</outputFormat>
        <parameters>
            <parameter name="root-element" format="xs:string" description="Root element"/>
        </parameters>
    </meta:metadata>
    
    <xsl:param name="root-element">metadata</xsl:param>
 
    <xsl:output method="xml" indent="yes" />
    
    <xsl:template match="/" > 
        <xsl:element name="{$root-element}">
            <xsl:namespace name="xs">http://www.w3.org/2001/XMLSchema</xsl:namespace>
            <xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
            <xsl:namespace name="dc">http://purl.org/dc/elements/1.1</xsl:namespace>
            <xsl:namespace name="dcterms">http://purl.org/dc/terms/</xsl:namespace>

            <xsl:apply-templates select="//c:stdyDscr/c:citation/c:titlStmt/c:titl" />
            <xsl:apply-templates select="//c:stdyDscr/c:citation/c:titlStmt/c:altTitl" />
            <xsl:apply-templates select="//c:stdyDscr/c:citation/c:titlStmt/c:parTitl" />
            <xsl:apply-templates select="//c:docDscr/c:citation/c:titlStmt/c:IDNo" />
            <xsl:apply-templates select="//c:stdyDscr/c:citation/c:rspStmt" />
            <xsl:apply-templates select="//c:stdyDscr/c:citation/c:distStmt/c:distDate" />
            <xsl:apply-templates select="//c:stdyDscr/c:citation/c:distStmt/c:depositr" />
            <xsl:apply-templates select="//c:stdyDscr/c:citation/c:distStmt/c:distrbtr" />
            <xsl:apply-templates select="//c:stdyDscr/c:stdyInfo/c:subject/c:keyword" />
            <xsl:apply-templates select="//c:stdyDscr/c:stdyInfo/c:subject/c:topcClas" />
            <xsl:apply-templates select="//c:stdyDscr/c:stdyInfo/c:abstract" />
            <xsl:apply-templates select="//c:stdyDscr/c:stdyInfo/c:sumDscr/c:timePrd" />
            <xsl:apply-templates select="//c:stdyDscr/c:stdyInfo/c:sumDscr/c:geogCover" />
            <xsl:apply-templates select="//c:stdyDscr/c:stdyInfo/c:sumDscr/c:geogBndBox" />
            <xsl:apply-templates select="//c:stdyDscr/c:stdyInfo/c:sumDscr/c:boundPoly" />
            <xsl:apply-templates select="//c:stdyDscr/c:stdyInfo/c:sumDscr/c:geogUnit" />
            <xsl:apply-templates select="//c:stdyDscr/c:stdyInfo/c:sumDscr/c:dataKind" />
            <xsl:apply-templates select="//c:stdyDscr/c:dataAccs/c:useStmt/c:restrctn" />
            <xsl:apply-templates select="//c:stdyDscr/c:dataAccs/c:setAvail/c:avlStatus" />
            <xsl:apply-templates select="//c:stdyDscr/c:othrStdyMat" />
            <xsl:apply-templates select="//c:stdyDscr/c:prodStmt/c:copyright" />
            <xsl:apply-templates select="//c:stdyDscr/c:prodStmt/c:prodDate" />
            <xsl:apply-templates select="//c:stdyDscr/c:dataColl/c:sources" />
            <xsl:apply-templates select="//c:fileDscr/c:fileTxt/c:fileType" />

        </xsl:element>
    </xsl:template> 

    <xsl:template match="c:altTitl">
        <dcterms:alternative>
            <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
            <xsl:value-of select="." />
        </dcterms:alternative>        
    </xsl:template>

    <xsl:template match="c:titl|c:parTitl">
        <dcterms:title>
            <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
            <xsl:value-of select="." />
        </dcterms:title>        
    </xsl:template>

    <!-- <xsl:template match="c:IDNo" >
        <xsl:element name="IDNo">
            <xsl:attribute name="agency">
                <xsl:value-of select="@agency" />
            </xsl:attribute>
            <xsl:value-of select="." />
        </xsl:element>
    </xsl:template> -->

    <xsl:template match="c:producer">
        <xsl:element name="dc:publisher">
            <xsl:attribute name="abbr">
                <xsl:value-of select="@abbr" />
            </xsl:attribute>
            <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
            <xsl:value-of select="." />
        </xsl:element>
    </xsl:template>

    <!-- <xsl:template match="c:distrbtr">
        <xsl:element name="distributer">
            <xsl:attribute name="abbr">
                <xsl:value-of select="@abbr" />
            </xsl:attribute>
            <xsl:attribute name="URI">
                <xsl:value-of select="@URI" />
            </xsl:attribute>
            <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
            <xsl:value-of select="." />
        </xsl:element>
    </xsl:template> -->

    <xsl:template match="c:IDNo">
        <dcterms:identifier>
            <xsl:value-of select="." />
        </dcterms:identifier>
    </xsl:template>

    <xsl:template match="c:AuthEnty">
            <dcterms:creator>
                <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
            <xsl:value-of select="." />
            </dcterms:creator>
    </xsl:template>

    <xsl:template match="c:distDate">
        <xsl:element name="dc:issued">
            <xsl:value-of select="." />
        </xsl:element>
    </xsl:template>

    <xsl:template match="c:timePrd|c:geogUnit|c:geogCover|c:geogBndBox|c:boundPoly">
        <xsl:element name="dc:coverage">
            <xsl:value-of select="." />
        </xsl:element>
    </xsl:template>

    <xsl:template match="c:dataKind">
        <xsl:element name="dc:type">
            <xsl:value-of select="." />
        </xsl:element>
    </xsl:template>

    <!-- Reference: https://www.dublincore.org/specifications/dublin-core/dcmi-terms/elements11/subject/ -->
    <xsl:template match="c:keyword|c:topcClas">
        <xsl:for-each select=".">
            <dcterms:subject>
                <xsl:attribute name="vocab">
                    <xsl:value-of select="@vocab" />
                </xsl:attribute>
                <xsl:attribute name="vocabURI">
                    <xsl:value-of select="@vocabURI" />
                </xsl:attribute>
                <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
                <xsl:value-of select="." />
            </dcterms:subject>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="c:abstract">
        <dcterms:abstract>
            <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
            <xsl:value-of select="." />        
        </dcterms:abstract>
    </xsl:template>

    <!-- <xsl:template match="c:restrctn">
        <dcterms:accessRights>
            <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
            <xsl:value-of select="." />
        </dcterms:accessRights>
    </xsl:template> -->

    <xsl:template match="c:avlStatus|c:restrctn">
        <dcterms:accessRights>
            <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
            <xsl:value-of select="." />
        </dcterms:accessRights>
    </xsl:template>

    <!-- <xsl:template match="publisher">
        <dcterms:publisher>
            <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
            <xsl:value-of select="." />
        </dcterms:publisher>
    </xsl:template>  -->

    <xsl:template match="c:othrStdyMat">
        <dcterms:relation>
            <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
            <xsl:value-of select="." />
        </dcterms:relation>
    </xsl:template> 

    <xsl:template match="c:copyright">
        <dc:rights>
            <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
            <xsl:value-of select="." />
        </dc:rights>
    </xsl:template> 

    <xsl:template match="c:prodDate">
        <dc:date>
            <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
            <xsl:value-of select="." />
        </dc:date>
    </xsl:template> 

    <xsl:template match="c:sources">
        <dc:source>
            <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
            <xsl:value-of select="." />
        </dc:source>
    </xsl:template>
    
    <xsl:template match="c:fileType">
        <dc:format>
            <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
            <xsl:value-of select="." />
        </dc:format>
    </xsl:template>     

    <!-- <xsl:template match="contributor">
        <dcterms:contributor>
            <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
            <xsl:value-of select="." />
        </dcterms:contributor>
    </xsl:template> -->

    <xsl:template match="othId|distrbtr|depositr">
        <dc:contributor>
            <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
            <xsl:value-of select="." />
        </dc:contributor>
    </xsl:template> 

    <!-- The following lines remove breaking lines in output -->
    <!-- <xsl:template match="*/text()[normalize-space()]">
        <xsl:value-of select="normalize-space()"/>
    </xsl:template>

    <xsl:template match="*/text()[not(normalize-space())]" /> -->

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