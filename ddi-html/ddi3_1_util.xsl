<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:g="ddi:group:3_1" xmlns:d="ddi:datacollection:3_1" xmlns:dce="ddi:dcelements:3_1"
    xmlns:c="ddi:conceptualcomponent:3_1" xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:a="ddi:archive:3_1" xmlns:m1="ddi:physicaldataproduct/ncube/normal:3_1"
    xmlns:ddi="ddi:instance:3_1" xmlns:m2="ddi:physicaldataproduct/ncube/tabular:3_1"
    xmlns:o="ddi:organizations:3_1" xmlns:l="ddi:logicalproduct:3_1"
    xmlns:m3="ddi:physicaldataproduct/ncube/inline:3_1" xmlns:pd="ddi:physicaldataproduct:3_1"
    xmlns:cm="ddi:comparative:3_1" xmlns:s="ddi:studyunit:3_1" xmlns:r="ddi:reusable:3_1"
    xmlns:pi="ddi:physicalinstance:3_1" xmlns:ds="ddi:dataset:3_1" xmlns:pr="ddi:profile:3_1"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.0"
    xsi:schemaLocation="ddi:instance:3_1 http://www.ddialliance.org/sites/default/files/schema/ddi3.1/instance.xsd">
    <xsl:output method="html"/>
    
    <!-- params -->
    <xsl:param name="translations">i18n/messages_en.properties.xml</xsl:param>
    <xsl:variable name="msg" select="document($translations)"/>	
    
    <!-- render text-elements of this language-->
    <xsl:param name="lang">da</xsl:param>
    <!-- if the requested language is not found for e.g. questionText, use fallback language-->
    <xsl:param name="fallback-lang">en</xsl:param>
    <!-- print anchors for eg QuestionItems-->
    <xsl:param name="print-anchor">1</xsl:param>
    
    <xsl:template name="CreateLink">
        <a>
            <xsl:attribute name="name"><xsl:value-of select="@id"/>.<xsl:value-of select="@version"/>
            </xsl:attribute>
        </a>    
    </xsl:template>
    
    <!-- DisplayLabel -->
    <!-- Context:  Variable, Concept, Category-->
    <xsl:template name="DisplayLabel">
        <xsl:choose>
            <xsl:when test="r:Label/@xml:lang">
                <xsl:choose>
                    <xsl:when test="r:Label[@xml:lang=$lang]">
                        <xsl:value-of select="r:Label[@xml:lang=$lang]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="r:Label[@xml:lang=$fallback-lang]"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="r:Label"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- DisplayDescription -->
    <!-- Context:  Variable, Concept, Category-->
    <xsl:template name="DisplayDescription">
        <xsl:choose>
            <xsl:when test="r:Description/@xml:lang">
                <xsl:choose>
                    <xsl:when test="r:Description[@xml:lang=$lang]">
                        <xsl:value-of select="r:Description[@xml:lang=$lang]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="r:Description[@xml:lang=$fallback-lang]"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="r:Description"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
