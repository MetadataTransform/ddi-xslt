<?xml version="1.0" encoding="UTF-8"?>
<!--
Description:
XSLT Stylesheet for conversion between DDI-C version 2.5 and dc/dcterms

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
            <!--
            <xsl:copy-of select="meta:mapLiteral('dcterms:', )" />
            -->
            <xsl:copy-of select="meta:mapLiteral('dcterms:title', //c:stdyDscr/c:citation/c:titlStmt/c:titl)" />
            <xsl:copy-of select="meta:mapLiteral('dcterms:title', //c:stdyDscr/c:citation/c:titlStmt/c:parTitl)" />
            <xsl:copy-of select="meta:mapLiteral('dcterms:abstract', //c:stdyDscr/c:stdyInfo/c:abstract)" />
            <xsl:copy-of select="meta:mapLiteral('dcterms:alternative', //c:stdyDscr/c:citation/c:titlStmt/c:altTitl)" />
            <xsl:copy-of select="meta:mapLiteral('dcterms:identifier', //c:stdyDscr/c:citation/c:titlStmt/c:IDNo)" />
            <xsl:copy-of select="meta:mapLiteral('dcterms:issued', //c:stdyDscr/c:citation/c:distStmt/c:distDate)" />
            <xsl:copy-of select="meta:mapLiteral('dcterms:isPartOf', //c:stdyDscr/c:citation/c:serStmt/c:serName)" />
            <xsl:copy-of select="meta:mapLiteral('dcterms:contributor', //c:stdyDscr/c:citation/c:distStmt/c:depositr)" />
            <xsl:copy-of select="meta:mapLiteral('dcterms:contributor', //c:stdyDscr/c:citation/c:distStmt/c:distrbtr)" />
            <xsl:copy-of select="meta:mapLiteral('dcterms:contributor', //c:stdyDscr/c:method/c:dataColl/c:dataCollector)" />
            <xsl:copy-of select="meta:mapLiteral('dcterms:type', //c:stdyDscr/c:stdyInfo/c:sumDscr/c:dataKind)" />
            <xsl:copy-of select="meta:mapLiteral('dcterms:subject', //c:stdyDscr/c:stdyInfo/c:subject/c:keyword)" />
            <xsl:copy-of select="meta:mapLiteral('dcterms:subject', //c:stdyDscr/c:stdyInfo/c:subject/c:topcClas)" />
            <xsl:copy-of select="meta:mapLiteral('dcterms:accessRights', //c:stdyDscr/c:dataAccs/c:useStmt/c:restrctn)" />
            <xsl:copy-of select="meta:mapLiteral('dcterms:accessRights', //c:stdyDscr/c:dataAccs/c:setAvail/c:avlStatus)" />
            <xsl:copy-of select="meta:mapLiteral('dcterms:spatial', //c:stdyDscr/c:stdyInfo/c:sumDscr/c:geogCover)" />
            <xsl:copy-of select="meta:mapLiteral('dcterms:publisher', //c:stdyDscr/c:citation/c:prodStmt/c:producer)" />
            <xsl:copy-of select="meta:mapLiteral('dcterms:format', //c:fileDscr/c:fileTxt/c:format)" />
            <xsl:copy-of select="meta:mapLiteral('dcterms:rights', //c:stdyDscr/c:prodStmt/c:copyright)" />
            <xsl:copy-of select="meta:mapLiteral('dcterms:created', //c:stdyDscr/c:prodStmt/c:prodDate)" />

            <xsl:apply-templates select="//c:stdyDscr/c:stdyInfo/c:sumDscr/c:timePrd" />
            <xsl:apply-templates select="//c:stdyDscr/c:stdyInfo/c:sumDscr/c:geogUnit" />
            <xsl:apply-templates select="//c:stdyDscr/c:stdyInfo/c:sumDscr/c:collDate" />
            <xsl:apply-templates select="//c:stdyDscr/c:stdyInfo/c:sumDscr/c:nation" />

            <xsl:apply-templates select="//c:stdyDscr/c:othrStdyMat/c:othRefs" />
            <xsl:apply-templates select="//c:stdyDscr/c:othrStdyMat/c:relMat" />
            <xsl:apply-templates select="//c:stdyDscr/c:othrStdyMat/c:relPubl" />
            <xsl:apply-templates select="//c:stdyDscr/c:othrStdyMat/c:relStdy" />
            
            <xsl:apply-templates select="//c:stdyDscr/c:method/c:dataColl/c:sources" />
            
            <xsl:apply-templates select="//c:stdyDscr/c:method/c:dataColl/c:frequenc" />
            
            <xsl:apply-templates select="//c:fileDscr/c:fileTxt/c:dimensns/c:varQnty" />
            <xsl:apply-templates select="//c:fileDscr/c:fileTxt/c:dimensns/c:caseQnty" />
        </xsl:element>
    </xsl:template>

    <xsl:template match="c:AuthEnty">
        <xsl:for-each select=".">
            <dcterms:creator>
                <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/><xsl:attribute name="affiliation" select="@affiliation"/></xsl:if>
                <xsl:value-of select="." />
            </dcterms:creator>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="c:timePrd">
        <xsl:for-each select=".">    
            <dc:temporal>
                <xsl:variable name="startdate" select="if (@event='start' and (@date!='')) then (@date) else null"/>
                <xsl:variable name="enddate" select="if (@event='end' and (@date!='')) then (@date) else null"/>
                <xsl:if test="@event">
                    <xsl:if test="@event='start'"><xsl:attribute name="start" select="$startdate"/>
                        <xsl:value-of select="$startdate" />
                    </xsl:if>
                    <xsl:if test="@event='end'"><xsl:attribute name="end" select="$enddate"/>
                        <xsl:value-of select="$enddate"/>
                    </xsl:if>
                </xsl:if>
            </dc:temporal>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="c:collDate">
        <xsl:for-each select=".">    
            <dcterms:date>
                <xsl:variable name="startdate" select="if (@event='start' and (@date!='')) then (@date) else null"/>
                <xsl:variable name="enddate" select="if (@event='end' and (@date!='')) then (@date) else null"/>
                <xsl:variable name="single" select="if (@event='single' and (@date!='')) then (@date) else null"/>
                <xsl:if test="@event">
                    <xsl:if test="@event='single'"><xsl:attribute name="single" select="$single"/>
                        <xsl:value-of select="$single"/>
                    </xsl:if>
                    <xsl:if test="@event='start'"><xsl:attribute name="start" select="$startdate"/>
                        <xsl:value-of select="$startdate" />
                    </xsl:if>
                    <xsl:if test="@event='end'"><xsl:attribute name="end" select="$enddate"/>
                        <xsl:value-of select="$enddate"/>
                    </xsl:if>
                </xsl:if>
            </dcterms:date>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="c:nation">
        <xsl:for-each select=".">
            <dcterms:spatial>
                <xsl:attribute name="abbr">
                    <xsl:value-of select="@abbr" />
                </xsl:attribute>
                <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
                <xsl:value-of select="." />
            </dcterms:spatial>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="c:othRefs|c:relMat|c:relPubl|c:relStdy">
        <xsl:for-each select=".">
            <dcterms:relation>
                <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
                <xsl:value-of select="." />
            </dcterms:relation>
        </xsl:for-each>
    </xsl:template> 

    <xsl:template match="c:sources">
        <xsl:for-each select=".">
            <dc:source>
                <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
                <xsl:value-of select="." />
            </dc:source>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="c:frequenc">
        <xsl:for-each select=".">
            <dc:accrualPeriodicity>
                <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
                <xsl:value-of select="." />
            </dc:accrualPeriodicity>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="c:varQnty|c:caseQnty">
        <dc:extent>
            <xsl:value-of select="." />
        </dc:extent>
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

    <xsl:function name="meta:mapLiteral">
        <xsl:param name = "element" />
        <xsl:param name = "content" />
    
        <xsl:for-each select="$content">
          <xsl:element name="{$element}">
            <xsl:copy-of select="@xml:lang" />
            <xsl:value-of select ="." />
          </xsl:element>
        </xsl:for-each> 
    </xsl:function>
</xsl:stylesheet>