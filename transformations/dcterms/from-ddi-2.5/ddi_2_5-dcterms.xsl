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
    xmlns:ci="ddi:codebook:2_5"

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

            <xsl:apply-templates select="//c:docDscr/citation/titlStmt" />
            <xsl:apply-templates select="//c:stdyDscr" />
            <xsl:apply-templates select="//c:stdyInfo" />
            
            <!-- <xsl:for-each select="//PhysicalDataProduct/p:PhysicalStructureScheme/p:PhysicalStructure/p:Format">
                <dcterms:format>
                    <xsl:value-of select="."></xsl:value-of>
                </dcterms:format>
            </xsl:for-each>
            
            <xsl:apply-templates select="//p:PhysicalInstance" /> -->
            

        </xsl:element>
    </xsl:template> 

    <xsl:template match="c:parTitl">
        <parTitl>
            <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
            <xsl:value-of select="." />
        </parTitl>        
    </xsl:template>

    <xsl:template match="c:titl">
        <title>
            <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
            <xsl:value-of select="." />
        </title>        
    </xsl:template>

    <xsl:template match="c:IDNo">
        <IDNo>
            <xsl:value-of select="." />
        </IDNo>
    </xsl:template>

    <xsl:template match="c:producer">
        <producer>
            <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
            <xsl:value-of select="." />
        </producer>        
    </xsl:template>

    <!-- <xsl:template match="s:Abstract">
        <dcterms:abstract>
            <xsl:if test="r:Content/@xml:lang">
                <xsl:attribute name="xml:lang" select="r:Content/@xml:lang"/>
            </xsl:if>
            <xsl:value-of select="r:Content" />
        </dcterms:abstract>
    </xsl:template> -->

    <!-- <xsl:template match="/codeBook//docDscr" mode="whole2"> 
          

            <xsl:apply-templates select="titlStmt/titl" />

            <xsl:for-each select="prodSt">
                <xsl:for-each select="citation">
                    <xsl:value-of select="."></xsl:value-of>
                </xsl:for-each>
            </xsl:for-each>
            
            <xsl:apply-templates select="//docDscr/citation/titlStmt" />
            
    </xsl:template> -->


    <!-- <xsl:template match="titl">
        <title>
            <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
            <xsl:value-of select="." />
        </title>        
    </xsl:template>  -->

<!--     <xsl:template match="titl">
        <dc:title>
            <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
            <xsl:value-of select="." />
        </dc:title>    

        <dc:subject>
            <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
            <xsl:value-of select="." />
        </dc:subject>
    </xsl:template> -->

<!--     <xsl:template match="Citation">
        <xsl:apply-templates select="titl" /> 

        <xsl:for-each select="Creator">
            <dcterms:creator>
                <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
                <xsl:value-of select="." />
            </dcterms:creator>
        </xsl:for-each>

        <xsl:for-each select="Contributor">
            <dcterms:contributor>
                <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
                <xsl:value-of select="." />
            </dcterms:contributor>
        </xsl:for-each>

        <xsl:for-each select="Publisher"> 
            <dc:publisher>
                <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
                <xsl:value-of select="." />
            </dc:publisher>
        </xsl:for-each>

        <xsl:if test="Language">
            <dcterms:language><xsl:value-of select="Language"/></dcterms:language>
        </xsl:if>

        <xsl:for-each select="InternationalIdentifier">
            <dc:identifier>
                <xsl:value-of select="."></xsl:value-of>
            </dc:identifier>
        </xsl:for-each>

    </xsl:template> 
        
    <xsl:template match="PhysicalInstance">
        <xsl:if test="GrossFileStructure/OverallRecordCount">
            <dcterms:extent><xsl:value-of select="GrossFileStructure/OverallRecordCount" /><xsl:text> records</xsl:text></dcterms:extent>
        </xsl:if>
        
        <xsl:if test="GrossFileStructure/CaseQuantity">
            <dcterms:extent><xsl:value-of select="GrossFileStructure/CaseQuantity" /><xsl:text> cases</xsl:text></dcterms:extent>
        </xsl:if>       
    </xsl:template>

    <xsl:template match="Abstract">
        <dcterms:abstract>
            <xsl:if test="Content/@xml:lang">
                <xsl:attribute name="xml:lang" select="Content/@xml:lang"/>
            </xsl:if>
            <xsl:value-of select="Content" />
        </dcterms:abstract> 
    </xsl:template> -->
</xsl:stylesheet>