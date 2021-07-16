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

    xmlns:ddi="http://www.ddialliance.org/Specification/DDI-Codebook/2.5/XMLSchema/codebook.xsd"
    xsi:schemaLocation="ddi:codebook:2_5 http://www.ddialliance.org/Specification/DDI-Codebook/2.5/XMLSchema/codebook.xsd"

 
    


    exclude-result-prefixes="#all"
    version="2.0">
    
    <xsl:param name="root-element">metadata</xsl:param>

    
    <xsl:output method="xml" indent="yes" />
    
    
    <xsl:template match="/" > 
        <xsl:element name="{$root-element}">
            <xsl:namespace name="xs">http://www.w3.org/2001/XMLSchema</xsl:namespace>
            <xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
            <xsl:namespace name="dc">http://purl.org/dc/elements/1.1</xsl:namespace>
            <xsl:namespace name="dcterms">http://purl.org/dc/terms/</xsl:namespace>

            <!-- <xsl:for-each select="docDscr">
                <xsl:for-each select="citation">
                    <xsl:value-of select="."></xsl:value-of>
                </xsl:for-each>
            </xsl:for-each>
            
            <xsl:copy-of select="//docDscr/citation/titlStmt" /> -->

            <!-- <xsl:apply-templates select="//c:docDscr/citation/titlStmt" /> -->
            <xsl:apply-templates select="//c:stdyDscr" />
            <!-- <xsl:apply-templates select="//c:stdyInfo" /> -->
            <xsl:apply-templates select="//c:docDscr/citation/prodStmt" />
            
            <!-- <xsl:for-each select="//PhysicalDataProduct/p:PhysicalStructureScheme/p:PhysicalStructure/p:Format">
                <dcterms:format>
                    <xsl:value-of select="."></xsl:value-of>
                </dcterms:format>
            </xsl:for-each>
            
            <xsl:apply-templates select="//p:PhysicalInstance" /> -->
            

        </xsl:element>
    </xsl:template> 

    <xsl:template match="c:parTitl">
        <alternative>
            <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
            <xsl:value-of select="." />
        </alternative>        
    </xsl:template>

    <xsl:template match="c:titl">
        <dc:title>
            <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
            <xsl:value-of select="." />
        </dc:title>        
    </xsl:template>

    <!-- <xsl:template match="c:IDNo" >
        <xsl:element name="IDNo">
            <xsl:attribute name="agency">
                <xsl:value-of select="@agency" />
            </xsl:attribute>
            <xsl:value-of select="." />
        </xsl:element>
    </xsl:template> -->

    <!-- <xsl:template match="c:producer">
        <xsl:element name="producer">
            <xsl:attribute name="abbr">
                <xsl:value-of select="@abbr" />
            </xsl:attribute>
            <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
            <xsl:value-of select="." />
        </xsl:element>
    </xsl:template> -->

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

    <xsl:template match="c:AuthEnty">
        <!-- <xsl:for-each select="AuthEnty"> -->
            <dcterms:creator>
                <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
            <xsl:value-of select="." />
            </dcterms:creator>
        <!-- </xsl:for-each>    -->
    </xsl:template>

    <xsl:template match="c:distDate">
        <xsl:element name="issued">
            <xsl:attribute name="date">
                <xsl:value-of select="@date" />
            </xsl:attribute>
        </xsl:element>
    </xsl:template>

    <!-- Reference: https://www.dublincore.org/specifications/dublin-core/dcmi-terms/elements11/subject/ -->
    <xsl:template match="c:keyword">
        <xsl:for-each select=".">
            <dc:subject>
                <xsl:attribute name="vocab">
                    <xsl:value-of select="@vocab" />
                </xsl:attribute>
                <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
                <xsl:value-of select="." />
            </dc:subject>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>