<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
                xmlns="http://schema.datacite.org/meta/kernel-2.2/metadata.xsd"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:g="ddi:group:3_1"
                xmlns:d="ddi:datacollection:3_1"
                xmlns:dce="ddi:dcelements:3_1"
                xmlns:c="ddi:conceptualcomponent:3_1"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:a="ddi:archive:3_1"
                xmlns:m1="ddi:physicaldataproduct/ncube/normal:3_1"
                xmlns:ddi="ddi:instance:3_1 http://www.ddialliance.org/sites/default/files/schema/ddi3.1/instance.xsd"
                xmlns:m2="ddi:physicaldataproduct/ncube/tabular:3_1"
                xmlns:o="ddi:organizations:3_1"
                xmlns:l="ddi:logicalproduct:3_1"
                xmlns:m3="ddi:physicaldataproduct/ncube/inline:3_1"
                xmlns:pd="ddi:physicaldataproduct:3_1"
                xmlns:cm="ddi:comparative:3_1"
                xmlns:s="ddi:studyunit:3_1"
                xmlns:r="ddi:reusable:3_1"
                xmlns:pi="ddi:physicalinstance:3_1"
                xmlns:ds="ddi:dataset:3_1"
                xmlns:pr="ddi:profile:3_1"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="http://datacite.org/schema/kernel-2.2 http://schema.datacite.org/meta/kernel-2.2/metadata.xsd"
                version="2.0">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <!--
    Document   : ddi_3_1-datacite_2_2.xsl
    Version    : development
    Created on : den 11 december 2011, 22:29
    Description: extract metadata from DDI 3.1 to DataCite metadata
    
    DOC: http://schema.datacite.org/meta/kernel-2.2/doc/DataCite-MetadataKernel_v2.2.pdf
    
    progress:
    id     |datacite              | ddi3
    =======================================
    1       +Identifier
    2       +Creator
    2.1     creatorName
    2.2     nameIdentifier
    2.2.1   nameIdentifierScheme
    3       +Title
    4       Publisher               r:Publisher
    ?       description             s:Abstract, s:purpose
    -->

    <!-- If no DOI is present in the DDI-instace provide this as a paramater-->
    <xsl:param name="doi"></xsl:param>
    <xsl:param name="lang">eng</xsl:param>
    
    <xsl:template match="//s:StudyUnit">
        <resource>
            <identifier identifierType="DOI"><xsl:value-of select="$doi"/></identifier>
            
            <titles>
                <xsl:choose>
                    <xsl:when test="r:Citation/r:Title[@xml:lang = $lang]">
                        <title><xsl:value-of select="r:Citation/r:Title[@xml:lang = $lang]"/></title>
                    </xsl:when>
                    <xsl:otherwise>
                        <title><xsl:value-of select="r:Citation/r:Title"/></title>
                    </xsl:otherwise>
                </xsl:choose>
            </titles>
            
            <!-- Creator -->
            <creators>
                <xsl:choose>
                    <xsl:when test="r:Citation/r:Creator/@xml:lang">
                        <xsl:for-each select="r:Citation/r:Creator[@xml:lang = $lang]">
                            <creator><xsl:value-of select="."/></creator>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each select="r:Citation/r:Creator">
                            <creator><xsl:value-of select="."/></creator>
                        </xsl:for-each>                        
                    </xsl:otherwise>
                </xsl:choose>
            </creators>
            
            <!-- Publisher -->
            <xsl:if test="r:Citation/r:Publisher">
                <xsl:choose>
                    <xsl:when test="r:Citation/r:Publisher/@xml:lang">
                            <publisher><xsl:value-of select="r:Citation/r:Publisher[@xml:lang = $lang]"/></publisher>
                    </xsl:when>
                    <xsl:otherwise>
                            <publisher><xsl:value-of select="r:Citation/r:Publisher"/></publisher>                      
                    </xsl:otherwise>
                </xsl:choose>                
            </xsl:if>
            
            <!-- s:Abstract, s:Purpose-->
            <xsl:if test="s:Abstract | s:Purpose">
                <descriptions>
                    <xsl:if test="s:Abstract">
                        <xsl:choose>
                            <xsl:when test="s:Abstract/r:Content[@xml:lang = $lang]">
                                <description descriptionType="Abstract"><xsl:value-of select="s:Abstract/r:Content[@xml:lang = $lang]"/></description>
                            </xsl:when>
                            <xsl:otherwise>
                                <description descriptionType="Abstract"><xsl:value-of select="s:Abstract/r:Content"/></description>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:if test="s:Purpose">
                        <xsl:choose>
                            <xsl:when test="s:Purpose/r:Content[@xml:lang = $lang]">
                                <description descriptionType="Other"><xsl:value-of select="s:Purpose/r:Content[@xml:lang = $lang]"/></description>
                            </xsl:when>
                            <xsl:otherwise>
                                <description descriptionType="Other"><xsl:value-of select="s:Purpose/r:Content"/></description>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </descriptions>
            </xsl:if>
        </resource>
    </xsl:template>

</xsl:stylesheet>