<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/"   

    xmlns:dc2="ddi:dcelements:3_1" 
    xmlns:g="ddi:group:3_1" 
    xmlns:d="ddi:datacollection:3_1"                 
    xmlns:c="ddi:conceptualcomponent:3_1"                 
    xmlns:a="ddi:archive:3_1"
    xmlns:m1="ddi:physicaldataproduct/ncube/normal:3_1" 				
    xmlns:m2="ddi:physicaldataproduct/ncube/tabular:3_1" 
    xmlns:m3="ddi:physicaldataproduct/ncube/inline:3_1" 
    xmlns:ddi="ddi:instance:3_1"
    xmlns:l="ddi:logicalproduct:3_1" 				
    xmlns:pd="ddi:physicaldataproduct:3_1"
    xmlns:cm="ddi:comparative:3_1" 
    xmlns:s="ddi:studyunit:3_1" 
    xmlns:r="ddi:reusable:3_1" 
    xmlns:pi="ddi:physicalinstance:3_1" 
    xmlns:ds="ddi:dataset:3_1" 
    xmlns:pr="ddi:profile:3_1"
    xsi:schemaLocation="ddi:instance:3_1 http://www.ddialliance.org/sites/default/files/schema/ddi3.1/instance.xsd"
    
    exclude-result-prefixes="xsl dc2 g d c a m1 m2 m3 ddi l pd cm s r pi ds pr"
    version="2.0">
    
    <xsl:output method="xml" indent="yes" />
    <xsl:param name="root-element">metadata</xsl:param>
    
    
    <xsl:template match="/ddi:DDIInstance">
        <xsl:element name="{$root-element}">
            <xsl:namespace name="xs" select="'http://www.w3.org/2001/XMLSchema'"/>
            <xsl:namespace name="xsi" select="'http://www.w3.org/2001/XMLSchema-instance'"/>
            <xsl:namespace name="dc" select="'http://purl.org/dc/elements/1.1/'"/>
            <xsl:namespace name="dcterms" select="'http://purl.org/dc/terms/'"/>
            
            <xsl:apply-templates select="//s:StudyUnit/r:Citation" />
            <xsl:apply-templates select="//s:Abstract" />
            
        </xsl:element>        
    </xsl:template>

    <xsl:template match="r:Citation">
        <xsl:for-each select="r:Title">
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

        <xsl:for-each select="r:Creator">
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

    </xsl:template>

    <xsl:template match="s:Abstract">
        <dcterms:abstract>
            <xsl:if test="r:Content/@xml:lang">
                <xsl:attribute name="xml:lang" select="r:Content/@xml:lang"/>
            </xsl:if>
            <xsl:value-of select="r:Content" />
        </dcterms:abstract>
    </xsl:template>

    
</xsl:stylesheet>