<?xml version="1.0" encoding="UTF-8"?>
<!--
    
Description:
XSLT Stylesheet for conversion between DDI-L version 3.2 and dc/dcterms

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

    xmlns:g="ddi:group:3_2"  
    xmlns:d="ddi:datacollection:3_2"                
    xmlns:c="ddi:conceptualcomponent:3_2"                
    xmlns:a="ddi:archive:3_2" 
    xmlns:m1="ddi:physicaldataproduct/ncube/normal:3_2" 				
    xmlns:m2="ddi:physicaldataproduct/ncube/tabular:3_2" 
    xmlns:m3="ddi:physicaldataproduct/ncube/inline:3_2" 
    xmlns:ddi="ddi:instance:3_2"
    xmlns:l="ddi:logicalproduct:3_2" 			

    xmlns:p="ddi:physicaldataproduct:3_2" 
    xmlns:cm="ddi:comparative:3_2" 
    xmlns:s="ddi:studyunit:3_2" 
    xmlns:r="ddi:reusable:3_2" 
    xmlns:pi="ddi:physicalinstance:3_2" 
    xmlns:ds="ddi:dataset:3_2" 
    xmlns:pr="ddi:profile:3_2" 
    xsi:schemaLocation="ddi:instance:3_2 https://ddialliance.org/Specification/DDI-Lifecycle/3.2/XMLSchema/instance.xsd"
    
    exclude-result-prefixes="#all"
    version="2.0">
    
    <xsl:output method="xml" indent="yes" />
    <xsl:param name="root-element">metadata</xsl:param>
    
    <xsl:template match="/ddi:DDIInstance">
        <xsl:element name="{$root-element}">
            <xsl:namespace name="xs" select="'http://www.w3.org/2001/XMLSchema'"/>
            <xsl:namespace name="xsi" select="'http://www.w3.org/2001/XMLSchema-instance'"/>
            <xsl:namespace name="dc" select="'http://purl.org/dc/elements/1.1/'"/>
            <xsl:namespace name="dcterms" select="'http://purl.org/dc/terms/'"/>
            
            <xsl:apply-templates select="r:Citation" />
            <xsl:apply-templates select="g:Group/g:SubGroup/s:StudyUnit/r:Abstract" />
            
            <xsl:for-each select="//PhysicalDataProduct/p:PhysicalStructureScheme/p:PhysicalStructure/p:Format">
                <dcterms:format>
                    <xsl:value-of select="."></xsl:value-of>
                </dcterms:format>
            </xsl:for-each>
            
            <xsl:apply-templates select="//p:PhysicalInstance" />
            
        </xsl:element>        
    </xsl:template>

    <xsl:template match="r:Citation">
        <xsl:for-each select="r:Title/r:String">
            <dc:title>
                <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
                <xsl:value-of select="." />
            </dc:title>
        </xsl:for-each>
        
        <xsl:for-each select="r:AlternativeTitle">
            <dcterms:alternative>
                <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
                <xsl:value-of select="." />
            </dcterms:alternative>
        </xsl:for-each>

        <xsl:for-each select="r:Creator/r:String">
            <dcterms:creator>
                <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
                <xsl:value-of select="." />
            </dcterms:creator>
        </xsl:for-each>

        <xsl:for-each select="r:Contributor">
            <dcterms:contributor>
                <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
                <xsl:value-of select="." />
            </dcterms:contributor>
        </xsl:for-each>

        <xsl:for-each select="r:Publisher/r:PublisherName/r:String">
            <dc:publisher>
                <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
                <xsl:value-of select="." />
            </dc:publisher>
        </xsl:for-each>

        <xsl:if test="r:Language">
            <dcterms:language><xsl:value-of select="r:Language"/></dcterms:language>
        </xsl:if>

        <xsl:for-each select="r:InternationalIdentifier">
            <dc:identifier>
                <xsl:value-of select="."></xsl:value-of>
            </dc:identifier>
        </xsl:for-each>
    </xsl:template>
        
    <xsl:template match="p:PhysicalInstance">
        <xsl:if test="p:GrossFileStructure/p:OverallRecordCount">
            <dcterms:extent><xsl:value-of select="p:GrossFileStructure/p:OverallRecordCount" /><xsl:text> records</xsl:text></dcterms:extent>
        </xsl:if>
        
        <xsl:if test="p:GrossFileStructure/p:CaseQuantity">
            <dcterms:extent><xsl:value-of select="p:GrossFileStructure/p:CaseQuantity" /><xsl:text> cases</xsl:text></dcterms:extent>
        </xsl:if>       
    </xsl:template>

    <xsl:template match="r:Abstract">
        <dcterms:abstract>
            <xsl:if test="r:Content/@xml:lang">
                <xsl:attribute name="xml:lang" select="r:Content/@xml:lang"/>
            </xsl:if>
            <xsl:value-of select="r:Content" />
        </dcterms:abstract>
    </xsl:template>

</xsl:stylesheet>